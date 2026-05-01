---
type: concept
tags: [knowledge-management, compounding, persistence, artifact]
created: 2026-05-01
updated: 2026-05-01
related: [llm-wiki-pattern.md, incremental-compilation.md]
sources: [../../raw/karpathy-llm-wiki-gist.md]
summary: "A wiki that grows richer over time — cross-references, synthesis, and structure compound with each addition"
---

# Persistent Compounding Artifact

## Overview

A **persistent compounding artifact** is a knowledge product that:
1. **Persists** across sessions (it's a git repo of markdown files, not ephemeral chat)
2. **Compounds** in value with every addition (new sources enrich existing pages, cross-references multiply)

This is the key insight from Karpathy's LLM Wiki pattern: the wiki is not just a collection of documents — it's an evolving, interlinked structure where every new piece of information strengthens the whole.

## Why "Compounding"?

- **Cross-references multiply**: Each new page can link to 5-10 existing pages, and those pages get updated with back-links. The graph grows quadratically.
- **Synthesis improves**: As more sources are ingested, the LLM can identify patterns, contradictions, and themes that weren't visible with fewer sources.
- **Context deepens**: The LLM's answers to queries improve because it has richer context in the wiki.
- **Maintenance is free**: Unlike human-maintained wikis, the LLM handles all the bookkeeping at near-zero marginal cost.

## Contrast with Alternatives

| Approach | Persistent? | Compounds? | Maintenance Cost |
|----------|------------|------------|-----------------|
| Chat sessions | ❌ | ❌ | None |
| RAG (retrieval) | ✅ | ❌ | Low |
| Human wiki | ✅ | ✅ | Very high |
| **LLM Wiki** | ✅ | ✅ | **Near zero** |

## Connections

- This property is what defines the [LLM Wiki Pattern](llm-wiki-pattern.md)
- Requires [Incremental Compilation](incremental-compilation.md) to maintain persistence
- The LLM's ability to touch many files in one pass is what makes maintenance near-zero cost

## Open Questions

- Is there a ceiling to compounding? At what scale does the wiki become too large to maintain effectively?
- How do you measure the "compound interest" of a knowledge base?
