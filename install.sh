#!/usr/bin/env bash

# Define text colors
RED='\033[0;31m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[0;33m'
BOLD='\033[1m'
MAGENTA='\033[35m'
RESET='\033[0m'

set -euo pipefail

SUDO="sudo"
[ "$EUID" -eq 0 ] && SUDO=""

DEVDOTS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Check if running on Arch Linux
is_arch() {
    grep -qi '^ID=arch' /etc/os-release || grep -qi '^ID_LIKE=.*arch' /etc/os-release
}

# Backup file if it exists
backup_file() {
    local file="$1"
    [[ -e "$file" ]] || return 0

    local backup="${file}.backup.$(date +%Y%m%d_%H%M%S)"
    echo -e "${YELLOW}${BOLD}Backing up ${file} to ${backup}.${RESET}"
    mv "$file" "$backup"
}

# Clone git repository safely
safe_clone() {
    local repo="$1"
    local dir="$2"

    if [ -d "$dir" ]; then
        echo -e "${YELLOW}${BOLD}Directory ${dir} already exists.${RESET}"
        read -rp "$(echo -e "${CYAN}${BOLD}Remove and re-clone it? (y/n):${RESET} ") " choice
        [[ $choice =~ ^[Yy](es)?$ ]] || {
            echo -e "${GREEN}${BOLD}Skipping clone of ${repo}.${RESET}"
            return 0
        }
        rm -rf "$dir"
    fi

    git clone "$repo" "$dir"
}

# Copy directory safely
safe_copy() {
    local src="$1"
    local dest="$2"
    local src_dir_name="$(basename "$1")"
    local dest_dir_name="$dest/$src_dir_name"

    [[ -e "$src" ]] || {
        echo -e "${RED}${BOLD}Source ${src} does not exist.${RESET}"
        return 1
    }

    if [ -e "$dest_dir_name" ]; then
        echo -e "${YELLOW}${BOLD}${dest_dir_name} already exists.${RESET}"
        read -rp "$(echo -e "${CYAN}${BOLD}Backup and overwrite? (y/n):${RESET} ") " choice
        [[ $choice =~ ^[Yy](es)?$ ]] || {
            echo -e "${GREEN}${BOLD}Skipping copy of ${src}.${RESET}"
            return 0
        }
        backup_file "$dest_dir_name"
    fi

    cp -r "$src" "$dest"
}

# Introduction
echo -e "
${MAGENTA}
██████╗ ███████╗██╗   ██╗██████╗  ██████╗ ████████╗███████╗
██╔══██╗██╔════╝██║   ██║██╔══██╗██╔═══██╗╚══██╔══╝██╔════╝
██║  ██║█████╗  ██║   ██║██║  ██║██║   ██║   ██║   ███████╗
██║  ██║██╔══╝  ╚██╗ ██╔╝██║  ██║██║   ██║   ██║   ╚════██║
██████╔╝███████╗ ╚████╔╝ ██████╔╝╚██████╔╝   ██║   ███████║
╚═════╝ ╚══════╝  ╚═══╝  ╚═════╝  ╚═════╝    ╚═╝   ╚══════╝
${RESET}
"

# Check if system is Arch Linux
if ! is_arch; then
     echo -e "${RED}This script is intended for Arch Linux only.${RESET}"
     exit 1
fi

# Warning prompt
echo -e "${RED}${BOLD}WARNING:${RESET} This script will make system changes."
echo -e "${CYAN}${BOLD}Ensure your data is backed up before proceeding.${RESET}"
read -rp "$(echo -e "${CYAN}${BOLD}Do you want to continue? (yes/no):${RESET} ") " choice
if [[ ! $choice =~ ^[Yy](es)?$ ]]; then
    echo -e "${RED}${BOLD}Operation cancelled by user.${RESET}"
    exit 1
fi

# Install Zsh plugins
ZSH_PLUGIN_DIR="$HOME/.local/share/zsh-plugins"
mkdir -p "$ZSH_PLUGIN_DIR"
echo -e "${GREEN}${BOLD}Cloning Zsh plugins...${RESET}"

# Define packages
packages=(
    git
    kitty
    nvim
    lsd
    zsh
    starship
)

# Install packages
echo -e "${CYAN}${BOLD}Installing packages...${RESET}"
for package in "${packages[@]}"; do 
  echo "$package"
done

$SUDO pacman -Syu --noconfirm
$SUDO pacman -S --needed "${packages[@]}"

mkdir -p "$HOME/.config"

# Copy dotfiles
for dir in "$DEVDOTS_DIR"/config/*; do
    if [[ -d "$dir" ]]; then
        echo "$dir"
        safe_copy "$dir" "$HOME/.config"
    fi
done

# zsh plugins
safe_clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_PLUGIN_DIR/zsh-syntax-highlighting"
safe_clone https://github.com/zsh-users/zsh-autosuggestions.git "$ZSH_PLUGIN_DIR/zsh-autosuggestions"
safe_clone https://github.com/zap-zsh/supercharge.git "$ZSH_PLUGIN_DIR/supercharge"

chsh -s "$(command -v zsh)" || echo -e "${YELLOW}Could not change shell automatically.${RESET}"
backup_file "$HOME/.zshrc"
safe_copy "$DEVDOTS_DIR/config/.zshrc" "$HOME"

echo -e "${GREEN}Setup complete!${RESET}"          
echo -e "${CYAN}Run 'exec zsh' to switch zsh immediately.${RESET}"          
exit 0
