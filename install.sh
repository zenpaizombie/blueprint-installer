#!/bin/bash

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

# Clear the screen
apt install git npm -y
clear


# Install Arix Theme
install_arix() {
    echo -e "${GREEN}Installing Dependencies...${NC}"

        apt update
        apt install -y ca-certificates curl gnupg zip unzip git curl wget npm
        
        curl -sL https://deb.nodesource.com/setup_16.x | sudo -E bash -
        apt install -y nodejs
        
        apt update
        npm i -g yarn
        
        cd /var/www/pterodactyl
        yarn

        export NODE_OPTIONS=--openssl-legacy-provider
        yarn build:production
        cd
        echo -e "${GREEN}Dependencies Installed Successfully!${NC}"

    echo -e "${GREEN}Installing Theme...${NC}"

        git clone https://github.com/zenpaizombie/theme-files.git /var/www/pterodactyl
        cd /var/www/pterodactyl
        unzip arix-theme.zip
        php artisan migrate --force && php artisan optimize:clear && php artisan optimize && chmod -R 755 storage/* bootstrap/cache
        php artisan arix
    echo -e "${GREEN}Installer: Installation Done!! Thank You For Using This Script!!${NC}"
    echo -e "Made With ❤️ By ! ZenpaiZombie !"
}

# Install Blueprint Theme
install_blueprint() {
    echo -e "${GREEN}Installing Dependencies...${NC}"
    
        apt-get update
        apt-get install -y ca-certificates curl gnupg zip unzip git curl wget npm
        
        mkdir -p /etc/apt/keyrings
        curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg
        echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_20.x nodistro main" | sudo tee /etc/apt/sources.list.d/nodesource.list
        
        apt-get update
        apt-get install -y nodejs
        npm i -g yarn
        
        cd /var/www/pterodactyl
        yarn
        cd
    
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
    echo -e "Made With ❤️ By ! ZenpaiZombie !"
}

# Install Nookure Theme
install_nookure() {
    echo -e "${GREEN}Installing Theme...${NC}"

        bash <(curl -s https://raw.githubusercontent.com/zenpaizombie/paid-theme/refs/heads/main/nookure.sh)
    echo -e "Made With ❤️ By ! ZenpaiZombie !"
}

# Install Enigma Theme
install_enigma() {
    echo -e "${GREEN}Installing Theme...${NC}"

        git clone https://github.com/rainmc0123/RainMc.git /var/www/pterodactyl
        cd /var/www/pterodactyl
        unzip enigmarain.zip
        bash <(curl -s https://raw.githubusercontent.com/zenpaizombie/paid-theme/refs/heads/main/enigmainstaller.sh)
    echo -e "Made With ❤️ By ! ZenpaiZombie !"
}

# Main Menu
echo -e "${RED}⚠️ Warning sudo must be installed!!${NC}"
echo -e "${CYAN}Select an option:${NC}"
echo -e "1. Install Arix Theme"
echo -e "2. Install Blueprint Theme"
echo -e "3. Install Nookure Theme"
echo -e "4. Install Enigma Theme"
echo -e "5. ${RED}Exit${NC}"

# Fix: Corrected missing variable assignment
read -p "Enter your choice (1-4): " choice

case $choice in
    1)
        install_arix
        ;;
    2)
        install_blueprint
        ;;
    3)
        install_nookure
        ;;
    4)
        install_enigma
        ;;
    5)
        echo -e "${GREEN}Exiting...${NC}"
        exit 0
        ;;
    *)
        echo -e "${RED}Invalid option. Please select between 1-4.${NC}"
        exit 1
        ;;
esac
