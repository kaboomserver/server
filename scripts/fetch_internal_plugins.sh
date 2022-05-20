#!/bin/sh
# Script used to fetch latest versions of internal plugins
# Plugins: CommandSpy, Extras, iControlU, ParticleTrails, Weapons

mkdir -p fetched_plugins

for download_url in https://nightly.link/kaboomserver/commandspy/workflows/main/master/CommandSpy.zip \
                    https://nightly.link/kaboomserver/extras/workflows/main/master/Extras.zip \
                    https://nightly.link/kaboomserver/icontrolu/workflows/main/master/iControlU.zip \
                    https://nightly.link/kaboomserver/particletrails/workflows/main/master/ParticleTrails.zip \
                    https://nightly.link/kaboomserver/weapons/workflows/main/master/Weapons.zip
do
    curl -L $download_url > archive.zip
    unzip -o archive.zip -d fetched_plugins
    rm archive.zip
done
