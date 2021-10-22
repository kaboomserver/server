#!/bin/sh
# Script used to fetch the latest version of Paper

mkdir -p fetched_server
curl -L https://papermc.io/api/v1/paper/1.17.1/latest/download > fetched_server/server.jar
