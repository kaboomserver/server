#!/bin/sh

update_pluginset() {
    [ "$1" = "ignoreerr" ] && ignoreerr=1

    while IFS= read -r line; do
        [ "$line" = "" ] && continue

        IFS=' ' read -r url zippath destpath <<EOF
$line
EOF

        exitcode=0

        if [ "$destpath" = "" ]; then
            echo "> $zippath"
            download "$url" "$zippath" || exitcode=$?
        else
            echo "> $destpath"
            download_zipped "$url" "$zippath" "$destpath" || exitcode=$?
        fi

        [ "$ignoreerr" = 0 ] && [ $exitcode != 0 ] && return $exitcode
    done

    return 0
}

if [ -z "$_PLUGINS_TYPE" ] || [ "$_PLUGINS_TYPE" = "external" ]; then
    echo Updating external plugins...
    update_pluginset <<EOF
$EXTERNAL_PLUGINS
EOF
fi

if [ -z "$_PLUGINS_TYPE" ] || [ "$_PLUGINS_TYPE" = "internal" ]; then
    echo Updating internal plugins...
    # ignore individual download errors
    update_pluginset ignoreerr <<EOF
$INTERNAL_PLUGINS
EOF
fi
