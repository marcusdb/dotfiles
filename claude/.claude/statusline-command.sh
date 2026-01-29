#!/bin/bash

################################################################################
# Claude Code Status Line Script
# Location: ~/.claude/statusline-command.sh
#
# This script generates a custom status line for Claude Code with:
# - Kubernetes context and namespace
# - Current working directory
# - AI model name
# - Git branch and status (with color coding)
# - Current time
# - Context window usage percentage
#
# The script receives JSON input via stdin with session information.
################################################################################

set -euo pipefail

# Read JSON input from stdin
input=$(cat)

# Extract current directory from JSON
current_dir=$(echo "$input" | jq -r '.workspace.current_dir // .cwd // "~"' 2>/dev/null)

# Build status line parts array
parts=()

################################################################################
# Kubernetes Context
################################################################################
k8s_context=$(kubectl config current-context 2>/dev/null || echo "")
if [[ -n "$k8s_context" ]]; then
  k8s_ns=$(kubectl config view --minify --output 'jsonpath={..namespace}' 2>/dev/null || echo "")
  if [[ -n "$k8s_ns" ]]; then
    parts+=("$(printf '\033[2m\033[33m%s :: %s\033[0m' "$k8s_context" "$k8s_ns")")
  else
    parts+=("$(printf '\033[2m\033[33m%s\033[0m' "$k8s_context")")
  fi
fi

################################################################################
# Current Directory
################################################################################
if [[ -n "$current_dir" && "$current_dir" != "null" ]]; then
  # Simplify path - replace home with ~
  display_path="${current_dir/#$HOME/~}"
  parts+=("$(printf '\033[2m\033[38;5;208m%s\033[0m' "$display_path")")
fi

################################################################################
# AI Model Name
################################################################################
model_name=$(echo "$input" | jq -r '.model.display_name // .model.id // ""' 2>/dev/null)
if [[ -n "$model_name" && "$model_name" != "null" && "$model_name" != "" ]]; then
  parts+=("$(printf '\033[2m\033[36m%s\033[0m' "$model_name")")
fi

################################################################################
# Git Branch and Status
################################################################################
if git rev-parse --git-dir >/dev/null 2>&1; then
  branch=$(git branch --show-current 2>/dev/null || git rev-parse --short HEAD 2>/dev/null || "")

  if [[ -n "$branch" ]]; then
    # Default: green for clean repository
    git_color="\033[32m"
    git_status=""

    # Check working tree and staging area (skip git locks)
    if ! git diff --quiet 2>/dev/null || ! git diff --cached --quiet 2>/dev/null; then
      git_color="\033[33m"  # yellow for uncommitted changes

      # Count changed files
      working_changed=$(git diff --shortstat 2>/dev/null | grep -oE '[0-9]+ file' | grep -oE '[0-9]+' || echo "0")
      staged_changed=$(git diff --cached --shortstat 2>/dev/null | grep -oE '[0-9]+ file' | grep -oE '[0-9]+' || echo "0")

      if [[ "$working_changed" != "0" ]]; then
        git_status+=" ~${working_changed}"
      fi
      if [[ "$staged_changed" != "0" ]]; then
        git_status+=" +${staged_changed}"
      fi
    fi

    # Check ahead/behind remote
    upstream=$(git rev-parse --abbrev-ref @{upstream} 2>/dev/null || echo "")
    if [[ -n "$upstream" ]]; then
      ahead=$(git rev-list --count @{upstream}..HEAD 2>/dev/null || echo "0")
      behind=$(git rev-list --count HEAD..@{upstream} 2>/dev/null || echo "0")

      if [[ "$ahead" != "0" && "$behind" != "0" ]]; then
        git_color="\033[31m"  # red for diverged
        git_status+=" ↑${ahead}↓${behind}"
      elif [[ "$ahead" != "0" ]]; then
        git_status+=" ↑${ahead}"
      elif [[ "$behind" != "0" ]]; then
        git_status+=" ↓${behind}"
      fi
    fi

    parts+=("$(printf '\033[2m%b%s%s\033[0m' "$git_color" "$branch" "$git_status")")
  fi
fi

################################################################################
# Context Window Usage (if available)
################################################################################
remaining=$(echo "$input" | jq -r '.context_window.remaining_percentage // empty' 2>/dev/null || echo "")
if [[ -n "$remaining" ]]; then
  # Color code based on remaining percentage
  if (( $(echo "$remaining < 20" | bc -l 2>/dev/null || echo 0) )); then
    ctx_color="\033[31m"  # red if < 20% remaining
  elif (( $(echo "$remaining < 50" | bc -l 2>/dev/null || echo 0) )); then
    ctx_color="\033[33m"  # yellow if < 50% remaining
  else
    ctx_color="\033[32m"  # green if >= 50% remaining
  fi
  parts+=("$(printf '\033[2m%bctx: %.0f%%\033[0m' "$ctx_color" "$remaining")")
fi

################################################################################
# Current Time
################################################################################
current_time=$(date +%H:%M:%S)
parts+=("$(printf '\033[2m\033[34m%s\033[0m' "$current_time")")

################################################################################
# Assemble Final Output
################################################################################
output=""
for i in "${!parts[@]}"; do
  if [[ $i -eq 0 ]]; then
    output="${parts[$i]}"
  else
    output+="$(printf '\033[2m | \033[0m')${parts[$i]}"
  fi
done

# Add dark gray background with padding
echo "$(printf '\033[48;5;236m \033[0m\033[48;5;236m%b \033[0m' "$output")"