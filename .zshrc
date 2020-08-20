export PATH=/usr/local/cuda-11.0/bin:$HOME/bin:/usr/local/bin:$PATH
export LD_LIBRARY_PATH=/usr/local/cuda-11.0/lib64:$LD_LIBRARY_PATH
export QT_IM_MODULE=fcitx
export XMODIFIERS=@im=fcitx
export GTK_IM_MODULE=fcitx

export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="spaceship"

CASE_SENSITIVE="true"

plugins=(git
	 python
	 adb
	 catimg
	 ubuntu
	 safe-paste
	 lol
	 alias-finder
	 zsh-autosuggestions
	 zsh-syntax-highlighting)

source $ZSH/oh-my-zsh.sh
source $HOME/.aliases.sh
