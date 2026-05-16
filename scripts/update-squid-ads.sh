#!/bin/bash
set -e

TMP=/tmp/hagezi_pro_raw.domains
DEST=/etc/squid/acl/hagezi_pro.domains
URL="https://raw.githubusercontent.com/hagezi/dns-blocklists/main/domains/pro.plus.txt"

curl -fsSo "$TMP" "$URL"

python3 - << PYEOF
domains = set()
with open("$TMP") as f:
    for line in f:
        line = line.strip()
        if not line or line.startswith("#"):
            continue
        domains.add(line)

result = []
for domain in domains:
    parts = domain.split(".")
    redundant = False
    for i in range(1, len(parts) - 1):
        if ".".join(parts[i:]) in domains:
            redundant = True
            break
    if not redundant:
        result.append("." + domain)

result.sort()
with open("$DEST", "w") as f:
    f.write("\n".join(result) + "\n")

print(f"HaGeZi PRO: {len(result)} domaines déployés")
PYEOF

squid -k reconfigure
