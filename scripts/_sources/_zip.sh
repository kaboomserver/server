#!/bin/sh

_download_type_zip() {
    read_args url skip_404 extract
    require_args extract

    zip_path="$(mktemp --suffix=.zip)"

    exitcode=0
    download_with_args "$zip_path" || exitcode=$?
    if [ $exitcode != 0 ]; then
        rm -f "$zip_path" 2>/dev/null

        if [ $exitcode = 200 ] && [ "${arg_skip_404:-false}" = "true" ]; then
            exitcode=0
        fi

        return $exitcode
    fi

    debug "extracting ${arg_extract:?} to $1"
    unzip -p "$zip_path" \
        "${arg_extract:?}" > "$1" || exitcode=$?
    rm -f "$zip_path" 2>/dev/null

    return $exitcode
}
