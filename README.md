# Setup mounted drive

```bash
ln -s /mnt/volume_fra1_01/cache ~/.cache
sudo ln -s /mnt/volume_fra1_01/docker /var/lib/docker
```

# Host static sites

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

# Start Book Bear (Legacy)

```bash
cd bookbear
docker run -d -p 3000:3000 -v ./data:/app/data bookbear:latest
```
