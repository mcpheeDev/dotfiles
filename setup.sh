#!/bin/bash
# =============================================================================
# Arch Linux — Tokyo Night Developer Setup
# Hyprland + Waybar (thin) + Ghostty + Neovim + VSCodium
# Run after archinstall with base Hyprland + LY
# =============================================================================

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

info()    { echo -e "${BLUE}[INFO]${NC} $1"; }
success() { echo -e "${GREEN}[OK]${NC} $1"; }
warn()    { echo -e "${YELLOW}[WARN]${NC} $1"; }

echo ""
echo -e "${BLUE}============================================${NC}"
echo -e "${BLUE}  Tokyo Night Hyprland Setup${NC}"
echo -e "${BLUE}============================================${NC}"
echo ""

read -p "Git name: " GIT_NAME
read -p "Git email: " GIT_EMAIL
echo ""
read -p "Press Enter to start..."

# =============================================================================
# YAY
# =============================================================================

info "Installing yay..."
if ! command -v yay &>/dev/null; then
    sudo pacman -S --needed --noconfirm base-devel git
    git clone https://aur.archlinux.org/yay.git /tmp/yay-build
    cd /tmp/yay-build && makepkg -si --noconfirm && cd ~ && rm -rf /tmp/yay-build
fi
success "yay ready"

# =============================================================================
# PACKAGES
# =============================================================================

info "Installing packages — this takes a while..."

yay -S --needed --noconfirm \
    hyprland hyprpaper hyprlock hypridle \
    waybar \
    dunst \
    swww \
    ghostty \
    thunar thunar-volman gvfs \
    neovim lazygit \
    vscodium-bin \
    zen-browser-bin \
    rofi-wayland \
    zsh starship \
    networkmanager nm-connection-editor network-manager-applet \
    bluez bluez-utils blueman \
    pipewire pipewire-pulse pipewire-alsa wireplumber pavucontrol \
    ttf-jetbrains-mono-nerd noto-fonts noto-fonts-emoji \
    git docker docker-compose python python-pip jdk-openjdk \
    ripgrep fd fzf curl wget unzip bat \
    grim slurp wl-clipboard \
    brightnessctl playerctl \
    xdg-desktop-portal-hyprland xdg-desktop-portal-gtk \
    polkit-gnome \
    qt5-wayland qt6-wayland \
    papirus-icon-theme \
    oh-my-zsh-git

success "Packages installed"

# =============================================================================
# SERVICES
# =============================================================================

info "Enabling services..."
sudo systemctl enable --now NetworkManager
sudo systemctl enable --now bluetooth
sudo systemctl enable --now docker
sudo usermod -aG docker "$USER"
sudo systemctl enable ly
chsh -s /bin/zsh
success "Services enabled"

# =============================================================================
# DIRECTORIES
# =============================================================================

info "Creating directories..."
mkdir -p ~/.config/{hypr,waybar,dunst,ghostty,rofi,nvim/lua/{config,plugins}}
mkdir -p ~/Pictures/wallpapers
mkdir -p ~/.local/bin
success "Directories created"

# =============================================================================
# HYPRLAND CONFIG
# =============================================================================

info "Writing Hyprland config..."

cat > ~/.config/hypr/hyprland.conf << 'EOF'
# =============================================================================
# Hyprland — Tokyo Night
# =============================================================================

monitor = eDP-1, 1920x1080@60, 0x0, 1

# Autostart
exec-once = /usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1
exec-once = swww-daemon
exec-once = swww clear #1a1b26
exec-once = waybar
exec-once = dunst
exec-once = nm-applet --indicator
exec-once = blueman-applet
exec-once = hypridle

# Environment
env = XCURSOR_SIZE, 24
env = XCURSOR_THEME, Adwaita
env = QT_QPA_PLATFORM, wayland
env = QT_WAYLAND_DISABLE_WINDOWDECORATION, 1
env = GDK_BACKEND, wayland
env = XDG_CURRENT_DESKTOP, Hyprland
env = XDG_SESSION_TYPE, wayland
env = MOZ_ENABLE_WAYLAND, 1
env = JAVA_HOME, /usr/lib/jvm/default

# Input
input {
    kb_layout = gb
    follow_mouse = 1
    sensitivity = 0
    accel_profile = flat
    touchpad {
        natural_scroll = true
        tap-to-click = true
        drag_lock = true
        disable_while_typing = true
    }
}

# General — Tokyo Night borders
general {
    gaps_in = 4
    gaps_out = 8
    border_size = 2
    col.active_border = rgba(7aa2f7ff) rgba(bb9af7ff) 45deg
    col.inactive_border = rgba(24283baa)
    layout = dwindle
    resize_on_border = true
}

# Decoration
decoration {
    rounding = 8
    blur {
        enabled = true
        size = 3
        passes = 2
        new_optimizations = true
    }
    drop_shadow = false
    dim_inactive = true
    dim_strength = 0.05
}

# Animations
animations {
    enabled = true
    bezier = smooth, 0.05, 0.9, 0.1, 1.0
    animation = windows, 1, 4, smooth, slide
    animation = windowsOut, 1, 3, smooth, slide
    animation = border, 1, 6, default
    animation = fade, 1, 4, smooth
    animation = workspaces, 1, 4, smooth, slidevert
}

# Layout
dwindle {
    preserve_split = true
    smart_split = true
}

# Misc
misc {
    disable_hyprland_logo = true
    disable_splash_rendering = true
    mouse_move_enables_dpms = true
    key_press_enables_dpms = true
    enable_swallow = true
    swallow_regex = ^(ghostty)$
}



# =============================================================================
# Keybindings
# =============================================================================

$mod = SUPER

# Apps
bind = $mod, Q,      killactive
bind = $mod, Return, exec, ghostty
bind = $mod, F,      exec, thunar
bind = $mod, W,      exec, zen-browser
bind = $mod, N,      exec, ghostty --class=nvim -e nvim
bind = $mod, V,      exec, codium
bind = $mod, E,      togglefloating

# App launcher on Super key alone
bindr = SUPER, Super_L, exec, rofi -show drun

# Wallpaper picker
bind = $mod SHIFT, W, exec, ~/.local/bin/wallpaper-picker

# Window focus
bind = $mod, left,  movefocus, l
bind = $mod, right, movefocus, r
bind = $mod, up,    movefocus, u
bind = $mod, down,  movefocus, d

# Move windows
bind = $mod SHIFT, left,  movewindow, l
bind = $mod SHIFT, right, movewindow, r
bind = $mod SHIFT, up,    movewindow, u
bind = $mod SHIFT, down,  movewindow, d

# Resize
binde = $mod CTRL, right, resizeactive,  30 0
binde = $mod CTRL, left,  resizeactive, -30 0
binde = $mod CTRL, up,    resizeactive,  0 -30
binde = $mod CTRL, down,  resizeactive,  0  30

# Workspaces 1-5
bind = $mod,       1, workspace, 1
bind = $mod,       2, workspace, 2
bind = $mod,       3, workspace, 3
bind = $mod,       4, workspace, 4
bind = $mod,       5, workspace, 5
bind = $mod SHIFT, 1, movetoworkspace, 1
bind = $mod SHIFT, 2, movetoworkspace, 2
bind = $mod SHIFT, 3, movetoworkspace, 3
bind = $mod SHIFT, 4, movetoworkspace, 4
bind = $mod SHIFT, 5, movetoworkspace, 5

# Extras
bind = $mod, L,   exec, hyprlock
bind = $mod, F11, fullscreen
bind = , Print,   exec, grim -g "$(slurp)" - | wl-copy
bind = $mod, P,   exec, grim -g "$(slurp)" ~/Pictures/screenshot-$(date +%Y%m%d-%H%M%S).png

# Volume
bind = , XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+
bind = , XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-
bind = , XF86AudioMute,        exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle

# Brightness
bind = , XF86MonBrightnessUp,   exec, brightnessctl set 5%+
bind = , XF86MonBrightnessDown, exec, brightnessctl set 5%-

# Mouse
bindm = $mod, mouse:272, movewindow
bindm = $mod, mouse:273, resizewindow
EOF

success "Hyprland config written"

# =============================================================================
# HYPRIDLE
# =============================================================================

cat > ~/.config/hypr/hypridle.conf << 'EOF'
general {
    lock_cmd = pidof hyprlock || hyprlock
    before_sleep_cmd = loginctl lock-session
    after_sleep_cmd = hyprctl dispatch dpms on
}

listener {
    timeout = 300
    on-timeout = brightnessctl -s set 10
    on-resume = brightnessctl -r
}

listener {
    timeout = 600
    on-timeout = loginctl lock-session
}

listener {
    timeout = 900
    on-timeout = hyprctl dispatch dpms off
    on-resume = hyprctl dispatch dpms on
}
EOF

# =============================================================================
# HYPRLOCK — Tokyo Night
# =============================================================================

cat > ~/.config/hypr/hyprlock.conf << 'EOF'
background {
    monitor =
    color = rgba(1a1b26ff)
    blur_passes = 0
}

input-field {
    monitor =
    size = 300, 48
    outline_thickness = 2
    outer_color = rgb(7aa2f7)
    inner_color = rgb(24283b)
    font_color = rgb(c0caf5)
    fade_on_empty = true
    placeholder_text = Password
    position = 0, -80
    halign = center
    valign = center
    rounding = 8
}

label {
    monitor =
    text = cmd[update:1000] echo "$(date +'%H:%M')"
    color = rgba(c0caf5ff)
    font_size = 72
    font_family = JetBrains Mono Nerd Font
    position = 0, 80
    halign = center
    valign = center
}

label {
    monitor =
    text = cmd[update:60000] echo "$(date +'%A, %d %B')"
    color = rgba(565f89ff)
    font_size = 18
    font_family = JetBrains Mono Nerd Font
    position = 0, 0
    halign = center
    valign = center
}
EOF

success "Hypr lock/idle written"

# =============================================================================
# WAYBAR — Thin (24px), Tokyo Night, Workspaces 1-5
# =============================================================================

info "Writing Waybar config..."

cat > ~/.config/waybar/config.jsonc << 'EOF'
{
    "layer": "top",
    "position": "top",
    "height": 24,
    "spacing": 0,
    "modules-left": ["hyprland/workspaces"],
    "modules-center": ["clock"],
    "modules-right": ["pulseaudio", "network", "bluetooth", "battery"],

    "hyprland/workspaces": {
        "format": "{id}",
        "on-click": "activate",
        "sort-by-number": true,
        "persistent-workspaces": {
            "1": [],
            "2": [],
            "3": [],
            "4": [],
            "5": []
        }
    },

    "clock": {
        "format": "{:%H:%M  %a %d/%m}",
        "tooltip-format": "<big>{:%B %Y}</big>\n<tt><small>{calendar}</small></tt>"
    },

    "battery": {
        "format": "{icon} {capacity}%",
        "format-charging": "󰂄 {capacity}%",
        "format-icons": ["󰁺", "󰁻", "󰁼", "󰁽", "󰁾", "󰁿", "󰂀", "󰂁", "󰂂", "󰁹"],
        "states": { "warning": 30, "critical": 15 },
        "tooltip": false
    },

    "network": {
        "format-wifi": "󰤨 {essid}",
        "format-ethernet": "󰈀 {ipaddr}",
        "format-disconnected": "󰤭",
        "on-click": "nm-connection-editor",
        "max-length": 16,
        "tooltip": false
    },

    "bluetooth": {
        "format": "󰂲",
        "format-connected": "󰂱",
        "on-click": "blueman-manager",
        "tooltip": false
    },

    "pulseaudio": {
        "format": "{icon} {volume}%",
        "format-muted": "󰝟",
        "format-icons": { "default": ["󰕿", "󰖀", "󰕾"] },
        "on-click": "pavucontrol",
        "tooltip": false
    }
}
EOF

cat > ~/.config/waybar/style.css << 'EOF'
/* Thin Tokyo Night Waybar */

* {
    font-family: "JetBrains Mono Nerd Font";
    font-size: 11px;
    border: none;
    border-radius: 0;
    min-height: 0;
    margin: 0;
    padding: 0;
}

window#waybar {
    background: rgba(26, 27, 38, 0.90);
    color: #c0caf5;
    border-bottom: 1px solid #1e2030;
}

/* Workspaces */
#workspaces {
    margin: 0 6px;
}

#workspaces button {
    padding: 0 8px;
    color: #3b4261;
    background: transparent;
    border-radius: 3px;
    margin: 3px 1px;
    transition: all 0.12s ease;
    min-width: 18px;
}

#workspaces button.active {
    color: #7aa2f7;
    background: #1e2030;
}

#workspaces button.occupied {
    color: #a9b1d6;
}

#workspaces button:hover {
    background: #1e2030;
    color: #c0caf5;
}

/* Clock */
#clock {
    color: #7aa2f7;
    font-weight: bold;
}

/* Right modules */
#battery,
#network,
#bluetooth,
#pulseaudio {
    margin: 0 8px 0 0;
    padding: 0 2px;
}

#battery          { color: #9ece6a; }
#battery.warning  { color: #e0af68; }
#battery.critical { color: #f7768e; }
#network          { color: #7dcfff; }
#bluetooth        { color: #bb9af7; }
#pulseaudio       { color: #e0af68; }
EOF

success "Waybar written"

# =============================================================================
# DUNST — Tokyo Night
# =============================================================================

info "Writing dunst config..."

cat > ~/.config/dunst/dunstrc << 'EOF'
[global]
    monitor = 0
    follow = mouse
    width = 320
    height = 120
    origin = top-right
    offset = 10x10
    notification_limit = 4
    progress_bar = true
    transparency = 8
    padding = 10
    horizontal_padding = 12
    frame_width = 2
    separator_height = 1
    separator_color = frame
    font = JetBrains Mono Nerd Font 11
    markup = full
    format = "<b>%s</b>\n%b"
    alignment = left
    corner_radius = 8
    icon_position = left
    min_icon_size = 28
    max_icon_size = 40
    mouse_left_click = close_current
    mouse_right_click = close_all

[urgency_low]
    background = "#1a1b26"
    foreground = "#c0caf5"
    frame_color = "#24283b"
    timeout = 4

[urgency_normal]
    background = "#1a1b26"
    foreground = "#c0caf5"
    frame_color = "#7aa2f7"
    timeout = 6

[urgency_critical]
    background = "#1a1b26"
    foreground = "#f7768e"
    frame_color = "#f7768e"
    timeout = 0
EOF

success "Dunst written"

# =============================================================================
# GHOSTTY — Tokyo Night + transparency
# =============================================================================

info "Writing Ghostty config..."

cat > ~/.config/ghostty/config << 'EOF'
font-family = JetBrains Mono Nerd Font
font-size = 13
background-opacity = 0.85
window-decoration = false
cursor-style = block
cursor-style-blink = false
shell-integration = zsh
shell-integration-features = cursor,sudo,title
scrollback-limit = 10000
copy-on-select = clipboard
window-padding-x = 12
window-padding-y = 8
confirm-close-surface = false

# Tokyo Night
background = #1a1b26
foreground = #c0caf5
cursor-color = #7aa2f7
selection-background = #283457
selection-foreground = #c0caf5

palette = 0=#15161e
palette = 1=#f7768e
palette = 2=#9ece6a
palette = 3=#e0af68
palette = 4=#7aa2f7
palette = 5=#bb9af7
palette = 6=#7dcfff
palette = 7=#a9b1d6
palette = 8=#414868
palette = 9=#f7768e
palette = 10=#9ece6a
palette = 11=#e0af68
palette = 12=#7aa2f7
palette = 13=#bb9af7
palette = 14=#7dcfff
palette = 15=#c0caf5
EOF

success "Ghostty written"

# =============================================================================
# ROFI — Tokyo Night
# =============================================================================

info "Writing Rofi config..."

cat > ~/.config/rofi/config.rasi << 'EOF'
configuration {
    modi: "drun";
    show-icons: true;
    icon-theme: "Papirus";
    drun-display-format: "{name}";
    font: "JetBrains Mono Nerd Font 12";
    kb-cancel: "Escape,Super_L";
}

* {
    bg:       #1a1b26;
    bg-alt:   #24283b;
    fg:       #c0caf5;
    selected: #7aa2f7;
    urgent:   #f7768e;
    border:   0;
    margin:   0;
    padding:  0;
    spacing:  0;
}

window {
    width: 480px;
    border-radius: 10px;
    background-color: @bg;
    border: 2px;
    border-color: @selected;
}

mainbox { padding: 10px; spacing: 8px; }

inputbar {
    background-color: @bg-alt;
    border-radius: 6px;
    padding: 8px 12px;
    spacing: 8px;
    children: [prompt, entry];
}

prompt { color: @selected; }
entry  { placeholder: "Search..."; color: @fg; }

listview { lines: 8; scrollbar: false; spacing: 4px; }

element {
    border-radius: 6px;
    padding: 7px 12px;
    spacing: 8px;
    background-color: transparent;
    children: [element-icon, element-text];
}

element normal normal   { color: @fg; }
element selected normal {
    background-color: @selected;
    color: @bg;
    border-radius: 6px;
}

element-icon { size: 22px; }
element-text { vertical-align: 0.5; }
EOF

success "Rofi written"

# =============================================================================
# WALLPAPER PICKER — WIN + SHIFT + W
# =============================================================================

info "Writing wallpaper picker..."

cat > ~/.local/bin/wallpaper-picker << 'EOF'
#!/bin/bash
# Wallpaper picker — drop images into ~/Pictures/wallpapers/
# Bind: WIN + SHIFT + W

WALLPAPER_DIR="$HOME/Pictures/wallpapers"
mkdir -p "$WALLPAPER_DIR"

if [ -z "$(ls -A "$WALLPAPER_DIR" 2>/dev/null)" ]; then
    notify-send "Wallpaper Picker" "No wallpapers found.\nAdd images to ~/Pictures/wallpapers/ and try again."
    exit 0
fi

SELECTED=$(ls "$WALLPAPER_DIR" | rofi \
    -dmenu \
    -p "󰸉 Wallpaper" \
    -theme-str 'window {width: 400px;}' \
    -theme-str 'listview {lines: 12;}')

if [ -n "$SELECTED" ]; then
    swww img "$WALLPAPER_DIR/$SELECTED" \
        --transition-type fade \
        --transition-duration 1 \
        --transition-fps 60
    notify-send "Wallpaper" "Set to: $SELECTED"
fi
EOF

chmod +x ~/.local/bin/wallpaper-picker
success "Wallpaper picker written"

# =============================================================================
# ZSH
# =============================================================================

info "Writing zsh config..."

ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

[[ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]] && \
    git clone https://github.com/zsh-users/zsh-autosuggestions \
    "$ZSH_CUSTOM/plugins/zsh-autosuggestions"

[[ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]] && \
    git clone https://github.com/zsh-users/zsh-syntax-highlighting \
    "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"

cat > ~/.zshrc << 'EOF'
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME=""
plugins=(git zsh-autosuggestions zsh-syntax-highlighting fzf)
source $ZSH/oh-my-zsh.sh

eval "$(starship init zsh)"

export PATH="$PATH:/opt/nvim/bin"
export PATH="$HOME/.local/bin:$PATH"
export JAVA_HOME=/usr/lib/jvm/default
export EDITOR="nvim"
export VISUAL="nvim"

# Aliases
alias v="nvim"
alias vim="nvim"
alias lg="lazygit"
alias ll="ls -la --color=auto"
alias cat="bat"
alias update="yay -Syu"
alias grep="grep --color=auto"
alias hyprconf="nvim ~/.config/hypr/hyprland.conf"
alias waybconf="nvim ~/.config/waybar/config.jsonc"
alias zshconf="nvim ~/.zshrc"
alias reload="source ~/.zshrc"
alias wallpaper="wallpaper-picker"
alias docker-up="docker compose up -d"
alias docker-down="docker compose down"

export FZF_DEFAULT_COMMAND="fd --type f --hidden --follow --exclude .git"
export FZF_DEFAULT_OPTS="--height 40% --border"
EOF

success "Zsh written"

# =============================================================================
# STARSHIP PROMPT — Tokyo Night colours
# =============================================================================

cat > ~/.config/starship.toml << 'EOF'
format = """
[╭─](bold #7aa2f7)$directory$git_branch$git_status$python$nodejs$java
[╰─](bold #7aa2f7)$character"""

[directory]
style = "bold #7aa2f7"
truncation_length = 3
truncate_to_repo = true

[git_branch]
symbol = " "
style = "bold #bb9af7"

[git_status]
style = "bold #f7768e"

[character]
success_symbol = "[❯](bold #9ece6a)"
error_symbol = "[❯](bold #f7768e)"

[python]
symbol = " "
style = "bold #e0af68"

[nodejs]
symbol = " "
style = "bold #9ece6a"

[java]
symbol = " "
style = "bold #f7768e"
EOF

success "Starship written"

# =============================================================================
# NEOVIM + LAZYVIM — Tokyo Night
# =============================================================================

info "Installing Neovim..."

if [ ! -f /opt/nvim/bin/nvim ]; then
    cd /tmp
    wget -q https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
    tar -xzf nvim-linux-x86_64.tar.gz
    sudo mv nvim-linux-x86_64 /opt/nvim
    rm nvim-linux-x86_64.tar.gz
    cd ~
fi

info "Cloning LazyVim..."
if [ ! -d ~/.config/nvim ]; then
    git clone https://github.com/LazyVim/starter ~/.config/nvim
    rm -rf ~/.config/nvim/.git
fi

cat > ~/.config/nvim/lua/config/options.lua << 'EOF'
local opt = vim.opt
opt.relativenumber = true
opt.number = true
opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.wrap = false
opt.ignorecase = true
opt.smartcase = true
opt.cursorline = true
opt.termguicolors = true
opt.signcolumn = "yes"
opt.scrolloff = 8
opt.undofile = true
opt.splitright = true
opt.splitbelow = true
opt.clipboard = "unnamedplus"
EOF

cat > ~/.config/nvim/lua/plugins/colorscheme.lua << 'EOF'
return {
    {
        "folke/tokyonight.nvim",
        lazy = false,
        priority = 1000,
        opts = {
            style = "night",
            transparent = true,
            terminal_colors = true,
            styles = {
                comments = { italic = true },
                keywords = { italic = true },
                sidebars = "dark",
                floats = "dark",
            },
        },
    },
    {
        "LazyVim/LazyVim",
        opts = { colorscheme = "tokyonight-night" },
    },
}
EOF

success "Neovim written"

# =============================================================================
# GIT
# =============================================================================

info "Configuring git..."
git config --global user.name "$GIT_NAME"
git config --global user.email "$GIT_EMAIL"
git config --global core.editor "nvim"
git config --global init.defaultBranch main
git config --global pull.rebase false
success "Git configured"

# =============================================================================
# SSH KEY
# =============================================================================

info "Generating SSH key..."
if [ ! -f ~/.ssh/id_ed25519 ]; then
    ssh-keygen -t ed25519 -C "$GIT_EMAIL" -f ~/.ssh/id_ed25519 -N ""
fi
success "SSH key ready"

# =============================================================================
# AUDIO
# =============================================================================

info "Enabling audio services..."
systemctl --user enable --now pipewire 2>/dev/null || true
systemctl --user enable --now pipewire-pulse 2>/dev/null || true
systemctl --user enable --now wireplumber 2>/dev/null || true
success "Audio enabled"

# =============================================================================
# LY — default, no animation
# =============================================================================

info "Configuring LY (default, no animation)..."
sudo sed -i 's/^animate.*/animate = false/' /etc/ly/config.ini 2>/dev/null || true
success "LY configured"

# =============================================================================
# DONE
# =============================================================================

echo ""
echo -e "${GREEN}============================================${NC}"
echo -e "${GREEN}  All done!${NC}"
echo -e "${GREEN}============================================${NC}"
echo ""
echo -e "${BLUE}Add this SSH key to GitHub → Settings → SSH Keys:${NC}"
echo ""
cat ~/.ssh/id_ed25519.pub
echo ""
echo -e "${YELLOW}After rebooting:${NC}"
echo "  1. Add SSH key above to GitHub"
echo "  2. Drop wallpapers into ~/Pictures/wallpapers/"
echo "  3. WIN + SHIFT + W to pick a wallpaper"
echo "  4. Open nvim → :LazyExtras → enable lang.python, lang.java"
echo "  5. nvim → :Mason → install pyright, jdtls, lua-language-server"
echo ""
echo -e "${YELLOW}Key bindings:${NC}"
echo "  WIN             → App launcher"
echo "  WIN + Enter     → Ghostty terminal"
echo "  WIN + N         → Neovim"
echo "  WIN + V         → VSCodium"
echo "  WIN + W         → Zen Browser"
echo "  WIN + F         → Thunar"
echo "  WIN + Q         → Close window"
echo "  WIN + E         → Float window"
echo "  WIN + L         → Lock screen"
echo "  WIN + SHIFT + W → Wallpaper picker"
echo "  WIN + P         → Screenshot to file"
echo "  Print Screen    → Screenshot to clipboard"
echo "  WIN + 1-5       → Switch workspace"
echo "  WIN + SHIFT+1-5 → Move window to workspace"
echo ""
echo -e "${GREEN}Run: sudo reboot${NC}"
