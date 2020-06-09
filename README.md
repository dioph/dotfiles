# Dotfiles

## Installation

This assumes a bare repo (see https://www.atlassian.com/git/tutorials/dotfiles)

To install, first clone this repo with 
__`git clone --bare https://github.com/dioph/dotfiles.git $HOME/.cfg`__,
then define an alias for using git in your home dir such as
__`alias dot='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'`__.
Use this alias to checkout (__`dot checkout`__) and if it complains about
previously existing files you might want to backup first before overwriting.

Finally, edit `install.sh` as needed and run it to set everything up.

### Sample script
```bash
which git &> /dev/null
if [ $? -ne 0 ]; then
    echo "Installing git..."
    sudo apt install -y git
else
    echo "Git is installed."
fi
git clone --bare https://github.com/dioph/dotfiles.git $HOME/.cfg
function dot {
   /usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME $@
}
dot checkout
if [ $? = 0 ]; then
    echo "Checked out."
else
    echo "Backing up pre-existing dotfiles..."
    mkdir -p .config-backup
    dot checkout 2>&1 | egrep "\s+\." | awk {'print $1'} | xargs -I{} mv {} .config-backup/{}
fi
dot checkout
```
