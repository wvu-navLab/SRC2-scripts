# modified from competitor.dockerfile
#
# Space Robotics Challenge 2: NASA JSC
# Final Round
#
# Copyright (c), 2019-2022 NASA-JSC. All Rights Reserved
# Unauthorized Distribution Strictly Prohibited
#
ARG base_image="scheducation/srcp2_comp:final_competitor"
FROM ${base_image}
ARG enduser_name="srcp2"

USER root
RUN export DEBIAN_FRONTEND=noninteractive && apt-get install -y ros-noetic-pcl-ros

RUN apt-get update && apt-get install -y \
    git \
    ros-noetic-move-base \
    ros-noetic-cv-bridge \
    ros-noetic-image-transport \
    ros-noetic-vision-opencv \
    ros-noetic-gazebo-msgs \
    ros-noetic-image-transport \
    ros-noetic-tf \
    ros-noetic-pcl-conversions \
    ros-noetic-costmap-2d \
    ros-noetic-nav-core \
    ros-noetic-base-local-planner \
    ros-noetic-tf2-geometry-msgs \
    ros-noetic-tf2-sensor-msgs \
    ros-noetic-navfn \
    ros-noetic-realtime-tools \
    ros-noetic-move-base-msgs \
    ros-noetic-map-server \
    ros-noetic-laser-assembler \
    ros-noetic-tf2-tools \
    ros-noetic-genpy \
    && \
    \
    pip3 install osrf-pycommon \
    scipy \
    numpy==1.19.2 \
    Pillow \
    setuptools \
    tensorflow \
    keras==2.3.1

# make sure that we are _not_ root at this time!
USER ${enduser_name}

#add non root stuff here
