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
Copy the docker files and launch scripts from the scripts repository using the following commands from the home directory:  

```    
git clone https://github.com/wvu-navLab/SRC2-scripts
cp ~/SRC2-scripts/wvu_competitor.dockerfile ~/srcp2-final-public/docker/dockerfiles & cp ~/SRC2-scripts/wvu_srcp2_final ~/srcp2-final-public/docker/scripts & cp ~/SRC2-scripts/wvu_comp_final ~/srcp2-final-public/docker/scripts & mkdir ~/srcp2-final-public/config & cp ~/SRC2-scripts/default_config.yaml ~/srcp2-final-public/config & chmod +x ~/srcp2-final-public/docker/scripts/wvu_srcp2_final & chmod +x ~/srcp2-final-public/docker/scripts/wvu_comp_final
rm -rf ~/SRC2-scripts
```  
   
### Copy files from Github (manually)
If not already cloned, clone srcp2-final-public:
`git clone https://gitlab.com/scheducation/srcp2-final-public.git`

Copy `wvu_competitor.dockerfile` to `~/srcp2-final-public/docker/dockerfiles` folder, `wvu_srcp2_final` script to `~/srcp2-final-public/docker/scripts` folder, and `wvu_comp_final` script to `~/srcp2-final-public/docker/scripts` folder.

## 2. Build the local Docker image

```
cd ~/srcp2-final-public
docker build --rm -t wvu-competitor -f ~/srcp2-final-public/docker/dockerfiles/wvu_competitor.dockerfile .
```

## 3. Launching the Simulator  
  
### Alias
Add the following alias to `~/.bashrc` (only needs performed once):
```
alias src2_sim='~/srcp2-final-public/docker/scripts/wvu_srcp2_final -C ~/srcp2-final-public/config/default_config.yaml -L'
alias src2_term='~/srcp2-final-public/docker/scripts/wvu_comp_final -d -i -L'
alias src2_nterm='docker exec -it competitor-final /bin/bash'
alias src2_rviz='docker exec -it srcp2-final bash -c "source ~/ros_workspace/install/setup.bash;rosrun rviz rviz"'
```

### Launch the sim
To launch the simulator, execuate the command `src2_sim`, or the following:
```
~/srcp2-final-public/docker/scripts/wvu_srcp2_final -C ~/srcp2-final-public/config/default_config.yaml -L
```

### Launch terminal on Docker image
To launch the terminal on the Docker image, execuate the commands `src2_term` and `src2_nterm`, or the following:
```
~/srcp2-final-public/docker/scripts/wvu_comp_final -d -i -L
source ~/ros_workspace/install/setup.bash
```
# Simple bash files to easy launch the simulator and new terminals
Copy launch_sim.sh , open_new_terminal.sh and open_container.sh inside the srcp2-final-public folder

```
 cp launch_sim.sh ~/srcp2-final-public
 ```
 ```
 cp open_new_terminal.sh ~/srcp2-final-public
```
```
cp open_contianer.sh ~/srcp2-final-public
```
Also copy source_cmd.sh into /srcp2-final-public/cmp_workspace
```
 cp source_cmd.sh ~/srcp2-final-public/cmp_workspace
 ```
## How to use it
From the folder ~/srcp2-final-public
run:
```
chmod +x launch_sim.sh
```
```
chmod +x open_container.sh
```
```
chmod +x open_new_terminal.sh
```

to run the simulation
```
./launch_sim.sh
```
In new terminal run the contianer
```
./open_container.sh
```
and inside the docker terminal to source the workspaces
```
cd /home/srcp2/cmp_workspace
```
Inside the source_cmd.sh, change the correct IP address (seems to be different for everyone)
```
source source_cmd.sh
```
For every other new terminal run:
```
./open_new_terminal.sh
```
```
cd /home/srcp2/cmp_workspace
```
```
source source_cmd.sh
```
