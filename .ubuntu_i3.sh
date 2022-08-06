#!/bin/bash

set -e

notify () {
    echo -e "\n\033[1;33m${1}\033[0m\n"
}

# update
notify "Updating..."
sudo apt update
sudo apt upgrade

# apt packages
sudo apt install adb calibre clang cmake figlet g++ gfortran gimp htop nasm neofetch lolcat mpv net-tools pdfshuffler ssh telegram-desktop

# latex stuff
sudo apt install texstudio dvipng latexmk cm-super

# i3-gaps
notify "Installing i3-gaps..."
sudo add-apt-repository ppa:kgilmer/speed-ricer
sudo apt update
sudo apt install i3-gaps

# alacritty
notify "Installing alacritty..."
sudo add-apt-repository ppa:mmstick76/alacritty
sudo apt update
sudo apt install alacritty

# i3blocks
notify "Compiling i3blocks from source..."
sudo apt install dh-autoreconf
git clone https://github.com/vivien/i3blocks.git
cd i3blocks/
./autogen.sh
./configure
make
sudo make install
rm -rf ../i3blocks

# i3blocks-contrib
notify "Cloning i3blocks-contrib github repo..."
git clone https://github.com/vivien/i3blocks-contrib.git .config/i3blocks/i3blocks-contrib

# moar stuff
sudo apt install acpi compton dmenu dunst feh i3lock-fancy i3status lm-sensors playerctl rofi sysstat xautolock yad

# intel_backlight
notify "Allow writing in intel_backlight/brightness"
# BE CAREFUL!!! USE VISUDO
sudo echo "$USER $HOST = (root) NOPASSWD: /usr/bin/tee" | sudo tee /etc/sudoers.d/backlight
sudo chmod 440 /etc/sudoers.d/backlight

# sublime-text
# https://www.sublimetext.com/docs/3/linux_repositories.html
notify "Installing Sublime..."
wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -
sudo apt install apt-transport-https
echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list
sudo apt update
sudo apt install sublime-text sublime-merge

# set up ubuntu 20.04 for gaming
# https://www.reddit.com/r/linux4noobs/comments/g7753y/how_to_set_up_ubuntu_2004_for_gaming_tutorial/
notify "Setting up gaming..."
## install gpu driver
which lspci &> /dev/null
if [ $? = 0 ]; then
    lspci | grep -i 'vga\|3d\|2d'
fi
read -p "Which GPU? [nvidia/amd/intel] " gpu
if [ ${gpu} = "nvidia" ]; then
    sudo add-apt-repository ppa:graphics-drivers/ppa
    sudo apt install nvidia-driver-440 libnvidia-gl-440 libnvidia-gl-440:i386
    sudo apt install libvulkan1 libvulkan1:i386
elif [ ${gpu} = "amd" -o ${gpu} = "intel" ]; then
    sudo dpkg --add-architecture i386
    sudo apt install libgl1-mesa-dri:i386
    sudo apt install mesa-vulkan-drivers mesa-vulkan-drivers:i386
else
    notify "Error: Invalid GPU!"
    exit 1
fi
## install wine staging
sudo dpkg --add-architecture i386
wget -qO - https://dl.winehq.org/wine-builds/winehq.key | sudo apt-key add -
sudo apt-add-repository 'deb https://dl.winehq.org/wine-builds/ubuntu/ focal main'
sudo apt update
sudo apt install --install-recommends wine-staging
sudo apt install libgnutls30:i386 libldap-2.4-2:i386 libgpg-error0:i386 libxml2:i386 libasound2-plugins:i386 libsdl2-2.0-0:i386 libfreetype6:i386 libdbus-1-3:i386 libsqlite3-0:i386
## install lutris
sudo add-apt-repository ppa:lutris-team/lutris
sudo apt update
sudo apt install lutris
## install steam
sudo apt install steam
notify "Remember to manually enable Gamemode (Steam > Properties > SET LAUNCH OPTIONS > 'gamemoderun %command%' > OK)"
notify "For Lutris, navigate to Preferences > System Options > Command prefix > 'gamemoderun'"

# fonts
sudo apt install fonts-cascadia-code fonts-font-awesome fcitx-mozc
mkdir -p ~/.local/share/fonts
wget -q https://github.com/adam7/delugia-code/releases/download/v2007.01/Delugia.Nerd.Font.ttf
mv Delugia.Nerd.Font.ttf ~/.local/share/fonts/

# oh-my-zsh
# https://github.com/denysdovhan/spaceship-prompt
notify "Installing Oh My Zsh..."
sudo apt install zsh
git clone https://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions.git ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
git clone https://github.com/denysdovhan/spaceship-prompt.git ~/.oh-my-zsh/custom/themes/spaceship-prompt
ln -s ~/.oh-my-zsh/custom/themes/spaceship-prompt/spaceship.zsh-theme ~/.oh-my-zsh/custom/themes/spaceship.zsh-theme
chsh -s /bin/zsh

# emacs
notify "Installing emacs..."
sudo apt install emacs
git clone https://github.com/dioph/.emacs.d.git ~/.emacs.d

# python
notify "Setting up python..."
sudo apt install python3-dev python3-tk python3-venv

# vscodium
notify "Setting up VSCodium..."
sudo snap install codium --classic
codium --install-extension ms-python.python --force
codium --install-extension James-Yu.latex-workshop --force
codium --install-extension yzhang.markdown-all-in-one --force

# youtube-dl
# https://github.com/ytdl-org/youtube-dl
which youtube-dl > /dev/null
if [ $? = 0 ]; then
    notify "Removing outdated youtube-dl..."
    sudo apt remove youtube-dl
fi
notify "Installing youtube-dl..."
sudo wget https://yt-dl.org/downloads/latest/youtube-dl -O /usr/local/bin/youtube-dl
sudo chmod a+rx /usr/local/bin/youtube-dl
hash -r

# cleaning apt
notify "Cleaning apt..."
sudo apt-get autoremove
sudo apt-get autoclean

sleep 2

# The End
notify "Done. Please reboot!"
exit 0

