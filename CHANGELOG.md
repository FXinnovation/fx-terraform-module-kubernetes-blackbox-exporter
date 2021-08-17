
1.3.0 / 2021-08-16
==================

  * feat (BREAKING): Update kubernetes terraform provider to version 2.x
  * chore: bump pre-commit hooks

1.2.0 / 2020-04-13
==================

  * feat: Change alerts annotations and labels as well as k8s resources labels and annotations.

1.1.2 / 2020-04-09
==================

  * fix: Add port annotation for prometheus on pods

1.1.1 / 2020-03-24
==================

  * fix: Error in alert rule groups output

1.1.0 / 2020-03-20
==================

  * fix: Make dashboard generic for import
  * fix: Remove scrape annotation from service
  * feat: Add default alerts as output of the module.

1.0.0 / 2020-03-18
==================

  * tech: adapt example to changes
  * breaking: Add possibility to add labels on targets
  * fix: Actually use the replica variable
  * feat: Add scrape annotation on pods
  * feat: Add first version of the grafana dashboard.

0.1.0 / 2020-03-05
==================

  * tech: improve Jenkinsfile
  * tech: Add more outputs on example
  * fix: Output descriptions
  * fix: Add better description for module configuration
  * feat: Initial import of module
  * Initial commit
