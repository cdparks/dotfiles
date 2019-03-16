# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# Guake won't set $TERM
if [ "$TERM" == "xterm" ]; then
    TERM=xterm-256color
fi

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# Don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# Append to the history file, don't overwrite it
shopt -s histappend

# For setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# Check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# Make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# Set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# Set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# Show number of backgrounded jobs
function count_jobs() {
  local stopped=$(jobs -sp | wc -l | tr -d ' ')
  [ $stopped -eq 1 ] && echo -n " [${stopped} job]"
  [ $stopped -gt 1 ] && echo -n " [${stopped} jobs]"
}

if [ "$color_prompt" = yes ]; then
    PS1='\n${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u\[\033[00m\] in \[\033[01;34m\]\w\[\033[00m\]\[\033[0;31m\]$(count_jobs)\[\033[00m\]\n + '
else
    PS1='\n${debian_chroot:+($debian_chroot)}\u in \w$(count_jobs)\n + '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# Alias definitions.
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

dbanalytics() {
  RAILS_ENV=analytics ~/code/megarepo/sql/scripts/run-command-ssh-tunnel.sh $PSQL -W
}

dbprod () {
  RAILS_ENV=production ~/code/megarepo/sql/scripts/run-command-ssh-tunnel.sh $PSQL -W
}

__sl() {
  if [[ ! -e /tmp/trombone.ogg ]]; then
    curl -s https://wompwompwomp.com/audio/sad-trombone.ogg > /tmp/trombone.ogg
  fi;
  canberra-gtk-play --file="/tmp/trombone.ogg"
}

sl() {
  (__sl &)
}

reparent-guake() {
  printf 'parent=$(xwininfo -name "Guake!" -int -tree | sed -ne "/Root/s/[^0-9]//gp")\n'
  parent=$(xwininfo -name "Guake!" -int -tree | sed -ne '/Root/s/[^0-9]//gp')
  printf "xdotool search --name "Guake!" windowreparent %s\n" "$parent"
  xdotool search --name "Guake!" windowreparent "$parent"
}

fix-tmux-paste() {
  printf '\e[?2004l'
}

# FZF
[ -f ~/.fzf.bash ] && source ~/.fzf.bash
