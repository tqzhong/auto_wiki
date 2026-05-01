---
type: concept
tags: [llm-wiki, knowledge-management, pattern, architecture]
created: 2026-05-01
updated: 2026-05-01
related: [persistent-compounding-artifact.md, incremental-compilation.md, human-llm-collaboration.md, ../sources/karpathy-llm-wiki-gist.md]
sources: [../../raw/karpathy-llm-wiki-gist.md]
summary: "The LLM Wiki pattern: LLMs build and maintain persistent personal wikis from raw sources"
---

# LLM Wiki Pattern

## Overview

The **LLM Wiki pattern** is a paradigm for personal knowledge management where an LLM agent incrementally builds and maintains a persistent wiki of interlinked markdown files. Unlike RAG-based approaches that retrieve and generate answers from raw documents on every query, the LLM Wiki pattern **compiles knowledge once and keeps it current**, creating a structured, evolving knowledge base.

First proposed by [Andrej Karpathy](../entities/andrej-karpathy.md) in a [2025 GitHub Gist](../sources/karpathy-llm-wiki-gist.md).

## Core Idea

Instead of treating the LLM as a question-answering system over raw documents, treat it as a **wiki maintainer**. The LLM:

1. Reads raw sources and extracts key information
2. Creates structured wiki pages with cross-references
3. Updates existing pages when new sources arrive
4. Flags contradictions and inconsistencies
5. Maintains an index and activity log

The result is a **persistent, compounding artifact** — a knowledge base that grows richer with every interaction.

## Key Principles

- **Compilation over retrieval**: Knowledge is compiled into structured pages, not retrieved from raw chunks
- **Persistence**: The wiki survives across sessions; it's a git repo of markdown files
- **Compounding value**: Each new source and query adds to the knowledge base
- **Human-LLM division**: Human curates and directs; LLM maintains and structures
- **Incremental updates**: Prefer updating existing pages over rewriting from scratch

## Three-Layer Architecture

```
┌─────────────────────────┐
│   Schema (CLAUDE.md)    │  ← Conventions & workflows
├─────────────────────────┤
│   Wiki (wiki/)          │  ← LLM-generated, LLM-maintained
├─────────────────────────┤
│   Raw Sources (raw/)    │  ← Immutable, human-curated
└─────────────────────────┘
```

## Three Core Operations

| Operation | Trigger | Output |
|-----------|---------|--------|
| **Ingest** | New source added | Source page + updated entities/concepts/index/log |
| **Query** | Human asks question | Synthesized answer + optional new wiki page |
| **Lint** | Periodic health check | Contradictions, orphans, staleness report |

## Connections

- The wiki is a [Persistent Compounding Artifact](persistent-compounding-artifact.md) — this is what makes it valuable over time
- Requires [Incremental Compilation](incremental-compilation.md) rather than batch processing
- Relies on effective [Human-LLM Collaboration](human-llm-collaboration.md) for curation and direction
- Contrast with RAG: RAG retrieves from raw docs at query time; LLM Wiki pre-compiles knowledge

## Open Questions

- What's the optimal wiki structure for different domains?
- How do you handle knowledge that's highly uncertain or rapidly evolving?
- Can multiple LLM agents maintain the same wiki concurrently?
