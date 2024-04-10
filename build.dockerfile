# This dockerfile uses extends image https://hub.docker.com/_/alpine
# VERSION 1
# Author: sinlov
# dockerfile offical document https://docs.docker.com/engine/reference/builder/
# maintainer="https://github.com/lord-of-dock/rust-runtime-debian"

# https://hub.docker.com/_/rust/tags?page=1
FROM rust:1.77.2

#USER root
ARG CARGO_HOME=/usr/local/cargo

# set proxy of rust
RUN mkdir -p ${CARGO_HOME}
COPY ./z-MakefileUtils/proxy-rsproxy.toml ${CARGO_HOME}/config
# set proxy of rustup
# ARG RUSTUP_DIST_SERVER=https://mirrors.tuna.tsinghua.edu.cn/rustup
# ARG RUSTUP_UPDATE_ROOT=https://mirrors.tuna.tsinghua.edu.cn/rustup/rustup
ARG RUSTUP_DIST_SERVER=https://rsproxy.cn
ARG RUSTUP_UPDATE_ROOT=https://rsproxy.cn/rustup
ENV RUSTUP_DIST_SERVER=${RUSTUP_DIST_SERVER}
ENV RUSTUP_UPDATE_ROOT=${RUSTUP_UPDATE_ROOT}

# add ci env
ENV CARGO_NET_RETRY=5
ENV CARGO_HTTP_TIMEOUT=300
ENV CARGO_HTTP_MULTIPLEXING=false
ENV CARGO_TERM_PROGRESS_WHEN=never
ENV CARGO_NET_GIT_FETCH_WITH_CLI=true
ENV CI=1

# add component
RUN export CARGO_HTTP_DEBUG=true \
  CARGO_REGISTRIES_CRATES_IO_PROTOCOL=sparse && \
  rustup component add rustfmt && \
  rustup component add clippy && \
  rustup component add rls && \
  rustup component add rust-analysis && \
  rustup component add rust-src && \
  cargo install --all-features --version 0.1.5 cargo-bak && \
  rm -rf ${CARGO_HOME}/registry && \
  rm -f ${CARGO_HOME}/.package-cache ${CARGO_HOME}/.crates2.json ${CARGO_HOME}/.crates.toml