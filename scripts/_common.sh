#!/bin/sh

_HAS_TTY=0
if (exec < /dev/tty) 2>/dev/null; then
    _HAS_TTY=1
fi

download() {
    exitcode=0

    # TTY present: enable curl's progress bar, clear curl output on exit
    if [ $_HAS_TTY = 1 ]; then
        tput sc 2>/dev/null || true # save cursor pos

        curl -#fL "$1" -o "$2" </dev/tty 3>&1 || exitcode=$?

        if [ $exitcode = 0 ]; then
            (tput rc; tput ed) 2>/dev/null || true # reset cursor pos; clear to end
        fi
    else
        curl -fL "$1" -o "$2" || exitcode="$?"
    fi

    return $exitcode
}

extract() {
    file="$1"
    shift

    while [ $# -gt 0 ]; do
        exitcode=0
        unzip -p "$file" "$1" > "$2" || exitcode=$?
        [ $exitcode != 0 ] && return $exitcode

        shift; shift
    done

    return 0
}

download_zipped() {
    file="$(mktemp --suffix=.zip)"

    exitcode=0
    download "$1" "$file" || exitcode=$?
    if [ $exitcode != 0 ]; then
        rm -f "$file" 2>/dev/null
        return $exitcode
    fi

    shift
    extract "$file" "$@" || exitcode=$?
    rm -f "$file" 2>/dev/null

    return $exitcode
}
