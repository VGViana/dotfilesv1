#!/usr/bin/env bash
set -euo pipefail

DOTS_DIR="${DOTS_DIR:-$HOME/dotfiles}"
cd "$DOTS_DIR"

if ! command -v stow >/dev/null 2>&1; then
  echo "GNU Stow is required. Install it first (e.g. sudo pacman -S stow)." >&2
  exit 1
fi

# Back up only exact files/symlinks that would conflict with Stow.
backup="$HOME/.dotfiles-backup-$(date +%Y%m%d-%H%M%S)"
conflicts=()

while IFS= read -r src; do
  rel="${src#dot-}"
  target="$HOME/$rel"
  if [[ -e "$target" && ! -L "$target" ]]; then
    conflicts+=("$target")
  elif [[ -L "$target" && "$(readlink "$target")" != "$DOTS_DIR/$src" ]]; then
    conflicts+=("$target")
  fi
done < <(find dot-* -type f -o -type l | sort)

if ((${#conflicts[@]})); then
  mkdir -p "$backup"
  echo "Backing up conflicting files to: $backup"
  for target in "${conflicts[@]}"; do
    rel="${target#"$HOME/"}"
    mkdir -p "$backup/$(dirname "$rel")"
    mv "$target" "$backup/$rel"
  done
fi

stow --dotfiles --restow .

mkdir -p "$HOME/.local/bin"

cat <<MSG

✓ Dotfiles linked with GNU Stow.
✓ Edit configuration normally through ~/.config, ~/.zshrc, etc.
✓ Run: dots

If a backup was created:
  $backup
MSG
