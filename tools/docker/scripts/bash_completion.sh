#!/bin/bash
# Author: Marko Schrempf

_build_completion() {
    local cur
    local prev
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"

    local targets="pdf spellcheck tex clean"
    local flags="--targets= --template="

    if [[ "$cur" == --targets=* ]]; then
        local value="${cur#--targets=}"
        local prefix=""
        local partial="$value"

        if [[ "$value" == *,* ]]; then
            prefix="${value%,*},"
            partial="${value##*,}"
        fi

        COMPREPLY=( $(compgen -W "$targets" -- "$partial") )
        for i in "${!COMPREPLY[@]}"; do
            COMPREPLY[$i]="--targets=${prefix}${COMPREPLY[$i]}"
        done
        return 0
    fi

    if [[ "$cur" == --* ]]; then
        COMPREPLY=( $(compgen -W "$flags" -- "$cur") )
        return 0
    fi

    if [[ "$prev" == "--template=" ]]; then
        COMPREPLY=()
        return 0
    fi

    COMPREPLY=( $(compgen -W "$targets" -- "$cur") )
}

complete -F _build_completion build
