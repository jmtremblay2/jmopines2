FROM ghcr.io/gohugoio/hugo:latest

# Install git into the Alpine-based Hugo image so Hugo can query git
# history for `.Lastmod`. We keep the image minimal.
USER root
RUN apk add --no-cache git

USER hugo
