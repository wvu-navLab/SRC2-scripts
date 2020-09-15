**The solution.rosinstall and instructions have only been tested for round one code. Need to add details for round 2 and round 3.**

# SRC2-scripts
This repository contains all scripts need for generating the docker images for submission as well as instructions for setting up the simulator and worksace (required for building the docker images).
  
## Dependencies
* Following instructions for installing [Docker](https://gitlab.com/scheducation/srcp2-competitors/-/wikis/Documentation/Install-Run/Install-Docker), [Nvidia Drivers](https://gitlab.com/scheducation/srcp2-competitors/-/wikis/Documentation/Install-Run/Install-Nvidia-Driver), and [Nvidia Docker Support](https://gitlab.com/scheducation/srcp2-competitors/-/wikis/Documentation/Install-Run/Install-Nvidia-Docker-Support).  

* Install [ROS Melodic](http://wiki.ros.org/melodic/Installation/Ubuntu) (use the full version `sudo apt-get install ros-melodic-desktop-full`).
  
* Install [wstool](http://wiki.ros.org/wstool). You can use the following command:  
```bash
$ sudo apt-get install python-wstool
```

Install more ROS packages by executing the following command:  
```bash
$ sudo apt-get install ros-melodic-ros-base ros-melodic-cv-bridge ros-melodic-gazebo-msgs ros-melodic-image-transport ros-melodic-tf ros-melodic-pcl-conversions ros-melodic-costmap-2d ros-melodic-pcl-ros ros-melodic-nav-core ros-melodic-base-local-planner ros-melodic-tf2-geometry-msgs ros-melodic-tf2-sensor-msgs ros-melodic-navfn ros-melodic-realtime-tools ros-melodic-move-base-msgs ros-melodic-map-server ros-melodic-move-base
```  
  
Install `pip` and some Python dependencies needed for the object-detection package:  
```bash
$ sudo apt-get install python-pip
$ pip install scipy
$ python2.7 -m pip install Pillow
$ python2.7 -m pip install setuptools
$ python2.7 -m pip install tensorflow
$ python2.7 -m pip install keras==2.3.1
```  
  
## Setup Workspace Inside Competitors Folder
To setup the workspace (inside of the competition folder), execute the following commands:  
```bash
$ git clone https://gitlab.com/scheducation/srcp2-competitors.git ~/srcp2-competitors
$ git config --global credential.helper cache
$ mkdir -p srcp2-competitors/ros_workspace/src
$ wstool init ~/srcp2-competitors/ros_workspace/src/ https://raw.githubusercontent.com/wvu-navLab/SRC2-scripts/master/solution.rosinstall?token=ABXQJT5AQKGDHJO6BPDW65C7NJFJM
```  

**NOTE: This is not necessary for building the images, but you should be able to compile the code in the workspace. To do so, execute the commands:**
```bash
$ cd ~/srcp2-competitors/ros_workspace
$ source install/setup.bash
$ catkin_make
```
 
## Creating Docker Images   
Follow the instruction for setting up the workspace inside the competitors folder, then add the docker files and scripts in this repository to the competitors folder. You can do this manually or by executing the following command:  
```bash
$ curl https://raw.githubusercontent.com/wvu-navLab/SRC2-scripts/master/build-wvu-solution-image.bash?token=ABXQJT5U56E2DH3YG7DWBLK7NIVGW >> ~/srcp2-competitors/build-wvu-solution-image.bash && curl https://raw.githubusercontent.com/wvu-navLab/SRC2-scripts/master/build-wvu-submission-image.bash?token=ABXQJT32NBOFDCJNXH2YCIC7NIVYW >> ~/srcp2-competitors/build-wvu-submission-image.bash && curl https://raw.githubusercontent.com/wvu-navLab/SRC2-scripts/master/wvu-submission-entrypoint.bash?token=ABXQJT32EFVHD7QOONYKVJS7NIV46 >> ~/srcp2-competitors/wvu-submission-entrypoint.bash && curl https://raw.githubusercontent.com/wvu-navLab/SRC2-scripts/master/wvu_solution.dockerfile?token=ABXQJT3W2NAY2YY4BLT4LIS7NIWB4 >> ~/srcp2-competitors/wvu_solution.dockerfile && curl https://raw.githubusercontent.com/wvu-navLab/SRC2-scripts/master/wvu_submission.dockerfile?token=ABXQJTYTW7PV7Y7JCUZM3NS7NIWEQ >> ~/srcp2-competitors/wvu_submission.dockerfile
$ chmod +x build-wvu-solution-image.bash && chmod +x build-wvu-submission-image.bash && chmod +x wvu-submission-entrypoint.bash
```  

NOTE: To delete cache and existing docker images, execute `docker system prune -a`. The build commands for docker should automatically detect changes in the .dockerfile and update the image accordingly, but this command is useful to ensure the image is built correctly after making modifications.

### Build Solution Image   
From the previous step, the `build-wvu-solution-image.bash`, `wvu_solution.dockerfile`, `build-wvu-submission-image.bash`, `wvu_submission.dockerfile`, and `wvu-submission-entrypoint.bash` should be in the cloned directory `~/srcp2-competitors`.  
  
Execute the following commands to build the solution image:  
```bash
$ cd ~/srcp2-competitors
$ ./build-wvu-solution-image.bash -n todo:wvu_mountaineers_sol
```  
  
### Build Submission Image  
**IMPORTANT: The tag of our "submission" to their dockerhub is (and MUST be) "wvu_mountaineers_src2".**  

The solution image must already be built. Now, to build the "submission" image **WITH ENCRYPTION**, execute the following commands:  
```bash
$ cd ~/srcp2-competitors
$ ./build-wvu-submission-image.bash -i todo:wvu_mountaineers_sol -t wvu_mountaineers_src2 -w /ros_workspace -p state_machine -1 sm_round1.launch -2 sm_round2.launch -3 sm_round3.launch
```   

To build the "submission" image **WITHOUT ENCRYPTION**, execute the following command (only difference is `--no-encryption` is added):
```bash
$ cd ~/srcp2-competitors
$ ./build-wvu-submission-image.bash --no-encryption -i todo:wvu_mountaineers_sol -t wvu_mountaineers_src2 -w /ros_workspace -p state_machine -1 sm_round1.launch -2 sm_round2.launch -3 sm_round3.launch
```   
NOTE: The default arguments exist in the script, but to ensure the proper files and parameters are used, please include the arguments.

## Run Submission Image
To run the submission image, run the simulator, then run the submission image.
* To run the simulator, execute:
```bash
$ cd ~/srcp2-competitors
$ ./docker/scripts/launch/roslaunch_docker -r <round-number>
```
* To run the submission, execute:
```bash
$ cd ~/srcp2-competitors
$ ./docker/scripts/qual_submission/run-submission.bash -r <round-number> -t wvu_mountaineers_src2
```

## Links
The submission guidelines from NASA are provided here: https://gitlab.com/scheducation/srcp2-competitors/-/wikis/Documentation/Rules/Submission  

A demo for generating the docker images from NASA is provided here: https://gitlab.com/scheducation/srcp2-competitors/-/tree/master/docker/scripts/qual_submission
