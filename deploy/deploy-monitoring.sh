#!/bin/bash
# Deploy monitoring stack (Prometheus, node_exporter, Grafana) to server

set -e

MONITORING_DIR="${1:-../monitoring}"
SERVER_IP=$(terraform -chdir=../terraform output -raw server_ipv4 2>/dev/null || echo "")

if [ -z "$SERVER_IP" ]; then
    echo "Error: Could not get server IP from Terraform"
    echo "You can override by setting SERVER_IP environment variable"
    exit 1
fi

if [ ! -d "$MONITORING_DIR" ]; then
    echo "Error: Monitoring directory '$MONITORING_DIR' does not exist"
    echo "Usage: $0 [path-to-monitoring-dir]"
    exit 1
fi

echo "Uploading monitoring configuration to server..."
scp -i ~/.ssh/id_ed25519_hydro "$MONITORING_DIR/compose.yml" "hydro@$SERVER_IP:/tmp/monitoring-compose.yml"
scp -i ~/.ssh/id_ed25519_hydro "$MONITORING_DIR/prometheus/prometheus.yml" "hydro@$SERVER_IP:/tmp/prometheus.yml"
scp -i ~/.ssh/id_ed25519_hydro "$MONITORING_DIR/blackbox/blackbox.yml" "hydro@$SERVER_IP:/tmp/blackbox.yml"

echo "Setting up directories and deploying monitoring stack..."
ssh -i ~/.ssh/id_ed25519_hydro "hydro@$SERVER_IP" << 'EOF'
    set -e
    echo "Creating /srv/monitoring directory structure..."
    sudo mkdir -p /srv/monitoring/prometheus
    sudo mkdir -p /srv/monitoring/blackbox
    sudo chown -R hydro:hydro /srv/monitoring

    echo "Moving configuration files..."
    mv /tmp/monitoring-compose.yml /srv/monitoring/compose.yml
    mv /tmp/prometheus.yml /srv/monitoring/prometheus/prometheus.yml
    mv /tmp/blackbox.yml /srv/monitoring/blackbox/blackbox.yml
    chmod 644 /srv/monitoring/compose.yml
    chmod 644 /srv/monitoring/prometheus/prometheus.yml
    chmod 644 /srv/monitoring/blackbox/blackbox.yml

    echo "Starting monitoring stack..."
    cd /srv/monitoring
    docker compose up -d

    echo "Restarting Prometheus to load updated config..."
    docker compose restart prometheus
EOF

echo "Monitoring stack deployed successfully!"
