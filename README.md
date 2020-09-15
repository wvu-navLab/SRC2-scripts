**The solution.rosinstall and instructions have only been tested for round one code. Need to add details for round 2 and round 3.**

# SRC2-scripts
Scripts for generating docker images for submission.  
  
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
$ wstool init srcp2-competitors/ros_workspace/src/ https://raw.githubusercontent.com/wvu-navLab/SRC2-meta/master/solution.rosinstall?token=ABXQJT2U46WGMCNQYNRVZZK7NBMVS
```  
  
## Creating Docker Images   
Follow the instruction for setting up the workspace inside the competitors folder, then add the docker files and scripts in this repository to the competitors folder. You can do this using the following commands:  
```bash
$ TODO
$ TODO
$ TODO
$ TODO
$ TODO
```  

NOTE: To delete cache and existing docker images, execute `docker system prune -a`. The build commands for docker should detect changes in the .dockerfile, but using this command is useful to ensure the image is built correctly after modifications.

### Build Solution Image   
From the previous step, the `build-wvu-solution-image.bash`, `wvu_solution.dockerfile`, `wvu_solution.dockerfile`, `wvu_solution.dockerfile`, and `wvu_solution.dockerfile` should be in the to the cloned directory `~/srcp2-competitors`.  
  
Execute the following commands to build the solution image:  
```bash
$ cd ~/srcp2-competitors
$ ./build-wvu-solution-image.bash -n TODO:wvu_mountaineers_sol
```  
If `build-wvu-solution-image.bash` is not an executable, execute `chmod +x build-wvu-solution-image.bash`.  
  
### Build Submission Image  
**IMPORTANT: The tag of our "submission" to their dockerhub is (and MUST be) "wvu_mountaineers_src2".**  

The solution image must already be built. Now, to build the submission image **WITH DEFAULT ENCRYPTION**, execute the following commands:  
```bash
$ cd ~/srcp2-competitors
$ ./build-wvu-submission-image.bash -i TODO:wvu_mountaineers_sol -t wvu_mountaineers_src2 -w /ros_workspace -p state_machine -1 sm_round1.launch -2 sm_round2.launch -3 sm_round3.launch
```   

To build the solution image **WITHOUT ENCRYPTION**, execute the following command:
```bash
$ cd ~/srcp2-competitors
$ ./build-wvu-submission-image.bash -i TODO:wvu_mountaineers_sol -t wvu_mountaineers_src2 -w /ros_workspace -p state_machine -1 sm_round1.launch -2 sm_round2.launch -3 sm_round3.launch --no-encryption
```   
NOTE: The default arguments exist in the script, but to ensure the proper files and parameters are used, please include the arguments.

## Run Submission Image
To run the submission image, run the simulator, then run the submission image.
* To run the simulator, execute:
```bash
$ ~/./docker/scripts/launch/roslaunch_docker -r <round-number>
```
* To run the submission, execute:
```bash
$ ~/./docker/scripts/qual_submission/run-submission.bash -r <round-number> -t wvu_mountaineers_src2
```
