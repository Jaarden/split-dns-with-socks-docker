# What is this?

This project tries to fix the issue of a lot of pentesters, UDP DNS is not working through a SOCKS5 proxy.
Therefore a lot of linux tools are not working, or even pentest specific tools such as SCCMHunter that don't have support for UDP over TCP.

What this Docker container does is being a split DNS server listening on UDP, so all you need to do is set it as your DEFAULT DNS server in linux. For example in `/etc/resolv.conf`

First you need to build the image using:
`docker build -t dns-proxy .`

Next you can run it, with the following environment variables:
```
SOCKS_IP=   The IP of the host where the SOCKS5 proxy is located
SOCKS_PORT=  As the name sugests, the port of the SOCKS5 proxy
PROXY_DOMAINS= A list of domains you want to force through the proxy, between quotes and comma separated "example.com,anotherdomain.local"
DNS_SERVER= The DNS server on the other side of the SOCKS5 proxy, for example the customers DNS server
```
This will look like the following docker run command:

```
docker run --rm \
  --name dns-proxy \
  -e SOCKS_IP=172.17.0.1 \
  -e SOCKS_PORT=9999 \
  -e PROXY_DOMAINS="example.com,anotherdomain.local" \
  -e DNS_SERVER=172.17.0.1 \
  dns-proxy
```


## Warning
You may need to allow your firewall to expose your SOCKS5 proxy port to the DNS container, for example `ufw allow 9999`