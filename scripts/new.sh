#!/usr/bin/env bash
set -euo pipefail

# Create a new content page using Hugo's archetype.
# Usage: ./scripts/new.sh <path>
# Example: ./scripts/new.sh content/thissite/my-page.md

source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/../.env"

if [[ $# -lt 1 ]]; then
  echo "Usage: $0 <content-path>"
  echo "Example: $0 content/thissite/my-page.md"
  exit 1
fi

docker run --rm \
  -v "${SITE_DIR}:/src" \
  -w /src \
  "${HUGO_IMAGE}" new "$1"
