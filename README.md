## Harvester on Equinix

This project demonstrates using the [Terraform Equinix provider](https://deploy.equinix.com/labs/terraform-provider-equinix/) to create a multi-node Harvester cluster.

The user needs to provide three environment variables:

* `METAL_AUTH_TOKEN`: API token to access your Equinix account through the Terraform Provider
* `TF_VAR_api_key`: API token to access your Equinix Metal account through the http Provider (needed only for Spot Market pricing)
* `TF_VAR_project_id`: Terraform variable to identify the project in your Equinix account
  
   Alternatively, the user can provide:
   `TF_VAR_metal_create_project`: create a project named `TF_VAR_project_name` if it does not exist

You can overwrite any values in `variables.tf` by using `.tfvars` files or [other means](https://www.terraform.io/language/values/variables#assigning-values-to-root-module-variables)

By default, the module will create a 3-node Harvester cluster.

The Harvester console can be accessed using an Elastic IP created by the sample.

A random token and password will be generated for your example.

```sh
terraform output -raw harvester_os_password
terraform output -raw harvester_cluster_secret
```

If you provide a Rancher API URL and keys, Rancher can manage your Harvester environment, and a `kubeconfig` file will be saved locally.

### Using `terraform.tfvars.example` to Override Variable Values

You can use the `terraform.tfvars.example` file to override the default values in `variables.tf`. To do this, rename the example File from `terraform.tfvars.example` to `terraform.tfvars`.