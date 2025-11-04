# Hydrogen

Infrastructure-as-code configuration for a small web server hosting [Pebble Patch](https://pebblepatch.dev/) and my other side projects.

This is highly unlikely to be directly reusable for anyone but me, but I'm making it public in the spirit of sharing and in case someone wants to suggest any improvements.

## Stack

The project uses:

- [Terraform](https://developer.hashicorp.com/terraform) for server provisioning
- [Ansible](https://www.ansible.com/) for automatic configuration of the server
- [Debian Stable](https://www.debian.org/) as the operating system of choice
- [Caddy](https://caddyserver.com/) for static site hosting
- [Docker](https://www.docker.com/) for dynamic site hosting (reverse-proxied through Caddy)

## Structure

```
terraform/       # Server provisioning
ansible/         # Configuration management
  roles/
    users/       # User and group setup
    security/    # SSH hardening, auto-updates
    docker/      # Docker installation
    caddy/       # Caddy web server
deploy/          # Example deployment scripts
caddy/           # My Caddyfile configurations
docker/          # My docker compose files
```

## Setup

See [SETUP.md](SETUP.md) for detailed instructions on provisioning and configuring a server from scratch.

If you actually want to use any of this yourself, make sure to check all variables and configurations.

## Deployment

Look at the included deploy scripts for example deployment workflows.

In practice, you should integrate these in your CI/CD pipeline of choice instead of depending on the shell scripts, though.
