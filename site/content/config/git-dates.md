---
title: "Automatic Dating with Git"
date: 2026-04-02
draft: false
tags: ['hugo', 'git', 'workflow']
---

Hugo can pull dates from Git history so you never have to update `lastmod`
by hand.

## Enable Git info

```toml
# hugo.toml
enableGitInfo = true
```

## Configure front matter date resolution

```toml
[frontmatter]
  date = [':filename', ':default']
  publishDate = [':filename', ':default']
  lastmod = [':git', ':fileModTime']
```

## How it works

- `.Date` — tries the filename first (`2026-04-03-post.md`), then the
  `date` field in front matter.
- `.Lastmod` — uses the Git author date of the last commit that touched
  the file, falling back to filesystem mtime.
- `.PublishDate` — same resolution chain as `.Date`.

## Filename date formats

Hugo recognizes these patterns:

```
2026-04-03-my-post.md       → date: 2026-04-03, slug: my-post
2026-04-03T14-30-00-post.md → date: 2026-04-03T14:30:00
```
