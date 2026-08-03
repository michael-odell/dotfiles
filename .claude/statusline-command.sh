#!/usr/bin/env bash
# Claude Code status line — compact, information-dense
#
# Enable by adding this to ~/.claude/settings.json
#
#  "statusLine": {
#    "type": "command",
#    "command": "bash /Users/michael.odell/.claude/statusline-command.sh"
#  },

input=$(cat)

# ---------------------------------------------------------------------------
# ANSI helpers
# ---------------------------------------------------------------------------
reset='\033[0m'
bold='\033[1m'
dim='\033[2m'

# Usage-limit bar colors (green → yellow → red)
color_green='\033[32m'
color_yellow='\033[33m'
color_red='\033[31m'

# Context-window bar color (cyan — visually distinct from rate-limit bars)
color_cyan='\033[36m'

# Spend color (magenta)
color_magenta='\033[35m'

# Token counter color (blue)
color_blue='\033[34m'

# Separator color
color_sep='\033[90m'  # dark gray

# ---------------------------------------------------------------------------
# mini_bar <pct_integer> — returns an 8-char Unicode block bar
# ---------------------------------------------------------------------------
mini_bar() {
  local pct=$1
  local total_chars=8
  # Clamp to 0-100
  [ "$pct" -lt 0 ] && pct=0
  [ "$pct" -gt 100 ] && pct=100

  # Each character represents 100/8 = 12.5 percentage points.
  # We work in eighths of a block character.
  local eighths=$(( pct * total_chars * 8 / 100 ))
  local full=$(( eighths / 8 ))
  local partial=$(( eighths % 8 ))
  local empty=$(( total_chars - full - (partial > 0 ? 1 : 0) ))

  local blocks=('▏' '▎' '▍' '▌' '▋' '▊' '▉' '█')
  local bar=""
  local i
  for (( i=0; i<full; i++ )); do
    bar="${bar}█"
  done
  if [ "$partial" -gt 0 ]; then
    bar="${bar}${blocks[$((partial - 1))]}"
  fi
  for (( i=0; i<empty; i++ )); do
    bar="${bar} "
  done
  printf '%s' "$bar"
}

# ---------------------------------------------------------------------------
# usage_color <pct_integer> — picks green/yellow/red based on thresholds
# ---------------------------------------------------------------------------
usage_color() {
  local pct=$1
  if [ "$pct" -lt 60 ]; then
    printf '%s' "$color_green"
  elif [ "$pct" -lt 85 ]; then
    printf '%s' "$color_yellow"
  else
    printf '%s' "$color_red"
  fi
}

# ---------------------------------------------------------------------------
# Extract fields from JSON
# ---------------------------------------------------------------------------
model=$(echo "$input" | jq -r '.model.id')

ctx_used=$(echo "$input" | jq -r '.context_window.used_percentage // empty')

five_pct=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')
week_pct=$(echo "$input" | jq -r '.rate_limits.seven_day.used_percentage // empty')

# Session spend: Claude Code computes this itself (client-side estimate,
# may differ from actual bill) and resets it on /clear. Token-count-based
# estimation was removed because context_window.total_input_tokens /
# total_output_tokens only reflect the most recent API call's context,
# not cumulative session usage (as of Claude Code >= 2.1.132).
spend_raw=$(echo "$input" | jq -r '.cost.total_cost_usd // empty')
if [ -n "$spend_raw" ]; then
  spend=$(awk -v c="$spend_raw" 'BEGIN { printf "%.2f", c }')
else
  spend=""
fi

# Token counters (display only — current context window, not cumulative)
total_in=$(echo "$input" | jq -r '.context_window.total_input_tokens // 0')
total_out=$(echo "$input" | jq -r '.context_window.total_output_tokens // 0')

# Format token counts: raw if < 1000, else rounded to nearest thousand with "k"
fmt_tokens() {
  local n=$1
  if [ "$n" -lt 1000 ]; then
    printf '%s' "$n"
  else
    printf '%sk' "$(( (n + 500) / 1000 ))"
  fi
}

tok_in=$(fmt_tokens "$total_in")
tok_out=$(fmt_tokens "$total_out")

# ---------------------------------------------------------------------------
# Build output segments
# ---------------------------------------------------------------------------
sep=$(printf "${color_sep}│${reset}")

# 1. Model name (bold, default color)
out=""
out="${out}$(printf "${bold}%s${reset}" "$model")"

# 2. Rate-limit bars — only when data is available
if [ -n "$five_pct" ] || [ -n "$week_pct" ]; then
  out="${out}  ${sep}  "
  if [ -n "$five_pct" ]; then
    five_int=$(printf '%.0f' "$five_pct")
    fcolor=$(usage_color "$five_int")
    fbar=$(mini_bar "$five_int")
    out="${out}${dim}5h${reset} ${fcolor}${fbar}${reset} ${dim}${five_int}%${reset}"
  fi
  if [ -n "$five_pct" ] && [ -n "$week_pct" ]; then
    out="${out}  "
  fi
  if [ -n "$week_pct" ]; then
    week_int=$(printf '%.0f' "$week_pct")
    wcolor=$(usage_color "$week_int")
    wbar=$(mini_bar "$week_int")
    out="${out}${dim}7d${reset} ${wcolor}${wbar}${reset} ${dim}${week_int}%${reset}"
  fi
fi

# 3. Context window bar
if [ -n "$ctx_used" ]; then
  ctx_int=$(printf '%.0f' "$ctx_used")
  cbar=$(mini_bar "$ctx_int")
  out="${out}  ${sep}  ${dim}ctx${reset} ${color_cyan}${cbar}${reset} ${dim}${ctx_int}%${reset}"
fi

# 4. Session spend
if [ -n "$spend" ]; then
  out="${out}  ${sep}  ${color_magenta}\$${spend}${reset}"
fi

# 5. Token counters (last API call's context, not cumulative session totals)
if [ "$total_in" -gt 0 ] || [ "$total_out" -gt 0 ]; then
  out="${out}  ${sep}  ${dim}ctx-in${reset} ${color_blue}${tok_in}${reset}  ${dim}ctx-out${reset} ${color_blue}${tok_out}${reset}"
fi

printf '%b' "$out"
