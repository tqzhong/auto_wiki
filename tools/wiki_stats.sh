#!/bin/bash
# wiki_stats.sh — Display statistics about the wiki
# Usage: ./tools/wiki_stats.sh

echo "╔══════════════════════════════════════╗"
echo "║        📊 Wiki Statistics            ║"
echo "╚══════════════════════════════════════╝"
echo ""

# Count pages by type
echo "📄 Pages by Type:"
echo "  Entities:     $(ls wiki/entities/*.md 2>/dev/null | wc -l | tr -d ' ')"
echo "  Concepts:     $(ls wiki/concepts/*.md 2>/dev/null | wc -l | tr -d ' ')"
echo "  Sources:      $(ls wiki/sources/*.md 2>/dev/null | wc -l | tr -d ' ')"
echo "  Comparisons:  $(ls wiki/comparisons/*.md 2>/dev/null | wc -l | tr -d ' ')"
TOTAL=$(find wiki/ -name "*.md" -not -name "index.md" -not -name "log.md" -not -name "overview.md" | wc -l | tr -d ' ')
echo "  ─────────────────────"
echo "  Total pages:  $TOTAL"
echo ""

# Count raw sources
echo "📦 Raw Sources: $(ls raw/*.md 2>/dev/null | wc -l | tr -d ' ')"
echo ""

# Count total words
WORDS=$(find wiki/ -name "*.md" -exec cat {} + 2>/dev/null | wc -w | tr -d ' ')
echo "📝 Total words in wiki: $WORDS"
echo ""

# Log entries
ENTRIES=$(grep -c "^## \[" wiki/log.md 2>/dev/null || echo "0")
echo "📋 Log entries: $ENTRIES"
echo ""

# Recent activity
echo "🕐 Recent Activity (last 5 entries):"
grep "^## \[" wiki/log.md 2>/dev/null | tail -5 | while read -r line; do
    echo "  $line"
done
echo ""
