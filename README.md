[![ci](https://github.com/lord-of-dock/rust-runtime-debian/actions/workflows/ci.yml/badge.svg)](https://github.com/lord-of-dock/rust-runtime-debian/actions/workflows/ci.yml)

[![GitHub license](https://img.shields.io/github/license/lord-of-dock/rust-runtime-debian)](https://github.com/lord-of-dock/rust-runtime-debian)
[![GitHub latest SemVer tag)](https://img.shields.io/github/v/tag/lord-of-dock/rust-runtime-debian)](https://github.com/lord-of-dock/rust-runtime-debian/tags)
[![GitHub release)](https://img.shields.io/github/v/release/lord-of-dock/rust-runtime-debian)](https://github.com/lord-of-dock/rust-runtime-debian/releases)

# rust-runtime-debian

[![docker version semver](https://img.shields.io/docker/v/sinlov/rust-runtime-debian?sort=semver)](https://hub.docker.com/r/sinlov/rust-runtime-debian)
[![docker image size](https://img.shields.io/docker/image-size/sinlov/rust-runtime-debian)](https://hub.docker.com/r/sinlov/rust-runtime-debian)
[![docker pulls](https://img.shields.io/docker/pulls/sinlov/rust-runtime-debian)](https://hub.docker.com/r/sinlov/rust-runtime-debian/tags?page=1&ordering=last_updated)

- docker hub see [https://hub.docker.com/r/sinlov/rust-runtime-debian](https://hub.docker.com/r/sinlov/rust-runtime-debian)

## feature

- rust build in docker with debian
- [![](https://img.shields.io/docker/v/_/rust/latest?label=rust&logo=rust&style=social)](https://hub.docker.com/_/rust/tags) latest semver version with `latest`
- install component
  - [rustfmt](https://github.com/rust-lang/rustfmt)
  - [clippy](https://doc.rust-lang.org/clippy/)
  - [rust-analysis](https://github.com/rust-lang/rust-analyzer)
  - [rust-src](https://github.com/rust-lang/rust)
  - ~~[rls](https://github.com/rust-lang/rls)~~ removed after image:1.87.0
- environment
  - [CARGO_CACHE_AUTO_CLEAN_FREQUENCY](https://doc.rust-lang.org/stable/cargo/reference/config.html#cacheauto-clean-frequency) `never` after image:1.88.0

### build kit version

#### just

support [just](https://github.com/casey/just)

| image version | [just](https://crates.io/crates/just) |
| ------------- | --------- |
| image:latest        | 1.42.4    |
| image:1.89.0        | 1.42.4    |
| image:1.86.0        | 1.40.0    |
| image:1.85.1        | 1.40.0    |
| image:1.85.0        | 1.39.0    |
| image:1.84.1        | 1.39.0    |
| image:1.83.0        | 1.38.0    |
| image:1.82.0        | 1.36.0    |
| image:1.81.0        | 1.35.0    |

#### cargo-bak

| image version | [cargo-bak](https://crates.io/crates/cargo-bak) |
| ------------- | --------- |
| image:latest        | 0.1.5     |
| image:1.75.0+       | 0.1.5     |
| image:1.74.0        | 0.1.4     |

### waring

- known issue [https://github.com/rust-lang/docker-rust/issues/72](https://github.com/rust-lang/docker-rust/issues/72) `linux/arm/v7` will has same problem.

### fast use

```bash
## show latest rust version
# pull latest image
docker pull sinlov/rust-runtime-debian:latest
# then check
docker run --rm \
  -it \
  --name "test-rust-runtime-debian" \
  sinlov/rust-runtime-debian:latest \
  rustup show

## latest rust version with kits env
# pull latest image
docker pull sinlov/rust-runtime-debian:latest-just
# then check
docker run --rm \
  --name "test-rust-runtime-debian" \
  sinlov/rust-runtime-debian:latest-just \
  bash -c ' \
  uname -asrm && \
  cat /etc/os-release && \
  gcc --version && \
  make --version && \
  just --version && \
  rustup show '

# check 1.89.0 build env
docker run --rm \
  --name "test-rust-runtime-debian" \
  sinlov/rust-runtime-debian:1.89.0 \
  bash -c ' \
  uname -asrm && \
  cat /etc/os-release && \
  make --version && \
  gcc --version && \
  rustup show '
```

# dev

## source repo

[https://github.com/lord-of-dock/rust-runtime-debian](https://github.com/lord-of-dock/rust-runtime-debian)

## source usage

### each version

- rust version `1.89.0`
  - change in `Makefile`
  - change in `Dockerfile` or `build.dockerfile`

release at:

- rust official latest version [![](https://img.shields.io/docker/v/_/rust/latest?label=rust&logo=rust&style=social)](https://hub.docker.com/_/rust/tags)
- [https://blog.rust-lang.org/releases/](https://blog.rust-lang.org/releases/)
- release manifests [https://static.rust-lang.org/manifests.txt](https://static.rust-lang.org/manifests.txt)
- Rust Changelogs [https://releases.rs/](https://releases.rs/)

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