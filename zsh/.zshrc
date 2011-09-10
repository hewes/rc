######
######  .zshrc
######
###### Last update by hewes 10/07/13

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

export LANG=ja_JP.UTF-8
export LANGUAGE=ja_JP.UTF-8
export GDM_LANG=jp_JP.UTF-8
export LC_ALL=C
export LC_MESSAGES=C

##-----------------------------------
## PATH
##-----------------------------------

## LIBRARY PATH
export LD_LIBRARY_PATH=".:/usr/local/lib:/usr/X11/lib:/usr/openwin/lib:/usr/lib:/usr/local/lib:/usr/X11R5/lib:/usr/X11R6/lib:/usr/ucblib:/usr/local/canna/lib:/usr/local/X11/lib:/usr/lib/locale/ja/wnn/lib:/usr/local/rvplayer5.0:/usr/local/ssl/lib:/etc/lib:/home/hewes/Javalib"

## EXE PATH
case ${UID} in
0)
	path=( ./ \
		/bin \
		/sbin \
		/usr/local/bin \
		/usr/local/sbin \
		/usr/sbin \
		/usr/bin \
		)
    ;;
*)
  PATH=$PATH:./:/bin:/sbin:/opt/local/bin
    ;;
esac

## MAN PATH
export MANPATH="/opt/SUNWspro/man:/usr/man:/usr/local/man:/usr/openwin/man:/usr/X11R5/man:/usr/X11R6/man:/usr/dt/man:/opt/gnu/man:/opt/SUNWspro/man:/home/gaea.home10/DEMO/SUNWspro/man:/alliance/man:/home/project/spice3f4/man:/usr/local/ssl/"


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
  zstyle ':vcs_info:*' formats '(%s:%b)'
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
	PROMPT="${TIME_FORMAT}${USER_AND_HOST}${RESET_COLOR}%% "
	PROMPT2="%{${fg[red]}%}%_> %{${reset_color}%}"
	SPROMPT="%{${fg[red]}%}correct: %R -> %r [nyae]? %{${reset_color}%}"
	RPROMPT="%1(v|%F{green}%1v%f|)${CURRENT_DIR}$RESET_COLOR"
	;;
esac

##-----------------------------------
## history
##-----------------------------------
##

HISTFILE=$ZDOTDIR/.zhistory

HISTSIZE=100000

SAVEHIST=100000

setopt hist_ignore_dups

setopt extended_history

setopt share_history

setopt hist_verify

setopt hist_ignore_space

setopt hist_no_store


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

###############
# auto-fu-init
###############
#source $ZDOTDIR/auto-fu.zsh; zle-line-init(){ auto-fu-init; }; zle -N zle-line-init
#function(){
  #local code
  #code=${functions[auto-fu-init]/'\n-azfu-'/''}
  #eval "function auto-fu-init () { $code }"
#}

# eval `dircolors`
export LSCOLORS=exfxcxdxbxegedabagacad

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

limit coredumpsize 102400

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
source $ZDOTDIR/.zalias

# set terminal title including current directory
#if [ $TERM = "screen" ];then
  #precmd() {
    #echo -ne "\033]0;${PWD}\007"
  #}
#fi

function chpwd(){
  ls
}

autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^P" history-beginning-search-backward-end
bindkey "^N" history-beginning-search-forward-end

function edit-file() {
    zle -I
    local file
    local -a words

    words=(${(z)LBUFFER})
    file="${words[$#words]}"
    [[ -f "$file" ]] && $EDITOR "$file"
}
zle -N edit-file
bindkey "^x^f" edit-file

function view-file() {
    zle -I
    local file
    local -a words

    words=(${(z)LBUFFER})
    file="${words[$#words]}"
    [[ -f "$file" ]] && $PAGER "$file"
}
zle -N view-file
bindkey "^x^r" view-file

