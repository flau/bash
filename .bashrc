if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

stty werase ^H
stty erase '^?'

# Prompt
PS1='[\[\e[1;91m\]\u@\h\[\e[0m\]: \W] \$ '
FONT="ter-120n"

alias ls="ls -Alhb --color=auto"

# cd and ls in new directory
function cs() {
    cd "$@" && ls
}

# List largest files in directory
function big() {
    if [ "$#" -gt 1 ] || ([ "$#" -eq 1 ] && ! [ -d "$1" ]); then
        >&2 echo "Usage: big <command> <args>"
        return 1
    fi

    echo "Directories and files"
    du -Sh $1 | sort -rh | tail -n +2 | head -5

    echo
    echo "Files"
    find $1 -type f -printf '%s %p\n' | sort -rn | head -5
}

# Run command in foreground and redirect output to /dev/null
function fgq() {
    if [ "$#" -lt 1 ]; then
        >&2 echo "Usage: fgq <command> <args>"
        return 1
    fi

    CMD="$@ > /dev/null 2>&1"

    echo "$CMD"
    eval "$CMD"

    return $?
}

# Run command in background and redirect output to /dev/null
function bgq() {
    if [ "$#" -lt 1 ]; then
        >&2 echo "Usage: bgq <command> <args>"
        return 1
    fi

    CMD="$@ > /dev/null 2>&1 &"
    echo "$CMD"
    eval "$CMD"

    return $?
}

# cd up n directories
function up() {
    if [ "$#" -gt 1 ] || ([ "$#" -gt 0 ] && [[ $1 =~ '^[0-9]+$' ]]); then
        >&2 echo "Usage: up <count>"
        return 1
    fi

    if [ "$#" -eq 0 ] || [ "$1" -ne 0 ]; then
        cd $(printf "%0.0s../" $(seq 1 $1))
    fi
}

# cd up to a directory starting with name
function upd() {
    if [ "$#" -gt 1 ]; then
        >&2 echo "Usage: upd <directory>"
        return 1
    fi

    current=$(pwd)
    re="(.*\/$1[^\/]*\/).*"

    if [ "$#" -eq 1 ] && ! [ $(echo "$current" | grep -Eie "$re") ]; then
        >&2 echo "Path $current does not contain $1"
        return 1
    fi

    cd $(echo "$current" | sed -r "s/$re/\1/I")
}
