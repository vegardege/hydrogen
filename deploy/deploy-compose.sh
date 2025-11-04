#!/bin/bash
# Deploy Docker Compose changes to server

set -e

COMPOSE_FILE="${1:-../docker/compose.yml}"
SERVER_IP=$(terraform -chdir=../terraform output -raw server_ipv4 2>/dev/null || echo "")

if [ -z "$SERVER_IP" ]; then
    echo "Error: Could not get server IP from Terraform"
    echo "You can override by setting SERVER_IP environment variable"
    exit 1
fi

if [ ! -f "$COMPOSE_FILE" ]; then
    echo "Error: Compose file '$COMPOSE_FILE' does not exist"
    echo "Usage: $0 [path-to-compose.yml]"
    exit 1
fi

echo "Uploading compose file to server..."
scp -i ~/.ssh/id_ed25519_hydro "$COMPOSE_FILE" "hydro@$SERVER_IP:/tmp/compose.yml"

echo "Moving compose file and applying changes..."
ssh -i ~/.ssh/id_ed25519_hydro "hydro@$SERVER_IP" << 'EOF'
    set -e
    echo "Moving compose file to /srv/docker/..."
    sudo mv /tmp/compose.yml /srv/docker/compose.yml
    cd /srv/docker
    echo "Running docker compose up -d..."
    docker compose up -d
    echo "Current containers:"
    docker compose ps
EOF

echo "Docker Compose deployed and containers updated!"
