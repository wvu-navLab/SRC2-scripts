# SRC2-scripts
This repository contains all scripts need for generating the docker images for submission as well as instructions for setting up the simulator and worksace (required for building the docker images).

## 1. Copying Files

### Cleanup Docker
```
docker system prune -a
```
### Copy files from Github (automatic)
If not already cloned, clone srcp2-final-public using the following command from the home directory:
```
git clone https://gitlab.com/scheducation/srcp2-final-public.git
```  
Copy the docker files, entrypoint, and launch scripts from the scripts repository using the following commands from the home directory:  

```    
git clone https://github.com/wvu-navLab/SRC2-scripts
cp ~/SRC2-scripts/wvu_competitor.dockerfile ~/srcp2-final-public/docker/dockerfiles/wvu_competitor.dockerfile & cp ~/SRC2-scripts/wvu_competitor_submit.dockerfile ~/srcp2-final-public/docker/dockerfiles/wvu_competitor_submit.dockerfile & cp ~/SRC2-scripts/wvu_comp_final ~/srcp2-final-public/docker/scripts & mkdir ~/srcp2-final-public/docker/scripts/container & cp ~/SRC2-scripts/config_solution.yaml ~/srcp2-final-public/docker/scripts/container & chmod +x ~/srcp2-final-public/docker/scripts/wvu_comp_final
rm -rf ~/SRC2-scripts
```  
   
### Copy files from Github (manually, not required if used automatic)
If not already cloned, clone srcp2-final-public:
`git clone https://gitlab.com/scheducation/srcp2-final-public.git`

Copy `wvu_competitor.dockerfile` to `~/srcp2-final-public/docker/dockerfiles` folder, and `wvu_comp_final` script to `~/srcp2-final-public/docker/scripts` folder.

### Download Our Source Code

Download our source code using `final.rosinstall`
```
cd
git clone https://github.com/wvu-navLab/SRC2-meta
cd ~/srcp2-final-public/cmp_workspace 
wstool init src/ ~/SRC2-meta/finals.rosinstall
rm -rf ~/SRC2-meta
```

Download the .h5 file from the following link: `https://drive.google.com/file/d/1932RKOfU87ylLC-n6bQkDjD2IacnZbT_/view?usp=sharing` to `~/srcp2-final-public/cmp_workspace/src/SRC2-object-detection/src`

## 2. Build the local Docker image

```
cd ~/srcp2-final-public
docker build --rm -t wvu-competitor -f ~/srcp2-final-public/docker/dockerfiles/wvu_competitor.dockerfile .
```

## 3. Launching the Simulator  
  
### Alias
Add the following alias to `~/.bashrc` (only needs performed once):
```
alias src2_sim='~/srcp2-final-public/docker/scripts/run_srcp2_final -C ~/srcp2-final-public/docker/scripts/container/config_solution.yaml -L'
alias src2_term='~/srcp2-final-public/docker/scripts/wvu_comp_final -d -i -L'
alias src2_nterm='docker exec -it competitor-final /bin/bash'
alias src2_rviz='docker exec -it srcp2-final bash -c "source ~/ros_workspace/install/setup.bash;rosrun rviz rviz"'
```

### Launch the sim
To launch the simulator, execuate the command `src2_sim`, or the following:
```
~/srcp2-final-public/docker/scripts/wvu_srcp2_final -C ~/srcp2-final-public/docker/scripts/container/config_solution.yaml -L
```

### Launch terminal on Docker image
To launch the terminal on the Docker image, execuate the commands `src2_term` and `src2_nterm`, or the following:
```
~/srcp2-final-public/docker/scripts/wvu_comp_final -d -i -L
source ~/ros_workspace/install/setup.bash
```

### Sourcing the workspaces inside the docker terminals
Copy source_cmd.sh into /srcp2-final-public/cmp_workspace
```
 cp source_cmd.sh ~/srcp2-final-public/cmp_workspace
 ```

Inside the source_cmd.sh, change the correct IP address (seems to be different for everyone.

Then, every time a new terminal is open inside a Docker container, you can source the workspaces with:
```
cd ~/cmp_workspace && source source_cmd.sh
```

## 4. Submission

### Step 1. Download and Build Code

Download and build our code, so the `src` and `install` folders exist, which is required for building the submission image. To build properly, delete the `cmp_workspace/install`, `cmp_workspace/devel`, `cmp_workspace/build`, and `cmp_workspace/log` folders, then execute the following commands (inside the docker container):
```
cd
cd cmp_workspace
mkdir install
catkin config --install
catkin build
```

### Step 2. Copy Files for Building Solution Image
Copy files for creating solution image:   

```    
git clone https://github.com/wvu-navLab/SRC2-scripts
cp ~/SRC2-scripts/solution-entrypoint.bash ~/srcp2-final-public/docker/scripts/container & cp ~/SRC2-scripts/wvu_competitor_submit.dockerfile ~/srcp2-final-public/docker/dockerfiles/solution.dockerfile
rm -rf ~/SRC2-scripts
```  
   
### Step 3. Build Solution Image
If `./build_comp_image.bash` is not an executable, run `chmod +x build_comp_image.bash`; otherwise, run the following to build the submission image:
```
cd ~/srcp2-final-public/docker/scripts/
./build_comp_image.bash -t wvumountaineers -n -v
```

## Development

### Task Planner
The task_planner.rosinstall contains the dependencies for testing the task planner:
```
wstool init ~/srcp2-final-public/cmp_workspace/src/ https://raw.githubusercontent.com/wvu-navLab/SRC2-scripts/master/task_planning.rosinstall?token=ABXQJT3N45LJRDRVUIJI5C3ANZNVU
```
Note, if the workspace is already initialized, then the command won't work. This can be resolved by running `rm -rf ~/srcp2-final-public/cmp_workspace/src` and `mkdir ~/srcp2-final-public/cmp_workspace/src`

