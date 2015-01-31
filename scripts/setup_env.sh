#!/bin/bash

ROOT_WRAPPER="sudo -E "

RBENV_DIR="${HOME}/.rbenv"
PYENV_DIR="${HOME}/.pyenv"
SRC_DIR="${HOME}/work"

function usage(){
  cat <<EOS
USAGE:
    ${0} {pyenv|rbenv|peco}
EOS
  exit 0
}

function is_linux(){
  [ -x /bin/uname ] && [ `/bin/uname` = 'Linux' ]
  return $?
}

function is_rhel(){
  test -e /etc/redhat-release
  return $?
}

function is_debian(){
  test -e /etc/debian_version
  return $?
}

function yum_install(){
  echo "install $*"
  ${ROOT_WRAPPER} yum -y install $* || error_exit "failed to install yum install"
}

function apt_get_install(){
  echo "install $*"
  ${ROOT_WRAPPER} apt-get install -y $* || error_exit "failed to install apt get install"
}

function mkdir_if_not_exist(){
  if [ -d $1 ];then
    echo "${1} already exists"
  else
    mkdir -p $1
  fi
}

function error_exit(){
  echo $*
  exit 1
}

function install_peco(){
  if is_linux ;then
    if [ -x "${HOME}/bin/peco" ];then
      echo "peco is already installed in ${HOME}/bin"
      return 1
    fi
    mkdir_if_not_exist "${HOME}/bin"
    mkdir_if_not_exist "${HOME}/work"
    pushd "${HOME}/work"
    if [ ! -e peco_linux_amd64.tar.gz ];then
      wget https://github.com/peco/peco/releases/download/v0.2.0/peco_linux_amd64.tar.gz
    fi
    tar -xzf peco_linux_amd64.tar.gz
    cp peco_linux_amd64/peco "${HOME}/bin/"
    rm -r peco_linux_amd64
    rm -r peco_linux_amd64.tar.gz
    popd
  else
    echo "other than linux is not supported"
  fi
}


function install_vim(){
  if is_rhel ;then
    echo "distribution is RHEL(or CentOS or Fedora)"
    yum_install gcc make ncurses-devel mercurial perl-devel perl-ExtUtils-Embed ruby-devel python-devel lua-devel
  elif is_debian; then
    echo "distribution is Debian(or Ubuntu)"
    apt_get_install mercurial gettext libncurses5-dev libacl1-dev libperl-dev libpython2.7-dev libgpm-dev lua5.2 liblua5.2-dev luajit libluajit-5.1
  else
    error_exit "unknown distribution"
  fi
  mkdir_if_not_exist ${SRC_DIR}
  if [ -d ${SRC_DIR}/vim ];then
    pushd ${SRC_DIR}/vim
    hg pull
  else
    pushd ${SRC_DIR}
    hg clone https://vim.googlecode.com/hg/ vim || error_exit "failed hg clone vim"
    cd vim
  fi
  ./configure --with-features=huge --enable-gui=gnome2 --enable-perlinterp --enable-pythoninterp --enable-rubyinterp --enable-luainterp --enable-fail-if-missing || error_exit "failed to configure"
  make || error_exit "failed to make"
  ${ROOT_WRAPPER} make install || error_exit "failed to make install"
  popd
}

function install_rbenv(){
  if is_rhel ;then
    echo "distribution is RHEL(or CentOS or Fedora)"
    yum_install git libyaml libyaml-devel zlib zlib-devel readline readline-devel openssl openssl-devel libxml2 libxml2-devel libxslt libxslt-devel
  elif is_debian; then
    echo "distribution is Debian(or Ubuntu)"
    apt_get_install git autoconf bison build-essential libssl-dev libyaml-dev libreadline6-dev zlib1g-dev libncurses5-dev
  else
    error_exit "unknown distribution"
  fi

  if [ ! -d ${RBENV_DIR} ];then
    git clone https://github.com/sstephenson/rbenv.git $RBENV_DIR >> /dev/null || error_exit "failed to clone rbenv"
  else
    echo "${RBENV_DIR} already exists skip cloning rbenv"
  fi
  mkdir_if_not_exist ${RBENV_DIR}/plugins
  if [ ! -d ${RBENV_DIR}/plugins/ruby-build ];then
    git clone https://github.com/sstephenson/ruby-build.git ${RBENV_DIR}/plugins/ruby-build >> /dev/null || error_exit "failed to clone rbuild"
  else
    echo "${RBENV_DIR}/plugins/ruby-build already exists, skip cloning ruby-build"
  fi
}

function install_pyenv(){
  if is_rhel ;then
    echo "distribution is RHEL(or CentOS or Fedora)"
    yum_install git zlib-devel bzip2 bzip2-devel readline-devel sqlite sqlite-devel
  elif is_debian; then
    echo "distribution is Debian(or Ubuntu)"
    apt_get_install git make build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev wget curl
  else
    error_exit "unknown distribution"
  fi

  if [ ! -d ${PYENV_DIR} ];then
    git clone https://github.com/yyuu/pyenv ${PYENV_DIR} >> /dev/null || error_exit "failed to clone pyenv"
  else
    echo "${PYENV_DIR} already exists skip cloning pyenv"
  fi
  mkdir_if_not_exist ${PYENV_DIR}/plugins
  if [ ! -d ${PYENV_DIR}/plugins/pyenv-virtualenv ];then
    git clone https://github.com/yyuu/pyenv-virtualenv.git ${PYENV_DIR}/plugins/pyenv-virtualenv
  else
    echo "${PYENV_DIR}/plugins/pyenv-virtualenv already exists skip cloning pyenv-virtualenv"
  fi
}

case $1 in
  rbenv)
    install_rbenv
    ;;
  pyenv)
    install_pyenv
    ;;
  peco)
    install_peco
    ;;
  install_vim)
    install_vim
    ;;
  *)
    usage
    ;;
esac

