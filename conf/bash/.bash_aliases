eval "`dircolors -b`"
alias ~='cd ~'
alias ..='cd ..'
alias ...='cd ../..'
alias ls='ls --color=auto'
alias dir='ls --color=auto --format=vertical'
alias vdir='ls --color=auto --format=long'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias upg='sudo apt-get upgrade'
alias inst='apt-get install'
alias d='cd ~/Desktop'
alias zf=/usr/local/zend/share/ZendFramework/bin/zf.sh
alias mkdir='mkdir -v'
alias myip='wget http://checkip.dyndns.org/ -O - -o /dev/null | cut -d: -f 2 | cut -d\< -f 1'
alias www="cd /var/www/"
alias ll='ls -alh --color=auto'
alias mmm="su -c 'sync && echo 3 > /proc/sys/vm/drop_caches'"

### Calls to functions
alias s='pacsearch'
alias ctar='mktar'
alias cgz='mkgz'
alias cbz='mkbz'
alias x='extract'
