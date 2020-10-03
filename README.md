# docker: tor socks & dns proxy 🌐 🐳

docker hub: https://hub.docker.com/r/fphammerle/tor-proxy

signed tags: https://github.com/fphammerle/docker-tor-proxy/tags

```sh
$ sudo docker run --rm --name tor_proxy \
    -p 127.0.0.1:9050:9050/tcp \
    -p 127.0.0.1:53:9053/udp \
    fphammerle/tor-proxy
```

or after cloning the repository 🐙
```sh
$ sudo docker-compose up
```

### test proxies

```sh
$ curl --proxy socks5h://localhost:9050 ipinfo.io
$ torsocks wget -O - ipinfo.io
$ torsocks lynx -dump https://check.torproject.org/
$ dig @localhost fabian.hammerle.me
$ ssh -o 'ProxyCommand nc -x localhost:9050 -v %h %p' abcdefghi.onion
# no anonymity!
$ chromium-browser --proxy-server=socks5://localhost:9050 ipinfo.io
```

### read-only root filesystem

optionally add
```sh
$ sudo docker run --read-only -v tor_proxy_data:/var/lib/tor --tmpfs /tmp:rw,size=4k` …
```
to make the container's root filesystem read-only

### isolate

```sh
sudo iptables -A OUTPUT ! -o lo -j REJECT --reject-with icmp-admin-prohibited
```

### change `SocksTimeout` option

```sh
$ sudo docker run -e SOCKS_TIMEOUT_SECONDS=60 …
```

### show circuits

```sh
$ sudo docker exec tor_proxy \
    sh -c 'printf "AUTHENTICATE\nGETINFO circuit-status\nQUIT\n" | nc localhost 9051'
```
relay search: https://metrics.torproject.org/rs.html
