#####
# Locals
#####

locals {
  labels = {
    "version"    = var.image_version
    "component"  = "exporter"
    "part-of"    = "monitoring"
    "managed-by" = "terraform"
    "name"       = "blackbox-exporter"
  }
  configuration = yamlencode(var.configuration)
  port          = 9115
  service_port  = 80
  prometheus_scrape_configs = templatefile("${path.module}/templates/prometheus_scrape_configs.yml.tmpl", {
    module_targets = var.module_targets,
    blackbox_url   = "${element(concat(kubernetes_service.this.*.metadata.0.name, list("")), 0)}.${element(concat(kubernetes_service.this.*.metadata.0.namespace, list("")), 0)}"
  })
  grafana_dashboards = [
    file("${path.module}/templates/grafana-dashboards/dashboard.json")
  ]
  prometheus_alert_groups_rules_labels = merge(
    {
      "source" = "https://scm.dazzlingwrench.fxinnovation.com/fxinnovation-public/terraform-module-kubernetes-blackbox-exporter"
    },
    var.prometheus_alert_groups_rules_labels
  )
  prometheus_alert_groups_rules_annotations = merge(
    {},
    var.prometheus_alert_groups_rules_annotations
  )
  prometheus_alert_groups = [
    {
      "name" = "blackbox-exporter"
      "rules" = [
        {
          "alert" = "blackbox-exporter - config reload"
          "expr"  = "blackbox_exporter_config_last_reload_successful < 1"
          "for"   = "30m"
          "labels" = merge(
            {
              "severity" = "warning"
              "urgency"  = "3"
            },
            local.prometheus_alert_groups_rules_labels
          )
          "annotations" = merge(
            {
              "summary"              = "Blackbox Exporter - A configuration reload has failed on {{ $labels.instance }}"
              "description"          = "Blackbox Exporter:\nA configuration reload has been failing for 30min on {{ $labels.instance }}.\nLabels:\n{{ $labels }}"
              "description_html"     = "<h3>Blackbox Exporter</h3><p>A configuration reload has been failing for 30min on {{ $labels.instance }}.</p><h4>Labels</h4><p>{{ $labels }}</p>"
              "description_markdown" = "### Blackbox Exporter\nA configuration reload has been failing for 30min on {{ $labels.instance }}.\n#### Labels\n{{ $labels }}"
            },
            local.prometheus_alert_groups_rules_annotations
          )
        }
      ]
    },
    {
      "name" = "blackbox"
      "rules" = [
        {
          "alert" = "blackbox - probe down warning"
          "expr"  = "probe_success < 1"
          "for"   = "2m"
          "labels" = merge(
            {
              "severity" = "warning"
              "urgency"  = "3"
            },
            local.prometheus_alert_groups_rules_labels
          )
          "annotations" = merge(
            {
              "summary"              = "Blackbox - {{ $labels.instance }} has been down for at least 2 minutes"
              "description"          = "Blackbox:\n{{ $labels.instance }} has been down for at least 2 minutes\nLabels:\n{{ $labels }}"
              "description_html"     = "<h3>Blackbox</h3><p>{{ $labels.instance }} has been down for at least 2 minutes<p><h4>Labels</h4><p>{{ $labels }}</p>"
              "description_markdown" = "### Blackbox:\n{{ $labels.instance }} has been down for at least 2 minutes\n#### Labels:\n{{ $labels }}"
            },
            local.prometheus_alert_groups_rules_annotations
          )
        },
        {
          "alert" = "blackbox - probe down critical"
          "expr"  = "probe_success < 1"
          "for"   = "5m"
          "labels" = merge(
            {
              "severity" = "critical"
              "urgency"  = "2"
            },
            local.prometheus_alert_groups_rules_labels
          )
          "annotations" = merge(
            {
              "summary"              = "Blackbox - {{ $labels.instance }} has been down for at least 5 minutes"
              "description"          = "Blackbox:\n{{ $labels.instance }} has been down for at least 5 minutes\nLabels:\n{{ $labels }}"
              "description_html"     = "<h3>Blackbox</h3><p>{{ $labels.instance }} has been down for at least 5 minutes</p><h4>Labels</h4><p>{{ $labels }}</p>"
              "description_markdown" = "### Blackbox:\n{{ $labels.instance }} has been down for at least 5 minutes\n#### Labels:\n{{ $labels }}"
            },
            local.prometheus_alert_groups_rules_annotations
          )
        },
        {
          "alert" = "blackbox - SSL certificate warning"
          "expr"  = "probe_ssl_earliest_cert_expiry - time() < ( 29 * 24 * 60 * 60 )"
          "for"   = "10m"
          "labels" = merge(
            {
              "severity" = "warning"
              "urgency"  = "3"
            },
            local.prometheus_alert_groups_rules_labels
          )
          "annotations" = merge(
            {
              "summary"              = "Blackbox - The SSL certificate for {{ $labels.instance }} will expire in less then 29 days"
              "description"          = "Blackbox:\nThe SSL certificate for {{ $labels.instance }} will expire in {{ $value }} seconds.\nLabels:\n{{ $labels }}"
              "description_html"     = "<h3>Blackbox</h3><p>The SSL certificate for {{ $labels.instance }} will expire in {{ $value }} seconds.</p><h4>Labels</h4><p>{{ $labels }}</p>"
              "description_markdown" = "### Blackbox:\nThe SSL certificate for {{ $labels.instance }} will expire in {{ $value }} seconds.\n#### Labels:\n{{ $labels }}"
            },
            local.prometheus_alert_groups_rules_annotations
          )
        },
        {
          "alert" = "blackbox - SSL certificate critical"
          "expr"  = "probe_ssl_earliest_cert_expiry - time() < ( 10 * 24 * 60 * 60 )"
          "for"   = "10m"
          "labels" = merge(
            {
              "severity" = "critical"
              "urgency"  = "2"
            },
            local.prometheus_alert_groups_rules_labels
          )
          "annotations" = merge(
            {
              "summary"              = "Blackbox - The SSL certificate for {{ $labels.instance }} will expire in less then 10 days"
              "description"          = "Blackbox:\nThe SSL certificate for {{ $labels.instance }} will expire in {{ $value }} seconds.\nLabels:\n{{ $labels }}"
              "description_html"     = "<h3>Blackbox</h3><p>The SSL certificate for {{ $labels.instance }} will expire in {{ $value }} seconds.<p><h4>Labels</h4><p>{{ $labels }}</p>"
              "description_markdown" = "### Blackbox:\nThe SSL certificate for {{ $labels.instance }} will expire in {{ $value }} seconds.\n#### Labels:\n{{ $labels }}"
            },
            local.prometheus_alert_groups_rules_annotations
          )
        },
      ]
    }
  ]
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
        "instance" = var.deployment_name
      },
      local.labels,
      var.labels,
      var.deployment_labels
    )
  }

  spec {
    replicas = var.replicas

    selector {
      match_labels = {
        "selector" = "blackbox-exporter-${random_string.selector.result}"
      }
    }
    template {
      metadata {
        annotations = merge(
          {
            "prometheus.io/scrape" = "true"
            "prometheus.io/port"   = local.port
          },
          var.annotations,
          var.deployment_template_annotations
        )
        labels = merge(
          {
            "instance" = var.deployment_name
            "selector" = "blackbox-exporter-${random_string.selector.result}"
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
            requests = {
              memory = "32Mi"
              cpu    = "5m"
            }
            limits = {
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
            requests = {
              memory = "128Mi"
              cpu    = "5m"
            }
            limits = {
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
      var.annotations,
      var.service_annotations
    )
    labels = merge(
      {
        "instance" = var.service_name
      },
      local.labels,
      var.labels,
      var.service_labels
    )
  }

  spec {
    selector = {
      "selector" = "blackbox-exporter-${random_string.selector.result}"
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
        "instance" = var.config_map_name
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
