#!/bin/bash

set -ueo pipefail

THIS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"


WEIGHTS_PATH="$THIS_DIR/darknet_ros/yolo_network_config/weights/yolo_network_config/weights"

WEIGHT_NAME="tiny-yolo-voc.weights"
WEIGHT_FILE="$WEIGHTS_PATH/WEIGHT_NAME"
if [ -d $"WEIGHT_FILE" ]; then
    echo "Downloading $WEIGHT_NAME to $WEIGHTS_PATH"
    wget --quiet "http://pjreddie.com/media/files/$WEIGHT_NAME" -P "$WEIGHTS_PATH"
fi

WEIGHT_NAME="yolo.weights"
WEIGHT_FILE="$WEIGHTS_PATH/WEIGHT_NAME"
if [ -d $"WEIGHT_FILE" ]; then
    echo "Downloading $WEIGHT_NAME to $WEIGHTS_PATH"
    wget --quiet "http://pjreddie.com/media/files/$WEIGHT_NAME" -P "$WEIGHTS_PATH"
fi
