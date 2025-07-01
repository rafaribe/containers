# Amazon Q Developer CLI Container

This container provides a complete development environment with Amazon Q Developer CLI and AWS CLI pre-installed, along with common development tools and language runtimes managed by mise.

## Features

- **Amazon Q Developer CLI**: Latest version for AI-powered development assistance
- **AWS CLI**: For managing AWS resources
- **Development Tools**: git, jq, vim, sqlite3, and more
- **Language Runtimes**: Python, Node.js, Java, Go (managed by mise)
- **Non-root User**: Runs as `dev` user for security
- **Persistent Storage**: Volumes for Amazon Q data and cache

## Usage

### Basic Usage
```bash
docker run -it --rm \
  -v "$(pwd):/home/dev/src" \
  -v "${HOME}/.aws:/home/dev/.aws:ro" \
  ghcr.io/rafaribe/amazon-q:latest
```

### With AWS Credentials
```bash
docker run -it --rm \
  -v "$(pwd):/home/dev/src" \
  -v "${HOME}/.aws/credentials:/home/dev/.aws/credentials:ro" \
  -v "${HOME}/.aws/config:/home/dev/.aws/config:ro" \
  -e AWS_PROFILE \
  -e AWS_REGION \
  ghcr.io/rafaribe/amazon-q:latest
```

### Interactive Shell
```bash
docker run -it --rm \
  -v "$(pwd):/home/dev/src" \
  --entrypoint bash \
  ghcr.io/rafaribe/amazon-q:latest
```

## Environment Variables

- `AWS_PROFILE`: AWS profile to use
- `AWS_REGION`: AWS region
- `TZ`: Timezone (defaults to Etc/UTC)

## Volumes

- `/home/dev/src`: Working directory (mount your project here)
- `/home/dev/.aws`: AWS configuration and credentials
- `/home/dev/.local/share/amazon-q`: Amazon Q data storage
- `/home/dev/.cache/amazon-q`: Amazon Q cache

## Architecture Support

This container supports both `linux/amd64` and `linux/arm64` platforms.
