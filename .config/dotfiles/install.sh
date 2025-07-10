#!/bin/bash

# Define color codes for success, failure, and information
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No color

# Function to output success or failure with color
log_status() {
    if [ $1 -eq 0 ]; then
        echo -e "${GREEN}[SUCCESS] $2${NC}"
    else
        echo -e "${RED}[FAILURE] $2${NC}"
    fi
}

# Update system
sudo apt update && sudo apt upgrade -y
log_status $? "System update completed"

# Install required packages (including gcc, g++ for C++ builds)
sudo apt install -y tmux git cmake ninja-build docker.io curl wget python3-pip google-chrome-stable htop \
    gcc g++ meson build-essential python3.12-venv

log_status $? "Required packages installed"
sudo usermod -aG docker $USER
sudo apt update && sudo apt install -y pipx
pipx ensurepath
pipx install "python-lsp-server[all]" glab csvtk terminator
# Install pip packages (using --user flag and --break-system-packages)
log_status $? "Pip packages installed"

# Install Oh My Zsh if not already installed
if [ -d "$HOME/.oh-my-zsh" ]; then
    echo -e "${YELLOW}Oh My Zsh is already installed.${NC}"
else
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    log_status $? "Oh My Zsh installed"
fi

# Install Hyprland (for Wayland) if not already installed
if ! dpkg -l | grep -q "hyprland"; then
    # Clone and build Hyprland
    git clone --recursive https://github.com/hyprwm/Hyprland
    cd Hyprland
    make all && sudo make install
    log_status $? "Hyprland installed"
else
    echo -e "${YELLOW}Hyprland is already installed.${NC}"
fi

# Install Warp if not already installed
if ! dpkg -l | grep -q "warp"; then
    # Install necessary packages for Warp
    sudo apt-get install wget gpg
    wget -qO- https://releases.warp.dev/linux/keys/warp.asc | gpg --dearmor > warpdotdev.gpg
    sudo install -D -o root -g root -m 644 warpdotdev.gpg /etc/apt/keyrings/warpdotdev.gpg
    sudo sh -c 'echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/warpdotdev.gpg] https://releases.warp.dev/linux/deb stable main" > /etc/apt/sources.list.d/warpdotdev.list'
    rm warpdotdev.gpg
    sudo apt update && sudo apt install warp-terminal
    log_status $? "Warp installed"
else
    echo -e "${YELLOW}Warp is already installed.${NC}"
fi

# Install VSCode if not already installed
if ! dpkg -l | grep -q "code"; then
    wget -qO- https://packages.microsoft.com/keys/microsoft.asc | sudo tee /etc/apt/trusted.gpg.d/microsoft.asc
    sudo add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main"
    sudo apt update
    sudo apt install -y code
    log_status $? "VSCode installed"
else
    echo -e "${YELLOW}VSCode is already installed.${NC}"
fi

# Set up Zsh as the default shell (skip manual Zsh config)
chsh -s $(which zsh)
log_status $? "Zsh set as default shell"
echo -e "${YELLOW}Zsh has been set as the default shell. Please restart your terminal for changes to take effect.${NC}"

# Install Neovim from Git (build from source)
if [ ! -d "$HOME/neovim" ]; then
    cd ~
    git clone https://github.com/neovim/neovim.git
    cd neovim
    make CMAKE_BUILD_TYPE=Release
    sudo make install
    log_status $? "Neovim installed from Git repository"
else
    echo -e "${YELLOW}Neovim is already installed from Git repository.${NC}"
fi

# Set default Hyprland configuration (update if not exists)
HYPR_CONFIG="$HOME/.config/hypr/hyprland.conf"
if [ ! -f "$HYPR_CONFIG" ]; then
    mkdir -p ~/.config/hypr
    cat <<EOF > "$HYPR_CONFIG"
# Example Hyprland configuration
output * scale 1.0
input * type keyboard repeat_delay 500
EOF
    log_status $? "Hyprland configuration set"
else
    echo -e "${YELLOW}Hyprland configuration already exists. Skipping update.${NC}"
fi

# Set up Chrome default settings (including Vimium) (update if not exists)
CHROME_PREFS="$HOME/.config/google-chrome/Default/Preferences"
if [ ! -f "$CHROME_PREFS" ]; then
    cat <<EOF > "$CHROME_PREFS"
{
  "browser": {
    "default_search_provider": {
      "search_url": "https://www.google.com/search?q={searchTerms}",
      "search_name": "Google"
    }
  }
}
EOF
    log_status $? "Chrome configuration set"
else
    echo -e "${YELLOW}Chrome configuration already exists. Skipping update.${NC}"
fi
gsettings set org.gnome.desktop.input-sources xkb-options "['caps:escape']"

# Install Vimium for Chrome via extension management or via their site:
# https://chrome.google.com/webstore/detail/vimium/kdckgpopklljmjmijlmjlbbhfclgnpnm
echo -e "${YELLOW}Install Vimium manually from the Chrome Web Store: https://chrome.google.com/webstore/detail/vimium/kdckgpopklljmjmijlmjlbbhfclgnpnm${NC}"
# # Reboot to apply all changes - COMMENTED OUT
# echo -e "${YELLOW}Rebooting system to apply changes...${NC}"
# sudo reboot
