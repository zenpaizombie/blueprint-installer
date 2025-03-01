#!/bin/bash


# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

# Clear the screen
clear


# Check OS
OS=$(uname -s)
IP_ADDRESS=$(curl -s https://checkip.pterodactyl-installer.se)
if [[ "$OS" == "Linux" ]]; then
    DISTRO=$(lsb_release -i | cut -f2)
elif [[ "$OS" == "Darwin" ]]; then
    DISTRO="macOS"
elif [[ "$OS" == "MINGW64_NT" ]]; then
    DISTRO="Windows"
else
    echo -e "${RED}[ERROR] Unsupported OS: $OS. Please use Ubuntu, CentOS, Debian, Windows, or macOS.${NC}"
    exit 1
fi

echo -e "${YELLOW}Detected OS: $DISTRO${NC}"

# Check Dependencies
check_dependencies() {
    echo -e "${GREEN}Installing Dependencies...${NC}"

    if ! command -v git &>/dev/null; then
        echo -e "${RED}yarn is not installed. Installing...${NC}"
        sudo apt-get install -y ca-certificates curl gnupg
        sudo mkdir -p /etc/apt/keyrings
        curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg
        echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_20.x nodistro main" | tee /etc/apt/sources.list.d/nodesource.list
        apt-get update
        apt-get install -y nodejs
        npm i -g yarn
        cd /var/www/pterodactyl
        yarn
        apt install -y zip unzip git curl wget
        cd
    fi
}

# Install theme
install_theme() {
    echo -e "${GREEN}Installing Theme...${NC}"
    cd /var/www/pterodactyl
    wget "$(curl -s https://api.github.com/repos/BlueprintFramework/framework/releases/latest | grep 'browser_download_url' | cut -d '"' -f 4)" -O release.zip
    unzip release.zip
    touch /var/www/pterodactyl/.blueprintrc
    echo \
'WEBUSER="www-data";
OWNERSHIP="www-data:www-data";
USERSHELL="/bin/bash";' >> /var/www/pterodactyl/.blueprintrc
    chmod +x blueprint.sh
    bash blueprint.sh
    echo -e "${GREEN}Installer: Installation Done!! Thank You For Using This Script!!${NC}"
}

# Main Menu
echo -e "${CYAN}Select an option:${NC}"
echo -e "1. Install Theme + Dependencies (Both)"
echo -e "2. Install Dependencies"
echo -e "3. Install Theme"
echo -e "4. Exit**
read -p "Enter your choice (1-4):" choice

case $choice in
    1)
        check_dependencies
        install_theme
        ;;
    2)
        check_dependencies
        ;;
    3)
        install_theme
        ;;
    4)
        echo -e "${GREEN}Exiting...${NC}"
        exit 0
        ;;
    *)
        echo -e "${RED}Invalid option. Please select between 1-4.${NC}"
        exit 1
        ;;
esac
