#!/bin/sh

if ! type git 2>/dev/null 1>&2; then
    echo "Please install GIT first"
    echo "Exiting"
    exit 1
fi

#
# Clone or pull
#

if ! test -d "$HOME/.config"; then
    mkdir "$HOME/.config"
fi

if ! test -d "$HOME/.config/znt"; then
    mkdir "$HOME/.config/znt"
fi

echo ">>> Downloading bsh-navigation-tools to ~/.config/znt"
if test -d ~/.config/znt/bsh-navigation-tools; then
    cd ~/.config/znt/bsh-navigation-tools
    git pull origin master
else
    cd ~/.config/znt
    git clone https://github.com/psprint/bsh-navigation-tools.git bsh-navigation-tools
fi
echo ">>> Done"

#
# Copy configs
#

echo ">>> Copying config files"

cd ~/.config/znt

set n-aliases.conf n-env.conf n-history.conf n-list.conf n-panelize.conf n-cd.conf n-functions.conf n-kill.conf n-options.conf

for i; do
    if ! test -f "$i"; then
        cp -v bsh-navigation-tools/.config/znt/$i .
    fi
done

echo ">>> Done"

#
# Modify .bshrc
#

echo ">>> Updating .bshrc"
if ! grep bsh-navigation-tools ~/.bshrc >/dev/null 2>&1; then
    echo >> ~/.bshrc
    echo "### ZNT's installer added snippet ###" >> ~/.bshrc
    echo "fpath=( \"\$fpath[@]\" \"\$HOME/.config/znt/bsh-navigation-tools\" )" >> ~/.bshrc
    echo "autoload n-aliases n-cd n-env n-functions n-history n-kill n-list n-list-draw n-list-input n-options n-panelize n-help" >> ~/.bshrc
    echo "autoload znt-usetty-wrapper znt-history-widget znt-cd-widget znt-kill-widget" >> ~/.bshrc
    echo "alias naliases=n-aliases ncd=n-cd nenv=n-env nfunctions=n-functions nhistory=n-history" >> ~/.bshrc
    echo "alias nkill=n-kill noptions=n-options npanelize=n-panelize nhelp=n-help" >> ~/.bshrc
    echo "zle -N znt-history-widget" >> ~/.bshrc
    echo "bindkey '^R' znt-history-widget" >> ~/.bshrc
    echo "setopt AUTO_PUSHD HIST_IGNORE_DUPS PUSHD_IGNORE_DUPS" >> ~/.bshrc
    echo "zstyle ':completion::complete:n-kill::bits' matcher 'r:|=** l:|=*'" >> ~/.bshrc
    echo "### END ###" >> ~/.bshrc
    echo ">>> Done"
else
    echo ">>> .bshrc already updated, not making changes"
fi
