---
type: concept
tags: [compilation, incremental, knowledge-management, llm-wiki]
created: 2026-05-01
updated: 2026-05-01
related: [llm-wiki-pattern.md, persistent-compounding-artifact.md]
sources: [../../raw/karpathy-llm-wiki-gist.md]
summary: "Knowledge is compiled once and kept current, not re-derived on every query"
---

# Incremental Compilation

## Overview

**Incremental compilation** is the core operational principle of the LLM Wiki pattern. Rather than retrieving and synthesizing knowledge from raw sources at query time (as RAG does), the LLM **compiles** each source into structured wiki pages when it's ingested. New sources trigger incremental updates to existing pages — adding information, revising summaries, flagging contradictions — rather than requiring a full re-compile.

## Compilation vs. Retrieval

### RAG (Retrieval-Augmented Generation)
```
Raw sources → [Store chunks] → Query → Retrieve relevant chunks → Generate answer
```
- Knowledge is rediscovered from scratch on every query
- No accumulation or synthesis across documents
- Subtle cross-document insights are missed

### LLM Wiki (Incremental Compilation)
```
Raw source → LLM reads → Extracts info → Creates/updates wiki pages → Cross-references
                                                                        ↓
                                         Query → LLM reads wiki → Synthesized answer
```
- Knowledge is compiled once when the source is ingested
- Cross-references and synthesis are pre-built
- Queries benefit from pre-compiled structure

## Why "Incremental"?

Each new source triggers updates to the **existing** wiki, not a rebuild:
1. Create a new source summary page
2. Update existing entity/concept pages with new information
3. Flag contradictions with existing claims
4. Add new cross-references
5. Update the overview if the big picture changed

This is analogous to how a compiler incrementally recompiles only the changed files, not the entire codebase.

## Connections

- This is the operational backbone of the [LLM Wiki Pattern](llm-wiki-pattern.md)
- Enables the wiki to be a [Persistent Compounding Artifact](persistent-compounding-artifact.md)
- The human-LLM workflow is described in [Human-LLM Collaboration](human-llm-collaboration.md)

## Open Questions

- What happens when a source fundamentally changes the wiki's understanding? Is a "recompile" ever needed?
- How do you detect when incremental updates have introduced inconsistencies?
