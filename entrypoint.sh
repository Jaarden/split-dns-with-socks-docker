#!/bin/bash
set -e

DNS_SERVER=${DNS_SERVER:-127.0.0.1}
SOCKS_IP=${SOCKS_IP:-127.0.0.1}
SOCKS_PORT=${SOCKS_PORT:-1080}
PROXY_DOMAINS=${PROXY_DOMAINS:-}
DNS2SOCKS_ADDR="127.0.0.1:5300"



CONTAINER_IP=$(ip addr show eth0 | grep 'inet ' | awk '{print $2}' | cut -d/ -f1)
echo "[+] Container IP: $CONTAINER_IP"

# Upstream DNS
UPSTREAM_DNS=$(grep -m1 "^nameserver" /etc/resolv.conf | awk '{print $2}')
echo "[+] Detected upstream DNS: ${UPSTREAM_DNS}"

# Start dns2socks in background
echo "[+] Starting dns2socks pointing to SOCKS ${SOCKS_IP}:${SOCKS_PORT}"
dns2socks -s "socks5://${SOCKS_IP}:${SOCKS_PORT}" -d "${UPSTREAM_DNS}:9999" -l"${DNS2SOCKS_ADDR}" -v trace & > /tmp/dns2socks.log
sleep 1

# Build dnsmasq config
echo "[+] Building dnsmasq config..."
cat <<EOF >/etc/dnsmasq.conf
listen-address=0.0.0.0
log-queries
bind-interfaces
EOF
#echo "server=1.1.1.1" >> /etc/dnsmasq.conf



IFS=',' read -ra DOMAINS <<< "$PROXY_DOMAINS"
for domain in "${DOMAINS[@]}"; do
  d=$(echo "$domain" | xargs)
  if [ -n "$d" ]; then
    echo "server=/${d}/127.0.0.1#5300" >> /etc/dnsmasq.conf
    echo "[+] Routing ${d} via SOCKS proxy"
  fi
done

# Start dnsmasq in foreground with logging
echo "[+] Starting dnsmasq..."
exec dnsmasq -k -d 
