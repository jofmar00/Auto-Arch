#!/bin/bash

#Colours
green="\e[0;32m\033[1m"
endColour="\033[0m\e[0m"
red="\e[0;31m\033[1m"
blue="\e[0;34m\033[1m"
yellow="\e[0;33m\033[1m"
purple="\e[0;35m\033[1m"
turquoise="\e[0;36m\033[1m"
gray="\e[0;37m\033[1m"
deleteLine="\033[K"

#Variables
dir=$(pwd)
package_dependencies="alacritty bat base-devel exa feh firefox htop lightdm lightdm-gtk-greeter neofetch network-manager-applet picom python-pip ranger rofi scrot starship xclip"

#####FUNCTIONS#####
function title(){
    echo -e "${green}"
    echo '    ___         __              ___              __  '
    echo '   /   | __  __/ /_____        /   |  __________/ /_ '
    echo '  / /| |/ / / / __/ __ \______/ /| | / ___/ ___/ __ \'
    echo ' / ___ / /_/ / /_/ /_/ /_____/ ___ |/ /  / /__/ / / /'
    echo '/_/  |_\__,_/\__/\____/     /_/  |_/_/   \___/_/ /_/'
    echo -e "\n By Jofmar00${endColour}" 
}

function check_package_installation(){
    if [ $? != 0 ]; then
        echo -e "${red}[!] Failed to install some package, exiting...${endColour}"
        exit 1
    else
        clear
        echo -e "${green}[+] Package installation succesfull! ${endColour}" 
    fi
}

function ctrl_c(){
    clear
    echo -e "$\n\n${red}[!] EXITING INSTALLATION, THIS MAY CAUSE PROBLEMS THE STATE OF YOUR MACHINE... ${endColour}\n"	
    exit 1
}



###### ----MAIN PROGRAM---- ######
if [ $UID -eq 0 ]; then
    echo -e "${red}[!] You should not run ./Auto-Arch.sh as root!${endColour}"
    exit 1
fi
trap ctrl_c SIGINT
clear
title
export XDG_CONFIG_HOME="~/.config"
echo -e "${blue}[+] Synchronizing package databases...${endColour}"
sudo pacman -Sy

echo -e "${blue}[+] Installing xorg... ${endColour}"
sleep 2
sudo pacman -S --noconfirm xorg xorg-server
check_package_installation

echo -e "${blue}[+] Installing qtile...${endColour}"
sleep 2
sudo pacman -S --noconfirm qtile
check_package_installation

echo -e "${blue}[+] Installing needed packages for the enviroment (This may take a while)... ${endColour}"
sleep 2
sudo pacman -S --noconfirm $package_dependencies
check_package_installation

echo -e "${blue}[+] Enabling the needed services...${endColour}"
sleep 1
sudo systemctl enable lightdm
check_package_installation

echo -e "${blue}[+] Starting configuration of the enviroment... ${endColour}"
sleep 1
pip install --break-system-packages psutil

echo -e "${blue}Setting up Wallpaper...${endColour}"
cp -rv ${dir}/wallpapers ~/


echo -e "${blue}Setting up configuration files...${endColour}"
cp -rv ${dir}/config/* /home/${USER}/.config_backup/
cp -v ${dir}/config/.bashrc ~/.bashrc
cp -v ${dir}/config/.bash_profile ~/.bash_profile
cp -v ${dir}/config/starship.toml ~/.config/starship.toml

echo -e "${blue}Setting up fonts...${endColour}"
if [[ ! -d /usr/share/fonts ]]; then
    mkdir /usr/share/fonts
fi
sudo cp -rv ${dir}/fonts /usr/share/fonts

echo -e "${green}[+] Enviroment configured :)!${endColour}"
sleep 2

while true; do
    echo -en "[?] It's necessary to restart the system. Do you want to do it now? ([y]/n):"
    read -r
    REPLY=${REPLY:-"y"}

    if [[ $REPLY =~ ^[Yy]$ ]]; then
        clear
        echo -e "${green}[+] REBOOTING THE SYSTEM... ${endColour}"
        sleep 2
        sudo reboot now
    elif [[ $REPLY =~ ^[Nn]$ ]]; then
        echo -e "${green}[+] Script finished succesfully, reboot to apply changes.${endColour}"
        exit 0
    else
        echo -e "\n ${red}[!] Invalid response, please try again \n ${endColour}"
    fi
done





