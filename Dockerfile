ARG BASE_IMAGE=ros
ARG BASE_IMAGE_TAG=kinetic

FROM ${BASE_IMAGE}:${BASE_IMAGE_TAG}

ARG BASE_IMAGE=ros
ARG BASE_IMAGE_TAG=kinetic

# ---------------------------------------------

RUN echo "source /opt/ros/kinetic/setup.sh" >> ~/.bashrc

RUN apt-get -q update && apt-get -qq install \
    less \
    vim \
    wget


WORKDIR /workspace/darknet_ros
COPY darknet src/darknet
COPY darknet_ros src/darknet_ros
COPY darknet_ros_msgs src/darknet_ros_msgs
COPY tut_common_msgs src/tut_common_msgs

RUN apt-get -q update && apt-get -qq install \
    libx11-dev

RUN apt-get -q update && apt-get -qq install -y \
    ros-kinetic-ros-base \
    ros-kinetic-image-transport \
    ros-kinetic-cv-bridge

RUN /bin/bash -c "source /opt/ros/kinetic/setup.bash && catkin_make install -DCMAKE_BUILD_TYPE=Release"
RUN echo "source $(pwd)/install/setup.sh" >> ~/.bashrc

WORKDIR /workspace

# Run the ros interface by default
CMD /bin/bash -c "source /opt/ros/kinetic/setup.bash && source darknet_ros/install/setup.bash && roslaunch darknet_ros darknet_ros.launch"

