#!/usr/bin/env bash
# Ensure environment.sh is sourced in ~/.bashrc
grep -qxF 'source ~/stretch3_project/environment.sh' ~/.bashrc || echo 'source ~/stretch3_project/environment.sh' >> ~/.bashrc

# Source environment.sh with an argument if provided
if [ -n "$1" ]; then
  source ~/stretch3_project/environment.sh "$1"
else
  source ~/stretch3_project/environment.sh
fi
