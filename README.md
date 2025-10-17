# Setup Mounted Drive (only once)

```bash
ln -s /mnt/volume_fra1_01/cache ~/.cache
sudo ln -s /mnt/volume_fra1_01/docker /var/lib/docker
```

# Run Caddy

Keep `Caddyfile` in sync:

```bash
cp /root/hydrogen/Caddyfile /etc/caddy/Caddyfile
```

```bash
systemctl start caddy	 # Start the service
systemctl stop caddy	 # Stop it
systemctl restart caddy	 # Restart after config changes
systemctl reload caddy	 # Graceful reload (no downtime)
```

# Host Static Sites

```bash
sudo chown -R caddy:caddy /srv/site
sudo chmod -R 755 /srv/site
```

In `Caddyfile`:

```
site.pebblepatch.dev {
    root * /srv/site
    file_server
}
```

# Host Reverse Proxy

- Add site to `Caddyfile`
- Add to `compose.yml`
- Ensure port number is the same

```bash
cd hydrogen
docker compose up -d
```
