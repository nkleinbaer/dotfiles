#!/usr/bin/env bash
# Claude Code status line — minimal with dim · separators and subtle ANSI colors

input=$(cat)

# ANSI color helpers (no backgrounds)
DIM='\033[2m'
RESET='\033[0m'
CYAN='\033[36m'
BLUE='\033[34m'
GREEN='\033[32m'
YELLOW='\033[33m'
ORANGE='\033[38;5;214m'
RED='\033[31m'

SEP="${DIM} · ${RESET}"

parts=()

# --- 1. Git branch (cyan) ---
cwd=$(echo "$input" | jq -r '.workspace.current_dir')
branch=$(git -C "$cwd" --no-optional-locks symbolic-ref --short HEAD 2>/dev/null)

if [ -n "$branch" ]; then
  unstaged=""
  staged=""
  if ! git -C "$cwd" --no-optional-locks diff --quiet 2>/dev/null; then
    unstaged="*"
  fi
  if ! git -C "$cwd" --no-optional-locks diff --cached --quiet 2>/dev/null; then
    staged="+"
  fi

  dirty=""
  if [ -n "$staged" ] && [ -n "$unstaged" ]; then
    dirty="${YELLOW}+${ORANGE}*${RESET}"
  elif [ -n "$staged" ]; then
    dirty="${YELLOW}+${RESET}"
  elif [ -n "$unstaged" ]; then
    dirty="${ORANGE}*${RESET}"
  fi

  parts+=("$(printf "${CYAN}%s${RESET}%s" "$branch" "$dirty")")
fi

# --- 2. Model (blue) + effort level in dim parens ---
model=$(echo "$input" | jq -r '.model.display_name // empty')

if [ -n "$model" ]; then
  effort=$(jq -r '.effortLevel // empty' /home/nick/.claude/settings.json 2>/dev/null)
  if [ -n "$effort" ]; then
    parts+=("$(printf "${BLUE}%s${RESET} ${DIM}(%s)${RESET}" "$model" "$effort")")
  else
    parts+=("$(printf "${BLUE}%s${RESET}" "$model")")
  fi
fi

# --- 3. Token count + context usage % — color based on raw token count ---
# Derive used token count from used_percentage * context_window_size.
used_pct=$(echo "$input" | jq -r '.context_window.used_percentage // empty')
ctx_size=$(echo "$input" | jq -r '.context_window.context_window_size // empty')

if [ -n "$used_pct" ] && [ -n "$ctx_size" ]; then
  ctx_tokens=$(awk "BEGIN { printf \"%.0f\", ($used_pct / 100) * $ctx_size }")
else
  ctx_tokens=""
fi

if [ -n "$ctx_tokens" ] && [ "$ctx_tokens" -gt 0 ] 2>/dev/null; then
  # Determine color from raw token count: green <140k, yellow 140k-500k, red >500k
  if [ "$ctx_tokens" -gt 500000 ]; then
    color="$RED"
  elif [ "$ctx_tokens" -gt 140000 ]; then
    color="$YELLOW"
  else
    color="$GREEN"
  fi
  # Format context tokens as human-readable (e.g. 12.3k, 1.2M)
  if [ "$ctx_tokens" -ge 1000000 ]; then
    token_label=$(awk "BEGIN { printf \"%.1fM\", $ctx_tokens/1000000 }")
  elif [ "$ctx_tokens" -ge 1000 ]; then
    token_label=$(awk "BEGIN { printf \"%.1fk\", $ctx_tokens/1000 }")
  else
    token_label="${ctx_tokens}"
  fi
  used_int=$(printf '%.0f' "$used_pct")
  parts+=("$(printf "${color}%s tokens ${DIM}(%s%%)${RESET}" "$token_label" "$used_int")")
fi

# --- Join with dim · separator ---
result=""
for part in "${parts[@]}"; do
  if [ -z "$result" ]; then
    result="$part"
  else
    result="${result}${SEP}${part}"
  fi
done

printf "%b" "$result"
