#####
# Global
#####

output "selector_labels" {
  description = "Map of the labels that are used as selectors."
  value       = module.default.selector_labels
}

output "image_name" {
  description = "Name of the docker image used for the blackbox-exporter container."
  value       = module.default.image_name
}

output "image_version" {
  description = "Tag of the docker image used for the blackbox-exporter container."
  value       = module.default.image_version
}

output "image_pull_policy" {
  description = "Image pull policy defined on the blackbox-exporter container."
  value       = module.default.image_pull_policy
}

output "prometheus_scrape_configs" {
  description = "List of prometheus scrape configs"
  value       = module.default.prometheus_scrape_configs
}

output "grafana_dashboards" {
  description = "List of grafana dashboards"
  value       = module.default.grafana_dashboards
}

output "prometheus_alert_groups" {
  description = "List of maps representing prometheus alert groups."
  value       = module.default.prometheus_alert_groups
}

#####
# Deployment
#####

output "deployment_name" {
  description = "Name of the deployment created by the module."
  value       = module.default.deployment_name
}

output "deployment_annotations" {
  description = "Map of annotations that are configured on the deployment."
  value       = module.default.deployment_annotations
}

output "deployment_labels" {
  description = "Map of labels that are configured on the deployment."
  value       = module.default.deployment_labels
}

output "deployment_template_annotations" {
  description = "Map of annotations that are configured on the deployment."
  value       = module.default.deployment_template_annotations
}

output "deployment_template_labels" {
  description = "Map of labels that are configured on the deployment."
  value       = module.default.deployment_template_labels
}

#####
# Service
#####

output "service_name" {
  description = "Name of the service created by the module."
  value       = module.default.service_name
}

output "service_port" {
  description = "Port number of the service port."
  value       = module.default.service_port
}

output "service_port_name" {
  description = "Name of the service port."
  value       = module.default.service_port_name
}

output "service_annotations" {
  description = "Map of annotations that are configured on the service."
  value       = module.default.service_annotations
}

output "service_labels" {
  description = "Map of labels that are configured on the service."
  value       = module.default.service_labels
}

#####
# Configmap
#####

output "config_map_name" {
  description = "Name of the config_map created by the module."
  value       = module.default.config_map_name
}

output "config_map_annotations" {
  description = "Map of annotations that are configured on the config_map."
  value       = module.default.config_map_annotations
}

output "config_map_labels" {
  description = "Map of labels that are configured on the config_map."
  value       = module.default.config_map_labels
}

#####
# Namespace
#####

output "namespace" {
  description = "Name of the namespace in which the resources have been deployed."
  value       = module.default.namespace
}
