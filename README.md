# dotfiles

> Tokyo Night Hyprland developer setup for Arch Linux — one command from bare metal to a fully working desktop.

![Hyprland](https://img.shields.io/badge/WM-Hyprland-blue?style=flat-square)
![Theme](https://img.shields.io/badge/Theme-Tokyo%20Night-purple?style=flat-square)
![Arch](https://img.shields.io/badge/OS-Arch%20Linux-1793d1?style=flat-square)

---

## What's Included

| Tool | Purpose |
|------|---------|
| Hyprland | Tiling Wayland compositor |
| Waybar | Minimal top bar |
| Ghostty | Terminal with Tokyo Night + transparency |
| Neovim + LazyVim | Primary editor |
| VSCodium | Secondary editor (no Microsoft telemetry) |
| Zen Browser | Primary browser |
| Thunar | File manager |
| Rofi | App launcher |
| Dunst | Notifications |
| awww | Wallpaper daemon |
| LY | Display manager |
| Git + Docker + Python + Java | Dev tools preinstalled |
| Starship | Prompt |
| Zsh + Oh My Zsh | Shell |

---

## Requirements

- Fresh Arch Linux install via `archinstall`
- **Base Hyprland** profile selected during archinstall
- **LY** display manager selected during archinstall
- Internet connection
- A GitHub account (for SSH key setup)

---

## Install

```bash
git clone https://github.com/alfiemcphee/dotfiles.git
cd dotfiles
chmod +x setup.sh
bash setup.sh
```

The script will ask for:
- Your git name
- Your git email

Everything else is automatic.

---

## After Install

1. Copy the SSH key printed at the end → add to [GitHub SSH keys](https://github.com/settings/keys)
2. Add wallpapers to `~/Pictures/wallpapers/`
3. Run `sudo reboot`

---

## First Launch

After rebooting and logging in via LY:

1. Open Neovim: `WIN + N`
2. Run `:LazyExtras` and enable:
   - `lang.python`
   - `lang.java`
   - `lang.typescript`
   - `lang.html`
   - `lang.sql`
3. Run `:Mason` and install:
   - `pyright`
   - `jdtls`
   - `lua-language-server`

---

## Keybindings

| Key | Action |
|-----|--------|
| `WIN` | App launcher |
| `WIN + Enter` | Ghostty terminal |
| `WIN + N` | Neovim |
| `WIN + V` | VSCodium |
| `WIN + W` | Zen Browser |
| `WIN + F` | Thunar files |
| `WIN + Q` | Close window |
| `WIN + E` | Toggle float |
| `WIN + L` | Lock screen |
| `WIN + F11` | Fullscreen |
| `WIN + SHIFT + W` | Wallpaper picker |
| `WIN + P` | Screenshot to file |
| `Print Screen` | Screenshot to clipboard |
| `WIN + 1-5` | Switch workspace |
| `WIN + SHIFT + 1-5` | Move window to workspace |
| `WIN + Arrows` | Move focus |
| `WIN + SHIFT + Arrows` | Move window |
| `WIN + CTRL + Arrows` | Resize window |

---

## Useful Aliases

| Alias | Command |
|-------|---------|
| `v` | neovim |
| `lg` | lazygit |
| `ll` | ls -la |
| `cat` | bat |
| `update` | yay -Syu |
| `hyprconf` | edit hyprland config |
| `waybconf` | edit waybar config |
| `zshconf` | edit zshrc |
| `wallpaper` | open wallpaper picker |
| `docker-up` | docker compose up -d |
| `docker-down` | docker compose down |

---

## Workspace Layout

| Workspace | Suggested Use |
|-----------|--------------|
| 1 | Neovim |
| 2 | Terminal |
| 3 | Browser |
| 4 | Git / Lazygit |
| 5 | Everything else |

---

## Colours — Tokyo Night Night

| Role | Hex |
|------|-----|
| Background | `#1a1b26` |
| Surface | `#24283b` |
| Blue (primary) | `#7aa2f7` |
| Purple | `#bb9af7` |
| Cyan | `#7dcfff` |
| Green | `#9ece6a` |
| Red | `#f7768e` |
| Yellow | `#e0af68` |
| Foreground | `#c0caf5` |

---

## Known Limitations

- `monitor = eDP-1` is hardcoded — if your monitor has a different name run `hyprctl monitors` and update `~/.config/hypr/hyprland.conf` accordingly
- `kb_layout = gb` is set to UK keyboard — change to your layout if needed (e.g. `us`, `de`, `fr`)
- Tested on Arch Linux only

---

## Adding a Wallpaper

Drop any image into `~/Pictures/wallpapers/` then press `WIN + SHIFT + W` to pick it.

---

*Built for the ThinkPad X1 Carbon Gen 8 — works on any Arch machine.*
