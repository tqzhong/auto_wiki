---
type: source
tags: [karpathy, llm-wiki, knowledge-management, personal-kb, pattern]
created: 2026-05-01
updated: 2026-05-01
related: [../concepts/persistent-compounding-artifact.md, ../concepts/llm-wiki-pattern.md, ../entities/andrej-karpathy.md]
sources: [../../raw/karpathy-llm-wiki-gist.md]
summary: "Karpathy's foundational gist proposing the LLM Wiki pattern for personal knowledge bases"
---

# Karpathy's LLM Wiki Gist

## Overview

Andrej Karpathy published a foundational gist describing a pattern for building personal knowledge bases using LLMs. Rather than using RAG (retrieve-and-generate) at query time, the LLM incrementally compiles and maintains a persistent, interlinked wiki of markdown files. The wiki is a **compounding artifact** that grows richer with every source ingested and every question asked.

**Source:** [GitHub Gist](https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f)

## Key Points

- **RAG is limited**: The LLM rediscovers knowledge from scratch on every query. No accumulation happens.
- **Wiki is different**: Knowledge is compiled once and kept current. Cross-references, contradictions, and synthesis are pre-built.
- **The wiki is persistent and compounding**: It keeps getting richer over time, unlike ephemeral chat sessions.
- **Human curates, LLM maintains**: The human sources material and asks questions. The LLM does all the bookkeeping.
- **Obsidian as IDE, LLM as programmer, wiki as codebase**: The practical workflow.
- **Applies broadly**: Personal tracking, research, book reading, business wikis, competitive analysis, etc.

## Architecture

1. **Raw sources** — Immutable curated documents (articles, papers, data). The source of truth.
2. **The wiki** — LLM-generated, LLM-maintained interlinked markdown files. Summaries, entity pages, concept pages, comparisons.
3. **The schema** — A configuration file (e.g., CLAUDE.md) defining conventions, page formats, and workflows.

## Operations

| Operation | Description |
|-----------|-------------|
| **Ingest** | Drop new source → LLM reads, discusses, creates source page, updates entities/concepts, updates index, logs activity |
| **Query** | Ask question → LLM finds relevant pages, synthesizes answer with citations, offers to file result as new page |
| **Lint** | Health check → Find contradictions, orphan pages, stale claims, missing cross-references, data gaps |

## Tools Mentioned

- **Obsidian**: Viewer/IDE for the wiki vault with graph view, Dataview plugin, Web Clipper
- **qmd**: Local search engine for markdown (hybrid BM25/vector search with LLM re-ranking)
- **Marp**: Markdown-based slide deck format for presentations
- **Dataview**: Obsidian plugin for querying page frontmatter

## Connections

- Establishes the [LLM Wiki Pattern](../concepts/llm-wiki-pattern.md) as the core framework
- The wiki is a [Persistent Compounding Artifact](../concepts/persistent-compounding-artifact.md)
- Inspirational lineage from [Vannevar Bush's Memex](../concepts/memex-concept.md) (1945)

## Open Questions

- How well does this scale beyond ~100 sources / hundreds of pages?
- What are the best practices for multi-agent wiki maintenance?
- How do you handle deeply technical domains where LLM accuracy is critical?

---

*Ingested: 2026-05-01*
