ARG ALPINE_TAG=latest
ARG BUILD_REPOSITORY="daveshow/python3-boto3"
ARG BUILD_DATE
ARG BUILD_DESCRIPTION="Python 3 Docker image with boto3 pre-installed, based on Alpine Linux."
ARG BUILD_NAME="Python 3 with boto3"
ARG BOTO3_VERSION=main

FROM alpine:${ALPINE_TAG}

ENV PYTHONDONTWRITEBYTECODE=1 \
  PYTHONUNBUFFERED=1 \
  PIP_DISABLE_PIP_VERSION_CHECK=1 \
  PIP_NO_CACHE_DIR=1

# Keep base packages up to date within the chosen Alpine release
RUN apk update && apk upgrade

# Install Python 3 + pip (from Alpine packages), plus CA roots
RUN apk add --no-cache python3 py3-pip ca-certificates py3-boto3 \
  && update-ca-certificates \
  && ln -sf python3 /usr/bin/python

LABEL \
  org.opencontainers.image.title="${BUILD_NAME}" \
  org.opencontainers.image.description="${BUILD_DESCRIPTION}" \
  org.opencontainers.image.vendor="Python boto3 application" \
  org.opencontainers.image.authors="David Peters (https://github.com/daveshow)" \
  org.opencontainers.image.licenses="MIT" \
  org.opencontainers.image.url="https://github.com/${BUILD_REPOSITORY}" \
  org.opencontainers.image.source="https://github.com/${BUILD_REPOSITORY}" \
  org.opencontainers.image.documentation="https://github.com/${BUILD_REPOSITORY}/blob/main/README.md" \
  org.opencontainers.image.created=${BUILD_DATE} \
  org.opencontainers.image.revision=${BOTO3_VERSION} \
  org.opencontainers.image.version=${ALPINE_TAG}

CMD ["python3", "-c", "import platform, boto3; print('Python', platform.python_version()); print('boto3', boto3.__version__)"]