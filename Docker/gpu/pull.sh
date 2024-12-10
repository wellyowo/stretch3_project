#!/usr/bin/env bash

REPOSITORY="hrcnthu/stretch3_2204"
TAG="gpu"

IMG="${REPOSITORY}:${TAG}"

docker pull "${IMG}"
