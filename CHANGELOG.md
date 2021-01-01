# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]
### Changed
- healthcheck: improve privacy by probing
  [network-liveness](https://gitweb.torproject.org/torspec.git/tree/control-spec.txt)
  instead of periodic http and dns requests
- changed log level of `control` domain to `warn`
  (to avoid log spam by healthcheck connecting to control listener)

### Removed
- `curl`
- `bin-tools` package including `dig`

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

[Unreleased]: https://github.com/fphammerle/docker-tor-proxy/compare/v3.0.0...HEAD
[3.0.0]: https://github.com/fphammerle/docker-tor-proxy/compare/v2.1.0...v3.0.0
[2.1.0]: https://github.com/fphammerle/docker-tor-proxy/compare/v2.0.0...v2.1.0
[2.0.0]: https://github.com/fphammerle/docker-tor-proxy/compare/v1.1.1...v2.0.0
[1.1.1]: https://github.com/fphammerle/docker-tor-proxy/compare/v1.1.0...v1.1.1
[1.1.0]: https://github.com/fphammerle/docker-tor-proxy/compare/1.0.0...v1.1.0
[1.0.0]: https://github.com/fphammerle/docker-tor-proxy/releases/tag/1.0.0
