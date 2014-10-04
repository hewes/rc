export ZDOTDIR=$HOME/rc/zsh

##-----------------------------------
## PATH
##-----------------------------------
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
  PATH=./:$HOME/bin:$HOME/rc/scripts:/bin:/sbin:/usr/local/bin/:/opt/local/bin:$PATH
    ;;
esac
