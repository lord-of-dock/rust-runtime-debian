variable "DEFAULT_TAG" {
  default = "rust-runtime-debian:local"
}

// Special target: https://github.com/docker/metadata-action#bake-definition
target "docker-metadata-action" {
  tags = ["${DEFAULT_TAG}"]
}

// Default target if none specified
group "default" {
  targets = ["image-local"]
}

target "image-local" {
  inherits = ["image"]
  output = ["type=docker"]
}

// this config use by `docker_bake_targets` most of time is `image-basic`
// https://docs.docker.com/build/bake/reference/#target
// show config as: docker buildx bake --print image-basic
target "image-basic" {
  inherits = ["docker-metadata-action"]
  context = "."
  dockerfile = "Dockerfile"
}

// must check by parent image support multi-platform
// doc: https://docs.docker.com/reference/cli/docker/buildx/build/#platform
// most of can as: linux/amd64 linux/386 linux/arm64/v8 linux/arm/v7 linux/arm/v6 linux/ppc64le linux/s390x
target "image-basic-all" {
  inherits = ["image-basic"]
  platforms = [
    "linux/amd64",
    "linux/386",
    "linux/arm64/v8",
    "linux/arm/v7"
  ]
}

// this config use by `docker_bake_targets` most of time is `image-just`
// https://docs.docker.com/build/bake/reference/#target
// show config as: docker buildx bake --print image-basic
target "image-just" {
  inherits = ["docker-metadata-action"]
  context = "."
  dockerfile = "build-just.dockerfile"
}

// must check by parent image support multi-platform
// doc: https://docs.docker.com/reference/cli/docker/buildx/build/#platform
// most of can as: linux/amd64 linux/386 linux/arm64/v8 linux/arm/v7 linux/arm/v6 linux/ppc64le linux/s390x
target "image-just-all" {
  inherits = ["image-just"]
  platforms = [
    "linux/amd64",
    "linux/386",
    "linux/arm64/v8",
    "linux/arm/v7"
  ]
}