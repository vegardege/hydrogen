#!/bin/bash
# Deploy Caddyfile changes to server

set -e

CADDYFILE="${1:-../caddy/Caddyfile}"
SERVER_IP=$(terraform -chdir=../terraform output -raw server_ipv4 2>/dev/null || echo "")

if [ -z "$SERVER_IP" ]; then
    echo "Error: Could not get server IP from Terraform"
    echo "You can override by setting SERVER_IP environment variable"
    exit 1
fi

if [ ! -f "$CADDYFILE" ]; then
    echo "Error: Caddyfile '$CADDYFILE' does not exist"
    echo "Usage: $0 [path-to-Caddyfile]"
    exit 1
fi

echo "Validating Caddyfile locally..."
if ! caddy validate --config "$CADDYFILE" --adapter caddyfile 2>/dev/null; then
    echo "Warning: Local caddy not found or validation failed. Continuing anyway..."
fi

echo "Uploading Caddyfile to server..."
scp -i ~/.ssh/id_ed25519_hydro "$CADDYFILE" "hydro@$SERVER_IP:/tmp/Caddyfile"

echo "Validating and reloading on server..."
ssh -i ~/.ssh/id_ed25519_hydro "hydro@$SERVER_IP" << 'EOF'
    set -e
    echo "Validating Caddyfile..."
    sudo caddy validate --config /tmp/Caddyfile --adapter caddyfile
    echo "Moving to /etc/caddy/Caddyfile..."
    sudo mv /tmp/Caddyfile /etc/caddy/Caddyfile
    echo "Reloading Caddy (zero downtime)..."
    sudo caddy reload --config /etc/caddy/Caddyfile
EOF

echo "Caddyfile deployed and Caddy reloaded successfully!"
