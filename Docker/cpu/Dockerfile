#########################################################################
# This docker is for stretch3's nuc to run the ros2 with fixed environment
# build in 2024/12/24
# By wellyowo
########################################################################
FROM ubuntu:22.04 

ENV DEBIAN_FRONTEND=noninteractive

ENV ROS_DISTRO=humble \
    SHELL=/bin/bash \
    NB_USER=hrc \
    NB_UID=1000

RUN echo 'Etc/UTC' > /etc/timezone && \
    ln -s /usr/share/zoneinfo/Etc/UTC /etc/localtime

###################################### user #####################################
RUN adduser --disabled-password \
    --gecos "Default user" \
    --uid ${NB_UID} \
    ${NB_USER} 

RUN echo "root:root" | chpasswd \
    && echo "${NB_USER}:111111" | chpasswd

ENV HOME=/home/${NB_USER}

###################################### basic #####################################
RUN apt-get update && \
    apt-get install -q -y --no-install-recommends \
    ccache \
    g++ \
    gcc \
    gdb \
    gawk \
    make \
    ninja-build \
    python3-numpy \
    python3-dev \
    python3-pyparsing \
    python3-serial \
    python-is-python3 \
    libpython3-stdlib \
    libtool-bin \
    zip \
    default-jre \
    socat \
    tzdata \
    pip \
    dirmngr \
    gnupg2 \
    git \
    gitk git-gui \
    vim \
    less \
    curl \
    wget \
    sudo \
    cmake \
    swig \
    net-tools \
    lsb-release \
    gnupg \
    build-essential \
    libcgal-dev \
    libfftw3-dev \
    rapidjson-dev \
    pkg-config \
    libboost-system-dev \
    libopencv-dev \
    gstreamer1.0-plugins-bad \
    gstreamer1.0-libav \
    gstreamer1.0-gl \
    software-properties-common \
    portaudio19-dev \
    festival \
    festvox-kallpc16k \
    gstreamer1.0-tools \
    gir1.2-gstreamer-1.0 \
    gstreamer1.0-alsa \
    gir1.2-gst-plugins-base-1.0 \
    gstreamer1.0-plugins-ugly \
    libgstreamer1.0-dev \
    libgstreamer-plugins-base1.0-dev \
    libglfw3-dev \
    && rm -rf /var/lib/apt/lists/*

RUN apt-get update && apt-get install -y python3-pyaudio || pip install pyaudio
###################################### Installation Commands with Context ###############################

# Clone the necessary repositories
WORKDIR /home/${NB_USER}/repos
RUN git clone https://github.com/hello-robot/stretch_dex_teleop


# Install hello-robot-stretch-body and related packages
RUN pip3 install hello-robot-stretch-body
RUN pip3 install hello-robot-stretch-body-tools

# Install dependencies for dex_teleop
WORKDIR /home/${NB_USER}/repos/stretch_dex_teleop
RUN apt-get update && apt-get install -y v4l-utils
RUN ./install_dex_teleop.sh

###################################### python packages ###############################
RUN apt-get update && apt-get upgrade pip -y && \
    pip install --upgrade pip && \
    pip install \
    numpy \
    scipy \
    matplotlib \
    scikit-learn \
    scikit-image \
    pandas \
    opencv-python \
    pyyaml \
    pyquaternion \
    pyserial \
    pexpect \
    Pillow \
    future \
    cython

###################################### ros2 ####################################
RUN curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -o /usr/share/keyrings/ros-archive-keyring.gpg && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(. /etc/os-release && echo $UBUNTU_CODENAME) main" | tee /etc/apt/sources.list.d/ros2.list > /dev/null && \
    apt-get update && apt-get install -y --no-install-recommends \
    ros-${ROS_DISTRO}-desktop \
    ros-${ROS_DISTRO}-ros2-control \
    ros-${ROS_DISTRO}-ros2-controllers \
    ros-${ROS_DISTRO}-joy* \
    ros-${ROS_DISTRO}-joint-state-publisher \
    ros-${ROS_DISTRO}-rosbridge-server \
    ros-${ROS_DISTRO}-vision-msgs \
    ros-${ROS_DISTRO}-ament-cmake \
    ros-${ROS_DISTRO}-geometry-msgs \
    ros-${ROS_DISTRO}-std-msgs \
    ros-${ROS_DISTRO}-sensor-msgs \
    ros-${ROS_DISTRO}-tf2-msgs \
    ros-${ROS_DISTRO}-xacro \
    ros-${ROS_DISTRO}-rviz-rendering \
    ros-${ROS_DISTRO}-rcl-interfaces \
    ros-${ROS_DISTRO}-urdf \
    ros-${ROS_DISTRO}-geographic-msgs \
    ros-${ROS_DISTRO}-topic-tools \
    ros-dev-tools \
    ros-${ROS_DISTRO}-launch-pytest \
    ros-${ROS_DISTRO}-joint-state-publisher-gui \ 
    python3-colcon-common-extensions \
    python3-rosdep \
    ros-dev-tools && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

################################## dep of mujoco ros2 ############################
WORKDIR /home/${NB_USER}/mujoco
ENV MUJOCO_VERSION=3.2.6
RUN wget https://github.com/google-deepmind/mujoco/releases/download/${MUJOCO_VERSION}/mujoco-$MUJOCO_VERSION-linux-x86_64.tar.gz
RUN tar -xzf mujoco-${MUJOCO_VERSION}-linux-x86_64.tar.gz

##################################### stretch3 MUJOCO ###########################
WORKDIR /home/${NB_USER}/mujoco
RUN git clone https://github.com/hello-robot/stretch_mujoco 
WORKDIR /home/${NB_USER}/mujoco/stretch_mujoco
RUN pip install -e .

#################################### Install respeaker requirement#################
WORKDIR /home/${NB_USER}/ros2_ws/src
RUN git clone https://github.com/hrc-pme/respeaker_ros2.git
RUN git clone https://github.com/hrc-pme/audio_common.git
# RUN source /opt/ros/${ROS_DISTRO}/setup.bash
WORKDIR /home/${NB_USER}/ros2_ws
RUN rosdep init && rosdep update
RUN rosdep install --from-paths src --ignore-src -i -r -n -y

################################## setup auth & set env param into .bashrc########################
RUN echo "root ALL=(ALL)  ALL" >> /etc/sudoers \
    && echo "source /opt/ros/${ROS_DISTRO}/setup.bash" >> ${HOME}/.bashrc \ 
    && echo export MUJOCO_DIR=/home/${NB_USER}/mujoco/mujoco-${MUJOCO_VERSION} >> ${HOME}/.bashrc

ENV XLA_PYTHON_CLIENT_PREALLOCATE=false

# Support of nvidia-docker 2.0
ENV NVIDIA_VISIBLE_DEVICES=all
ENV NVIDIA_DRIVER_CAPABILITIES=all
