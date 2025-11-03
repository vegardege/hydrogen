# Hydrogen

This repository contains the configuration needed to setup a small server hosting [Pebble Patch](https://pebblepatch.dev/) and my other side projects.

I don't expect the reusability to be significant, but share the files because sharing is nice and feedback always welcome.

Following are instructions on how to setup a new server from scratch.

## Creating the Server

The server is currently hosted at [Hetzner](https://hetzner.com/). First steps:

1. Setup an account and a new project
2. Create an API Token in `Security > API Tokens > Generate API Token`
3. Export the newly generated token as `HCLOUD_TOKEN` in your shell
4. Add your SSH key: `hcloud ssh-key create --name "<name>" --public-key-from-file ~/.ssh/id_ed25519.pub`
5. Update `terraform.tfvars` with the chosen ssh-key name.

We are now ready to create the server itself. For a reproducible setup, we use [Terraform](https://developer.hashicorp.com/terraform). Follow the installation instructions on your preferred system, then initialize with:

```bash
cd terraform
terraform init
```

After the initial setup, you can use:

```bash
cd terraform
terraform plan
terraform apply
ssh root@<ipv4-address-from-output>
```

To destroy the setup again:

```bash
cd terraform
terraform plan -destroy
terraform destroy
```
