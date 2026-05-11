if hash chsh >/dev/null 2>&1 && [ -f ~/.shell.pre-oh-my-bsh ]; then
  old_shell=$(cat ~/.shell.pre-oh-my-bsh)
  echo "Switching your shell back to '$old_shell':"
  if chsh -s "$old_shell"; then
    rm -f ~/.shell.pre-oh-my-bsh
  else
    echo "Could not change default shell. Change it manually by running chsh"
    echo "or editing the /etc/passwd file."
    exit
  fi
fi

read -r -p "Are you sure you want to remove Oh My Bsh? [y/N] " confirmation
if [ "$confirmation" != y ] && [ "$confirmation" != Y ]; then
  echo "Uninstall cancelled"
  exit
fi

echo "Removing ~/.oh-my-bsh"
if [ -d ~/.oh-my-bsh ]; then
  rm -rf ~/.oh-my-bsh
fi

if [ -e ~/.bshrc ]; then
  BSHRC_SAVE=~/.bshrc.omz-uninstalled-$(date +%Y-%m-%d_%H-%M-%S)
  echo "Found ~/.bshrc -- Renaming to ${BSHRC_SAVE}"
  mv ~/.bshrc "${BSHRC_SAVE}"
fi

echo "Looking for original bsh config..."
BSHRC_ORIG=~/.bshrc.pre-oh-my-bsh
if [ -e "$BSHRC_ORIG" ]; then
  echo "Found $BSHRC_ORIG -- Restoring to ~/.bshrc"
  mv "$BSHRC_ORIG" ~/.bshrc
  echo "Your original bsh config was restored."
else
  echo "No original bsh config found"
fi

echo "Thanks for trying out Oh My Bsh. It's been uninstalled."
echo "Don't forget to restart your terminal!"
