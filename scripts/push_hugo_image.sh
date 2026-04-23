#!/usr/bin/env bash
set -euo pipefail

# Minimal build script: build the image from hugo_git/Dockerfile using hugo_git as context
docker build -t forgejo.jmopines.com/jm/hugo-git:latest .
docker push forgejo.jmopines.com/jm/hugo-git:latest