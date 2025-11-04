# Deployment Scripts

Helper scripts for deploying to the Hydrogen server.

## Prerequisites

- Terraform applied (for getting server IP)
- Ansible playbook run (users and services set up)
- SSH keys configured (`~/.ssh/id_ed25519_hydro` and `~/.ssh/id_ed25519_deploy`)

## Scripts

### deploy-static.sh

Deploy static site files to the server.

```bash
./deploy-static.sh <local-directory> <site-name>
```

**Example:**
```bash
./deploy-static.sh ~/projects/pebblepatch/dist pebblepatch
```

This will rsync the local directory to `/srv/static/pebblepatch/` on the server. Changes are visible immediately (no reload needed).

### deploy-caddy.sh

Deploy Caddyfile changes to the server.

```bash
./deploy-caddy.sh [path-to-Caddyfile]
```

**Example:**
```bash
./deploy-caddy.sh ../caddy/Caddyfile
```

If no path is provided, defaults to `../caddy/Caddyfile`. This will:
1. Validate the Caddyfile
2. Upload to server
3. Validate on server
4. Gracefully reload Caddy (zero downtime)

### deploy-compose.sh

Deploy Docker Compose file changes to the server.

```bash
./deploy-compose.sh [path-to-compose.yml]
```

**Example:**
```bash
./deploy-compose.sh ../docker/compose.yml
```

If no path is provided, defaults to `../docker/compose.yml`. This will:
1. Upload compose file to `/srv/docker/compose.yml`
2. Run `docker compose up -d` (recreates changed containers)
3. Show running containers

## Environment Variables

All scripts try to get the server IP from Terraform. If that fails, you can override:

```bash
SERVER_IP=49.13.211.238 ./deploy-static.sh ./site pebblepatch
```

## Notes

- **Static sites**: Changes are immediate, no reload needed
- **Caddyfile**: Uses `caddy reload` for zero-downtime updates
- **Docker Compose**: Uses `up -d` which only recreates changed containers
- All scripts use the appropriate SSH keys (`deploy` for static, `hydro` for admin tasks)
