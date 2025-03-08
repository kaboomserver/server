#!/bin/sh

_fetch_github_asset() {
    list_release_url="https://api.github.com/repos/$1/releases"
    debug "fetch: $list_release_url"

    # We have to read the variables like this because POSIX read
    # doesn't support reading multiple variables at a time
    download_url="$(fetch -so- "$list_release_url" | \
        jq --raw-output --exit-status --arg filter "$2" \
            '.[0].assets[] | select(.name | test($filter)) | .browser_download_url')"
}

_download_type_github() {
    read_args repo asset
    require_args repo asset

    _fetch_github_asset "${arg_repo:?}" "${arg_asset:?}"
    download "$download_url" "$1"
}