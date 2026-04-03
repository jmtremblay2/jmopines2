---
title: "Using Tags and Categories"
date: 2026-04-01
draft: false
tags: ['hugo', 'meta']
---

Hugo ships with two default taxonomies: **tags** and **categories**.

## Assigning terms

Add them to any article's front matter:

```yaml
---
title: "My Article"
tags: ['python', 'tools']
categories: ['tutorials']
---
```

## What Hugo generates

For each taxonomy, Hugo creates:

- A **taxonomy list** page: `/tags/` — shows all terms.
- A **term** page per value: `/tags/python/` — lists all articles with
  that tag.

## Custom taxonomies

Define additional taxonomies in `hugo.toml`:

```toml
[taxonomies]
  tag = "tags"
  category = "categories"
  series = "series"
```

Then use `series: ['my-series']` in front matter. Hugo generates `/series/`
and `/series/my-series/` automatically.

## Tag overlap

Tags are meant to cross-cut sections. An article in `software/` and one in
`config/` can share the tag `hugo` — the term page at `/tags/hugo/` will
list both.
