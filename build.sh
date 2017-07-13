#!/bin/sh

# The name of the Docker image to build
NAME=jenkins-jnlp-slave-php

# The version of the Docker image to build
VERSION=$1

# Build the Docker image
docker build --no-cache -t gomoob/$NAME:$VERSION ./$VERSION
