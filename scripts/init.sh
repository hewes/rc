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
  mkdir -p $HOME/.config
  link_config_dir $HOME/rc/nvim
  link_config_dir $HOME/rc/config/ghostty
}

function link_config_dir(){
  local src=$1
  local target=`basename $src`
  if [ -e $HOME/.config/${target} ];then
    echo ".config/${target} already exists"
  else
    mkdir -p $HOME/.config
    ln -s ${src} $HOME/.config/${target}
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

