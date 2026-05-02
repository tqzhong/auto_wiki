---
type: concept
tags: [collaboration, human-ai, workflow, llm-wiki]
created: 2026-05-01
updated: 2026-05-02
related: [llm-wiki-pattern.md, incremental-compilation.md, multi-agent-orchestration.md]
sources: [../../raw/karpathy-llm-wiki-gist.md]
summary: "The division of labor: human curates and directs, LLM maintains and structures"
---

# Human-LLM Collaboration

## Overview

The LLM Wiki pattern defines a clear division of labor between human and LLM agent. Neither replaces the other — they have complementary strengths.

## Roles

### Human's Job
- **Curate sources**: Decide what to read, what's worth ingesting
- **Direct analysis**: Guide the LLM on what to emphasize, what's important
- **Ask questions**: Drive exploration through insightful queries
- **Think about meaning**: Interpret, evaluate, form judgments
- **Evolve the schema**: Adjust conventions as the wiki grows

### LLM's Job
- **Read and summarize**: Process raw sources into structured pages
- **Cross-reference**: Link related pages, maintain connections
- **Update and maintain**: Keep the wiki consistent and current
- **Flag issues**: Detect contradictions, staleness, orphans
- **Bookkeeping**: Maintain index, log, frontmatter

## The Karpathy Workflow

> "I have the LLM agent open on one side and Obsidian open on the other. The LLM makes edits based on our conversation, and I browse the results in real time — following links, checking the graph view, reading the updated pages. **Obsidian is the IDE; the LLM is the programmer; the wiki is the codebase.**"

## Why This Works

- Humans are good at **judgment** (what matters, what's true, what's interesting)
- LLMs are good at **bookkeeping** (summarizing, cross-referencing, updating, filing)
- The tedious maintenance that makes humans abandon wikis is exactly what LLMs excel at
- The curation and direction that LLMs can't do well is exactly what humans enjoy

## Ingest Styles

| Style | Description | When to use |
|-------|-------------|-------------|
| **Collaborative** | Ingest one source at a time, discuss key takeaways, guide the LLM | When you want deep understanding |
| **Batch** | Ingest many sources at once with less supervision | When catching up or processing backlog |

## Connections

- This collaboration model is central to the [LLM Wiki Pattern](llm-wiki-pattern.md)
- The human's role is curation; the LLM's role is [Incremental Compilation](incremental-compilation.md)
- [Multi-Agent Orchestration](multi-agent-orchestration.md) extends this pattern: multiple AI Agents collaborate under human oversight, rather than a single LLM

## Open Questions

- How does collaboration change with different LLM capabilities?
- What's the right level of human oversight for different domains?
