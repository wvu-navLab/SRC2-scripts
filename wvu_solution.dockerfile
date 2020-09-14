# wvuMountaineers .dockerfile for generating "solution" docker image

FROM "ros:melodic"

# set up dependencies
RUN apt-get update && apt-get install -y ros-melodic-ros-base ros-melodic-cv-bridge ros-melodic-gazebo-msgs ros-melodic-image-transport ros-melodic-tf ros-melodic-pcl-conversions ros-melodic-costmap-2d ros-melodic-pcl-ros ros-melodic-nav-core ros-melodic-base-local-planner ros-melodic-tf2-geometry-msgs ros-melodic-tf2-sensor-msgs ros-melodic-navfn ros-melodic-realtime-tools ros-melodic-move-base-msgs ros-melodic-map-server ros-melodic-move-base

# set up the ros-ws
RUN mkdir -p /ros_workspace/src

COPY ros_workspace /ros_workspace
RUN chmod 777 /ros_workspace

RUN rm -rf /ros_workspace/devel
RUN rm -rf /ros_workspace/build
RUN  /bin/bash -c "source /ros_workspace/install/setup.bash; source /opt/ros/melodic/setup.bash; source /ros_workspace/install/setup.bash; cd /ros_workspace; catkin_make"
