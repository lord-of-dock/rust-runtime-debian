# This dockerfile uses extends image https://hub.docker.com/_/alpine
# VERSION 1
# Author: sinlov
# dockerfile offical document https://docs.docker.com/engine/reference/builder/
# maintainer="https://github.com/lord-of-dock/rust-runtime-debian"

# https://hub.docker.com/_/rust/tags?page=1
FROM rust:1.84.1

#USER root

# ARG CARGO_HOME=/usr/local/cargo
# set cargo config
# RUN mkdir -p ${CARGO_HOME}
# COPY ./z-MakefileUtils/cargo-config.toml ${CARGO_HOME}/config


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