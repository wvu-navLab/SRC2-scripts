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
RUN apt-get update && apt-get install -y \
    ros-noetic-move-base

# make sure that we are _not_ root at this time!
USER ${enduser_name}

#add non root stuff here
