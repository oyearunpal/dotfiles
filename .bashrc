# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=10000
HISTFILESIZE=20000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[[01;32m\]\u@\h\[[00m\]:\[[01;34m\]\w\[[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\]$PS1"
    ;;
*)
    ;;
esac


# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

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

# colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'
export PATH="$HOME/neovim/bin:$PATH"
export EDITOR='nvim'
export ANSIBLE_INVENTORY="$HOME/iaac/inventory/"
export NVM_DIR="$HOME/.nvm"
export MANPAGER="nvim +Man!"

function tmux_prod_log {
	if [ -n "$(tmux list-sessions 2> /dev/null)" ]; then

		log_dir="$HOME/.tmux/logs"
		base_index=$(tmux show-option -gv base-index)
		window_index=$(tmux display-message -p '#I')
		pane_index=$(tmux display-message -p '#P')

		# Remove logs older than 2 days
		find "$log_dir" -name "tmux_session_*.log" -mtime +2 -exec rm {} \;
		if [ "$(tmux display-message -p '#S')" = "prod" ] && [ "$window_index" -eq "$base_index" ] && [ "$pane_index" -eq "$base_index" ]; then
			env > "$log_dir/env_log.txt"
			tmux pipe-pane "cat >> $log_dir/tmux_session_#S_#I_#P_$(date +%Y%m%d%H%M%S).log" 2> /dev/null
		fi
	fi
}
tmux_prod_log


function sol(){
    if [ $# -eq 0 ]; then
        echo "Usage: sol <bsefo42>, this will jump to bse fo 42 box"
        return 1
    fi
    file="$ANSIBLE_INVENTORY/trading.yml"
    # Check if the line exists in the file
    if grep -q -w "$1" "$file"; then
        # Extracting relevant information
        line=$(grep -w -m1 "$1" "$file")
        host=$(echo "$line" | awk -F' ' '{print $2}' | awk -F'=' '{print $2}')
        user=$(echo "$line" | awk -F' ' '{print $3}' | awk -F'=' '{print $2}')
        password=$(echo "$line" | awk -F' ' '{print $4}' | awk -F'=' '{print $2}')

    # Constructing sshpass command
    #sshpass -p "$password" ssh "$user@$host"
		sshpass -p "$password" ssh -o StrictHostKeyChecking=no -J omm@172.16.100.252 -t "$user@$host"
    # echo "sshpass -p "$password" ssh "$user@$host""
else
    echo "Line '$1' not found in $file"
    fi
}

function ui(){
    if [ $# -eq 0 ]; then
        echo "Usage: sol <bsefo42>, this will jump to bse fo 42 box"
        return 1
    fi
    file="$ANSIBLE_INVENTORY/ui.yml"
    # Check if the line exists in the file
    if grep -q -w "$1" "$file"; then
        # Extracting relevant information
        line=$(grep -w -m1 "$1" "$file")
        host=$(echo "$line" | awk -F' ' '{print $2}' | awk -F'=' '{print $2}')
        user=$(echo "$line" | awk -F' ' '{print $3}' | awk -F'=' '{print $2}')
        password=$(echo "$line" | awk -F' ' '{print $4}' | awk -F'=' '{print $2}')

    # Constructing sshpass command
    #sshpass -p "$password" ssh "$user@$host"
		sshpass -p "$password" ssh -o StrictHostKeyChecking=no -J omm@172.16.100.252 -t "$user@$host"
else
    echo "Line '$1' not found in $file"
    fi
}
solt ()
{
# Connect and attach the tmux , do not call it from inside the tmux
    if [ $# -eq 0 ]; then
        echo "Usage: sol <bsefo42>, this will jump to bse fo 42 box";
        return 1;
    fi;
    file="$ANSIBLE_INVENTORY/trading.yml";
    if grep -q -w --color=auto  "$1" "$file"; then
        line=$(grep -w -m1 "$1" "$file");
        host=$(echo "$line" | awk -F' ' '{print $2}' | awk -F'=' '{print $2}');
        user=$(echo "$line" | awk -F' ' '{print $3}' | awk -F'=' '{print $2}');
        password=$(echo "$line" | awk -F' ' '{print $4}' | awk -F'=' '{print $2}');
# Please note 252 is jump host , you can use other ip as well from which colo
# box are accessible provided you have added the keys for jump host box
        sshpass -p "$password" ssh -o StrictHostKeyChecking=no -J omm@172.16.100.252 -t "$user@$host" "tmux a";
    else
        echo "Line '$1' not found in $file";
    fi
}

# source ~/.profile

[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Set up fzf key bindings and fuzzy completion
[ -f ~/.fzf.bash ] && source ~/.fzf.bash
[ -f ~/.bash_variable ] && source ~/.bash_variable
[ -f ~/.bash_function ] && source ~/.bash_function
source ~/.bash_completion

# # Auto-Warpify
# [[ "$-" == *i* ]] && printf 'P$f{"hook": "SourcedRcFileForWarp", "value": { "shell": "bash", "uname": "Linux" }}œ'
