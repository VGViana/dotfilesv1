#!/usr/bin/env bash
set -euo pipefail

DOTS_DIR="${DOTS_DIR:-$HOME/dotfiles}"
cd "$DOTS_DIR"

command -v gh >/dev/null 2>&1 || { echo 'gh is required.' >&2; exit 1; }

gh auth status >/dev/null 2>&1 || {
  echo 'GitHub CLI is not authenticated.' >&2
  echo 'Run: gh auth login'
  exit 1
}

if git remote get-url origin >/dev/null 2>&1; then
  echo "origin already exists: $(git remote get-url origin)"
else
  gh repo create --private --source="$DOTS_DIR" --remote=origin --push
fi
