# AGENTS.md

Guidance for OpenCode agents working in this repo.

## What this repo is

A **Docker base image** project (`sinlov/rust-runtime-debian`) that repackages the official `rust` Debian image with extra components (rustfmt, clippy, rust-analysis, rust-src, cargo-bak, optionally `just`). There is **no Rust application code, no `Cargo.toml`, no test suite, no linter** — "testing" means building the image and running `rustup show` inside it. Do not look for `cargo build` / `cargo test`; they do not apply here.

## The version bump (most common change)

The Rust version is the project version. A bump must touch **all four** in lockstep:

- `package.json` `version` (e.g. `1.96.0`)
- `Dockerfile` `FROM rust:<version>`
- `build.dockerfile` `FROM rust:<version>` (and `build-just.dockerfile`)
- `Makefile` `ROOT_PARENT_SWITCH_TAG`
- README.md version tables (just + cargo-bak rows) — CI ignores README-only changes, but keep them consistent

Tag prefix is `v` (see `.versionrc`), so a release tag looks like `v1.96.0`.

## Three Dockerfiles — distinct roles, do not conflate

| File | Role | Used by |
|------|------|---------|
| `Dockerfile` | **Published** basic image (no `just`) | CI `image-basic` bake target, `make dockerBuild` |
| `build-just.dockerfile` | **Published** image + `just` | CI `image-just` bake target |
| `build.dockerfile` | **Local test only** — adds rsproxy.cn mirror + `RUSTUP_DIST_SERVER` for fast builds in China | `make dockerTestRestartLatest` / `make all` |

When adding a component to the published image, edit **both** `Dockerfile` and `build-just.dockerfile`. `build.dockerfile` only needs the mirror/proxy differences.

## Local development (Makefile)

The Makefile `include`s `z-MakefileUtils/MakeImage.mk` (a shared, reusable snippet — edit cautiously, it is reused across other projects). Useful targets:

- `make help` — print available targets
- `make env` / `make dockerEnv` — print the build env (image name, tag, parent image, etc.)
- `make all` → `dockerTestRestartLatest` — full cycle: rm old container+image, build `build.dockerfile`, run
- `make clean` → `dockerTestPruneLatest` — remove test container and image
- `make dockerTestRestartLatest` — rebuild + rerun the local test image
- `make dockerBeforePush` — build + tag the production `Dockerfile` (does not push)

`ENV_DIST_VERSION` (default `latest`) controls the tag; override on the command line: `make dockerTestRestartLatest ENV_DIST_VERSION=1.96.0`.

## Docker bake (multi-platform CI builds)

`docker-bake.hcl` defines targets. Inspect with `docker buildx bake --print image-basic`.

- `image-basic` / `image-just` — single-platform (used by CI per-platform matrix)
- `image-basic-all` / `image-just-all` — multi-platform: `linux/amd64`, `linux/386`, `linux/arm64/v8`, `linux/arm/v7`
- `image-local` — local docker-output build (default group)

Two published variants: `<version>` (basic) and `<version>-just`. Known upstream issue: `linux/arm/v7` inherits the `rust-lang/docker-rust#72` problem.

## Release flow (tag-driven)

CI lives in `.github/workflows/ci.yml` and orchestrates reusable workflows:

- **On merged PR** (`pull_request.merged == true`): builds `latest` + `latest-just` and pushes to Docker Hub.
- **On semver tag push** (`refs/tags/*`): `version.yml` → `docker-buildx-bake-hubdocker-tag.yml` (basic + just, multi-platform) → `deploy-tag.yml` (GitHub Release with auto-generated conventional-changelog body + Docker Hub README sync).

`CHANGELOG.md` is **auto-generated** by `convention-change/conventional-version-check@v1.4.0` from conventional commits — do not hand-edit it.

**Required GitHub config** (CI fails without):
- Variables: `ENV_DOCKERHUB_OWNER`, `ENV_DOCKERHUB_REPO_NAME`
- Secret: `DOCKERHUB_TOKEN`

## Conventional Commits (enforced)

Commit messages follow Conventional Commits; `.versionrc` defines type → changelog section mapping and `tag-prefix: v`. Use the `/gitcc` OpenCode command to generate and commit. First line < 72 chars, imperative mood, atomic commits. Hidden types (`style`, `test`, `ci`, `chore`) do not surface in CHANGELOG.

Branch prefixes recognized by CI: `FE-*` / `*-feature-*`, `BF-*` / `*-bug-*`, `PU-*`, `DOC-*` / `*-documentation-*`, `*-hotfix-*`, `release-*`. README-only pushes are ignored by CI.

## OpenCode task system (`.shared/tasks/`)

Multi-developer task claiming with advisory file locking via [Agentlocks](https://github.com/simke9445/agentlocks). One Markdown file per task under `.shared/tasks/<category>/`, with YAML frontmatter (`id`, `title`, `status`, `owner`, `locked_at`, `priority`, `category`).

- Set `export AGENTLOCKS_AGENT_ID="<your-id>"` in your shell profile before using.
- Commands: `/task-create`, `/task-claim <id>`, `/task-list`, `/task-status`, `/task-release <id>`, `/task-done <id>`.
- **Never hand-edit** `status` / `owner` / `locked_at` — use the commands.
- Locks are advisory and local-worktree only; default TTL 10 min (refresh via `/task-status`). For distributed work use Git branches.

## OpenCode config (`.opencode/`)

Local OpenCode plugin/config (depends on `@opencode-ai/plugin` 1.18.7). Not part of the published image. Custom commands live in `.opencode/commands/`; the `agents/` and `modes/` dirs are empty placeholders.

## Further reading

- `doc-dev/dev.md` — developer guide (version bump checklist, dev commands)
- `.github/CONTRIBUTING_DOC/CONTRIBUTING.md` — contribution workflow and commit spec
- `README.md` — published image usage and version tables (synced to Docker Hub as the repo description)
