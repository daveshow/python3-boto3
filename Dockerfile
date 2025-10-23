ARG ALPINE_TAG=latest
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

CMD ["python3", "-c", "import platform, boto3; print('Python', platform.python_version()); print('boto3', boto3.__version__)"]