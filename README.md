docker run --rm  --name dns-proxy  -e SOCKS_IP=172.17.0.1   -e SOCKS_PORT=9999   -e PROXY_DOMAINS="example.com,anotherdomain.net" -e DNS_SERVER=172.17.0.1  dns-proxy
