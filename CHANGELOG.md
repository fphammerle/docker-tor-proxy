# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [2.1.0] - 2020-09-27
### Added
- Enable [Tor control](https://gitweb.torproject.org/torspec.git/tree/control-spec.txt)
  listener on port `9051`
  (listening on loopback device only)

## [2.0.0] - 2020-03-24
### Changed
- Changed DNS port from 53 to 9053

### Fixed
- Run as unprivileged user

## [1.1.1] - 2020-03-21
### Fixed
- Fix invalid torrc path

## [1.1.0] - 2020-03-21
### Added
- Change `SocksTimeout` option by setting `$SOCKS_TIMEOUT_SECONDS`

## [1.0.0] - 2019-10-12
### Added
- Tor Socks5 & DNS proxy

[Unreleased]: https://github.com/fphammerle/docker-tor-proxy/compare/v2.1.0...HEAD
[2.1.0]: https://github.com/fphammerle/docker-tor-proxy/compare/v2.0.0...v2.1.0
[2.0.0]: https://github.com/fphammerle/docker-tor-proxy/compare/v1.1.1...v2.0.0
[1.1.1]: https://github.com/fphammerle/docker-tor-proxy/compare/v1.1.0...v1.1.1
[1.1.0]: https://github.com/fphammerle/docker-tor-proxy/compare/1.0.0...v1.1.0
[1.0.0]: https://github.com/fphammerle/docker-tor-proxy/releases/tag/1.0.0
