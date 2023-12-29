[![ci](https://github.com/lord-of-dock/rust-runtime-debian/actions/workflows/ci.yml/badge.svg)](https://github.com/lord-of-dock/rust-runtime-debian/actions/workflows/ci.yml)

[![GitHub license](https://img.shields.io/github/license/lord-of-dock/rust-runtime-debian)](https://github.com/lord-of-dock/rust-runtime-debian)
[![GitHub latest SemVer tag)](https://img.shields.io/github/v/tag/lord-of-dock/rust-runtime-debian)](https://github.com/lord-of-dock/rust-runtime-debian/tags)
[![GitHub release)](https://img.shields.io/github/v/release/lord-of-dock/rust-runtime-debian)](https://github.com/lord-of-dock/rust-runtime-debian/releases)

[![docker version semver](https://img.shields.io/docker/v/sinlov/rust-runtime-debian?sort=semver)](https://hub.docker.com/r/sinlov/rust-runtime-debian)
[![docker image size](https://img.shields.io/docker/image-size/sinlov/rust-runtime-debian)](https://hub.docker.com/r/sinlov/rust-runtime-debian)
[![docker pulls](https://img.shields.io/docker/pulls/sinlov/rust-runtime-debian)](https://hub.docker.com/r/sinlov/rust-runtime-debian/tags?page=1&ordering=last_updated)

# rust-runtime-debian

- docker hub see [https://hub.docker.com/r/sinlov/rust-runtime-debian](https://hub.docker.com/r/sinlov/rust-runtime-debian)

## for

- rust build in docker with buster
- [![](https://img.shields.io/docker/v/_/rust/buster?label=rust&logo=rust&style=social)](https://hub.docker.com/_/rust/tags?page=1&name=buster) latest semver version with `buster`
- install component
  - [rustfmt](https://github.com/rust-lang/rustfmt)
  - [clippy](https://doc.rust-lang.org/clippy/)
  - [rls](https://github.com/rust-lang/rls)
  - [rust-analysis](https://github.com/rust-lang/rust-analyzer)
  - [rust-src](https://github.com/rust-lang/rust)
- install tools
  - [cargo-bak](https://crates.io/crates/cargo-bak) above 1.70.0

### waring

- known issue [https://github.com/rust-lang/docker-rust/issues/72](https://github.com/rust-lang/docker-rust/issues/72) `linux/arm/v7` will has same problem.

### fast use

```bash
# run as cli
docker run --rm \
  -it \
  --name "test-rust-runtime-debian" \
  sinlov/rust-runtime-debian:latest

# check rustc --version
docker run --rm \
  --name "test-rust-runtime-debian" \
  sinlov/rust-runtime-debian:latest \
  rustc --version
```

## source repo

[https://github.com/lord-of-dock/rust-runtime-debian](https://github.com/lord-of-dock/rust-runtime-debian)

## source usage

### each version

- rust version `1.72.1`
  - change in `Makefile`
  - change in `Dockerfile` or `build.dockerfile`

### dev mode

```bash
# see help
$ make help
# see or check build env
$ make env

# fast build
$ make all
# clean build
$ make clean

# check env
$ make dockerEnv

# change build.dockerfile
# then test image
$ make dockerTestRestartLatest
# remove build image
$ make clean
```

then change github workflows config to use

## Contributing

[![Contributor Covenant](https://img.shields.io/badge/contributor%20covenant-v1.4-ff69b4.svg)](.github/CONTRIBUTING_DOC/CODE_OF_CONDUCT.md)
[![GitHub contributors](https://img.shields.io/github/contributors/lord-of-dock/rust-runtime-debian)](https://github.com/lord-of-dock/rust-runtime-debian/graphs/contributors)

We welcome community contributions to this project.

Please read [Contributor Guide](.github/CONTRIBUTING_DOC/CONTRIBUTING.md) for more information on how to get started.

请阅读有关 [贡献者指南](.github/CONTRIBUTING_DOC/zh-CN/CONTRIBUTING.md) 以获取更多如何入门的信息