#####
# Providers
#####

provider "random" {
  version = "~> 2"
}

provider "kubernetes" {
  version          = "1.10.0"
  load_config_file = true
}

#####
# Randoms
#####

resource "random_string" "default" {
  upper   = false
  number  = false
  special = false
  length  = 8
}

resource "random_string" "disabled" {
  upper   = false
  number  = false
  special = false
  length  = 8
}

#####
# Context
#####

resource "kubernetes_namespace" "default" {
  metadata {
    name = random_string.default.result
  }
}

resource "kubernetes_namespace" "disabled" {
  metadata {
    name = random_string.disabled.result
  }
}

#####
# default example
#####

module "default" {
  source = "../.."

  namespace = kubernetes_namespace.default.metadata.0.name

  module_targets = [
    {
      name    = "http_2xx",
      targets = ["https://fxinnovation.com"]
    }
  ]
}

#####
# disabled example
#####

module "disabled" {
  source = "../.."

  enabled = false

  namespace = kubernetes_namespace.disabled.metadata.0.name
}
