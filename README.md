# SRC2-scripts
This repository contains all scripts need for generating the docker images for submission as well as instructions for setting up the simulator and worksace (required for building the docker images).


## Cleanup Docker
```
docker system prune -a
```

## Copy files from Github
Copy `wvu_competitor.dockerfile` to `~/srcp2-final-public/docker/dockerfiles` folder, `wvu_srcp2_final` script to `~/srcp2-final-public/docker/scripts` folder, and `wvu_comp_final` script to `~/srcp2-final-public/docker/scripts` folder.

```
curl "https://raw.githubusercontent.com/wvu-navLab/SRC2-scripts/master/wvu_competitor.dockerfile?token=ABXQJT6NSOENIUYYKP2A4H3AGAZXU" > ~/srcp2-final-public/docker/dockerfiles/wvu_competitor.dockerfile && curl "https://raw.githubusercontent.com/wvu-navLab/SRC2-scripts/master/wvu_comp_final.sh?token=ABXQJTYQ4ZTX5M3LJMH3FLLAGA5VC" > ~/srcp2-final-public/docker/scripts/wvu_comp_final && curl "https://raw.githubusercontent.com/wvu-navLab/SRC2-scripts/master/wvu_srcp2_final.sh?token=ABXQJT2BMEDLDZ53LXEYFH3AGA5WW" > ~/srcp2-final-public/docker/scripts/wvu_srcp2_final && chmod +x ~/srcp2-final-public/docker/scripts/wvu_comp_final && chmod +x ~/srcp2-final-public/docker/scripts/wvu_srcp2_final
```

## Build the local Docker image

```
docker build --rm -t wvu-competitor -f ~/srcp2-final-public/docker/dockerfiles/wvu_competitor.dockerfile .
```

## Launch the sim

```
~/srcp2-final-public/docker/scripts/wvu_srcp2_final -C ~/srcp2-final-public/config/default_config.yaml -L
```

## Launch terminal on Docker image
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
