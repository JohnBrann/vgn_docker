# VGN Docker Setup

This repository provides a setup for running the VGN inference inside a Docker container.

Pre-built image is hosted on Docker Hub (coming soon):

```bash

```

Contains:

- The ability to produce grasps on a scene using VGN's pretrained models

## Requirements

- Docker and/or Docker Compose installed on a Linux machine
- Not tested outside of Linux, instructions are for Ubuntu but should work on any machine capable of running Docker

## Setup Instructions

### 1. Installing Docker & Compose on your machine

```bash
sudo apt update
sudo apt install docker.io docker-compose
```

### 2. Clone the repository

```bash
git clone https://github.com/JohnBrann/vgn_docker
cd vgn_docker
```

### 3. Start the container (coming soon)

```bash
docker-compose up -d
```

Then enter the container:

```bash
docker exec -it vgn_docker bash
```

#### 3.1 (Optional alternative: no docker compose)
If you do not wish to use docker compose but still don't want to build the image yourself:

<pre>
# Enable X11 access from Docker containers
xhost +local:docker

# Run the container
docker run -it --rm --gpus all \
  --net=host \
  -e DISPLAY=$DISPLAY \
  -v "/tmp/.X11-unix:/tmp/.X11-unix:rw" \
  -v "$HOME/vgn/data:/vgn/data:rw" \
  vgn
</pre>

#### 3.2  (Optional alternative: local image build)
Lastly, if you wish to build the docker image yourself:

<pre>
# Build the image
docker build -t vgn:latest .

# Enable X11 access from Docker containers
xhost +local:docker
  
# Run the container
docker run -it --rm --gpus all \
  --net=host \
  -e DISPLAY=$DISPLAY \
  -v "/tmp/.X11-unix:/tmp/.X11-unix:rw" \
  -v "$HOME/vgn/data:/vgn/data:rw" \
  vgn
</pre>

### 4. Generate Grasps

Inside the container:

```bash
roscore & sleep 3 && python3 scripts/sim_grasp.py --model data/models/vgn_conv.pth --sim-gui --rviz
```

This will perform simulated grasps in pybullet

## Download Models and Data
  You will need to modify the mounted location of the model checkpoints in the run commands above. It does not matter the directory at which these files are located on your system, as long as they mounted into the docker workspace it should work. 
### Model
Download trained models from [here](https://drive.google.com/file/d/1MysYHve3ooWiLq12b58Nm8FWiFBMH-bJ/view)


## Troubleshooting: Reset Docker Environment

To fully reset Docker:

```bash
docker ps -q | xargs -r docker stop
docker ps -aq | xargs -r docker rm
docker images -q | xargs -r docker rmi
```

To remove just this image:

```bash
docker stop arm_driver_ws
docker rm arm_driver_ws
docker rmi flynnbm/arm_driver_ws:jazzy
```

## Future Improvements

- Add directions for where someone could collect and train their own model
- Add some images to the instructions to make setup more clear
