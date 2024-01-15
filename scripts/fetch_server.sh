#!/bin/sh
# Script used to fetch the latest version of the server jar

mkdir -p fetched_server

curl -L https://ci.plex.us.org/job/Scissors/job/1.20.4/lastSuccessfulBuild/artifact/*zip*/archive.zip > archive.zip
unzip -o archive.zip
mv archive/build/libs/scissors-*.jar fetched_server/server.jar

rm -rf archive/
rm archive.zip
