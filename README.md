## Harvester on Equinix

Simple example using the terraform equinix provider to create a multi node harvester cluster.

The user needs to provide two environment variables

`METAL_AUTH_TOKEN` API token to access your Equinix account

`TF_VAR_project_name` Terraform variable to identify project in your Equinix account.

By default the module will create a 3 node Harvester cluster.

The Harvester console can be accessed using an Elastic IP created by the sample.

A random token and password will be generated for your example.