FROM debian:bullseye-slim

# Install dependencies
RUN apt-get update && apt-get install -y dnsmasq curl unzip bash iproute2 dnsutils  && \
    rm -rf /var/lib/apt/lists/*

# Download dns2socks release
RUN curl -L -o /tmp/dns2socks.zip https://github.com/tun2proxy/dns2socks/releases/download/v0.2.3/dns2socks-x86_64-unknown-linux-gnu.zip && \
    unzip /tmp/dns2socks.zip -d /usr/local/bin && \
    chmod +x /usr/local/bin/dns2socks && \
    rm -rf /tmp/dns2socks.zip

# Copy entrypoint
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 53/udp 53/tcp
ENTRYPOINT ["/entrypoint.sh"]
