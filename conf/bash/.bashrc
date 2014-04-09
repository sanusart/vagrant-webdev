[ -z "$PS1" ] && return
export HISTCONTROL=ignoredups
export HISTCONTROL=ignoreboth
shopt -s checkwinsize
[ -x /usr/bin/lesspipe ] && eval "$(lesspipe)"

case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

force_colored_prompt=yes
unset color_prompt force_color_prompt

# Titlebar name set
case "$TERM" in
    xterm*|rxvt*)
        PROMPT_COMMAND='echo -ne "\0033]0;${USER}  ${PWD/$HOME/~}\007"'
        ;;
    *)
        ;;
esac

##### NORMAL => ##### PS1='[\u@\h \W]\$ '
##### My =>
TXTBLK='\[\e[0;30m\]' # Black - Regular
TXTRED='\[\e[0;31m\]' # Red
TXTGRN='\[\e[0;32m\]' # Green
TXTYLW='\[\e[0;33m\]' # Yellow
TXTBLU='\[\e[0;34m\]' # Blue
TXTPUR='\[\e[0;35m\]' # Purple
TXTCYN='\[\e[0;36m\]' # Cyan
TXTWHT='\[\e[0;37m\]' # White
BLDBLK='\[\e[1;30m\]' # Black - Bold
BLDRED='\[\e[1;31m\]' # Red
BLDGRN='\[\e[1;32m\]' # Green
BLDYLW='\[\e[1;33m\]' # Yellow
BLDBLU='\[\e[1;34m\]' # Blue
BLDPUR='\[\e[1;35m\]' # Purple
BLDCYN='\[\e[1;36m\]' # Cyan
BLDWHT='\[\e[1;37m\]' # White
UNDBLK='\[\e[4;30m\]' # Black - Underline
UNDRED='\[\e[4;31m\]' # Red
UNDGRN='\[\e[4;32m\]' # Green
UNDYLW='\[\e[4;33m\]' # Yellow
UNDBLU='\[\e[4;34m\]' # Blue
UNDPUR='\[\e[4;35m\]' # Purple
UNDCYN='\[\e[4;36m\]' # Cyan
UNDWHT='\[\e[4;37m\]' # White
BAKBLK='\[\e[40m\]'   # Black - Background
BAKRED='\[\e[41m\]'   # Red
BAKGRN='\[\e[42m\]'   # Green
BAKYLW='\[\e[43m\]'   # Yellow
BAKBLU='\[\e[44m\]'   # Blue
BAKPUR='\[\e[45m\]'   # Purple
BAKCYN='\[\e[46m\]'   # Cyan
BAKWHT='\[\e[47m\]'   # White
TXTRST='\[\e[0m\]'    # Text Reset

PS1="$BAKGRN$BLDWHT \u $BAKWHT$BLDBLK \w $BLDWHT$BAKYLW\$(show_git_branch)$TXTRST$BLDWHT$BAKCYN > $TXTRST "
### PS1="$BAKWHT$BLDBLK \w  $TXTRST$BLDWHT >$TXTRST "
### PS1=">"

### HOME
export HOME="/home/$USER"

### Include bin dir per user
export PATH=~/bin:$PATH

### Path to .inputrc
export INPUTRC=$HOME/.inputrc

### System-wide editor (instead of VI).
### Editor.
export EDITOR=nano
export VISUAL=$EDITOR

###  Fast shellcompletion
set show-all-if-ambiguous on

### Includes
if [ -f ~/.bash_functions ]; then . ~/.bash_functions; fi
if [ -f ~/.bash_aliases ]; then . ~/.bash_aliases; fi
if [ -f /etc/bash_completion ]; then . /etc/bash_completion; fi
