# terraform-module-kubernetes-blackbox-exporter

Terraform module to deploy blackbox-exporter on kubernetes.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.14 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | >= 2.0.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | >= 2.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | >= 2.0.0 |
| <a name="provider_random"></a> [random](#provider\_random) | >= 2.0.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [kubernetes_config_map.this](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/config_map) | resource |
| [kubernetes_deployment.this](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/deployment) | resource |
| [kubernetes_service.this](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/service) | resource |
| [random_string.selector](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_annotations"></a> [annotations](#input\_annotations) | Additionnal annotations that will be merged on all resources. | `map` | `{}` | no |
| <a name="input_config_map_annotations"></a> [config\_map\_annotations](#input\_config\_map\_annotations) | Additionnal annotations that will be merged for the config map. | `map` | `{}` | no |
| <a name="input_config_map_labels"></a> [config\_map\_labels](#input\_config\_map\_labels) | Additionnal labels that will be merged for the config map. | `map` | `{}` | no |
| <a name="input_config_map_name"></a> [config\_map\_name](#input\_config\_map\_name) | Name of the config map that will be created. | `string` | `"blackbox-exporter"` | no |
| <a name="input_configuration"></a> [configuration](#input\_configuration) | Object representating the configuration for blackbox-exporter. [documentation](https://github.com/prometheus/blackbox_exporter/blob/master/CONFIGURATION.md) (will be converted into yaml) | `any` | <pre>{<br>  "modules": {<br>    "http_2xx": {<br>      "prober": "http"<br>    },<br>    "http_post_2xx": {<br>      "http": {<br>        "method": "POST"<br>      },<br>      "prober": "http"<br>    },<br>    "icmp": {<br>      "prober": "icmp"<br>    },<br>    "irc_banner": {<br>      "prober": "tcp",<br>      "tcp": {<br>        "query_response": [<br>          {<br>            "send": "NICK prober"<br>          },<br>          {<br>            "send": "USER prober prober prober :prober"<br>          },<br>          {<br>            "expect": "PING :([^ ]+)",<br>            "send": "PONG 1"<br>          },<br>          {<br>            "expect": "^:[^ ]+ 001"<br>          }<br>        ]<br>      }<br>    },<br>    "pop3s_banner": {<br>      "prober": "tcp",<br>      "tcp": {<br>        "query_response": [<br>          {<br>            "expect": "^+OK"<br>          }<br>        ],<br>        "tls": true,<br>        "tls_config": {<br>          "insecure_skip_verify": false<br>        }<br>      }<br>    },<br>    "ssh_banner": {<br>      "prober": "tcp",<br>      "tcp": {<br>        "query_response": [<br>          {<br>            "expect": "^SSH-2.0-"<br>          }<br>        ]<br>      }<br>    },<br>    "tcp_connect": {<br>      "prober": "tcp"<br>    }<br>  }<br>}</pre> | no |
| <a name="input_deployment_annotations"></a> [deployment\_annotations](#input\_deployment\_annotations) | Additionnal annotations that will be merged on the deployment. | `map` | `{}` | no |
| <a name="input_deployment_labels"></a> [deployment\_labels](#input\_deployment\_labels) | Additionnal labels that will be merged on the deployment. | `map` | `{}` | no |
| <a name="input_deployment_name"></a> [deployment\_name](#input\_deployment\_name) | Name of the deployment that will be create. | `string` | `"blackbox-exporter"` | no |
| <a name="input_deployment_template_annotations"></a> [deployment\_template\_annotations](#input\_deployment\_template\_annotations) | Additionnal annotations that will be merged on the deployment template. | `map` | `{}` | no |
| <a name="input_deployment_template_labels"></a> [deployment\_template\_labels](#input\_deployment\_template\_labels) | Additionnal labels that will be merged on the deployment template. | `map` | `{}` | no |
| <a name="input_enabled"></a> [enabled](#input\_enabled) | Whether or not to enable this module. | `bool` | `true` | no |
| <a name="input_image_name"></a> [image\_name](#input\_image\_name) | Name of the docker image to use. | `string` | `"prom/blackbox-exporter"` | no |
| <a name="input_image_pull_policy"></a> [image\_pull\_policy](#input\_image\_pull\_policy) | Image pull policy on the main container. | `string` | `"IfNotPresent"` | no |
| <a name="input_image_version"></a> [image\_version](#input\_image\_version) | Tag of the docker image to use. | `string` | `"v0.16.0"` | no |
| <a name="input_labels"></a> [labels](#input\_labels) | Additionnal labels that will be merged on all resources. | `map` | `{}` | no |
| <a name="input_module_targets"></a> [module\_targets](#input\_module\_targets) | List of objects representing all the targets you want to activate the blackbox-exporter on (with it's modules). **Note:** This value is used by the prometheus configuration helper which is the `prometheus_scrape_configs` output. | <pre>list(object({<br>    name    = string<br>    targets = list(string)<br>    labels  = map(string)<br>  }))</pre> | `[]` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Namespace in which the module will be deployed. | `string` | `"default"` | no |
| <a name="input_prometheus_alert_groups_rules_annotations"></a> [prometheus\_alert\_groups\_rules\_annotations](#input\_prometheus\_alert\_groups\_rules\_annotations) | Map of strings that will be merge on all prometheus alert groups rules annotations. | `map` | `{}` | no |
| <a name="input_prometheus_alert_groups_rules_labels"></a> [prometheus\_alert\_groups\_rules\_labels](#input\_prometheus\_alert\_groups\_rules\_labels) | Map of strings that will be merge on all prometheus alert groups rules labels. | `map` | `{}` | no |
| <a name="input_replicas"></a> [replicas](#input\_replicas) | Number of replicas to deploy. | `number` | `1` | no |
| <a name="input_service_annotations"></a> [service\_annotations](#input\_service\_annotations) | Additionnal annotations that will be merged for the service. | `map` | `{}` | no |
| <a name="input_service_labels"></a> [service\_labels](#input\_service\_labels) | Additionnal labels that will be merged for the service. | `map` | `{}` | no |
| <a name="input_service_name"></a> [service\_name](#input\_service\_name) | Name of the service that will be create | `string` | `"blackbox-exporter"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_config_map_annotations"></a> [config\_map\_annotations](#output\_config\_map\_annotations) | Map of annotations that are configured on the config\_map. |
| <a name="output_config_map_labels"></a> [config\_map\_labels](#output\_config\_map\_labels) | Map of labels that are configured on the config\_map. |
| <a name="output_config_map_name"></a> [config\_map\_name](#output\_config\_map\_name) | Name of the config\_map created by the module. |
| <a name="output_deployment_annotations"></a> [deployment\_annotations](#output\_deployment\_annotations) | Map of annotations that are configured on the deployment. |
| <a name="output_deployment_labels"></a> [deployment\_labels](#output\_deployment\_labels) | Map of labels that are configured on the deployment. |
| <a name="output_deployment_name"></a> [deployment\_name](#output\_deployment\_name) | Name of the deployment created by the module. |
| <a name="output_deployment_template_annotations"></a> [deployment\_template\_annotations](#output\_deployment\_template\_annotations) | Map of annotations that are configured on the deployment. |
| <a name="output_deployment_template_labels"></a> [deployment\_template\_labels](#output\_deployment\_template\_labels) | Map of labels that are configured on the deployment. |
| <a name="output_grafana_dashboards"></a> [grafana\_dashboards](#output\_grafana\_dashboards) | List of strings representing grafana dashbaords under the form of json strings. |
| <a name="output_image_name"></a> [image\_name](#output\_image\_name) | Name of the docker image used for the blackbox-exporter container. |
| <a name="output_image_pull_policy"></a> [image\_pull\_policy](#output\_image\_pull\_policy) | Image pull policy defined on the blackbox-exporter container. |
| <a name="output_image_version"></a> [image\_version](#output\_image\_version) | Tag of the docker image used for the blackbox-exporter container. |
| <a name="output_namespace"></a> [namespace](#output\_namespace) | Name of the namespace in which the resources have been deployed. |
| <a name="output_prometheus_alert_groups"></a> [prometheus\_alert\_groups](#output\_prometheus\_alert\_groups) | List of object representing prometheus alert groups you can importer for prometheus to alert you in case of problems. |
| <a name="output_prometheus_scrape_configs"></a> [prometheus\_scrape\_configs](#output\_prometheus\_scrape\_configs) | List of objects representing the promehteus scrape configs you need import for prometheus to scrape this exporter. |
| <a name="output_selector_labels"></a> [selector\_labels](#output\_selector\_labels) | Map of the labels that are used as selectors. |
| <a name="output_service_annotations"></a> [service\_annotations](#output\_service\_annotations) | Map of annotations that are configured on the service. |
| <a name="output_service_labels"></a> [service\_labels](#output\_service\_labels) | Map of labels that are configured on the service. |
| <a name="output_service_name"></a> [service\_name](#output\_service\_name) | Name of the service created by the module. |
| <a name="output_service_port"></a> [service\_port](#output\_service\_port) | Port number of the service port. |
| <a name="output_service_port_name"></a> [service\_port\_name](#output\_service\_port\_name) | Name of the service port. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

### prometheus_scrape_configs
The prometheus scrape config output is a helper to generate static prometheus scrape configs for the targets passed as vairable. The following assumptions are made:
* prometheus is scraping from the same kubernetes cluster
* there are no blocking network policies

In addition, the eporter's metrics will automatically be discovered by prometheus if the `kubernetes_to_sd` configuration is correctly configured.
