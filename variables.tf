#####
# Global
#####

variable "annotations" {
  description = "Additionnal annotations that will be merged on all resources."
  default     = {}
}

variable "enabled" {
  description = "Whether or not to enable this module."
  default     = true
}

variable "labels" {
  description = "Additionnal labels that will be merged on all resources."
  default     = {}
}

variable "namespace" {
  description = "Namespace in which the module will be deployed."
  default     = "default"
}

#####
# Prometheus
#####

variable "prometheus_alert_groups_rules_labels" {
  description = "Map of strings that will be merge on all prometheus alert groups rules labels."
  default     = {}
}

variable "prometheus_alert_groups_rules_annotations" {
  description = "Map of strings that will be merge on all prometheus alert groups rules annotations."
  default     = {}
}

#####
# Application
#####

variable "configuration" {
  description = "Object representating the configuration for blackbox-exporter. [documentation](https://github.com/prometheus/blackbox_exporter/blob/master/CONFIGURATION.md) (will be converted into yaml)"
  type        = any
  default = {
    modules = {
      http_2xx = {
        prober = "http"
      },
      http_post_2xx = {
        prober = "http"
        http = {
          method = "POST"
        }
      },
      tcp_connect = {
        prober = "tcp"
      },
      pop3s_banner = {
        prober = "tcp"
        tcp = {
          query_response = [
            { expect = "^+OK" }
          ]
          tls = true
          tls_config = {
            insecure_skip_verify = false
          }
        }
      },
      ssh_banner = {
        prober = "tcp"
        tcp = {
          query_response = [
            { expect = "^SSH-2.0-" }
          ]
        }
      },
      irc_banner = {
        prober = "tcp"
        tcp = {
          query_response = [
            { "send" = "NICK prober" },
            { "send" = "USER prober prober prober :prober" },
            {
              "expect" = "PING :([^ ]+)"
              "send"   = "PONG ${1}"
            },
            { "expect" = "^:[^ ]+ 001" }
          ]
        }
      },
      icmp = {
        prober = "icmp"
      }
    }
  }
}

variable "module_targets" {
  description = "List of objects representing all the targets you want to activate the blackbox-exporter on (with it's modules). **Note:** This value is used by the prometheus configuration helper which is the `prometheus_scrape_configs` output.`"
  type = list(object({
    name    = string
    targets = list(string)
    labels  = map(string)
  }))
  default = []
}

#####
# Deployment
#####

variable "deployment_annotations" {
  description = "Additionnal annotations that will be merged on the deployment."
  default     = {}
}

variable "deployment_labels" {
  description = "Additionnal labels that will be merged on the deployment."
  default     = {}
}

variable "deployment_name" {
  description = "Name of the deployment that will be create."
  default     = "blackbox-exporter"
}

variable "deployment_template_annotations" {
  description = "Additionnal annotations that will be merged on the deployment template."
  default     = {}
}

variable "deployment_template_labels" {
  description = "Additionnal labels that will be merged on the deployment template."
  default     = {}
}

variable "image_name" {
  description = "Name of the docker image to use."
  default     = "prom/blackbox-exporter"
}

variable "image_pull_policy" {
  description = "Image pull policy on the main container."
  default     = "IfNotPresent"
}

variable "image_version" {
  description = "Tag of the docker image to use."
  default     = "v0.16.0"
}

variable "replicas" {
  description = "Number of replicas to deploy."
  default     = 1
}

#####
# Service
#####

variable "service_annotations" {
  description = "Additionnal annotations that will be merged for the service."
  default     = {}
}

variable "service_labels" {
  description = "Additionnal labels that will be merged for the service."
  default     = {}
}

variable "service_name" {
  description = "Name of the service that will be create"
  default     = "blackbox-exporter"
}

#####
# Config Map
#####

variable "config_map_annotations" {
  description = "Additionnal annotations that will be merged for the config map."
  default     = {}
}

variable "config_map_labels" {
  description = "Additionnal labels that will be merged for the config map."
  default     = {}
}

variable "config_map_name" {
  description = "Name of the config map that will be created."
  default     = "blackbox-exporter"
}
