#####
# Global
#####

output "selector_labels" {
  description = "Map of the labels that are used as selectors."
  value       = element(concat(kubernetes_service.this.*.spec.0.selector, [{}]), 0)
}

output "image_name" {
  description = "Name of the docker image used for the blackbox-exporter container."
  value       = var.enabled ? var.image_name : ""
}

output "image_version" {
  description = "Tag of the docker image used for the blackbox-exporter container."
  value       = var.enabled ? var.image_version : ""
}

output "image_pull_policy" {
  description = "Image pull policy defined on the blackbox-exporter container."
  value       = var.enabled ? var.image_pull_policy : ""
}

output "prometheus_scrape_configs" {
  description = "List of objects representing the promehteus scrape configs you need import for prometheus to scrape this exporter."
  value       = var.enabled ? yamldecode(local.prometheus_scrape_configs).scrape_configs : []
}

output "grafana_dashboards" {
  description = "List of strings representing grafana dashbaords under the form of json strings."
  value       = var.enabled ? local.grafana_dashboards : []
}

output "prometheus_alert_groups" {
  description = "List of object representing prometheus alert groups you can importer for prometheus to alert you in case of problems."
  value       = var.enabled ? local.prometheus_alert_groups : []
}

#####
# Deployment
#####

output "deployment_name" {
  description = "Name of the deployment created by the module."
  value       = element(concat(kubernetes_deployment.this.*.metadata.0.name, [""]), 0)
}

output "deployment_annotations" {
  description = "Map of annotations that are configured on the deployment."
  value       = element(concat(kubernetes_deployment.this.*.metadata.0.annotations, [{}]), 0)
}

output "deployment_labels" {
  description = "Map of labels that are configured on the deployment."
  value       = element(concat(kubernetes_deployment.this.*.metadata.0.labels, [{}]), 0)
}

output "deployment_template_annotations" {
  description = "Map of annotations that are configured on the deployment."
  value       = element(concat(kubernetes_deployment.this.*.spec.0.template.0.metadata.0.annotations, [{}]), 0)
}

output "deployment_template_labels" {
  description = "Map of labels that are configured on the deployment."
  value       = element(concat(kubernetes_deployment.this.*.spec.0.template.0.metadata.0.labels, [{}]), 0)
}

#####
# Service
#####

output "service_name" {
  description = "Name of the service created by the module."
  value       = element(concat(kubernetes_service.this.*.metadata.0.name, [""]), 0)
}

output "service_port" {
  description = "Port number of the service port."
  value       = var.enabled ? local.service_port : ""
}

output "service_port_name" {
  description = "Name of the service port."
  value       = var.enabled ? "http" : ""
}

output "service_annotations" {
  description = "Map of annotations that are configured on the service."
  value       = element(concat(kubernetes_service.this.*.metadata.0.annotations, [{}]), 0)
}

output "service_labels" {
  description = "Map of labels that are configured on the service."
  value       = element(concat(kubernetes_service.this.*.metadata.0.labels, [{}]), 0)
}

#####
# Configmap
#####

output "config_map_name" {
  description = "Name of the config_map created by the module."
  value       = element(concat(kubernetes_config_map.this.*.metadata.0.name, [""]), 0)
}

output "config_map_annotations" {
  description = "Map of annotations that are configured on the config_map."
  value       = element(concat(kubernetes_config_map.this.*.metadata.0.annotations, [{}]), 0)
}

output "config_map_labels" {
  description = "Map of labels that are configured on the config_map."
  value       = element(concat(kubernetes_config_map.this.*.metadata.0.labels, [{}]), 0)
}

#####
# Namespace
#####

output "namespace" {
  description = "Name of the namespace in which the resources have been deployed."
  value       = element(concat(kubernetes_deployment.this.*.metadata.0.namespace, [""]), 0)
}
