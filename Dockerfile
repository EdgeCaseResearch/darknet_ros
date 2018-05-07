ARG BASE_IMAGE=ros
ARG BASE_IMAGE_TAG=kinetic

FROM ${BASE_IMAGE}:${BASE_IMAGE_TAG}

# ---------------------------------------------

RUN echo "source /opt/ros/kinetic/setup.sh" >> ~/.bashrc

RUN apt-get -q update && apt-get -qq install \
    less \
    vim \
    wget \
    libx11-dev  \
    ros-kinetic-ros-base \
    ros-kinetic-image-transport \
    ros-kinetic-cv-bridge \
    git


WORKDIR /workspace/darknet_ros
COPY darknet src/darknet
COPY darknet_ros src/darknet_ros
COPY darknet_ros_msgs src/darknet_ros_msgs
RUN git clone https://github.com/EdgeCaseResearch/tut_common_msgs.git /workspace/darknet_ros/src/tut_common_msgs

RUN /bin/bash -c "source /opt/ros/kinetic/setup.bash && catkin_make install -DCMAKE_BUILD_TYPE=Release"
RUN echo "source $(pwd)/install/setup.sh" >> ~/.bashrc

WORKDIR /workspace

# Run the ros interface by default
CMD /bin/bash -c "source /opt/ros/kinetic/setup.bash && source darknet_ros/install/setup.bash && roslaunch darknet_ros darknet_ros.launch"

