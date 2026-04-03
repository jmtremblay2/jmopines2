#!/usr/bin/env bash
set -euo pipefail

# Initialize a Hugo site with the Terminal theme using Docker.
# Usage: ./scripts/setup.sh

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
SITE_DIR="${PROJECT_ROOT}/site"
HUGO_IMAGE="ghcr.io/gohugoio/hugo:latest"

hugo() {
  docker run --rm \
    -v "${SITE_DIR}:/src" \
    -w /src \
    "${HUGO_IMAGE}" "$@"
}

if [[ -d "${SITE_DIR}" ]]; then
  echo "[setup] Site directory already exists: ${SITE_DIR}"
  echo "[setup] Delete it first if you want a fresh start."
  exit 1
fi

echo "[setup] Creating new Hugo site in ${SITE_DIR}"
mkdir -p "${SITE_DIR}"
docker run --rm \
  -v "${PROJECT_ROOT}:/src" \
  -w /src \
  "${HUGO_IMAGE}" new site site

echo "[setup] Initializing Hugo module"
hugo mod init gohugo-jm

echo "[setup] Writing hugo.toml"
cat > "${SITE_DIR}/hugo.toml" << 'EOF'
baseURL = "http://localhost:1313/"
languageCode = "en-us"
title = "JM's Site"
pagination.pagerSize = 5

[markup.highlight]
  noClasses = false

[params]
  contentTypeName = "posts"
  showMenuItems = 2
  fullWidthTheme = false
  centerTheme = true

[languages]
  [languages.en]
    languageName = "English"
    title = "JM's Site"

    [languages.en.params]
      subtitle = "hello, it's JM"
      owner = "JM"
      keywords = ""
      copyright = ""
      menuMore = "Show more"
      readMore = "Read more"
      readOtherPosts = "Read other posts"
      newerPosts = "Newer posts"
      olderPosts = "Older posts"
      missingContentMessage = "Page not found..."
      missingBackButtonLabel = "Back to home page"
      minuteReadingTime = "min read"
      words = "words"

      [languages.en.params.logo]
        logoText = "JM's Terminal"
        logoHomeLink = "/"

      [languages.en.menu]
        [[languages.en.menu.main]]
          identifier = "about"
          name = "About"
          url = "/about"

[module]
  [[module.imports]]
    path = 'github.com/panr/hugo-theme-terminal/v4'
EOF

echo "[setup] Fetching theme module"
hugo mod get github.com/panr/hugo-theme-terminal/v4

echo "[setup] Creating first post"
mkdir -p "${SITE_DIR}/content/posts"
cat > "${SITE_DIR}/content/posts/hello.md" << 'EOF'
---
title: "Hello, it's JM"
date: 2026-04-03
draft: false
---

Hello, it's JM. Welcome to my site.

This is my first post, built with [Hugo](https://gohugo.io/) and the
[Terminal](https://github.com/panr/hugo-theme-terminal) theme.
EOF

echo "[setup] Done. Run ./scripts/build.sh to serve the site."
