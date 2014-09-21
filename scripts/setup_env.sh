#!/bin/bash

function is_rhel(){
  test -e /etc/redhat-release
  return $?
}

function is_debian(){
  test -e /etc/debian_release
  return $?
}

function check_git_is_executable(){
  if [ ! -x git ];then
    error_exit "git is not in PATH"
  fi
}

function prepare_rbenv(){
  if is_rhel ;then
    echo "distribution is RHEL(or CentOS or Fedora)"
    echo "install git install libyaml libyaml-devel zlib zlib-devel readline readline-devel openssl openssl-devel libxml2 libxml2-devel libxslt libxslt-devel"
    sudo -E yum -y git install libyaml libyaml-devel zlib zlib-devel readline readline-devel openssl openssl-devel libxml2 libxml2-devel libxslt libxslt-devel
  elif is_debian; then
    echo "distribution is Debian(or Ubuntu)"
    echo "install git autoconf bison build-essential libssl-dev libyaml-dev libreadline6-dev zlib1g-dev libncurses5-dev"
    sudo -E apt-get install git autoconf bison build-essential libssl-dev libyaml-dev libreadline6-dev zlib1g-dev libncurses5-dev
  else
    # if debian distribution
    echo "unknown distribution"
  fi
}

function prepare_pyenv(){
  if is_rhel ;then
    echo "distribution is RHEL(or CentOS or Fedora)"
    echo "install git zlib-devel bzip2 bzip2-devel readline-devel sqlite sqlite-devel"
    sudo -E yum install -y git zlib-devel bzip2 bzip2-devel readline-devel sqlite sqlite-devel
  elif is_debian; then
    echo "distribution is Debian(or Ubuntu)"
    echo "install git make build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev wget curl"
    sudo -E apt-get install git make build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev wget curl
  else
    # if debian distribution
    echo "unknown distribution"
  fi
}

function error_exit(){
  echo $*
  exit 1
}

case $1 in
  rbenv)
    prepare_rbenv
    if [ ! -d ~/.rbenv ];then
      git clone https://github.com/sstephenson/rbenv.git ~/.rbenv >> /dev/null || error_exit "failed to clone rbenv"
    else
      echo "~/.rbenv already exists skip cloning rbenv"
    fi
    [ ! -d ~/.rbenv/plugins ] || error_exit "~/.rbenv exists but ~/.rbenv/plugins does not exist"
    if [ ! -d ~/.rbenv/plugins ];then
      git clone https://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build  || error_exit "failed to clone rbuild"
    else
      echo "~/.rbenv/plugins/ruby-build already exists, skip cloning ruby-build"
    fi
    ;;
  pyenv)
    prepare_pyenv
    if [ ! -d ~/.pyenv ];then
      git clone https://github.com/yyuu/pyenv ~/.pyenv >> /dev/null || error_exit "failed to clone pyenv"
    else
      echo "~/.pyenv already exists skip cloning pyenv"
    fi
esac

