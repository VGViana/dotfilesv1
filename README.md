# Viana Dotfiles

Personal CachyOS + Wayland/Hyprland/DMS configuration managed with Git + GNU Stow.

## Philosophy

The files in this repository are the real configuration files. GNU Stow exposes them in `$HOME` through symlinks; there is no second copy to keep synchronized.

Edit normally:

    nvim ~/.config/hypr/hyprland.lua

The edit is immediately an edit inside this repository.

Then run:

    dots

`dots` stages changes, creates a commit, and pushes to GitHub.

## Restore on a new machine

1. Install Git and GNU Stow.
2. Clone this repository to `~/dotfiles`.
3. Run `./bootstrap.sh`.

## Important

Secrets, browser state, application databases, caches, and machine-specific runtime state are intentionally excluded.
