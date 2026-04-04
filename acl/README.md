# ACL directory

## pgl_yoyo.domains

This configuration uses [Peter Lowe's Ad and tracking server list](https://pgl.yoyo.org/adservers/) for ad blocking (~3500 domains).

The list is fetched in `squid` format and preprocessed to prefix entries with `.` to cover all subdomains.

---

## Automated update via systemd (recommended)

### `update-squid-ads.service`

```ini
[Unit]
Description=Update Squid ad blocking list (pgl.yoyo.org)
After=network-online.target
Wants=network-online.target

[Service]
Type=oneshot
# Download to a temporary file
ExecStart=/usr/bin/curl -fsSo /tmp/pgl_yoyo_raw.domains \
  "https://pgl.yoyo.org/adservers/serverlist.php?hostformat=squid&showintro=0&mimetype=plaintext"
# Prefix entries with '.' to cover subdomains, then deploy
ExecStartPost=/bin/bash -c \
  "sed 's/^\([^#.]\)/.\1/' /tmp/pgl_yoyo_raw.domains > /etc/squid/acl/pgl_yoyo.domains"
# Reload Squid without restart
ExecStartPost=/usr/sbin/squid -k reconfigure

[Install]
WantedBy=multi-user.target
```

### `update-squid-ads.timer`

```ini
[Unit]
Description=Weekly update of Squid ad blocking list

[Timer]
OnCalendar=weekly
RandomizedDelaySec=3600
Persistent=true

[Install]
WantedBy=timers.target
```

### Deploy

```bash
# Install service and timer
sudo cp update-squid-ads.service /etc/systemd/system/
sudo cp update-squid-ads.timer /etc/systemd/system/

sudo systemctl daemon-reload
sudo systemctl enable --now update-squid-ads.timer

# Run immediately to populate the list on first install
sudo systemctl start update-squid-ads.service
```

### Verify

```bash
# Check timer status and next trigger
systemctl status update-squid-ads.timer

# Check last service run
systemctl status update-squid-ads.service

# Confirm the list was deployed
wc -l /etc/squid/acl/pgl_yoyo.domains
```

---

## File permissions

```bash
sudo chown squid:squid /etc/squid/acl/pgl_yoyo.domains
sudo chmod 640 /etc/squid/acl/pgl_yoyo.domains
```

---

## Expected warnings

After each update, `squid -k reconfigure` may emit harmless warnings such as:

```
WARNING: Ignoring .t.appsflyer.com because it is already covered by .appsflyer.com
```

These are duplicate entries in the upstream list and can be safely ignored.
