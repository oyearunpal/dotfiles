# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Structure

This is a **Home Manager configuration** repository using Nix flakes for managing dotfiles and system packages on Linux. The configuration is specifically set up for a Hyprland Wayland desktop environment.

### Core Files

- `flake.nix` - Main flake configuration defining inputs (nixpkgs, home-manager, nixGL) and outputs
- `home.nix` - Primary Home Manager configuration with all packages, services, and Hyprland setup
- `validate-config.sh` - Validation script for testing configuration integrity

## Development Commands

### Configuration Management
```bash
# Validate configuration syntax and test build
./validate-config.sh

# Build configuration (dry-run to test without applying)
home-manager build --dry-run

# Apply configuration changes
home-manager switch

# Check flake syntax
nix flake check

# Update flake inputs to latest versions
nix flake update
```

### Hyprland-Specific Commands
```bash
# Reload Hyprland configuration
hyprctl reload

# Test specific Hyprland settings
hyprctl keyword decoration:shadow:enabled true

# Check current Hyprland configuration
hyprctl clients
hyprctl workspaces
```

## Architecture Overview

### Nix Flake Structure
- Uses `nixpkgs-unstable` for latest packages
- Integrates `nixGL` for OpenGL support on non-NixOS systems
- Home Manager manages user-space configuration

### Key Configuration Areas

**Desktop Environment:**
- Hyprland as primary Wayland compositor with comprehensive keybindings
- Waybar for status bar, Rofi for application launcher, Dunst for notifications
- Kitty terminal with Catppuccin Mocha theme
- Custom window rules and workspace assignments

**Package Management:**
- Essential Wayland tools (grim, slurp, wl-clipboard, swww)
- Development tools (neovim, lazygit, ripgrep, fzf, tmux)
- Media utilities (playerctl, pavucontrol, brightnessctl)
- Productivity tools (btop, ncdu, httpie, starship)

**Security & Session:**
- Hyprlock for screen locking with custom styling
- Hypridle for idle management and auto-suspend
- Polkit authentication agent integration

### Validation System
The `validate-config.sh` script provides comprehensive testing:
- Nix syntax validation
- Home Manager build testing
- Hyprland configuration verification
- Detection of deprecated options
- Warning analysis

## Important Notes

- Configuration targets user "irage" at `/home/irage`
- Uses JetBrainsMono Nerd Font throughout
- Workspace 1: Terminals, 2: Browsers, 3: Development, 4: Discord, 5: Spotify
- Caps Lock mapped to Escape
- Custom application jumping and cycling keybindings (Super+Alt+[key])
- You can refer wiki for configuration on https://wiki.hypr.land/Nix/Hyprland-on-Home-Manager/