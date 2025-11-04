#!/bin/bash
# Deploy static site to server

set -e

if [ "$#" -lt 2 ]; then
    echo "Usage: $0 <local-directory> <site-name>"
    echo "Example: $0 ./pebblepatch-build pebblepatch"
    exit 1
fi

LOCAL_DIR="$1"
SITE_NAME="$2"
SERVER_IP=$(terraform -chdir=../terraform output -raw server_ipv4 2>/dev/null || echo "")

if [ -z "$SERVER_IP" ]; then
    echo "Error: Could not get server IP from Terraform"
    echo "You can override by setting SERVER_IP environment variable"
    exit 1
fi

if [ ! -d "$LOCAL_DIR" ]; then
    echo "Error: Local directory '$LOCAL_DIR' does not exist"
    exit 1
fi

echo "Deploying $LOCAL_DIR to /srv/static/$SITE_NAME on $SERVER_IP..."

rsync -avz \
    -e "ssh -i ~/.ssh/id_ed25519_deploy" \
    "$LOCAL_DIR/" \
    "deploy@$SERVER_IP:/srv/static/$SITE_NAME/"

echo "Deployment complete!"
