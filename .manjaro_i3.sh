#!/bin/zsh

set -e

notify () {
    echo -e "\n\033[1;33m${1}\033[0m\n"
}

# update
sudo pacman -Syu

# pacman packages
sudo pacman -S calibre clang cmake figlet firefox gimp nasm neofetch lolcat mpv net-tools pdfarranger telegram-desktop
pamac build numix-circle-icon-theme-git

# latex stuff
sudo pacman -S texstudio texlive-fontsextra

# i3 stuff
sudo pacman -S i3-gaps alacritty i3blocks
git clone https://github.com/vivien/i3blocks-contrib.git  ~/.config/i3blocks/i3blocks-contrib
sudo pacman -S feh playerctl rofi sysstat yad
pamac build i3lock-fancy-git

# intel_backlight
# TODO: 

# sublime
pamac build sublime-text-dev

# gaming
## drivers
which lspci &> /dev/null
if [ $? = 0 ]; then
    lspci | grep -i 'vga\|3d\|2d'
fi
read -p "Which GPU? [nvidia/amd/intel]] " gpu
if [ ${gpu} = "nvidia" ]; then
    sudo pacman -S nvidia-dkms nvidia-utils lib32-nvidia-utils vulkan-icd-loader lib32-vulkan-icd-loader
elif [ ${gpu} = "amd" ]; then
    sudo pacman -S lib32-mesa vulkan-radeon lib32-vulkan-radeon vulkan-icd-loader lib32-vulkan-icd-loader
elif [ ${gpu} = "intel"]; then
    sudo pacman -S lib32-mesa vulkan-intel lib32-vulkan-intel vulkan-icd-loader lib32-vulkan-icd-loader
else
    notify "Unknown GPU! Skipping..."
fi
## wine-staging
sudo pacman -S wine-staging
## lutris
sudo pacman -S lutris
## steam
sudo pacman -S steam

# fonts
sudo pacman -S ttf-cascadia-code otf-font-awesome ttf-font-awesome fcitx-mozc
mkdir -p ~/.local/share/fonts
wget -q https://github.com/adam7/delugia-code/releases/download/v2007.01/Delugia.Nerd.Font.ttf
mv Delugia.Nerd.Font.ttf ~/.local/share/fonts/
# TODO: fcitx config

# oh-my-zsh
git clone https://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions.git ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
git clone https://github.com/denysdovhan/spaceship-prompt.git ~/.oh-my-zsh/custom/themes/spaceship-prompt
ln -s ~/.oh-my-zsh/custom/themes/spaceship-prompt/spaceship.zsh-theme ~/.oh-my-zsh/custom/themes/spaceship.zsh-theme

# emacs
sudo pacman -S emacs
git clone https://github.com/dioph/.emacs.d.git  ~/.emacs.d

# python
sudo pacman -S tk

# vscodium
pamac build vscodium-bin

# optional
pamac build discord_arch_electron
pamac build zoom
# TODO: spotify virtualbox

# youtube-dl
sudo wget https://yt-dl.org/downloads/latest/youtube-dl -O /usr/local/bin/youtube-dl
sudo chmod a+rx /usr/local/bin/youtube-dl
hash -r

# The End
notify "Done. Please reboot!"
exit 0
