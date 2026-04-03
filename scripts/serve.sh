#!/usr/bin/env bash
set -euo pipefail

# Serve the Hugo site locally using Docker.
# Usage: ./scripts/serve.sh

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
SITE_DIR="${PROJECT_ROOT}/site"
HUGO_IMAGE="ghcr.io/gohugoio/hugo:latest"
PORT="${1:-1313}"

if [[ ! -d "${SITE_DIR}" ]]; then
  echo "[serve] Site directory not found: ${SITE_DIR}"
  echo "[serve] Run ./scripts/setup.sh first."
  exit 1
fi

echo "[serve] Serving site at http://localhost:${PORT}/"
echo "[serve] Press Ctrl+C to stop."

docker run --rm \
  -v "${SITE_DIR}:/src" \
  -w /src \
  -p "${PORT}:1313" \
  "${HUGO_IMAGE}" server \
    --bind 0.0.0.0 \
    --baseURL "http://localhost:${PORT}/" \
    --appendPort=false
