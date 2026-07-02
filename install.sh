#!/bin/bash
set -e
DOTFILES="$(cd "$(dirname "$0")" && pwd)"

if ! git -C "$DOTFILES" diff --quiet || ! git -C "$DOTFILES" diff --cached --quiet; then
  echo "dotfiles-common has uncommitted changes. Aborting."
  exit 1
fi

stow_pkg() {
  echo "Stowing $1..."
  stow -v --adopt -d "$DOTFILES" -t "$HOME" "$1"
  git -C "$DOTFILES" checkout -- .
}

# Default: stow everything. On an Omarchy machine, call with an explicit
# subset instead, e.g.: ./install.sh bash starship wallpapers
# (Omarchy manages its own nvim/tmux/smug, so skip those there.)
PKGS=("$@")
if [ ${#PKGS[@]} -eq 0 ]; then
  PKGS=(bash nvim tmux smug starship wallpapers)
fi

for pkg in "${PKGS[@]}"; do
  stow_pkg "$pkg"
done

echo "Done."
