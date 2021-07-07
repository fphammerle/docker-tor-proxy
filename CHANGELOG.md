# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]
### Added
- added ability to exclude exit nodes via `EXCLUDE_EXIT_NODES` environment variable

## [4.3.1] - 2021-05-15
### Fixed
- create prerouting chain if not already created by container runtime
  (fixes dns proxy with direct routing & transparent proxy on some hosts)

## [4.3.0] - 2021-05-07
### Added
- when running entrypoint as `uid=0`:
  add `nftables` rule forwarding udp dns requests (port 53) to tor
  (alternative for less flexible `docker run --publish 53:9053 …`)

## [4.2.0] - 2021-04-30
### Added
- when running entrypoint as `uid=0`:
  add `nftables` rule redirecting `tcp` traffic to transparent proxy

## [4.1.0] - 2021-03-03
### Added
- enabled transparent proxy, listening on port `9040` (requires netfilter rules)
- image labels:
  - `org.opencontainers.image.revision` (git commit hash via build arg)
  - `org.opencontainers.image.source` (repo url)
  - `org.opencontainers.image.title`

## [4.0.0] - 2021-01-01
### Changed
- healthcheck: replace periodic http requests with probing
  [network-liveness](https://gitweb.torproject.org/torspec.git/tree/control-spec.txt)
  to improve privacy (keeping dns requests for faster updates)
- changed log level of `control` domain to `warn`
  (to avoid log spam by healthcheck connecting to control listener)
- added message domains to log messages

### Removed
- `curl`
- `bind-tools` package including `dig`

## [3.0.0] - 2020-10-03
### Added
- create mount point at `/var/lib/tor`
  to be able to make container's root filesystem read-only

### Changed
- moved tor's data directory from `/home/onion/.tor` to `/var/lib/tor`
- run `tor` as user `tor` (uid=100) instead of `onion` (uid=101)
- docker-compose & ansible-playbook: read-only root filesystem

### Fixed
- ansible-playbook: drop capabilities

## [2.1.0] - 2020-09-27
### Added
- enable [tor control](https://gitweb.torproject.org/torspec.git/tree/control-spec.txt)
  listener on port `9051`
  (listening on loopback device only)

## [2.0.0] - 2020-03-24
### Changed
- changed DNS port from 53 to 9053
- run as unprivileged user

## [1.1.1] - 2020-03-21
### Fixed
- fix invalid torrc path

## [1.1.0] - 2020-03-21
### Added
- change `SocksTimeout` option by setting `$SOCKS_TIMEOUT_SECONDS`

## [1.0.0] - 2019-10-12
### Added
- tor socks5 & DNS proxy

[Unreleased]: https://github.com/fphammerle/docker-tor-proxy/compare/v4.3.1...HEAD
[4.3.1]: https://github.com/fphammerle/docker-tor-proxy/compare/v4.3.0...v4.3.1
[4.3.0]: https://github.com/fphammerle/docker-tor-proxy/compare/v4.2.0...v4.3.0
[4.2.0]: https://github.com/fphammerle/docker-tor-proxy/compare/v4.1.0...v4.2.0
[4.1.0]: https://github.com/fphammerle/docker-tor-proxy/compare/v4.0.0...v4.1.0
[4.0.0]: https://github.com/fphammerle/docker-tor-proxy/compare/v3.0.0...v4.0.0
[3.0.0]: https://github.com/fphammerle/docker-tor-proxy/compare/v2.1.0...v3.0.0
[2.1.0]: https://github.com/fphammerle/docker-tor-proxy/compare/v2.0.0...v2.1.0
[2.0.0]: https://github.com/fphammerle/docker-tor-proxy/compare/v1.1.1...v2.0.0
[1.1.1]: https://github.com/fphammerle/docker-tor-proxy/compare/v1.1.0...v1.1.1
[1.1.0]: https://github.com/fphammerle/docker-tor-proxy/compare/1.0.0...v1.1.0
[1.0.0]: https://github.com/fphammerle/docker-tor-proxy/releases/tag/1.0.0
