# SRC2-scripts
This repository contains all scripts need for generating the docker images for submission as well as instructions for setting up the simulator and worksace (required for building the docker images).
  
# Quick Start (Minimal Steps for Testing Submission)
This quick start assume that you already have installed [Docker](https://gitlab.com/scheducation/srcp2-competitors/-/wikis/Documentation/Install-Run/Install-Docker), [Nvidia Drivers](https://gitlab.com/scheducation/srcp2-competitors/-/wikis/Documentation/Install-Run/Install-Nvidia-Driver), and [Nvidia Docker Support](https://gitlab.com/scheducation/srcp2-competitors/-/wikis/Documentation/Install-Run/Install-Nvidia-Docker-Support).  

1. Download scripts needed for building submission image:   
```bash
$ git clone https://gitlab.com/scheducation/srcp2-competitors.git ~/srcp2-competitors
$ curl https://raw.githubusercontent.com/wvu-navLab/SRC2-scripts/master/build-wvu-submission-image.bash?token=ABXQJT32NBOFDCJNXH2YCIC7NIVYW > ~/srcp2-competitors/build-wvu-submission-image.bash && curl https://raw.githubusercontent.com/wvu-navLab/SRC2-scripts/master/wvu-submission-entrypoint.bash?token=ABXQJT32EFVHD7QOONYKVJS7NIV46 > ~/srcp2-competitors/wvu-submission-entrypoint.bash && curl https://raw.githubusercontent.com/wvu-navLab/SRC2-scripts/master/wvu_submission.dockerfile?token=ABXQJTYTW7PV7Y7JCUZM3NS7NIWEQ > ~/srcp2-competitors/wvu_submission.dockerfile && chmod +x ~/srcp2-competitors/build-wvu-submission-image.bash && chmod +x ~/srcp2-competitors/wvu-submission-entrypoint.bash
```   
2. Build the submission image without encryption using our solution image on Docker Hub (where the `<solution-tag>` is the version of the solution image pulled from our Docker Hub):   
```bash
$ cd ~/srcp2-competitors
$ ./build-wvu-submission-image.bash --no-encryption -i wvumountaineers/srcp2_qualification_solution:<solution-tag> -t wvu_mountaineers_src2 -w /ros_workspace -p state_machine -1 sm_round1.launch -2 sm_round2.launch -3 sm_round3.launch
```   
3. Run the simulator (replacing `<round-number>`)
```bash
$ cd ~/srcp2-competitors
$ ./docker/scripts/launch/roslaunch_docker -r <round-number>
```
4. Run the submission image (replacing `<round-number>`)
```bash
$ cd ~/srcp2-competitors
$ ./docker/scripts/qual_submission/run-submission.bash -r <round-number> -t wvu_mountaineers_src2
```
5. Unpause the simulator.  

NOTE: If you get the error, unable to find the public key "../encryption/srcp2-public.pem". Update the competitors folder.
  
# Creating Docker Images from Workspace
## 1. Dependencies
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
    
## 2. Setup Workspace Inside Competitors Folder
To setup the workspace (inside of the competition folder), execute the following commands:  
```bash
$ git clone https://gitlab.com/scheducation/srcp2-competitors.git ~/srcp2-competitors
$ git config --global credential.helper cache
$ mkdir -p ~/srcp2-competitors/ros_workspace/src
$ wstool init ~/srcp2-competitors/ros_workspace/src/ https://raw.githubusercontent.com/wvu-navLab/SRC2-scripts/master/solution.rosinstall?token=ABXQJT5AQKGDHJO6BPDW65C7NJFJM
```  

This is not necessary for building the images, but you should be able to compile the code in the workspace. To do so, execute the commands:
```bash
$ cd ~/srcp2-competitors/ros_workspace
$ source install/setup.bash
$ catkin_make
```  

## 3. Download Scripts for Creating Docker Images  
Follow the instruction for setting up the workspace inside the competitors folder, then add the docker files and scripts in this repository to the competitors folder. You can do this manually or by executing the following command:  
```bash
$ curl https://raw.githubusercontent.com/wvu-navLab/SRC2-scripts/master/build-wvu-solution-image.bash?token=ABXQJT5U56E2DH3YG7DWBLK7NIVGW > ~/srcp2-competitors/build-wvu-solution-image.bash && curl https://raw.githubusercontent.com/wvu-navLab/SRC2-scripts/master/build-wvu-submission-image.bash?token=ABXQJT32NBOFDCJNXH2YCIC7NIVYW > ~/srcp2-competitors/build-wvu-submission-image.bash && curl https://raw.githubusercontent.com/wvu-navLab/SRC2-scripts/master/wvu-submission-entrypoint.bash?token=ABXQJT32EFVHD7QOONYKVJS7NIV46 > ~/srcp2-competitors/wvu-submission-entrypoint.bash && curl https://raw.githubusercontent.com/wvu-navLab/SRC2-scripts/master/wvu_solution.dockerfile?token=ABXQJT3W2NAY2YY4BLT4LIS7NIWB4 > ~/srcp2-competitors/wvu_solution.dockerfile && curl https://raw.githubusercontent.com/wvu-navLab/SRC2-scripts/master/wvu_submission.dockerfile?token=ABXQJTYTW7PV7Y7JCUZM3NS7NIWEQ > ~/srcp2-competitors/wvu_submission.dockerfile
$ chmod +x ~/srcp2-competitors/build-wvu-solution-image.bash && chmod +x ~/srcp2-competitors/build-wvu-submission-image.bash && chmod +x ~/srcp2-competitors/wvu-submission-entrypoint.bash
```  

NOTE: To delete cache and existing docker images, execute `docker system prune -a`. The build commands for docker should automatically detect changes in the .dockerfile and update the image accordingly, but this command is useful to ensure the image is built correctly after making modifications.

## 4. Create Solution Image (only needed if not using solution image on Docker Hub)   
From the previous step, the `build-wvu-solution-image.bash`, `wvu_solution.dockerfile`, `build-wvu-submission-image.bash`, `wvu_submission.dockerfile`, and `wvu-submission-entrypoint.bash` should be in the cloned directory `~/srcp2-competitors`.  
  
Execute the following commands to build the solution image replacing `<solution-tag>`:  
```bash
$ cd ~/srcp2-competitors
$ ./build-wvu-solution-image.bash -n wvumountaineers/srcp2_qualification_solution:<solution-tag>
```  
To push the solution image, execute the following command replaceing `<solution-tag>` (**Careful! Avoid overwriting existing solution images. Instead, just create a new tag when pushing. Check the [solution repository](https://hub.docker.com/repository/docker/wvumountaineers/srcp2_qualification_solution) to see existing tags.**):
```bash
docker push wvumountaineers/srcp2_qualification_solution:<solution-tag>
```

## 5. Create Submission Image  
**IMPORTANT: The tag of our "submission" to their dockerhub is (and MUST be) "wvu_mountaineers_src2". This is specified when building the submission image (using `-t wvu_mountaineers_src2`) and is different from `<solution-tag>`.**  

**WITH ENCRYPTION:** To build the "submission" image with encryption, execute the following commands replacing `<solution-tag>`:  
```bash
$ cd ~/srcp2-competitors
$ ./build-wvu-submission-image.bash -i wvumountaineers/srcp2_qualification_solution:<solution-tag> -t wvu_mountaineers_src2 -w /ros_workspace -p state_machine -1 sm_round1.launch -2 sm_round2.launch -3 sm_round3.launch
```   

**WITHOUT ENCRYPTION:** To build the "submission" image without encryption, execute the following commands replacing `<solution-tag>` (only difference is `--no-encryption` is added):
```bash
$ cd ~/srcp2-competitors
$ ./build-wvu-submission-image.bash --no-encryption -i wvumountaineers/srcp2_qualification_solution:<solution-tag> -t wvu_mountaineers_src2 -w /ros_workspace -p state_machine -1 sm_round1.launch -2 sm_round2.launch -3 sm_round3.launch
```   
If the "solution" image is on Docker Hub, then the build script will automatically pull the docker image for building the submission image. To build and push a "solution" image see instructions from previous steps.

## 6. Run Submission Image
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
