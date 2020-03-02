#####
# Locals
#####

locals {
  labels = {
    "app.kubernetes.io/version"    = var.image_version
    "app.kubernetes.io/component"  = "exporter"
    "app.kubernetes.io/part-of"    = "monitoring"
    "app.kubernetes.io/managed-by" = "terraform"
    "app.kubernetes.io/name"       = "blackbox-exporter"
  }
  configuration = yamlencode(var.configuration)
  port          = 9115
  service_port  = 80
  prometheus_scrape_configs = templatefile("${path.module}/templates/prometheus_scrape_configs.yml.tmpl", {
    module_targets = var.module_targets,
    blackbox_url   = "${element(concat(kubernetes_service.this.*.metadata.0.name, list("")), 0)}.${element(concat(kubernetes_service.this.*.metadata.0.namespace, list("")), 0)}"
  })
  grafana_dashboards      = []
  prometheus_alert_groups = []
}

#####
# Randoms
#####

resource "random_string" "selector" {
  special = false
  upper   = false
  number  = false
  length  = 8
}

#####
# Deployment
#####

resource "kubernetes_deployment" "this" {
  count = var.enabled ? 1 : 0

  metadata {
    name      = var.deployment_name
    namespace = var.namespace
    annotations = merge(
      var.annotations,
      var.deployment_annotations
    )
    labels = merge(
      {
        "app.kubernetes.io/instance" = var.deployment_name
      },
      local.labels,
      var.labels,
      var.deployment_labels
    )
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app    = "blackbox-exporter"
        random = random_string.selector.result
      }
    }
    template {
      metadata {
        annotations = merge(
          var.annotations,
          var.deployment_template_annotations
        )
        labels = merge(
          {
            "app.kubernetes.io/instance" = var.deployment_name
            app                          = "blackbox-exporter"
            random                       = random_string.selector.result
          },
          local.labels,
          var.labels,
          var.deployment_template_labels
        )
      }
      spec {
        container {
          name              = "configmap-reload"
          image             = "jimmidyson/configmap-reload:v0.2.2"
          image_pull_policy = "IfNotPresent"

          args = [
            "--volume-dir=/etc/config",
            "--webhook-url=http://127.0.0.1:${local.port}/-/reload"
          ]

          resources {
            requests {
              memory = "32Mi"
              cpu    = "5m"
            }
            limits {
              memory = "64Mi"
              cpu    = "10m"
            }
          }

          volume_mount {
            name       = "configuration"
            mount_path = "/etc/config/config.yml"
            sub_path   = "config.yml"
            read_only  = true
          }
        }

        container {
          name              = "blackbox-exporter"
          image             = "${var.image_name}:${var.image_version}"
          image_pull_policy = var.image_pull_policy

          args = [
            "--config.file",
            "/config/config.yml"
          ]

          readiness_probe {
            http_get {
              path   = "/"
              port   = local.port
              scheme = "HTTP"
            }

            timeout_seconds       = 5
            period_seconds        = 5
            success_threshold     = 1
            failure_threshold     = 35
            initial_delay_seconds = 60
          }

          liveness_probe {
            http_get {
              path   = "/"
              port   = local.port
              scheme = "HTTP"
            }

            timeout_seconds       = 5
            period_seconds        = 10
            success_threshold     = 1
            failure_threshold     = 3
            initial_delay_seconds = 90
          }

          port {
            name           = "http"
            container_port = local.port
            protocol       = "TCP"
          }

          resources {
            requests {
              memory = "128Mi"
              cpu    = "5m"
            }
            limits {
              memory = "256Mi"
              cpu    = "50m"
            }
          }

          volume_mount {
            name       = "configuration"
            mount_path = "/config/config.yml"
            sub_path   = "config.yml"
          }
        }

        volume {
          name = "configuration"
          config_map {
            name = element(concat(kubernetes_config_map.this.*.metadata.0.name, [""]), 0)
            items {
              key  = "config.yml"
              path = "config.yml"
            }
          }
        }
      }
    }
  }
}

#####
# Service
#####

resource "kubernetes_service" "this" {
  count = var.enabled ? 1 : 0

  metadata {
    name      = var.service_name
    namespace = var.namespace
    annotations = merge(
      {
        "prometheus.io/scrape" = "true"
      },
      var.annotations,
      var.service_annotations
    )
    labels = merge(
      {
        "app.kubernetes.io/instance" = var.service_name
      },
      local.labels,
      var.labels,
      var.service_labels
    )
  }

  spec {
    selector = {
      random = random_string.selector.result
      app    = "blackbox-exporter"
    }
    type = "ClusterIP"
    port {
      port        = local.service_port
      target_port = "http"
      protocol    = "TCP"
      name        = "http"
    }
  }
}

#####
# ConfigMap
#####

resource "kubernetes_config_map" "this" {
  count = var.enabled ? 1 : 0

  metadata {
    name      = var.config_map_name
    namespace = var.namespace
    annotations = merge(
      var.annotations,
      var.config_map_annotations
    )
    labels = merge(
      {
        "app.kubernetes.io/instance" = var.config_map_name
      },
      local.labels,
      var.labels,
      var.config_map_labels
    )
  }

  data = {
    "config.yml" = local.configuration
  }
}
