#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="${DOTFILES_DIR:-$HOME/dotfiles}"

cd "$DOTFILES_DIR"

if ! command -v gh >/dev/null 2>&1; then
    echo "GitHub CLI não está instalado." >&2
    exit 1
fi

if ! gh auth status >/dev/null 2>&1; then
    echo "GitHub CLI não está autenticado."
    echo
    echo "Execute:"
    echo "  gh auth login"
    exit 1
fi

if git remote get-url origin >/dev/null 2>&1; then
    echo "origin: $(git remote get-url origin)"
else
    git remote add origin git@github.com:VGViana/dotfilesv1.git
    echo "origin configurado."
fi

echo
echo "GitHub configurado."
