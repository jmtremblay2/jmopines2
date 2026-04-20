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

# Run Hugo in Docker to produce static files. This does not start the dev server.
docker run --rm \
  -v "${SITE_DIR}:/src" \
  -w /src \
  "${HUGO_IMAGE}" \
  --minify --destination "public" --baseURL "/"

echo "[build] Build complete: ${SITE_DIR}/public"
