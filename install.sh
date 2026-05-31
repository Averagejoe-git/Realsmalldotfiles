#!/usr/bin/env bash
# =============================================================================
# Dotfiles Bootstrap Installer
# Usage on a fresh machine:
#   bash <(curl -s https://raw.githubusercontent.com/YOUR_USERNAME/dotfiles/main/install.sh)
# =============================================================================

set -e

REPO="https://github.com/YOUR_USERNAME/dotfiles.git"
DOTFILES_DIR="$HOME/dotfiles"

# ── Colors ────────────────────────────────────────────────────────────────────
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
RESET='\033[0m'

info()    { echo -e "${BLUE}[info]${RESET}  $*"; }
success() { echo -e "${GREEN}[ok]${RESET}    $*"; }
warn()    { echo -e "${YELLOW}[warn]${RESET}  $*"; }
error()   { echo -e "${RED}[error]${RESET} $*"; exit 1; }

# ── 1. Clone or update the repo ───────────────────────────────────────────────
if [[ -d "$DOTFILES_DIR/.git" ]]; then
  info "Dotfiles repo already exists — pulling latest changes..."
  git -C "$DOTFILES_DIR" pull --ff-only
else
  info "Cloning dotfiles repo to $DOTFILES_DIR ..."
  git clone "$REPO" "$DOTFILES_DIR"
fi

# ── 2. Helper: create a symlink (overwrites silently) ─────────────────────────
link() {
  local src="$1"
  local dest="$2"
  mkdir -p "$(dirname "$dest")"
  ln -sf "$src" "$dest"
  success "Linked  $dest  →  $src"
}

# ── 3. Walk every topic folder ────────────────────────────────────────────────
#
# Expected layout:
#   ~/dotfiles/<topic>/.config/<app>/...     → ~/.config/<app>/...
#   ~/dotfiles/<topic>/.local/...            → ~/.local/...
#   ~/dotfiles/<topic>/.themes/...           → ~/.themes/...
#   ~/dotfiles/<topic>/.<file>               → ~/.<file>          (top-level dotfiles)
#   ~/dotfiles/<topic>/*.theme               → ~/.themes/<file>   (GTK theme files)
#
for topic_dir in "$DOTFILES_DIR"/*/; do
  topic=$(basename "$topic_dir")
  info "Processing topic: $topic"

  # ── .config/** ─────────────────────────────────────────────────────────────
  if [[ -d "$topic_dir/.config" ]]; then
    while IFS= read -r -d '' src; do
      rel="${src#"$topic_dir/"}"          # e.g. .config/nvim/init.lua
      dest="$HOME/$rel"
      link "$src" "$dest"
    done < <(find "$topic_dir/.config" -type f -print0)
  fi

  # ── .local/** ──────────────────────────────────────────────────────────────
  if [[ -d "$topic_dir/.local" ]]; then
    while IFS= read -r -d '' src; do
      rel="${src#"$topic_dir/"}"
      dest="$HOME/$rel"
      link "$src" "$dest"
    done < <(find "$topic_dir/.local" -type f -print0)
  fi

  # ── .themes/** (already in a .themes subdir) ───────────────────────────────
  if [[ -d "$topic_dir/.themes" ]]; then
    while IFS= read -r -d '' src; do
      rel="${src#"$topic_dir/"}"
      dest="$HOME/$rel"
      link "$src" "$dest"
    done < <(find "$topic_dir/.themes" -type f -print0)
  fi

  # ── Bare *.theme files → ~/.themes/<filename> ──────────────────────────────
  while IFS= read -r -d '' src; do
    filename=$(basename "$src")
    dest="$HOME/.themes/$filename"
    mkdir -p "$HOME/.themes"
    link "$src" "$dest"
  done < <(find "$topic_dir" -maxdepth 1 -name "*.theme" -print0)

  # ── Top-level dotfiles (.<name> files directly in topic dir) ───────────────
  while IFS= read -r -d '' src; do
    filename=$(basename "$src")
    dest="$HOME/$filename"
    link "$src" "$dest"
  done < <(find "$topic_dir" -maxdepth 1 -name ".*" -not -name ".git" -type f -print0)

done

echo ""
success "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
success " Dotfiles installed successfully! 🎉 "
success "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
warn "You may need to restart your shell or log out/in for all changes to take effect."
