# boto3 image auto-builder (Alpine base)

This repository builds and pushes a Docker image that:
- Uses the plain Alpine base image
- Installs Python 3 and pip from Alpine packages
- Installs the exact latest `boto3` release
- Pushes to your container registry
- Rebuilds automatically when a new `boto3` version is detected (polled every 6 hours)

## Configure

1) Create a new GitHub repository and add these files.

2) Set repository variables (Settings → Secrets and variables → Variables):
- `REGISTRY`: `ghcr.io` (recommended) or `docker.io`
- `IMAGE_NAME`: e.g. `daveshow/boto3-alpine`
- `ALPINE_TAG`:
  - `latest` to always track the newest Alpine release (and its Python)
  - `3.20` to pin to Alpine 3.20 which includes Python 3.12

3) Authentication:
- If using GHCR (`ghcr.io`), the workflow uses `${{ secrets.GITHUB_TOKEN }}`.
- If using Docker Hub or another registry, set repository secrets:
  - `DOCKER_USERNAME`
  - `DOCKER_TOKEN` (a Personal Access Token or password)

## Tags

- `latest`: updated whenever a new boto3 release is built
- `boto3-<version>`: e.g. `boto3-1.35.69`

## Triggers

- Scheduled every 6 hours
- Manual via "Run workflow"
- On push to `main`

The workflow checks if `boto3-<version>` already exists in the registry and skips rebuilding that tag if so.

## Python version notes

- With `ALPINE_TAG=latest`, Python tracks whatever version ships with the latest Alpine release.
- If you need Python 3.12 specifically, set `ALPINE_TAG=3.20` (or another Alpine version that ships Python 3.12).

## Local build

```bash
docker build --build-arg ALPINE_TAG=latest --build-arg BOTO3_VERSION=LATEST -t local/boto3:latest .
```

## Optional weekly refresh

If you want to refresh the base even when boto3 hasn't changed, add a separate weekly job that rebuilds and pushes regardless of existing tags.