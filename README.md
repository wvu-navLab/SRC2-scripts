**The solution.rosinstall and instructions have only been tested for round one code. Need to add details for round 2 and round 3.**

# SRC2-scripts
Scripts for generating docker images for submission.  
  
## Dependencies
Following instructions for installing [Docker](https://gitlab.com/scheducation/srcp2-competitors/-/wikis/Documentation/Install-Run/Install-Docker), [Nvidia Drivers](https://gitlab.com/scheducation/srcp2-competitors/-/wikis/Documentation/Install-Run/Install-Nvidia-Driver), and [Nvidia Docker Support](https://gitlab.com/scheducation/srcp2-competitors/-/wikis/Documentation/Install-Run/Install-Nvidia-Docker-Support).  

Install [ROS Melodic](http://wiki.ros.org/melodic/Installation/Ubuntu) (use the full version `sudo apt-get install ros-melodic-desktop-full`).
  
Install [wstool](http://wiki.ros.org/wstool).  

Install more ROS packages by executing the following command:  
`$ sudo apt-get install ros-melodic-ros-base ros-melodic-cv-bridge ros-melodic-gazebo-msgs ros-melodic-image-transport ros-melodic-tf ros-melodic-pcl-conversions ros-melodic-costmap-2d ros-melodic-pcl-ros ros-melodic-nav-core ros-melodic-base-local-planner ros-melodic-tf2-geometry-msgs ros-melodic-tf2-sensor-msgs ros-melodic-navfn ros-melodic-realtime-tools ros-melodic-move-base-msgs ros-melodic-map-server ros-melodic-move-base`  
  
Install `pip` some Python dependencies for the object-detection package:  
`$ sudo apt-get install python-pip`  
`$ pip install scipy`  
`$ python2.7 -m pip install Pillow`  
`$ python2.7 -m pip install setuptools`  
`$ python2.7 -m pip install tensorflow`  
`$ python2.7 -m pip install keras==2.3.1`  
  
## Setup Workspace
To setup the workspace (inside of the competition folder), execute the following commands:  
`$ git clone https://gitlab.com/scheducation/srcp2-competitors.git ~/srcp2-competitors`  
`$ git config --global credential.helper cache`  
`$ mkdir -p srcp2-competitors/ros_workspace/src`  
`$ wstool init srcp2-competitors/ros_workspace/src/ https://raw.githubusercontent.com/wvu-navLab/SRC2-meta/master/solution.rosinstall?token=ABXQJT2U46WGMCNQYNRVZZK7NBMVS`  
  
## Create Solution Image   
1) Add `build-wvu-solution-image.bash` and `wvu_solution.dockerfile` to the cloned directory, which should be `~/srcp2-competitors`.  
2) In `~/srcp2-competitors`, run `./build-wvu-solution-image.bash`
  
## Create Submission Image  
TODO  
