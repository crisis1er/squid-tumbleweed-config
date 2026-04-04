# ACL directory

## pgl_yoyo.domains

This configuration uses the [Peter Lowe's Ad and tracking server list](https://pgl.yoyo.org/adservers/) for ad blocking.

Download and place the domain list at `/etc/squid/acl/pgl_yoyo.domains`:

```bash
sudo mkdir -p /etc/squid/acl

sudo curl -s "https://pgl.yoyo.org/adservers/serverlist.php?hostformat=nohtml&showintro=0&mimetype=plaintext" \
  -o /etc/squid/acl/pgl_yoyo.domains

sudo chown squid:squid /etc/squid/acl/pgl_yoyo.domains
sudo chmod 640 /etc/squid/acl/pgl_yoyo.domains
```

Refresh weekly via cron or systemd timer:

```bash
# /etc/cron.weekly/update-squid-acl
#!/bin/bash
curl -s "https://pgl.yoyo.org/adservers/serverlist.php?hostformat=nohtml&showintro=0&mimetype=plaintext" \
  -o /etc/squid/acl/pgl_yoyo.domains
squid -k reconfigure
```
