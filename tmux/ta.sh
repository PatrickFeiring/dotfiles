#!/bin/sh
#
# Create tmux sessions based on current folder.
#
# Initial version copied from Chris Toomeys tmux course.

usage() {
    echo "Usage:"
    echo "  ta.sh [<session-name> [<tmuxinator-layout>]]"
}

if [[ $# -gt 2 ]]; then
    usage
    exit 1
fi

if [[ $# -gt 0 ]]; then
    if [[ $1 == '.' ]]; then
        name="$(basename "$PWD" | tr . -)"
    else
        name=$1
    fi
else
    name="$(basename "$PWD" | tr . -)"
fi

if [[ $# -gt 1 ]]; then
    layout=$2
else
    layout=''
fi

session_exists() {
  tmux list-sessions | sed -E 's/:.*$//' | grep -q "^$name$"
}

not_in_tmux() {
  [ -z "$TMUX" ]
}

if not_in_tmux; then
    if [[ -z "$layout" ]]; then
        tmux new-session -A -s "$name"
    else
        tmuxinator start "$layout" --name="$name"
    fi
else
    if ! session_exists; then
        if [[ -z "$layout" ]]; then
            (TMUX='' tmux new-session -A -d -s "$name")
        else
            tmuxinator start "$layout" --name="$name"
        fi
    fi

    tmux switch-client -t "$name"
fi
