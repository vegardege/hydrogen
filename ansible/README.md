# Ansible Configuration

This directory contains Ansible playbooks and roles for configuring the Hydrogen server.

## Prerequisites

1. Terraform must be applied first (to create the server)
2. Install Ansible on your local machine
3. Ensure you have the SSH keys required
4. Install required Ansible collections:
   ```bash
   cd ansible
   ansible-galaxy install -r requirements.yml
   ```

## Directory Structure

```
ansible/
├── ansible.cfg             # Ansible configuration
├── inventory/
│   └── hosts.yml           # Server inventory
├── playbooks/
│   └── setup.yml           # Main setup playbook
└── roles/
    └── users/              # User management role
```

## Usage

Run the main setup playbook:

```bash
cd ansible
ansible-playbook playbooks/setup.yml
```

This will:

- Create the `deploy` group
- Create the `hydro` admin user with sudo privileges
- Set up SSH key authentication for the `hydro` user

## Roles

### users

Creates admin user and groups:

- **User**: `hydro`
- **Groups**: `sudo`, `deploy`
- **Features**: Passwordless sudo, SSH key authentication

## Testing

Test connectivity before running playbooks:

```bash
cd ansible
ansible hydrogen -m ping
```

## Switching from root to hydro

After the initial setup, you can update the inventory to connect as `hydro`:

```yaml
ansible_user: hydro
```

Then disable root SSH login using an SSH hardening role (to be created).
