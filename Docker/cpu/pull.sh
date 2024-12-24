#!/usr/bin/env bash

REPOSITORY="hrcnthu/stretch3_2204"
TAG="cpu"

IMG="${REPOSITORY}:${TAG}"

docker pull "${IMG}"
