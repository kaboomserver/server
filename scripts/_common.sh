#!/bin/sh

_EXEC_PATH="$(realpath .)"
_HAS_TTY=0
if (exec < /dev/tty) 2>/dev/null; then
    _HAS_TTY=1
fi

if [ "$DEBUG" = 1 ]; then
    debug() {
        printf '[DEBUG] '

        # If shell supports FUNCNAME, print it
        # The -20 is used to pad the function name with up to 20 spaces on the right.
        if [ -n "${FUNCNAME+x}" ]; then
            # shellcheck disable=SC3054 # FUNCNAME support requires array support
            printf '%-20s' "${FUNCNAME[1]}"
        fi

        echo "$@"
    }
else debug() { true; }
fi

contains() {
    NEEDLE="$1"
    shift

    for piece in "$@"; do
        if [ "$piece" = "$NEEDLE" ]; then
            return 0
        fi
    done

    return 1
}

check_path() {
    rpath="$(realpath "$1")"

    case "$1" in
        "/"*)   echo "Attempted path traversal: $1 is absolute"
                return 1;;

        *);; # Safe
    esac
    case "$rpath" in
        "$_EXEC_PATH/"*);; # Safe

        *)  echo "Attempted path traversal: $1 is outside current directory"
            return 1;;
    esac

    return 0
}

download() {
    debug "downloading $1 to $2"

    exitcode=0
    # TTY present: enable curl's progress bar, clear curl output on exit
    if [ $_HAS_TTY = 1 ]; then
        tput sc 2>/dev/null || true # save cursor pos

        curl -#fL "$1" -o "$2" </dev/tty 3>&1 || exitcode=$?

        if [ $exitcode = 0 ]; then
            (tput rc; tput ed) 2>/dev/null || true # reset cursor pos; clear to end
        fi
    else
        curl -fL "$1" -o "$2" || exitcode=$?
    fi

    return $exitcode
}
