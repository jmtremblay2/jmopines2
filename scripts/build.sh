#!/usr/bin/env bash
set -euo pipefail

# Build the Hugo site into the `public/` directory for deployment (e.g. nginx).
# Usage: ./scripts/build.sh

source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/../.env"

if [[ ! -d "${SITE_DIR}" ]]; then
  echo "[build] Site directory not found: ${SITE_DIR}"
  echo "[build] Run ./scripts/setup.sh first."
  exit 1
fi

echo "[build] Building site into ${SITE_DIR}/public ..."

# Use the prebuilt/pushed Hugo image (hardcoded to the image created by
# scripts/push_hugo_image.sh). This keeps the build script simple and
# predictable.
HUGO_GIT_IMAGE="forgejo.jmopines.com/jm/hugo-git:latest"
USE_IMAGE="${HUGO_GIT_IMAGE}"

# Run Hugo in Docker to produce static files. Mount the content and the repo
# .git directory so Hugo can resolve git-based dates. Mount .git read-only.
docker run --rm \
  -v "${SITE_DIR}:/src" \
  -v "${PROJECT_ROOT}/.git:/src/.git:ro" \
  -w /src \
  "${USE_IMAGE}" \
  --minify --destination "public" --baseURL "/"

echo "[build] Build complete: ${SITE_DIR}/public"
