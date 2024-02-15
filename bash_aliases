# Enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
  test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
  alias ls='ls --color=auto'
  alias grep='grep --color=auto'
  alias fgrep='fgrep --color=auto'
  alias egrep='egrep --color=auto'
fi

# Navigation
alias ..='cd ..; ls'

# More ways to ls
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Copy/paste
if [[ "$OSTYPE" == "linux-gnu" ]]; then
  alias pbcopy='xclip -i -selection clipboard'
  alias pbpaste='xclip -o -selection clipboard'
fi

# Switch to neovim
alias vim='nvim'
export EDITOR=nvim
export PSQL_EDITOR="/usr/bin/nvim"

# Bel signal
alias bel='echo -ne "\007"'

# Databases
# Change this to temporarily use psql
export PSQL=pgcli

if [[ "$OSTYPE" == "linux-gnu" ]]; then
  export CSROOT=/mnt/c/CrowdStrike
  export _CSROOT=$CSROOT
  export _CSBUILDROOT="$CSROOT/private/sensor/build"
else
  export CSROOT=$HOME/sources/crowdstrike
  export _CSROOT=$CSROOT
  export _CSBUILDROOT="$CSROOT/private/sensor/build"
  export ANY_MAC=1
fi
