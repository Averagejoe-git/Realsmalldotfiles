#!/usr/bin/env bash
# =============================================================================
# Dotfiles Bootstrap Installer
# Usage on a fresh machine:
#   bash <(curl -s https://raw.githubusercontent.com/YOUR_USERNAME/dotfiles/main/install.sh)
#
# Dry run (preview only, no changes):
#   bash install.sh --dry-run
# =============================================================================

set -e

REPO="https://github.com/YOUR_USERNAME/dotfiles.git"
DOTFILES_DIR="$HOME/dotfiles"
DRY_RUN=false

[[ "$1" == "--dry-run" ]] && DRY_RUN=true

# ── Colors ────────────────────────────────────────────────────────────────────
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
RED='\033[0;31m'
RESET='\033[0m'

info()    { echo -e "${BLUE}[info]${RESET}   $*"; }
success() { echo -e "${GREEN}[ok]${RESET}     $*"; }
warn()    { echo -e "${YELLOW}[warn]${RESET}   $*"; }
dryrun()  { echo -e "${CYAN}[dry-run]${RESET} would link: $*"; }
error()   { echo -e "${RED}[error]${RESET}  $*"; exit 1; }

$DRY_RUN && warn "DRY RUN MODE — no files will be changed."
echo ""

# ── 1. Install packages ───────────────────────────────────────────────────────
PACKAGES=(
  nwg-look
  thunar
  hyprlock
  hyprshot
  swaync
)

if ! $DRY_RUN; then
  # Install yay if not already present
  if ! command -v yay &>/dev/null; then
    info "Installing yay (AUR helper)..."
    sudo pacman -S --needed git base-devel
    git clone https://aur.archlinux.org/yay.git /tmp/yay
    (cd /tmp/yay && makepkg -si --noconfirm)
    rm -rf /tmp/yay
    success "yay installed."
  else
    success "yay already installed — skipping."
  fi

  info "Installing packages..."
  sudo pacman -S --needed "${PACKAGES[@]}"
else
  info "Would install yay (if not present)"
  info "Would install packages: ${PACKAGES[*]}"
fi

echo ""

# ── 2. Clone or update the repo ──────────────────────────────────────────────
if ! $DRY_RUN; then
  if [[ -d "$DOTFILES_DIR/.git" ]]; then
    info "Dotfiles repo already exists — pulling latest..."
    git -C "$DOTFILES_DIR" pull --ff-only
  else
    info "Cloning dotfiles repo to $DOTFILES_DIR ..."
    git clone "$REPO" "$DOTFILES_DIR"
  fi
fi

# ── 3. Helper: create a symlink ───────────────────────────────────────────────
link() {
  local src="$1"
  local dest="$2"
  if $DRY_RUN; then
    dryrun "$dest  →  $src"
  else
    mkdir -p "$(dirname "$dest")"
    ln -sf "$src" "$dest"
    success "Linked  $dest  →  $src"
  fi
}

# ── 4. Walk every topic folder ────────────────────────────────────────────────
for topic_dir in "$DOTFILES_DIR"/*/; do
  # Skip .git
  [[ "$(basename "$topic_dir")" == ".git" ]] && continue

  topic=$(basename "$topic_dir")
  info "Processing topic: $topic"

  # .config/** → ~/.config/
  if [[ -d "$topic_dir/.config" ]]; then
    while IFS= read -r -d '' src; do
      rel="${src#"$topic_dir/"}"
      link "$src" "$HOME/$rel"
    done < <(find "$topic_dir/.config" -type f -print0)
  fi

  # .local/** → ~/.local/
  if [[ -d "$topic_dir/.local" ]]; then
    while IFS= read -r -d '' src; do
      rel="${src#"$topic_dir/"}"
      link "$src" "$HOME/$rel"
      # Make scripts executable
      [[ "$src" == *.sh ]] && { $DRY_RUN || chmod +x "$src"; }
    done < <(find "$topic_dir/.local" -type f -print0)
  fi

  # .themes/** → ~/.themes/
  if [[ -d "$topic_dir/.themes" ]]; then
    while IFS= read -r -d '' src; do
      rel="${src#"$topic_dir/"}"
      link "$src" "$HOME/$rel"
    done < <(find "$topic_dir/.themes" -type f -print0)
  fi

  # bare *.theme files → ~/.themes/
  while IFS= read -r -d '' src; do
    filename=$(basename "$src")
    $DRY_RUN || mkdir -p "$HOME/.themes"
    link "$src" "$HOME/.themes/$filename"
  done < <(find "$topic_dir" -maxdepth 1 -name "*.theme" -print0)

  # top-level dotfiles (.<file>) → ~/
  while IFS= read -r -d '' src; do
    filename=$(basename "$src")
    link "$src" "$HOME/$filename"
  done < <(find "$topic_dir" -maxdepth 1 -name ".*" -not -name ".git" -type f -print0)

done

echo ""
if $DRY_RUN; then
  warn "Dry run complete — nothing was changed. Run without --dry-run to apply."
else
  success "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  success " Dotfiles installed successfully! 🎉  "
  success "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo ""
  warn "Restart your shell or log out/in for all changes to take effect."
fi
