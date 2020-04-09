# terraform-module-kubernetes-blackbox-exporter

Terraform module to deploy blackbox-exporter on kubernetes.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.12 |
| kubernetes | >= 1.10.0 |
| random | >= 2.0.0 |

## Providers

| Name | Version |
|------|---------|
| kubernetes | >= 1.10.0 |
| random | >= 2.0.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| annotations | Additionnal annotations that will be merged on all resources. | `map` | `{}` | no |
| config\_map\_annotations | Additionnal annotations that will be merged for the config map. | `map` | `{}` | no |
| config\_map\_labels | Additionnal labels that will be merged for the config map. | `map` | `{}` | no |
| config\_map\_name | Name of the config map that will be created. | `string` | `"blackbox-exporter"` | no |
| configuration | Object representating the configuration for blackbox-exporter. [documentation](https://github.com/prometheus/blackbox_exporter/blob/master/CONFIGURATION.md) (will be converted into yaml) | `any` | <pre>{<br>  "modules": {<br>    "http_2xx": {<br>      "prober": "http"<br>    },<br>    "http_post_2xx": {<br>      "http": {<br>        "method": "POST"<br>      },<br>      "prober": "http"<br>    },<br>    "icmp": {<br>      "prober": "icmp"<br>    },<br>    "irc_banner": {<br>      "prober": "tcp",<br>      "tcp": {<br>        "query_response": [<br>          {<br>            "send": "NICK prober"<br>          },<br>          {<br>            "send": "USER prober prober prober :prober"<br>          },<br>          {<br>            "expect": "PING :([^ ]+)",<br>            "send": "PONG 1"<br>          },<br>          {<br>            "expect": "^:[^ ]+ 001"<br>          }<br>        ]<br>      }<br>    },<br>    "pop3s_banner": {<br>      "prober": "tcp",<br>      "tcp": {<br>        "query_response": [<br>          {<br>            "expect": "^+OK"<br>          }<br>        ],<br>        "tls": true,<br>        "tls_config": {<br>          "insecure_skip_verify": false<br>        }<br>      }<br>    },<br>    "ssh_banner": {<br>      "prober": "tcp",<br>      "tcp": {<br>        "query_response": [<br>          {<br>            "expect": "^SSH-2.0-"<br>          }<br>        ]<br>      }<br>    },<br>    "tcp_connect": {<br>      "prober": "tcp"<br>    }<br>  }<br>}</pre> | no |
| deployment\_annotations | Additionnal annotations that will be merged on the deployment. | `map` | `{}` | no |
| deployment\_labels | Additionnal labels that will be merged on the deployment. | `map` | `{}` | no |
| deployment\_name | Name of the deployment that will be create. | `string` | `"blackbox-exporter"` | no |
| deployment\_template\_annotations | Additionnal annotations that will be merged on the deployment template. | `map` | `{}` | no |
| deployment\_template\_labels | Additionnal labels that will be merged on the deployment template. | `map` | `{}` | no |
| enabled | Whether or not to enable this module. | `bool` | `true` | no |
| image\_name | Name of the docker image to use. | `string` | `"prom/blackbox-exporter"` | no |
| image\_pull\_policy | Image pull policy on the main container. | `string` | `"IfNotPresent"` | no |
| image\_version | Tag of the docker image to use. | `string` | `"v0.16.0"` | no |
| labels | Additionnal labels that will be merged on all resources. | `map` | `{}` | no |
| module\_targets | List of objects representing all the targets you want to activate the blackbox-exporter on (with it's modules). **Note:** This value is used by the prometheus configuration helper which is the `prometheus_scrape_configs` output. | <pre>list(object({<br>    name    = string<br>    targets = list(string)<br>    labels  = map(string)<br>  }))</pre> | `[]` | no |
| namespace | Namespace in which the module will be deployed. | `string` | `"default"` | no |
| prometheus\_alert\_groups\_rules\_annotations | Map of strings that will be merge on all prometheus alert groups rules annotations. | `map` | `{}` | no |
| prometheus\_alert\_groups\_rules\_labels | Map of strings that will be merge on all prometheus alert groups rules labels. | `map` | `{}` | no |
| replicas | Number of replicas to deploy. | `number` | `1` | no |
| service\_annotations | Additionnal annotations that will be merged for the service. | `map` | `{}` | no |
| service\_labels | Additionnal labels that will be merged for the service. | `map` | `{}` | no |
| service\_name | Name of the service that will be create | `string` | `"blackbox-exporter"` | no |

## Outputs

| Name | Description |
|------|-------------|
| config\_map\_annotations | Map of annotations that are configured on the config\_map. |
| config\_map\_labels | Map of labels that are configured on the config\_map. |
| config\_map\_name | Name of the config\_map created by the module. |
| deployment\_annotations | Map of annotations that are configured on the deployment. |
| deployment\_labels | Map of labels that are configured on the deployment. |
| deployment\_name | Name of the deployment created by the module. |
| deployment\_template\_annotations | Map of annotations that are configured on the deployment. |
| deployment\_template\_labels | Map of labels that are configured on the deployment. |
| grafana\_dashboards | List of strings representing grafana dashbaords under the form of json strings. |
| image\_name | Name of the docker image used for the blackbox-exporter container. |
| image\_pull\_policy | Image pull policy defined on the blackbox-exporter container. |
| image\_version | Tag of the docker image used for the blackbox-exporter container. |
| namespace | Name of the namespace in which the resources have been deployed. |
| prometheus\_alert\_groups | List of object representing prometheus alert groups you can importer for prometheus to alert you in case of problems. |
| prometheus\_scrape\_configs | List of objects representing the promehteus scrape configs you need import for prometheus to scrape this exporter. |
| selector\_labels | Map of the labels that are used as selectors. |
| service\_annotations | Map of annotations that are configured on the service. |
| service\_labels | Map of labels that are configured on the service. |
| service\_name | Name of the service created by the module. |
| service\_port | Port number of the service port. |
| service\_port\_name | Name of the service port. |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

### prometheus_scrape_configs
The prometheus scrape config output is a helper to generate static prometheus scrape configs for the targets passed as vairable. The following assumptions are made:
* prometheus is scraping from the same kubernetes cluster
* there are no blocking network policies

In addition, the eporter's metrics will automatically be discovered by prometheus if the `kubernetes_to_sd` configuration is correctly configured.
