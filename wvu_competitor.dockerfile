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

RUN apt-get install software-properties-common -y

RUN wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/cuda-ubuntu2004.pin 

RUN mv cuda-ubuntu2004.pin /etc/apt/preferences.d/cuda-repository-pin-600

RUN  wget https://developer.download.nvidia.com/compute/cuda/11.2.2/local_installers/cuda-repo-ubuntu2004-11-2-local_11.2.2-460.32.03-1_amd64.deb
RUN dpkg -i cuda-repo-ubuntu2004-11-2-local_11.2.2-460.32.03-1_amd64.deb
RUN apt-key add /var/cuda-repo-ubuntu2004-11-2-local/7fa2af80.pub
RUN apt-get update
RUN apt-get install cuda-toolkit-11-2 -y

RUN apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/7fa2af80.pub
RUN add-apt-repository "deb https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/ /"
RUN apt-get update
RUN apt-get install libcudnn8=8.1.1.*-1+cuda11.2 -y
RUN apt-get install libcudnn8-dev=8.1.1.*-1+cuda11.2 -y

ENV LD_LIBRARY_PATH $LD_LIBRARY_PATH:/usr/local/cuda-11.2/targets/x86_64-linux/lib

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
    tensorflow-gpu==2.5.0 \
    matplotlib \
    keras-nightly==2.5.0.dev2021032900

#automatically source
RUN echo "source /home/srcp2/ros_workspace/install/setup.bash" >> /etc/bash.bashrc
RUN echo "source /home/srcp2/cmp_workspace/devel/setup.bash" >> /etc/bash.bashrc
RUN echo "export ROS_MASTER_URI=http://172.18.0.3:11311"  >> /etc/bash.bashrc ##Set de current address from sim container
#RUN echo "export PATH=/usr/local/cuda-11.2/bin${PATH:+:${PATH}}"  >> /etc/bash.bashrc
#RUN echo "export LD_LIBRARY_PATH=/usr/local/cuda-11.2/lib64${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}"  >> /etc/bash.bashrc
#RUN echo "export CUDA_HOME=/usr/local/cuda"  >> /etc/bash.bashrc



# make sure that we are _not_ root at this time!
USER ${enduser_name}

#add non root stuff here
