#!/usr/bin/env bash
export ROS_DOMAIN_ID=${1:-1} # Use $1 if provided, otherwise default to 1
source /opt/ros/humble/setup.bash
source $HOME/stretch3_project/ros2_ws/install/local_setup.bash