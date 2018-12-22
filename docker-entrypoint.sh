#!/bin/zsh
set -o errexit
set -o nounset

eval $(ssh-agent)
test -f "${HOME}/.ssh/id_rsa" && ssh-add

if [[ -z "$@" ]]; then
    set -- ansible -m ping all
fi

exec gosu ansible "$@"
