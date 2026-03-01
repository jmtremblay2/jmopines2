---
title: "How Dates Work on This Site"
date: 2026-04-03
draft: false
tags: ['hugo', 'git', 'workflow', 'AI-gen']
---

Every page on this site has two dates: **Created** and **Updated**.
Neither one is maintained by hand. Here's the full flow.

## Creating a new page

New content is created with the `new.sh` script:

```bash
./scripts/new.sh content/thissite/my-page.md
```

This sources `.env` for `HUGO_IMAGE` and `SITE_DIR`, then runs
`hugo new` inside the Docker container.

Hugo reads the archetype template at `archetypes/default.md`:

```yaml
+++
date = '{{ .Date }}'
draft = true
title = '{{ replace .File.ContentBaseName "-" " " | title }}'
tags = []
+++
```

At creation time, Hugo substitutes `{{ .Date }}` with the current
timestamp and writes it into the new file's front matter. The result
looks like:

```yaml
---
date: 2026-04-03T14:30:00-04:00
draft: true
title: "My Page"
tags: []
---
```

**That `date` value is baked into the file once and never changes.**
It represents when the page was created. Nobody edits it afterward.

## How "Updated" works

The `lastmod` field is **not** stored in the file at all. It's resolved
at build time by Hugo based on this config in `hugo.toml`:

```toml
enableGitInfo = true

[frontmatter]
  date = [':default']
  lastmod = [':git', ':fileModTime']
```

The resolution chain for `lastmod`:

1. **`:git`** — Hugo calls `git log` to find the author date of the most
   recent commit that touched the file. This is the primary source.
2. **`:fileModTime`** — Fallback to the filesystem modification time
   (useful when the file hasn't been committed yet, e.g. during local
   preview).

So when Hugo builds the site, it inspects the git history for each
content file and injects `.Lastmod` into the page context. Templates can
then render it with `{{ .Lastmod }}`.

## What does git actually track?

Git records the **author date** on each commit. When you edit a file and
commit it, that commit's date becomes the new updated date for that file.
The original `date` in front matter is untouched — it still reflects
creation time.

```
commit abc123
Author: JM <jm@example.com>
Date:   Thu Apr 3 14:30:00 2026 -0400

    Fix typo in dates page
```

Hugo will see `Apr 3 14:30:00 2026` as the updated date for any file
modified in that commit.

## The full lifecycle

| Step | What happens | Where the date lives |
|---|---|---|
| `hugo new content/thissite/foo.md` | Archetype stamps `date` | In the file's front matter |
| First `git commit` | Git records author date | In git history |
| Edit the file later | `date` in front matter unchanged | Still in front matter |
| `git commit` the edit | Git records a new author date | In git history |
| `hugo build` | Hugo reads `date` from front matter, `lastmod` from git | Injected into page context at build time |

## Key points

- **Created date**: set once by the archetype, stored in front matter,
  never changes.
- **Updated date**: not stored in the file. Resolved from git at build
  time. Zero maintenance.
- **`enableGitInfo = true`** is required in `hugo.toml` for any of the
  git-based date resolution to work.
- **No tracking needed** for the updated date — it's derived, not stored.
