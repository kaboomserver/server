#!/bin/sh
# shellcheck disable=SC1091 # Included files should be manually checked
set -e

# Pipefail is part of POSIX.1-2024, however some shells haven't
# implemented it yet. Turn it on only if it's available.
# shellcheck disable=SC3040
if (set -o pipefail 2>/dev/null); then
    set -o pipefail
fi

_SCRIPT_PATH="$(dirname "$(readlink -f -- "$0")")"
. "$_SCRIPT_PATH"/_common.sh
. "$_SCRIPT_PATH"/_sources/_index.sh

_FILTER="$1"
if [ "$_FILTER" = "help" ]; then
    cat <<USAGE
Usage: scripts/update.sh [FILTER]
Downloads all files contained in scripts/downloads.json. If FILTER
is specified, only files whose JSON paths start with FILTER will be
downloaded.

Examples:
    scripts/update.sh server
    scripts/update.sh plugins/internal
USAGE
    exit 1
fi

_parse_downloads() {
    exitcode=0

    jq --null-input --raw-output --exit-status \
        --arg arg1 "$_FILTER" \
        --from-file "$_SCRIPT_PATH"/_parser.jq \
        --stream "$_SCRIPT_PATH"/downloads.json || exitcode=$?
    if [ $exitcode = 4 ]; then
        echo 'No downloads matched the filter.'>&2
        return $exitcode
    fi

    return $exitcode
}

echo "Downloading with filter ${_FILTER:-"<none>"}..."
_parse_downloads | while read -r path; read -r type; read -r args; do
    echo "> $path"
    if ! check_path "$path"; then
        echo "Bailing!"
        exit 1
    fi

    debug "download_type: type=$type; args=$args"

    # Since the args are part of the function's stdin, they will be
    # be propagated up.
    echo "$args" | download_type "$type" "$path"
done
