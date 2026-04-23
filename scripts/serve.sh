#!/usr/bin/env bash
set -euo pipefail

# Serve the Hugo site locally using Docker.
# Usage: ./scripts/serve.sh

source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/../.env"
PORT="${1:-$PORT}"

if [[ ! -d "${SITE_DIR}" ]]; then
  echo "[serve] Site directory not found: ${SITE_DIR}"
  echo "[serve] Run ./scripts/setup.sh first."
  exit 1
fi

echo "[serve] Serving site at http://localhost:${PORT}/"
echo "[serve] Press Ctrl+C to stop."

# Use the prebuilt/pushed Hugo image (hardcoded to the image created by
# scripts/push_hugo_image.sh). This simplifies the serve script and avoids
# local image build logic.
HUGO_GIT_IMAGE="forgejo.jmopines.com/jm/hugo-git:latest"
USE_IMAGE="${HUGO_GIT_IMAGE}"

# Run Hugo server. Mount the repo .git read-only so git-based info is available
# inside the container when `enableGitInfo = true`.
docker run --rm \
  -v "${SITE_DIR}:/src" \
  -v "${PROJECT_ROOT}/.git:/src/.git:ro" \
  -w /src \
  -p "${PORT}:1313" \
  "${USE_IMAGE}" server \
    --bind 0.0.0.0 \
    --baseURL "http://localhost:${PORT}/" \
    --appendPort=false
