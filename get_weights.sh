#!/bin/bash

set -ueo pipefail

THIS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"


WEIGHTS_PATH="$THIS_DIR/darknet_ros/yolo_network_config/weights"

WEIGHT_NAME="tiny-yolo-voc.weights"
WEIGHT_FILE="$WEIGHTS_PATH/$WEIGHT_NAME"
if [ ! -f $"WEIGHT_FILE" ]; then
    echo "Downloading $WEIGHT_NAME to $WEIGHTS_PATH"
    wget "http://pjreddie.com/media/files/$WEIGHT_NAME" -P "$WEIGHTS_PATH"
else
    echo "Weight file $WEIGHT_FILE already exists"
fi

echo "------------------"

WEIGHT_NAME="yolo.weights"
WEIGHT_FILE="$WEIGHTS_PATH/$WEIGHT_NAME"
if [ ! -f $"WEIGHT_FILE" ]; then
    echo "Downloading $WEIGHT_NAME to $WEIGHTS_PATH"
    wget "http://pjreddie.com/media/files/$WEIGHT_NAME" -P "$WEIGHTS_PATH"
else
    echo "Weight file $WEIGHT_FILE already exists"
fi
