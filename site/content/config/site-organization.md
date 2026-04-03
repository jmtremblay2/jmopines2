---
title: "Organizing This Site"
date: 2026-04-03
draft: false
tags: ['hugo', 'workflow', 'meta']
---

A reference for how this Hugo site is organized and what configuration
options are available.

## Sections

Sections are created automatically from the directory tree under `content/`.
Any directory with an `_index.md` file becomes a section with its own list
page.

```
content/
├── _index.md           ← home page
├── about/
│   ├── _index.md       ← /about/ list page
│   ├── whoami.md
│   └── now.md
├── software/
│   ├── _index.md       ← /software/ list page
│   ├── ollama.md
│   └── hugo-setup/     ← page bundle (leaf)
│       ├── index.md
│       └── architecture.svg
└── config/
    ├── _index.md       ← /config/ list page
    └── this-file.md
```

No config changes are needed — Hugo derives sections from the filesystem.

## Taxonomies

Tags and categories are enabled by default. Assign them in front matter:

```yaml
tags: ['hugo', 'docker', 'tools']
```

Hugo auto-generates pages at `/tags/`, `/tags/hugo/`, etc.

To define custom taxonomies beyond tags/categories:

```toml
# hugo.toml
[taxonomies]
  tag = "tags"
  category = "categories"
  series = "series"          # custom
```

## Page bundles

A **leaf bundle** is a directory with `index.md` (not `_index.md`). All
sibling files become page resources — images, data files, etc. — that
travel with the article.

A **branch bundle** uses `_index.md` and represents a section (it can have
children).

| File | Type | Has children? |
|---|---|---|
| `index.md` | leaf bundle | No |
| `_index.md` | branch bundle | Yes |

## Automatic dating

Three mechanisms, configured in `hugo.toml`:

```toml
enableGitInfo = true

[frontmatter]
  date = [':filename', ':default']
  lastmod = [':git', ':fileModTime']
```

- **`:filename`** — extracts date from `2026-04-03-my-post.md`.
- **`:default`** — falls back to the `date` field in front matter.
- **`:git`** — uses the Git author date of the last commit.
- **`:fileModTime`** — uses the file's mtime on disk.

## Automatic tagging

Hugo does **not** auto-tag content. Tags must be set manually in front
matter. The closest workaround is `cascade` in a section `_index.md`,
which pushes shared parameters to descendants — but it only works for
custom `.Params` fields, not real taxonomy terms.

For true auto-tagging, use an external script or LLM to populate front
matter before building.

## Menu

The Terminal theme reads `showMenuItems` from config. To add sections to
the nav menu:

```toml
[languages.en.menu]
  [[languages.en.menu.main]]
    identifier = "about"
    name = "About"
    url = "/about"
  [[languages.en.menu.main]]
    identifier = "software"
    name = "Software"
    url = "/software"
  [[languages.en.menu.main]]
    identifier = "config"
    name = "Config"
    url = "/config"
```

Set `showMenuItems = 3` (or more) to display them all without a "Show
more" toggle.
