#!/bin/bash -x

set -e

# update
echo "Updating..."
sudo apt update
sudo apt upgrade

# apt packages
APT_PACKAGES=(
    adb
    clang
    cmake
    dvipng
    emacs
    g++
    gfortran
    gimp
    git
    gnome-tweaks
    latexmk
    net-tools
    numix-gtk-theme
    numix-icon-theme-circle
    okular
    python3-tk
    python3-venv
    ssh
    vlc
)

sudo apt-get install $(APT_PACKAGES)

# sublime-text
# https://www.sublimetext.com/docs/3/linux_repositories.html
echo "Installing Sublime..."
wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -
sudo apt-get install apt-transport-https
echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list
sudo apt-get update
sudo apt-get install sublime-text

# set up ubuntu 20.04 for gaming
# https://www.reddit.com/r/linux4noobs/comments/g7753y/how_to_set_up_ubuntu_2004_for_gaming_tutorial/
echo "Setting up gaming..."
# install gpu driver
read -p "Which GPU? [nvidia/amd/intel] " -n 1 gpu
if [ ${gpu} == "nvidia" ]; then
    sudo add-apt-repository ppa:graphics-drivers/ppa
    sudo apt install nvidia-driver-440 libnvidia-gl-440 libnvidia-gl-440:i386
    sudo apt install libvulkan1 libvulkan1:i386
elif [${gpu} == "amd" -o ${gpu} == "intel" ]; then
    sudo dpkg --add-architecture i386
    sudo apt install libgl1-mesa-dri:i386
    sudo apt install mesa-vulkan-drivers mesa-vulkan-drivers:i386
else
    echo "Error: Invalid GPU!"
    exit 1
fi
# install wine staging
sudo dpkg --add-architecture i386 wget -nc https://dl.winehq.org/wine-builds/win...
sudo apt-key add winehq.key
sudo apt-add-repository 'deb https://dl.winehq.org/wine-builds/ubu... eoan main'
sudo apt-get update
sudo apt-get install --install-recommends wine-staging
sudo apt-get install libgnutls30:i386 libldap-2.4-2:i386 libgpg-error0:i386 libxml2:i386 libasound2-plugins:i386 libsdl2-2.0-0:i386 libfreetype6:i386 libdbus-1-3:i386 libsqlite3-0:i386
# install lutris
sudo add-apt-repository ppa:lutris-team/lutris
sudo apt-get update sudo apt-get install lutris
# install steam
sudo apt install steam
echo "Remember to manually enable Gamemode (Steam > Properties > SET LAUNCH OPTIONS > 'gamemoderun %command%' > OK)"
echo "For Lutris, navigate to Preferences > System Options > Command prefix > 'gamemoderun'"

# oh-my-zsh
# https://github.com/denysdovhan/spaceship-prompt
echo "Installing Oh My Zsh..."
sudo apt-get install zsh fonts-powerline
git clone https://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
git clone https://github.com/denysdovhan/spaceship-prompt.git ~/.oh-my-zsh/custom/themes/spaceship-prompt
ln -s ~/.oh-my-zsh/custom/themes/spaceship-prompt/spaceship.zsh-theme ~/.oh-my-zsh/custom/themes/spaceship.zsh-theme
chsh -s /bin/zsh

# load gnome-terminal profiles preferences
echo "Loading terminal profiles..."
dconf load /org/gnome/terminal/legacy/profiles:/ < gnome-terminal-profiels.dconf

# checkout dotfiles
# https://www.atlassian.com/git/tutorials/dotfiles
echo "Checking out config..."
function dot {
   /usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME $@
}
dot checkout
if [ $? = 0]; then
    echo "Checked out."
else
    echo "Backing up pre-existing dotfiles..."
    mkdir -p .config-backup
    config checkout 2>&1 | egrep "\s+\." | awk {'print $1'} | xargs -I{} mv {} .config-backup/{}
fi
dot checkout

# cleaning apt
echo "Cleaning apt..."
sudo apt-get autoremove
sudo apt-get autoclean

# The End
echo "Finish..."
exit 0
