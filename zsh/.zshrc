######
######  .zshrc
######

if [ -d /opt/homebrew/opt/zplug ];then
  # if MacOS and zplug is installed by homebrew
  export ZPLUG_HOME=/opt/homebrew/opt/zplug
else
  # curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh | zsh
  export ZPLUG_HOME=$HOME/.zplug
fi

if [ -d $ZPLUG_HOME ];then
  # zplug
  source $ZPLUG_HOME/init.zsh
  zplug 'zplug/zplug', hook-build:'zplug --self-manage'

  # syntax highlight (https://github.com/zsh-users/zsh-syntax-highlighting)
  zplug "zsh-users/zsh-syntax-highlighting"

  # history
  zplug "zsh-users/zsh-history-substring-search"

  # completion
  zplug "zsh-users/zsh-autosuggestions"
  zplug "zsh-users/zsh-completions"

  zplug "chrissicool/zsh-256color"

  # Install plugins if there are plugins that have not been installed
  if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
      echo; zplug install
    fi
  fi
  # Then, source plugins and add commands to $PATH
  zplug load
fi

##-----------------------------------
## ENVIRONMENT
##-----------------------------------

##HOST
export  HOST=`uname -n`
export  hostname=$HOST

##HOSTOS
export  HOSTOS=`uname`
export  hostos=$HOSTOS
export	osversion=`uname -r`

##TERMINAL
#export  TERM=xterm
#export  TERMINAL_EMULATOR=xterm

## VALIDVERSION

export PAGER='less'
export MORE='-c'

#export AWT_TOOLKIT=MToolkit

##-----------------------------------
## LANG
##-----------------------------------

#export LANG=ja_JP.UTF-8
#export LANGUAGE=ja_JP.UTF-8
#export GDM_LANG=jp_JP.UTF-8
#export LC_ALL=C
#export LC_MESSAGES=C

export PATH="${HOME}/google-cloud-sdk/bin/:/usr/local/bin/:${PATH}"

## LIBRARY PATH
export LD_LIBRARY_PATH=".:/usr/local/lib:/usr/X11/lib:/usr/openwin/lib:/usr/lib:/usr/local/lib:/usr/X11R5/lib:/usr/X11R6/lib:/usr/ucblib:/usr/local/canna/lib:/usr/local/X11/lib:/usr/lib/locale/ja/wnn/lib:/usr/local/rvplayer5.0:/usr/local/ssl/lib:/etc/lib:/home/hewes/Javalib"

##-----------------------------------
## PROMPT
##-----------------------------------
##
autoload colors
colors

case ${UID} in
  0)
    PROMPT="%{$fg[red]%}<%T>%{$fg[red]%}[root@%m] %(!.#.$) %{${reset_color}%}%{${fg[red]}%}[%~]%{${reset_color}%} "
    PROMPT2="%{${fg[red]}%}%_> %{${reset_color}%}"
    SPROMPT="%{${fg[red]}%}correct: %R -> %r [nyae]? %{${reset_color}%}"
    RPROMPT="%{${fg[cyan]}%}[%~]%{${reset_color}%} "
    ;;
  *)
    autoload -Uz vcs_info
    zstyle ':vcs_info:*' formats '(%s: %b)'
    zstyle ':vcs_info:*' actionformats '(%s)-[%b|%a]'
    precmd () {
      psvar=()
      LANG=en_US.UTF-8 vcs_info
      [[ -n "$vcs_info_msg_0_" ]] && psvar[1]="$vcs_info_msg_0_"
    }
    TIME_FORMAT="%{${fg[yellow]}%}<%T>"
    USER_AND_HOST="%{$fg[white]%}[%n@%m]"
    CURRENT_DIR="%{${fg[yellow]}%}[%~]"
    RESET_COLOR="%{${reset_color}%}"
    PROMPT="
${TIME_FORMAT}${USER_AND_HOST}${RESET_COLOR}%  ${CURRENT_DIR}${RESET_COLOR} %1(v|%F{green}%1v%f|)
%% "
    PROMPT2="%{${fg[red]}%}%_> %{${reset_color}%}"
    SPROMPT="%{${fg[red]}%}correct: %R -> %r [nyae]? %{${reset_color}%}"
    RPROMPT=""
    ;;
esac

##-----------------------------------
## history
##-----------------------------------
##

HISTFILE=$ZDOTDIR/.zhistory
HISTSIZE=100000
SAVEHIST=100000
setopt extended_history
setopt share_history
setopt hist_verify
setopt hist_ignore_space
setopt hist_no_store
setopt hist_find_no_dups

##-----------------------------------
## completion
##-----------------------------------
##

#zstyle ':completion:*' list-colors ''
zstyle ':completion:*:default' menu select=1
zstyle ':completion:*' keep-prefix
zstyle ':completion:*' use-cache true
zstyle ':completion:*:cd' tag-order local-directories
# when "sudo" add hoge/sbin to path
#zstyle ':completion:*:sudo:*' command-path /usr/local/sbin /sbin /usr/sbin
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# show complete candidates as groups
zstyle ':completion:*' group-name ''
zstyle ':completion:*:descriptions' format $'%B%{\e[33m%}Completing %d%b'

autoload -U compinit
compinit

setopt list_types
setopt auto_list
setopt auto_pushd

# for BSD
export LSCOLORS=gxfxcxdxbxegedabagacad

# for GNU
LS_COLORS='di=94:ln=35:so=32:pi=33:ex=31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'
export LS_COLORS
export ZLS_COLORS=$LS_COLORS

#zstyle ':completion:*' list-colors 'di=34' 'ln=35' 'so=32' 'ex=31' 'bd=46;34' 'cd=43;34'
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}

setopt auto_cd

setopt auto_param_keys

setopt auto_param_slash

## TAB
setopt auto_menu

## --prefix=/usr
setopt magic_equal_subst

# setopt list_packed

#autoload predict-on
#predict-on

if [ $OSTYPE != cygwin ];then
  limit coredumpsize 102400
fi

unsetopt promptcr

## Emacs like keybind
bindkey -e

## vi like keybind
#bindkey -v

setopt prompt_subst
setopt nobeep
setopt long_list_jobs
setopt auto_resume
setopt pushd_ignore_dups
setopt extended_glob
setopt equals
setopt numeric_glob_sort
setopt print_eight_bit
setopt correct
setopt brace_ccl
setopt NO_flow_control
setopt interactive_comments
setopt mark_dirs
setopt no_flow_control
setopt noautoremoveslash
#unsetopt autoremoveslash
setopt appendhistory
setopt extendedglob
setopt notify
setopt nomatch

WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'$

#setopt noglob
#unsetopt nomatch

zstyle :compinstall filename '$ZDOTDIR/.zshrc'

export JLESSCHARSET=japanese-euc
export EDITOR=vim

##---------------------------
##ALIAS
##---------------------------
if [[ $OSTYPE =~ linux ]]; then
# for GNU ls
  alias	ls='ls --color=auto -F'
  alias	ls='ls -lF --color=auto'
  alias	la='ls -aF --color=auto'
  alias	grep='grep --color=auto'
else
# for BSD ls
  alias	ls='ls -G'
  alias	ls='ls -l -G'
  alias	la='ls -a -G'
fi

alias	s='screen'
alias	ss='screen -S'
alias	sr='screen -D -RR'
alias	tmr='tmux attach -t 0 || tmux'

autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^P" history-beginning-search-backward-end
bindkey "^N" history-beginning-search-forward-end

if [ -d $HOME/.rbenv ]; then
    export PATH=$HOME/.rbenv/bin:$PATH
    eval "$(rbenv init -)"
fi

if [ -d $HOME/.pyenv ]; then
    export PATH=$HOME/.pyenv/bin:$PATH
    eval "$(pyenv init -)"
fi

if [ -d $HOME/.nodebrew ]; then
    export PATH=$HOME/.nodebrew/current/bin:$PATH
fi

if type zprof > /dev/null 2>&1; then
  zprof | less
fi

if [ -d /opt/homebrew/bin ];then
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

if hash starship ;then
  eval "$(starship init zsh)"
fi

