<!---
NOTE: AUTO-GENERATED FILE
to edit this file, instead edit its template at: ./scripts/templates/README.md.j2
-->
<div align="center">

<img src="https://raw.githubusercontent.com/rafaribe/home-ops/main/docs/assets/logo.png" width="144px" height="144px"/>

## containers

_A focused collection of container images for my home-ops stack_ 🏠

</div>

<div align="center">

![GitHub Repo stars](https://img.shields.io/github/stars/rafaribe/containers?style=for-the-badge&color=cba6f7)
![GitHub forks](https://img.shields.io/github/forks/rafaribe/containers?style=for-the-badge&color=89b4fa)
![GitHub Workflow Status](https://img.shields.io/github/actions/workflow/status/rafaribe/containers/release-scheduled.yaml?style=for-the-badge&label=Scheduled%20Release&color=a6e3a1)

</div>

---

## Overview

Personal container images used in my [home-ops](https://github.com/rafaribe/home-ops) cluster. Images are published to [GitHub Container Registry](https://github.com/rafaribe?tab=packages&repo_name=containers).

## Principles

- 📦 [Semantically versioned](https://semver.org/) — pin by digest for true immutability
- 🏗️ [Multi-arch](https://www.docker.com/blog/multi-arch-build-and-images-the-simple-way/) — `linux/amd64` and `linux/arm64`
- 🔒 [Rootless](https://rootlesscontaine.rs/) — no root required
- 🪶 [KISS](https://en.wikipedia.org/wiki/KISS_principle) — stdout logging, one process per container, no s6-overlay

## Tag Immutability

Tags here are **not** immutable by themselves. Pin to the sha256 digest for a truly immutable reference:

| Reference | Immutable |
|---|:---:|
| `ghcr.io/rafaribe/paperless-ai:rolling` | ❌ |
| `ghcr.io/rafaribe/paperless-ai:1.2.3` | ❌ |
| `ghcr.io/rafaribe/paperless-ai:rolling@sha256:abcd...` | ✅ |
| `ghcr.io/rafaribe/paperless-ai:1.2.3@sha256:abcd...` | ✅ |

> [Renovate](https://github.com/renovatebot/renovate) can track both digest and version changes automatically.

## Available Images

| Container | Channel | Image |
|---|---|---|
| [docmost-mcp-server](https://github.com/rafaribe/containers/pkgs/container/docmost-mcp-server) | `stable` | `ghcr.io/rafaribe/docmost-mcp-server` |
| [musicgrabber](https://github.com/rafaribe/containers/pkgs/container/musicgrabber) | `stable` | `ghcr.io/rafaribe/musicgrabber` |
| [paperless-ai](https://github.com/rafaribe/containers/pkgs/container/paperless-ai) | `stable` | `ghcr.io/rafaribe/paperless-ai` |
| [qbittorrent](https://github.com/rafaribe/containers/pkgs/container/qbittorrent) | `stable` | `ghcr.io/rafaribe/qbittorrent` |
| [qbittorrent-beta](https://github.com/rafaribe/containers/pkgs/container/qbittorrent-beta) | `beta` | `ghcr.io/rafaribe/qbittorrent-beta` |


## Usage

### Kubernetes

```yaml
spec:
  securityContext:
    runAsUser: 65534
    runAsGroup: 65534
    fsGroup: 65534
    fsGroupChangePolicy: OnRootMismatch
```

### Docker Compose

```yaml
services:
  app:
    image: ghcr.io/rafaribe/<image>:<version>
    user: 65534:65534
```