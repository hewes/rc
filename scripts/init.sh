#/bin/bash

rc3=(vimrc gvimrc vim zshenv screenrc tmux.conf)
rc5=(xmonad Xdefaults xinitrc Xmodmap xmobarrc vimperatorrc fehbg)

function setup(){
  for file in ${files[*]};do
    if [ -e $HOME/.${file} ];then
      echo "${file} already exists"
    else
      ln -s $HOME/rc/${file} $HOME/.${file}
    fi
  done
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

