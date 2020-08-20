#!/bin/zsh

set -e

notify () {
    echo -e "\n\033[1;33m${1}\033[0m\n"
}

# update
pamac checkupdates -a
pamac upgrade -a

# pacman packages
pamac install calibre clang cmake figlet firefox gimp nasm neofetch lolcat mpv net-tools pdfarranger telegram-desktop

# latex stuff
pamac install texstudio texlive-fontsextra

# i3 stuff
pamac install i3-gaps alacritty i3blocks
git clone https://github.com/vivien/i3blocks-contrib.git  ~/.config/i3blocks/i3blocks-contrib
pamac install feh playerctl rofi sysstat yad
pamac build i3lock-fancy-git

# intel_backlight
notify "Allow writing in intel_backlight/brightness"
sudo echo "$USER $HOST = (root) NOPASSWD: /usr/bin/tee" | sudo tee /etc/sudoers.d/backlight
sudo chmod 440 /etc/sudoers.d/backlight

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
    pamac install nvidia-dkms nvidia-utils lib32-nvidia-utils vulkan-icd-loader lib32-vulkan-icd-loader
elif [ ${gpu} = "amd" ]; then
    pamac install lib32-mesa vulkan-radeon lib32-vulkan-radeon vulkan-icd-loader lib32-vulkan-icd-loader
elif [ ${gpu} = "intel"]; then
    pamac install lib32-mesa vulkan-intel lib32-vulkan-intel vulkan-icd-loader lib32-vulkan-icd-loader
else
    notify "Unknown GPU! Skipping..."
fi
## wine, lutris, steam
pamac install wine-staging lutris steam

# fonts
pamac install ttf-cascadia-code otf-font-awesome ttf-font-awesome fcitx-mozc manjaro-asian-input-support-fcitx
mkdir -p ~/.local/share/fonts
wget -q https://github.com/adam7/delugia-code/releases/download/v2007.01/Delugia.Nerd.Font.ttf
mv Delugia.Nerd.Font.ttf ~/.local/share/fonts/

# oh-my-zsh
git clone https://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions.git ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
git clone https://github.com/denysdovhan/spaceship-prompt.git ~/.oh-my-zsh/custom/themes/spaceship-prompt
ln -s ~/.oh-my-zsh/custom/themes/spaceship-prompt/spaceship.zsh-theme ~/.oh-my-zsh/custom/themes/spaceship.zsh-theme
chsh -s /bin/zsh

# emacs
pamac install emacs
git clone https://github.com/dioph/.emacs.d.git  ~/.emacs.d

# python
pamac install tk
python -m venv ~/venvs/astro
source ~/venvs/astro/bin/activate
python -m pip install --upgrade pip wheel
pip install astropy astroquery emcee ipython jupyter lightkurve matplotlib numpy pandas pybind11 pymc3 PyWavelets sklearn scipy tqdm
pip install celerite george exoplanet
deactivate

# vscodium
pamac build vscodium-bin

# optional
pamac build discord_arch_electron zoom
# TODO: spotify virtualbox libreoffice android-studio slack anki

# youtube-dl
sudo wget https://yt-dl.org/downloads/latest/youtube-dl -O /usr/local/bin/youtube-dl
sudo chmod a+rx /usr/local/bin/youtube-dl
hash -r

# The End
notify "Done. Please reboot!"
exit 0
