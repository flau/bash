if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

stty werase ^H
stty erase '^?'

# Prompt
PS1='[\[\e[1;91m\]\u@\h\[\e[0m\]: \W] \$ '
FONT="ter-120n"

alias ls="ls -Alhb --color=auto"

function cs() {
    cd "$@" && ls
}

function bigfiles() {
    du -Sh $1 | sort -rh | tail -n +2 | head -10
}

function bgq() {
    if [ "$#" -lt 1 ]; then
        echo "Usage: bgq <command> <args>"
        return 1
    fi

    CMD="$@ > /dev/null 2>&1 &"
    echo "$CMD"
    eval "$CMD"

    return $?
}

function fgq() {
    if [ "$#" -lt 1 ]; then
        echo "Usage: fgq <command> <args>"
        return 1
    fi

    CMD="$@ > /dev/null 2>&1"
    echo "$CMD"
    eval "$CMD"

    return $?
}
