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
SHELL ["/bin/bash","--login", "-c"] #change shell type for automatically sourcing the .bashrc

RUN apt-get update

RUN export DEBIAN_FRONTEND=noninteractive && apt-get install -y ros-noetic-pcl-ros

#Install CUDA-Toolkit
#RUN apt-get update && apt-get install -y apt-utils && apt-get install -y curl
#RUN wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/cuda-ubuntu2004.pin
#RUN mv cuda-ubuntu2004.pin /etc/apt/preferences.d/cuda-repository-pin-600
#RUN wget https://developer.download.nvidia.com/compute/cuda/11.3.0/local_installers/cuda-repo-ubuntu2004-11-3-local_11.3.0-465.19.01-1_amd64.deb
#RUN dpkg -i cuda-repo-ubuntu2004-11-3-local_11.3.0-465.19.01-1_amd64.deb
#RUN apt-key add /var/cuda-repo-ubuntu2004-11-3-local/7fa2af80.pub
#RUN apt-get update
#RUN apt-get -y install cuda


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
    ros-noetic-image-view


RUN apt-get update && pip3 install osrf-pycommon \
    scipy==1.4.1 \
    numpy==1.19.2 \
    Pillow \
    setuptools \
    tensorflow-gpu==2.2.0 \
    matplotlib \
    keras==2.3.1

#automatically source
RUN echo "source /home/srcp2/ros_workspace/install/setup.bash" >> /etc/bash.bashrc
RUN echo "source /home/srcp2/cmp_workspace/devel/setup.bash" >> /etc/bash.bashrc
RUN echo "export ROS_MASTER_URI=http://172.18.0.3:11311"  >> /etc/bash.bashrc ##Set de current address from sim container

# make sure that we are _not_ root at this time!
USER ${enduser_name}

#add non root stuff here
