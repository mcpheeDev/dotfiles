#!/bin/bash
# =============================================================================
# push-dotfiles.sh
# Syncs all configs to ~/dotfiles and pushes to GitHub
# Run this any time you make changes to your config
# =============================================================================

set -e

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

info()    { echo -e "${BLUE}[INFO]${NC} $1"; }
success() { echo -e "${GREEN}[OK]${NC} $1"; }
warn()    { echo -e "${YELLOW}[WARN]${NC} $1"; }

DOTFILES="$HOME/dotfiles"

# =============================================================================
# CHECK REPO EXISTS
# =============================================================================

if [ ! -d "$DOTFILES/.git" ]; then
    echo -e "${YELLOW}dotfiles repo not found at $DOTFILES${NC}"
    read -p "GitHub username: " GH_USER
    git clone "git@github.com:$GH_USER/dotfiles.git" "$DOTFILES" || \
    git clone "https://github.com/$GH_USER/dotfiles.git" "$DOTFILES"
fi

# =============================================================================
# SYNC CONFIGS
# =============================================================================

info "Syncing configs..."

mkdir -p "$DOTFILES/config/"{hypr,waybar,ghostty,rofi,dunst,nvim,starship,zsh}
mkdir -p "$DOTFILES/scripts"

# Hyprland
cp ~/.config/hypr/hyprland.conf "$DOTFILES/config/hypr/" 2>/dev/null && success "hyprland.conf" || warn "hyprland.conf not found"
cp ~/.config/hypr/hyprlock.conf "$DOTFILES/config/hypr/" 2>/dev/null && success "hyprlock.conf" || warn "hyprlock.conf not found"
cp ~/.config/hypr/hypridle.conf "$DOTFILES/config/hypr/" 2>/dev/null && success "hypridle.conf" || warn "hypridle.conf not found"

# Waybar
cp ~/.config/waybar/config.jsonc "$DOTFILES/config/waybar/" 2>/dev/null && success "waybar config" || warn "waybar config not found"
cp ~/.config/waybar/style.css "$DOTFILES/config/waybar/" 2>/dev/null && success "waybar style" || warn "waybar style not found"

# Ghostty
cp ~/.config/ghostty/config "$DOTFILES/config/ghostty/" 2>/dev/null && success "ghostty config" || warn "ghostty config not found"

# Rofi
cp ~/.config/rofi/config.rasi "$DOTFILES/config/rofi/" 2>/dev/null && success "rofi config" || warn "rofi config not found"

# Dunst
cp ~/.config/dunst/dunstrc "$DOTFILES/config/dunst/" 2>/dev/null && success "dunstrc" || warn "dunstrc not found"

# Neovim
cp -r ~/.config/nvim/lua "$DOTFILES/config/nvim/" 2>/dev/null && success "nvim config" || warn "nvim config not found"

# Starship
cp ~/.config/starship.toml "$DOTFILES/config/starship/" 2>/dev/null && success "starship.toml" || warn "starship.toml not found"

# Zsh
cp ~/.zshrc "$DOTFILES/config/zsh/zshrc" 2>/dev/null && success "zshrc" || warn "zshrc not found"

# Wallpaper picker
cp ~/.local/bin/wallpaper-picker "$DOTFILES/scripts/" 2>/dev/null && success "wallpaper-picker" || warn "wallpaper-picker not found"

# =============================================================================
# COPY SETUP SCRIPT + README IF PRESENT
# =============================================================================

# Copy setup.sh if it's in Downloads
if [ -f "$HOME/Downloads/setup.sh" ]; then
    cp "$HOME/Downloads/setup.sh" "$DOTFILES/"
    success "setup.sh"
fi

if [ -f "$HOME/Downloads/setup(1).sh" ]; then
    cp "$HOME/Downloads/setup(1).sh" "$DOTFILES/setup.sh"
    success "setup.sh (from setup(1).sh)"
fi

# =============================================================================
# WRITE GITIGNORE
# =============================================================================

cat > "$DOTFILES/.gitignore" << 'EOF'
*.jpg
*.jpeg
*.png
*.gif
*.webp
*.bmp
Pictures/
.ssh/
*.log
.DS_Store
EOF

# =============================================================================
# GIT PUSH
# =============================================================================

cd "$DOTFILES"

info "Staging changes..."
git add .

# Check if there's anything to commit
if git diff --staged --quiet; then
    warn "Nothing changed — already up to date"
    exit 0
fi

read -p "Commit message [default: 'update dotfiles']: " MSG
MSG=${MSG:-"update dotfiles"}

git commit -m "$MSG"

info "Pushing to GitHub..."
git push

echo ""
echo -e "${GREEN}============================================${NC}"
echo -e "${GREEN}  Pushed to GitHub successfully!${NC}"
echo -e "${GREEN}============================================${NC}"
echo ""
echo -e "${BLUE}View at:${NC} https://github.com/$(git remote get-url origin | sed 's/.*github.com[:/]\(.*\)\.git/\1/' | sed 's/.*github.com[:/]\(.*\)/\1/')"
