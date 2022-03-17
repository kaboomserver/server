#!/bin/sh
# Script used to fetch the latest version of Paper

mkdir -p fetched_server
curl -L https://api.purpurmc.org/v2/purpur/1.18.2/latest/download > fetched_server/server.jar
