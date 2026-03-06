#!/bin/bash
set -euo pipefail

LOG=/var/log/cron.log

echo "[$(date -Iseconds)] bookbear refresh started" >> "$LOG"

/usr/bin/docker pull vegardege/bookbear-pipeline:latest >> "$LOG" 2>&1

/usr/bin/docker run --rm \
    -e XDG_DATA_HOME=/srv/data \
    -v /srv/data:/srv/data \
    vegardege/bookbear-pipeline:latest \
    refresh /srv/data/pvduck/wiki.duckdb /srv/data/bookbear/database.json >> "$LOG" 2>&1

echo "[$(date -Iseconds)] bookbear refresh complete" >> "$LOG"
