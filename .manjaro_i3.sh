#!/bin/zsh

set -e

notify () {
    echo -e "\n\033[1;33m${1}\033[0m\n"
}

# update
notify "Updating..."
sudo pacman-mirrors --fasttrack && pacman -Syyu

# pacman packages (down=400M, inst=1.7G)
pamac install calibre clang cmake figlet firefox gimp nasm neofetch lolcat mpv net-tools pdfarranger telegram-desktop xclip
pamac build numix-gtk-theme numix-circle-icon-theme-git

# latex stuff (down=760M, inst=2.2G)
pamac install texstudio texlive-fontsextra

# i3 stuff
pamac install i3-gaps alacritty i3blocks
git clone https://github.com/vivien/i3blocks-contrib.git  ~/.config/i3blocks/i3blocks-contrib
pamac install feh playerctl rofi sysstat yad
pamac build i3lock-fancy-git

# pulseaudio
pamac install manjaro-pulse pavucontrol

# intel_backlight
notify "Allow writing in intel_backlight/brightness"
sudo echo "$USER $HOST = (root) NOPASSWD: /usr/bin/tee" | sudo tee /etc/sudoers.d/backlight
sudo chmod 440 /etc/sudoers.d/backlight

# sublime (down=13M, inst=35M)
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
## wine, lutris, steam (down=170M, inst=1.1G)
pamac install wine-staging lutris steam

# fonts (down=25M, inst=70M)
pamac install ttf-cascadia-code fcitx-mozc manjaro-asian-input-support-fcitx
pamac build ttf-vlgothic ttf-font-awesome-4
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

# emacs (down=45M, inst=150M)
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

# vscodium (down=88M, inst=258M)
pamac build vscodium-bin

# kvm
pamac install virt-manager qemu virt-viewer dnsmasq bridge-utils openbsd-netcat ebtables
sudo systemctl enable --now libvirtd.service

# optional (inst=2.5G)
pamac install anki streamlink transmission-gtk libreoffice-still
pamac build android-studio bitwarden discord_arch_electron slack-desktop zoom
# TODO: spotify virtualbox

# youtube-dl
sudo wget https://yt-dl.org/downloads/latest/youtube-dl -O /usr/local/bin/youtube-dl
sudo chmod a+rx /usr/local/bin/youtube-dl
hash -r

# clean
pamac remove palemoon-bin conky nitrogen rxvt-unicode vim

# TROUBLESHOOTING
## if mic is not recognized and hardware is Dell (Intel):
### write to /etc/modprobe.d/headset.conf:
#### options snd-hda-intel model=dell-headset-multi
## if soundcards are not found (to test, do cat /proc/asound/cards):
### downgrade linux kernel to 5.4
## automatically unlock gnome-keyring:
### write to /etc/pam.d/login:
#### #%PAM-1.0
####
#### auth       required     pam_securetty.so
#### auth       requisite    pam_nologin.so
#### auth       include      system-local-login
#### auth       optional     pam_gnome_keyring.so
#### account    include      system-local-login
#### session    include      system-local-login
#### session    optional     pam_gnome_keyring.so auto_start
## touchpad config:
### write to /etc/X11/xorg.conf.d/30-touchpad.conf:
#### Section "InputClass"
#### Identifier "touchpad"
####     Driver "libinput"
####     MatchIsTouchpad "on"
####     Option "Tapping" "on"
#### EndSection

# The End
notify "Done. Please reboot!"
exit 0
