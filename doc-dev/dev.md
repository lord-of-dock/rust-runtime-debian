# dev

## source repo

[https://github.com/lord-of-dock/rust-runtime-debian](https://github.com/lord-of-dock/rust-runtime-debian)

## source usage

### each version

- rust version `1.91.0`
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

