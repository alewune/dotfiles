#!/usr/bin/env bash
# Prints the git branch (or short commit when detached) for the directory in $1.
# Prints nothing outside a repository. Used by the tmux status-right.
cd "$1" 2>/dev/null || exit 0
branch=$(git branch --show-current 2>/dev/null)
[ -z "$branch" ] && branch=$(git rev-parse --short HEAD 2>/dev/null)
[ -n "$branch" ] && printf ' %s  ' "$branch"
