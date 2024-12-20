#!/bin/sh

_download_type_zip() {
    read_args url skip_404 extract

    zip_path="$(mktemp --suffix=.zip)"

    exitcode=0
    download_with_args "$zip_path" || exitcode=$?
    if [ $exitcode != 0 ]; then
        rm -f "$zip_path" 2>/dev/null

        if [ $exitcode = 100 ] && [ "${arg_skip_404:-false}" = "true" ]; then
            return 0
        else
            return $exitcode
        fi
    fi

    debug "extracting ${arg_extract:?} to $1"
    unzip -p "$zip_path" \
        "${arg_extract:?}" > "$1" || exitcode=$?
    rm -f "$zip_path" 2>/dev/null

    return $exitcode
}
