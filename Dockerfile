FROM nvidia/cuda:9.0-devel

# Install ROS Kinetic
RUN sh -c 'echo "deb http://packages.ros.org/ros/ubuntu xenial main" > /etc/apt/sources.list.d/ros-latest.list' \
    && apt-key adv --keyserver hkp://ha.pool.sks-keyservers.net:80 --recv-key 421C365BD9FF1F717815A3895523BAEEB01FA116 \
    && apt-get update && apt-get install -y \
    ros-kinetic-ros-base \
    ros-kinetic-image-transport \
    ros-kinetic-cv-bridge

RUN rosdep init && rosdep update

RUN echo "source /opt/ros/kinetic/setup.sh" >> ~/.bashrc

RUN apt-get update && apt-get install -y \
    less \
    vim \
    wget

WORKDIR /workspace
RUN mkdir -p darknet_ros/src/darknet_ros

# Copy over the darknet_ros code
WORKDIR /workspace/darknet_ros/src/darknet_ros
COPY . .

# # Build the ROS messages
WORKDIR /workspace/darknet_ros
RUN rm -rf build devel install

# WORKDIR /workspace/catkin_ws/src
# RUN /bin/bash -c "source /opt/ros/kinetic/setup.bash && catkin_init_workspace"

# Source the CUDA requirements
ENV LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:/usr/local/cuda-9.0/lib64
ENV PATH=${PATH}:/usr/local/cuda-9.0/bin

# Alienware's GeForce GTX 1070 Ti
ENV NVIDIA_COMPUTE=compute_61

# GeForce GTX 970M
# ENV NVIDIA_COMPUTE=compute_52
  
# AWS's Tesla K30
# ENV NVIDIA_COMPUTE=compute_37

WORKDIR /workspace/darknet_ros
RUN /bin/bash -c "source /opt/ros/kinetic/setup.bash && catkin_make install -DCMAKE_BUILD_TYPE=Release"
RUN echo "source $(pwd)/install/setup.sh" >> ~/.bashrc

WORKDIR /workspace

# Run the ros interface by default
CMD /bin/bash -c "source /opt/ros/kinetic/setup.bash && source darknet_ros/install/setup.bash && roslaunch darknet_ros darknet_ros.launch"

