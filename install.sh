#!/bin/sh

# Define text colors
RED='\033[0;31m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[0;33m'
BOLD='\033[1m'
MAGENTA='\033[35m'
RESET='\033[0m'

DEVDOTS_DIR="$(pwd)"

# Check if running on Arch Linux
is_arch() {
    if ! grep -qi '^ID=arch' /etc/os-release; then
        return 1
    fi
}

# Check if yay is installed
check_yay() {
  if ! command -v yay &> /dev/null; then
      return 1
  else
      echo -e "${GREEN}${BOLD}Yay is already installed.${RESET}"
  fi
}

# Check last command status
check_status() {
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}${BOLD}Success: $1${RESET}"
    else
        echo -e "${RED}${BOLD}Error: ${RESET}$2"
        exit 1
    fi
}

# Backup file if it exists
backup_file() {
    local file="$1"
    [[ -e "$file" ]] || return 0

    local backup="${file}.backup.$(date +%Y%m%d_%H%M%S)"
    echo -e "${YELLOW}${BOLD}Backing up ${file} to ${backup}.${RESET}"
    mv "$file" "$backup"
    check_status "Backup completed" "Backup failed"
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
    check_status "Cloned $repo successfully" "Cloning failed"
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
    check_status "Copied $src to $dest" "Copy failed"
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

# Check and install yay
if ! check_yay; then
    echo -e "${CYAN}${BOLD}Installing yay...${RESET}"
    sudo pacman -S --needed git base-devel
    safe_clone https://aur.archlinux.org/yay.git $HOME/yay
    cd $HOME/yay
    makepkg -si
    cd $HOME
    check_status "yay installed" "Failed to install yay"
fi

# Install Zsh plugins
ZSH_PLUGIN_DIR="$HOME/.local/share/zsh-plugins"
mkdir -p "$ZSH_PLUGIN_DIR"
echo -e "${GREEN}${BOLD}Cloning Zsh plugins...${RESET}"

safe_clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_PLUGIN_DIR/zsh-syntax-highlighting"
safe_clone https://github.com/zsh-users/zsh-autosuggestions.git "$ZSH_PLUGIN_DIR/zsh-autosuggestions"
safe_clone https://github.com/zap-zsh/supercharge.git "$ZSH_PLUGIN_DIR/supercharge"

# Install and configure Zsh
echo -e "${GREEN}${BOLD}Installing Zsh...${RESET}"
yay -S --noconfirm zsh
check_status "Zsh installed" "Failed to install Zsh"
chsh -s /bin/zsh
backup_file "$HOME/.zshrc"
touch "$HOME/.zshrc"

# Define packages
packages=(
  kitty
  nvim
  lsd
  zsh
  starship
)

# Install packages
echo -e "${CYAN}${BOLD}Installing packages...${RESET}"
for package in "${packages[@]}"; do 
  echo -e "$package"
done

yay -S --noconfirm "${packages[@]}"
check_status "Packages installed" "Package installation failed"

# Copy dotfiles
for dir in $DEVDOTS_DIR/config/*; do
    if [[ -d "$dir" ]]; then
        echo "$dir"
        safe_copy "$dir" "$HOME/.config"
    fi
done

safe_copy "$DEVDOTS_DIR/config/.zshrc" "$HOME"

echo -e "${GREEN}Setup complete.${RESET}"          
exit 0
