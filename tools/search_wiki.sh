#!/bin/bash
# search_wiki.sh — Simple text search across all wiki pages
# Usage: ./tools/search_wiki.sh "search term"

if [ -z "$1" ]; then
    echo "Usage: $0 <search_term>"
    echo ""
    echo "Searches all markdown files in wiki/ for the given term."
    echo "Returns matching lines with file paths and line numbers."
    exit 1
fi

SEARCH_TERM="$1"

echo "=== Searching wiki for: '$SEARCH_TERM' ==="
echo ""

# Search in wiki files
grep -rn --include="*.md" -i "$SEARCH_TERM" wiki/ | while IFS=: read -r file line content; do
    echo "📄 $file:$line"
    echo "   $content"
    echo ""
done

# Count results
COUNT=$(grep -rn --include="*.md" -i "$SEARCH_TERM" wiki/ | wc -l | tr -d ' ')
echo "=== Found $COUNT matches ==="
