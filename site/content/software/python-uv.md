---
title: "Python Packaging with uv"
date: 2026-04-03
draft: false
tags: ['python', 'tools', 'workflow']
---

`uv` is a fast Python package manager and project tool written in Rust.

## Why uv over pip/poetry/pipenv?

- 10–100x faster dependency resolution.
- Single tool: replaces pip, pip-tools, virtualenv, and pyenv.
- Lockfile support via `uv.lock`.

## Common commands

```bash
uv init myproject          # scaffold a new project
uv add requests            # add a dependency
uv sync                    # install from lockfile
uv run pytest              # run inside the managed venv
```

## Project convention

All Python projects in this workspace use `uv` exclusively — no raw
`pip install` or `python -m pytest`.
