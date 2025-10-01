# VGN Dockerfile
FROM ros:noetic-ros-base
SHELL ["/bin/bash", "-lc"]

# Install system dependencies
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
      git cmake build-essential \
      libeigen3-dev libopencv-dev libpcl-dev \
      libyaml-cpp-dev libgoogle-glog-dev \
      libhdf5-dev libgflags-dev \
      openmpi-bin libopenmpi-dev \
      python3-pip python3-dev python3-venv \
      python3-catkin-tools \
      ros-noetic-tf2-ros \
    && rm -rf /var/lib/apt/lists/*

# Clone VGN repo 
RUN git clone https://github.com/ethz-asl/vgn /vgn

# Install Python dependencies
RUN pip3 install --no-cache-dir -r /vgn/requirements.txt && \
    pip3 install --no-cache-dir "numpy>=1.23"

# Catkin workspace build
RUN mkdir -p /vgn/catkin_ws/src && \
    ln -s /vgn /vgn/catkin_ws/src/vgn && \
    cd /vgn/catkin_ws && \
    catkin init && \
    catkin config --extend /opt/ros/noetic && \
    catkin build vgn

# Auto-source catkin env for interactive shells
RUN echo 'source /opt/ros/noetic/setup.bash' >> /etc/bash.bashrc && \
    echo 'source /vgn/catkin_ws/devel/setup.bash' >> /etc/bash.bashrc

WORKDIR /vgn

# Default to bash
CMD ["bash"]
