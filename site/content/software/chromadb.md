---
title: "Vector Search with ChromaDB"
date: 2026-04-02
draft: false
tags: ['chromadb', 'python', 'llm', 'tools']
---

ChromaDB is an embedding database for building search and retrieval systems.

## How I use it

I chunk documentation (VyOS, Hugo) into paragraphs, embed them with
`nomic-embed-text` via Ollama, and store the vectors in ChromaDB for
semantic search.

## Stack

```
Documents → Chunker → Ollama embeddings → ChromaDB → Query API
```

## Key concepts

- **Collection**: a named group of embeddings (like a table).
- **Document**: the raw text stored alongside the vector.
- **Metadata**: key-value pairs for filtering results.
