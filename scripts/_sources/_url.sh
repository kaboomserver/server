#!/bin/sh

_download_type_url() {
    read_args url
    require_args url

    download "${arg_url:?}" "$1"
}
