#!/bin/sh
# Fill (v3) is Paper's API for downloading builds
# See https://docs.papermc.io/misc/downloads-api

_fetch_latest_file() {
    builds_url="$1/builds/latest"
    debug "fetch: $builds_url"

    DEFAULT_DOWNLOAD_URL="$(fetch -so- "$builds_url" \
        | jq --raw-output --exit-status '.downloads["server:default"].url')"
}

_download_type_fill() {
    read_args endpoint project version
    require_args endpoint project version
    version_url="${arg_endpoint:?}/v3/projects/${arg_project:?}/versions/${arg_version:?}"

    _fetch_latest_file "$version_url"
    download "$DEFAULT_DOWNLOAD_URL" "$1"
}