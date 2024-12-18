#!/bin/sh

echo Updating server...
download_zipped 'https://ci.plex.us.org/job/Scissors/job/1.20.4/lastSuccessfulBuild/artifact/*zip*/archive.zip' \
    'archive/build/libs/scissors-*.jar' server.jar
