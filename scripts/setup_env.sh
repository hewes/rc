#!/bin/bash

RBENV_DIR="~/.rbenv"
PYENV_DIR="~/.pyenv"

function usage(){
  cat <<EOS
USAGE:
    ${0} {pyenv|rbenv}
EOS
  exit 0
}

function is_rhel(){
  test -e /etc/redhat-release
  return $?
}

function is_debian(){
  test -e /etc/debian_release
  return $?
}

function yum_install(){
  echo "install $*"
  sudo -E yum -y $*
}

function apt_get_install(){
  echo "install $*"
  sudo apt-get install -y $*
}

function mkdir_if_not_exist(){
  [ ! -d $1 ] || mkdir -p $1
}

function error_exit(){
  echo $*
  exit 1
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
  *)
    usage
    ;;
esac

