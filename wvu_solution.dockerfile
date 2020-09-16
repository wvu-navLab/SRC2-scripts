# wvuMountaineers .dockerfile for generating "solution" docker image

FROM "ros:melodic"

# download package information
RUN apt-get update

# set up python dependencies
RUN sudo apt-get install python-pip python-matplotlib -y 

RUN pip install scipy && python2.7 -m pip install Pillow && python2.7 -m pip install setuptools && python2.7 -m pip install tensorflow && python2.7 -m pip install keras==2.3.1

# set up ros dependencies
RUN apt-get install -y ros-melodic-ros-base ros-melodic-cv-bridge ros-melodic-gazebo-msgs ros-melodic-image-transport ros-melodic-tf ros-melodic-pcl-conversions ros-melodic-costmap-2d ros-melodic-pcl-ros ros-melodic-nav-core ros-melodic-base-local-planner ros-melodic-tf2-geometry-msgs ros-melodic-tf2-sensor-msgs ros-melodic-navfn ros-melodic-realtime-tools ros-melodic-move-base-msgs ros-melodic-map-server ros-melodic-move-base ros-melodic-laser-assembler ros-melodic-genpy python-rosdep python-rosinstall python-rosinstall-generator python-wstool

# RUN sudo rosdep init 
# RUN rosdep update

# set up the ros-ws
RUN mkdir -p /ros_workspace/src

COPY ros_workspace /ros_workspace
RUN chmod 777 /ros_workspace

RUN rm -rf /ros_workspace/devel
RUN rm -rf /ros_workspace/build

#without source /ros_workspace/install/setup.bash the catkin_make fails
RUN  /bin/bash -c "source /opt/ros/melodic/setup.bash; source /ros_workspace/install/setup.bash; cd /ros_workspace; catkin_make"
