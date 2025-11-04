# Hydrogen

This repository contains the configuration needed to setup a small server hosting [Pebble Patch](https://pebblepatch.dev/) and my other side projects.

I don't expect the reusability to be significant, but share the files because sharing is nice and feedback always welcome.

Following are instructions on how to setup a new server from scratch.

## Provisioning the Server

The server is currently hosted at [Hetzner](https://hetzner.com/). First steps:

1. Setup an account and a new project
2. Create an API Token in `Security > API Tokens > Generate API Token`
3. Export the newly generated token as `HCLOUD_TOKEN` in your shell
4. Add your SSH key in the console
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

You should now have a running server. To destroy the setup again:

```bash
cd terraform
terraform plan -destroy
terraform destroy
```

## Configuring the Server

To automate the server setup, we will use [Ansible](https://www.redhat.com/en/ansible-collaborative). Follow the installation instructions on your preferred system.

Once Ansible is installed, create the desired SSH keys (e.g. `ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519_hydro` and `ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519_deploy`) and initialize ansible with:

```bash
cd ansible
ansible-galaxy install -r requirements.yml
```

You can now configure the server by running the main playbook:

```bash
cd ansible
ansible-playbook playbooks/setup.yml -e "server_ip=$(terraform -chdir=../terraform output -raw server_ipv4)"
```

Feel free to hard code the server IP as a variable or an env var, of course. I don't pay for a floating IP myself, so it's only constant for the lifetime of the server.

This will, by default:

- Create a `hydro` admin user with sudo privileges
- Create a `deploy` user with limited access for static site deployment

After the playbook completes, add the following to `~/.ssh/config`:

```bash
Host hydrogen
  HostName <ip>
  User hydro
  IdentityFile ~/.ssh/id_ed25519_hydro
```

And you can SSH to the server:

```bash
ssh hydrogen
```

Or SSH with the desired user:

```bash
ssh -i ~/.ssh/id_ed25519_deploy deploy@<ip>
```
