#!/bin/bash
# distill_session.sh — 帮助从不同平台导出对话内容到 raw/sessions/
#
# 使用方式:
#   ./tools/distill_session.sh                   # 交互式创建空白 session 文件
#   ./tools/distill_session.sh clip              # 从剪贴板读取对话内容
#   ./tools/distill_session.sh file <path>       # 从文件导入
#   ./tools/distill_session.sh claude            # 提示如何从 Claude Code 导出

WIKI_DIR="$(cd "$(dirname "$0")/.." && pwd)"
RAW_DIR="$WIKI_DIR/raw/sessions"
mkdir -p "$RAW_DIR"

TODAY=$(date +%Y-%m-%d)
TIMESTAMP=$(date +%Y%m%d_%H%M%S)

create_session_template() {
    local filename="$1"
    local title="$2"
    cat > "$RAW_DIR/$filename" << EOF
---
type: session
date: $TODAY
title: "$title"
platform: "Claude Code / ChatGPT / other"
topic: ""
tags: []
---

# Session: $title

## Context
<!-- 这次对话的背景是什么？你想解决什么问题？ -->

## Conversation

### Human
> (在此粘贴你的问题/输入)

### AI
> (在此粘贴 AI 的回答)

---
(继续添加更多轮次...)

## Summary
<!-- 对话结束后填入：核心结论是什么？ -->

## Action Items
<!-- 有什么需要后续跟进的？ -->

## Wiki Extraction Notes
<!-- LLM 填入：这次对话中哪些内容应该沉淀到 wiki 的哪些页面？ -->
- Entity to update/create:
- Concept to update/create:
- New insight:
EOF
    echo "✅ Created session file: $RAW_DIR/$filename"
    echo "📝 Edit this file to add your conversation content, then run:"
    echo "   \"请帮我蒸馏这次对话\" in your LLM session"
}

case "${1:-interactive}" in
    interactive)
        echo "🧠 Create a new session file"
        echo ""
        read -p "Session title (e.g., 'Learning Rust ownership model'): " TITLE
        SLUG=$(echo "$TITLE" | tr '[:upper:]' '[:lower:]' | tr ' ' '-' | tr -cd 'a-z0-9\-')
        FILENAME="${TIMESTAMP}_${SLUG}.md"
        create_session_template "$FILENAME" "$TITLE"
        ;;

    clip)
        echo "📋 Reading from clipboard..."
        if command -v pbpaste &>/dev/null; then
            CLIP=$(pbpaste)
        elif command -v xclip &>/dev/null; then
            CLIP=$(xclip -selection clipboard -o)
        else
            echo "❌ No clipboard tool found. Install pbpaste (macOS) or xclip (Linux)"
            exit 1
        fi

        if [ -z "$CLIP" ]; then
            echo "❌ Clipboard is empty"
            exit 1
        fi

        # Try to detect a title from the first meaningful line
        FIRST_LINE=$(echo "$CLIP" | head -5 | grep -v "^$" | head -1 | cut -c1-60)
        SLUG=$(echo "$FIRST_LINE" | tr '[:upper:]' '[:lower:]' | tr ' ' '-' | tr -cd 'a-z0-9\-')
        FILENAME="${TIMESTAMP}_clipboard-session.md"

        # Create file with clipboard content embedded
        cat > "$RAW_DIR/$filename" << EOF
---
type: session
date: $TODAY
title: "Clipboard session - $FIRST_LINE"
platform: "clipboard"
topic: ""
tags: []
---

# Session from Clipboard

## Conversation

$CLIP

## Summary
<!-- 核心结论 -->

## Wiki Extraction Notes
<!-- LLM 填入 -->
EOF
        echo "✅ Saved clipboard content to: $RAW_DIR/$FILENAME"
        echo "📝 Now ask your LLM: \"请帮我蒸馏 raw/sessions/$FILENAME\""
        ;;

    file)
        if [ -z "$2" ]; then
            echo "❌ Usage: $0 file <path-to-conversation-file>"
            exit 1
        fi
        SOURCE="$2"
        if [ ! -f "$SOURCE" ]; then
            echo "❌ File not found: $SOURCE"
            exit 1
        fi
        BASENAME=$(basename "$SOURCE")
        FILENAME="${TIMESTAMP}_${BASENAME}"
        cp "$SOURCE" "$RAW_DIR/$FILENAME"
        echo "✅ Imported to: $RAW_DIR/$FILENAME"
        echo "📝 Now ask your LLM: \"请帮我蒸馏 raw/sessions/$FILENAME\""
        ;;

    claude)
        echo ""
        echo "📖 How to export Claude Code conversations:"
        echo ""
        echo "  Method 1: Direct (recommended)"
        echo "    In your Claude Code session, just say:"
        echo "    \"请把我们这次对话的要点总结后沉淀到我的 wiki 里\""
        echo "    The LLM will distill directly from the current conversation."
        echo ""
        echo "  Method 2: Manual export"
        echo "    1. Copy the conversation from your terminal"
        echo "    2. Run: ./tools/distill_session.sh clip"
        echo "    3. Then: \"请帮我蒸馏 raw/sessions/<filename>\""
        echo ""
        echo "  Method 3: Claude.ai web"
        echo "    1. Copy the conversation text from claude.ai"
        echo "    2. Run: ./tools/distill_session.sh clip"
        echo ""
        ;;

    *)
        echo "Usage: $0 [interactive|clip|file <path>|claude]"
        echo ""
        echo "  interactive  - Create a blank session template (default)"
        echo "  clip         - Import from clipboard"
        echo "  file <path>  - Import from a file"
        echo "  claude       - Show instructions for Claude Code export"
        ;;
esac
