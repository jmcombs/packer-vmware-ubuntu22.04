# Ubuntu 22.04 Minimal Image Template for VMware vCenter

For those who want to create Ubuntu 22.04 Minimal images,for automated deployment in VMware vCenter, with Terraform.
This is a template, using Hashicorp Packer, that aims to allow the process to be automated and secure by keeping sensitive information outside of the templates.
1Password CLI 2 and Docker are used in this.

```sh
op run --env-file=.env -- docker run \
--env PKR_VAR_ssh_username \
--env PKR_VAR_ssh_password \
--env PKR_VAR_ssh_hashed_password \
--env PKR_VAR_vcenter_username \
--env PKR_VAR_vcenter_password \
--env PKR_VAR_vcenter_server \
--env PKR_VAR_vcenter_datacenter \
--env PKR_VAR_vcenter_cluster \
--env PKR_VAR_vcenter_datastore \
--env PKR_VAR_vcenter_network \
--env PKR_VAR_vcenter_network \
--env PKR_VAR_vcenter_network \
--env PACKER_PLUGIN_PATH=/workspace/.packer.d/plugins \
-v `pwd`:/workspace \
-w /workspace \
hashicorp/packer:latest \
build -on-error=ask .
```
