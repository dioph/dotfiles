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
wget -q https://github.com/adam7/delugia-code/releases/download/v2007.01/Delugia.Nerd.Font.ttf
mkdir -p ~/.local/share/fonts
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

# set flameshot as default screenshot tool
sudo apt install flameshot
gsettings set org.gnome.settings-daemon.plugins.media-keys screenshot '[]'
gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings "['/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/']"
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ name 'flameshot'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ command '/usr/bin/flameshot gui'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ binding 'Print'

# Desktop & Gnome preferences
notify "Setting up Gnome Shell..."
sudo apt install gnome-tweaks gnome-shell-extensions numix-gtk-theme numix-icon-theme-circle
## dash to dock
## walkpaper
## resource monitor
## workspace matrix
## enable user shell themes
gnome-extensions enable user-theme@gnome-shell-extensions.gcampax.github.com
gsettings set org.gnome.shell favorite-apps "['org.gnome.Nautilus.desktop', 'firefox.desktop']"
## tweaks > extensions
gsettings set org.gnome.shell.extensions.desktop-icons show-home false
gsettings set org.gnome.shell.extensions.desktop-icons show-trash false
## tweaks > top bar
gsettings set org.gnome.desktop.interface clock-show-weekday true
gsettings set org.gnome.desktop.interface show-battery-percentage true
## tweaks > appearance
gsettings set org.gnome.desktop.interface gtk-theme 'Numix'
gsettings set org.gnome.desktop.interface cursor-theme 'Yaru'
gsettings set org.gnome.desktop.interface icon-theme 'Numix-Circle'
gsettings set org.gnome.desktop.wm.preferences theme 'Adwaita'

# load gnome-terminal profiles preferences
notify "Loading terminal profiles..."
dconf load /org/gnome/terminal/legacy/profiles:/ < gnome-terminal-profiles.dconf

# cleaning apt
notify "Cleaning apt..."
sudo apt-get autoremove
sudo apt-get autoclean

sleep 2
notify "The gnome shell will be restarted so that new extensions can load properly."
sleep 3

function sleep_countdown () {
    i=$@
    echo "Restarting shell in..."
    while [ $i -gt 0 ]; do
	figlet "$i" | lolcat
	sleep 1
	let i=i-1
    done
}

sleep_countdown 5
killall -1 gnome-shell

# The End
notify "Done. Please reboot!"

## mamba create -n data -c pytorch -c conda-forge python=3.8 pytorch torchvision torchaudio cudatoolkit=11.3 tensorflow-gpu autograd bottleneck celerite2 emcee george PyWavelets tqdm xarray dynesty h5py ultranest numba astropy pymc3-ext astroquery lightkurve statsmodels seaborn opencv scikit-image pybind11
## conda install -c conda-forge mamba
exit 0
