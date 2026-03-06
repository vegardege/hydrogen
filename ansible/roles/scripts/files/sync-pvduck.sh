#!/bin/bash
set -euo pipefail

LOG=/var/log/cron.log

echo "[$(date -Iseconds)] pvduck sync started" >> "$LOG"

/usr/bin/docker pull vegardege/pvduck:latest >> "$LOG" 2>&1

/usr/bin/docker run --rm \
    -e XDG_DATA_HOME=/srv/data \
    -e XDG_CONFIG_HOME=/srv/config \
    -v /srv/data:/srv/data \
    -v /srv/config:/srv/config \
    vegardege/pvduck:latest sync wiki >> "$LOG" 2>&1

echo "[$(date -Iseconds)] pvduck sync complete" >> "$LOG"
