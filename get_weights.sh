#!/bin/bash

set -ueo pipefail

THIS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

WEIGHT_URL="https://s3-us-west-2.amazonaws.com/public.ecr.guru/3rdparty/yolo"

WEIGHTS_PATH="$THIS_DIR/darknet_ros/yolo_network_config/weights"

NAMES=(
    "yolo.weights"
    "tiny-yolo-voc.weights"
    "yolo-voc.weights"
    )


for WEIGHT_NAME in "${NAMES[@]}"; do
    echo ""
    WEIGHT_FILE="${WEIGHTS_PATH}/${WEIGHT_NAME}"
    if [ -f "${WEIGHT_FILE}" ]; then
        echo "Weight file ${WEIGHT_FILE} already exists"
    else
        echo "Downloading ${WEIGHT_NAME} to ${WEIGHTS_PATH}"
        wget --quiet "${WEIGHT_URL}/${WEIGHT_NAME}" -P "${WEIGHTS_PATH}"
    fi
done
