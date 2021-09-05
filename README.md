# docker: tor socks & dns proxy 🌐 🐳

Docker Hub: https://hub.docker.com/r/fphammerle/tor-proxy

Signed image tags: https://github.com/fphammerle/docker-tor-proxy/tags

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

### Test Proxies

```sh
$ curl --proxy socks5h://localhost:9050 ipinfo.io
$ torsocks wget -O - ipinfo.io
$ torsocks lynx -dump https://check.torproject.org/
$ dig @localhost fabian.hammerle.me
$ ssh -o 'ProxyCommand nc -x localhost:9050 -v %h %p' abcdefghi.onion
# no anonymity!
$ chromium-browser --proxy-server=socks5://localhost:9050 ipinfo.io
```

### Read-only Root Filesystem

Optionally add
```sh
$ sudo docker run --read-only -v tor_proxy_data:/var/lib/tor --tmpfs /tmp:rw,size=4k` …
```
to make the container's root filesystem read-only.

### Isolate Host

```sh
sudo iptables -A OUTPUT ! -o lo -j REJECT --reject-with icmp-admin-prohibited
```

### Change `SocksTimeout` Option

```sh
$ sudo docker run -e SOCKS_TIMEOUT_SECONDS=60 …
```

### Select Exit Nodes

```sh
$ sudo docker run -e EXIT_NODES=1.2.3.4,1.2.3.5,{at} …
```

### Exclude Exit Nodes

```sh
$ sudo docker run -e EXCLUDE_EXIT_NODES=1.2.3.4,1.2.3.5 …
```

### Show Circuits

```sh
$ printf 'AUTHENTICATE\nGETINFO circuit-status\nQUIT\n' \
    | sudo docker exec -i tor_proxy nc localhost 9051
```
relay search: https://metrics.torproject.org/rs.html

or using [onioncircuits](https://gitlab.tails.boum.org/tails/onioncircuits) ([debian repo](https://salsa.debian.org/pkg-privacy-team/onioncircuits)):
```sh
$ sudo apt-get install --no-install-recommends onioncircuits
$ sudo nsenter --target "$(sudo docker inspect --format='{{.State.Pid}}' tor_proxy)" --net \
    sudo -u $USER onioncircuits
```

### Troubleshooting

Disable `SafeLogging` (temporarily) to log IP addresses instead of `[scrubbed]`:
```
$ printf 'AUTHENTICATE\nSETCONF SafeLogging=0\nGETCONF SafeLogging\nQUIT\n' \
    | sudo docker exec -i tor_proxy nc localhost 9051
```
