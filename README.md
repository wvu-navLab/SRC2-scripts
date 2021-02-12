# SRC2-scripts
This repository contains all scripts need for generating the docker images for submission as well as instructions for setting up the simulator and worksace (required for building the docker images).
  

## Cleanup Docker
```
docker system prune -a
```

## Copy files from Github
Copy `wvu_competitor.dockerfile` to `~/srcp2-final-public/docker/dockerfiles` folder, `wvu_srcp2_final` script to `~/srcp2-final-public/docker/scripts` folder, and `wvu_comp_final` script to `~/srcp2-final-public/docker/scripts` folder.

```
curl https://raw.githubusercontent.com/wvu-navLab/SRC2-scripts/master/wvu_competitor.dockerfile?token=ABXQJT6NSOENIUYYKP2A4H3AGAZXU > ~/srcp2-final-public/docker/dockerfiles/wvu_competitor.dockerfile && https://raw.githubusercontent.com/wvu-navLab/SRC2-scripts/master/wvu_comp_final?token=AFAVV7NA3BATZBH6LKMVCTTAGA4DE > ~/srcp2-final-public/docker/scripts/wvu_comp_final && https://raw.githubusercontent.com/wvu-navLab/SRC2-scripts/master/wvu_srcp2_final?token=AFAVV7JKDRAUTJWWP5LM2L3AGA4AA > ~/srcp2-final-public/docker/scripts/wvu_srcp2_final && chmod +x ~/srcp2-final-public/docker/scripts/wvu_comp_final && chmod +x ~/srcp2-final-public/docker/scripts/wvu_srcp2_final 
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
