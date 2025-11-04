# Server Setup from Scratch

Complete instructions for provisioning and configuring a Hydrogen server.

## Prerequisites

- [Terraform](https://developer.hashicorp.com/terraform) installed
- [Ansible](https://www.ansible.com/) installed
- Hetzner Cloud account

## 1. Provision Infrastructure with Terraform

### Setup Hetzner Cloud

1. Create a Hetzner Cloud account and project
2. Create an API Token in `Security > API Tokens > Generate API Token`
3. Export the token in your shell:
   ```bash
   export HCLOUD_TOKEN=your-token-here
   ```

### Add SSH Key

Add your SSH key to Hetzner Cloud in the console (make sure to choose the correct project):

Update `terraform/terraform.tfvars` with your SSH key name:

```hcl
ssh_key_name = "pebblepatch"
```

### Create Server

Initialize and apply Terraform configuration:

```bash
cd terraform
terraform init
terraform plan
terraform apply
```

The server IP will be displayed in the output. You can also retrieve it later:

```bash
terraform output server_ipv4
```

### Test Access

SSH to the server as root:

```bash
ssh root@<ipv4-address-from-output>
```

### Destroy Server (Optional)

To destroy the infrastructure:

```bash
cd terraform
terraform plan -destroy
terraform destroy
```

## 2. Configure Server with Ansible

### Create SSH Keys

Create separate SSH keys for admin (`hydro`) and deployment (`deploy`):

```bash
ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519_hydro
ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519_deploy
```

### Install Ansible Dependencies

Install required Ansible collections:

```bash
cd ansible
ansible-galaxy install -r requirements.yml
```

### Run Setup Playbook

Configure the server with all roles (users, security, docker, caddy):

```bash
cd ansible
ansible-playbook playbooks/setup.yml -e "server_ip=$(terraform -chdir=../terraform output -raw server_ipv4)"
```

**Note:** You can hardcode the server IP instead if preferred. Without a floating IP, the IP only remains constant for the server's lifetime.

This playbook will:

- Create `hydro` admin user with sudo privileges
- Create `deploy` user for deployments with restricted SSH access
- Install Docker and Docker Compose
- Install Caddy web server
- Create `/srv/static/` and `/srv/docker/` directories with proper permissions
- Configure automatic security updates
- Disable SSH password authentication

### Configure SSH Access

Add an SSH config entry for easy access:

```bash
cat >> ~/.ssh/config <<EOF

Host hydrogen
  HostName $(terraform -chdir=terraform output -raw server_ipv4)
  User hydro
  IdentityFile ~/.ssh/id_ed25519_hydro
EOF
```

Now you can SSH to the server:

```bash
ssh hydrogen
```

Or connect as the deploy user:

```bash
ssh -i ~/.ssh/id_ed25519_deploy deploy@<server-ip>
```

## 3. Verify Installation

SSH to the server and verify services:

```bash
ssh hydrogen

# Check Docker
docker --version
docker compose version
docker ps

# Check Caddy
caddy version
sudo systemctl status caddy

# Check directory structure
ls -la /srv/
```

## 4. Deploy Sites

See the deploy scripts for example deployment instructions. Note that you probably want to include this in your CI/CD pipeline of choice instead of running bash scripts locally.

## Directory Structure on Server

```
/srv/
├── static/              # Static websites (served by Caddy)
│   ├── pebblepatch/
│   └── ...
├── docker/              # Docker compose files
│   └── compose.yml
└── scripts/             # Cron job scripts

/etc/caddy/
└── Caddyfile            # Caddy configuration
```

## Maintenance

### Updating Configuration

Re-run the Ansible playbook to apply configuration changes:

```bash
cd ansible
ansible-playbook playbooks/setup.yml -e "server_ip=<server-ip>"
```

The playbook is idempotent and safe to run multiple times.

### Security Updates

The server is configured with `unattended-upgrades` for automatic security updates. Manual updates:

```bash
ssh hydrogen
sudo apt update
sudo apt upgrade
```

Check if reboot is required:

```bash
cat /var/run/reboot-required
```

### Monitoring Services

Check service status:

```bash
sudo systemctl status caddy
sudo systemctl status docker
```

View logs:

```bash
sudo journalctl -u caddy -f
sudo journalctl -u docker -f
```
