#!/bin/sh

_download_type_url() {
    read_args url skip_404

    exitcode=0
    download_with_args "$@" || exitcode=$?

    if [ $exitcode = 200 ] && [ "${arg_skip_404:-false}" = "true" ]; then
        exitcode=0
    fi

    return $exitcode
}
