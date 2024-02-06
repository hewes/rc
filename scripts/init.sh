#/bin/bash

rc3=(peco gitconfig gitconfig.common vimrc gvimrc vim zshenv screenrc tmux.conf)
rc5=(xmonad Xdefaults xinitrc Xmodmap xmobarrc fehbg)

function setup(){
  for file in ${files[*]};do
    if [ -e $HOME/.${file} ];then
      echo "${file} already exists"
    else
      ln -s $HOME/rc/${file} $HOME/.${file}
    fi
  done
  if [ -e $HOME/.config ];then
    mkdir -p $HOME/.config
  fi
  if [ -e $HOME/.config/nvim ];then
    echo ".config/nvim already exists"
  else
    mkdir -p $HOME/.config
    ln -s $HOME/rc/nvim $HOME/.config/nvim
  fi
}

case $1 in
  rc3)
    files=(${rc3[*]})
    ;;
  rc5)
    files=(${rc3[*]} ${rc5[*]})
    ;;
  *)
    files=(${rc3[*]})
    ;;
esac

setup

