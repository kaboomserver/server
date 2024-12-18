#!/bin/sh
# shellcheck disable=1091 # Files should not be followed, but instead manually checked
set -e
_SCRIPT_PATH="$(dirname "$(readlink -f -- "$0")")"

export EXTERNAL_PLUGINS='
https://ci.ender.zone/job/EssentialsX/lastSuccessfulBuild/artifact/*zip*/archive.zip        archive/jars/EssentialsX-*.jar                      Essentials.jar
https://ci.athion.net/job/FastAsyncWorldEdit/lastSuccessfulBuild/artifact/*zip*/archive.zip archive/artifacts/FastAsyncWorldEdit-Bukkit-*.jar   FastAsyncWorldEdit.jar
https://nightly.link/GeyserMC/Geyser/workflows/build/master/Geyser-Spigot.zip               Geyser-Spigot.jar                                   Geyser.jar
https://ci.viaversion.com/job/ViaVersion/lastSuccessfulBuild/artifact/*zip*/archive.zip     archive/build/libs/ViaVersion-*.jar                 ViaVersion.jar
https://ci.viaversion.com/job/ViaBackwards/lastSuccessfulBuild/artifact/*zip*/archive.zip   archive/build/libs/ViaBackwards-*.jar               ViaBackwards.jar
https://ci.viaversion.com/job/ViaRewind/lastSuccessfulBuild/artifact/*zip*/archive.zip      archive/build/libs/ViaRewind-*.jar                  ViaRewind.jar
'

export INTERNAL_PLUGINS='
https://nightly.link/kaboomserver/commandspy/workflows/main/master/CommandSpy.zip           CommandSpy.jar      CommandSpy.jar
https://nightly.link/kaboomserver/extras/workflows/main/master/Extras.zip                   Extras.jar          Extras.jar
https://nightly.link/kaboomserver/icontrolu/workflows/main/master/iControlU.zip             iControlU.jar       iControlU.jar
https://nightly.link/kaboomserver/particletrails/workflows/main/master/ParticleTrails.zip   ParticleTrails.jar  ParticleTrails.jar
https://nightly.link/kaboomserver/weapons/workflows/main/master/Weapons.zip                 Weapons.jar         Weapons.jar
'

_TYPE="$1"
if [ "$_TYPE" = "help" ]; then
    echo "scripts/update.sh [server|plugins] [external|internal]"
    exit 1
fi

. "$_SCRIPT_PATH"/_common.sh

if [ -z "$_TYPE" ] || [ "$_TYPE" = "server" ]; then
    . "$_SCRIPT_PATH"/_update_server.sh
fi

if [ -z "$_TYPE" ] || [ "$_TYPE" = "plugins" ]; then
    _PLUGINS_TYPE="$2"

    cd plugins
        . "$_SCRIPT_PATH"/_update_plugins.sh
    cd ..
fi
