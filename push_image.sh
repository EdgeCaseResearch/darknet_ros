#!/bin/bash
# Edge Case Research LLC. Copyright (C) 2018. All Rights Reserved

set -ueo pipefail

function printUsage() {
    echo "Usage:  "
    echo "  push_docker.sh <target> [<nvidia_compute>]"
    echo "  where <target> is one of:"
    echo "      gpu      Build for Nvidia GPU with CUDA"
    echo "      cpu      Build for CPU only"
    echo "  where <nvidia_compute> is the compute number for your graphics card. It is required when the target is 'gpu'. Some examples are:"
    echo "      61      Alienware's GeForce GTX 1070 Ti"
    echo "      52      GeForce GTX 970M"
    echo "      37      AWS's Tesla K30"

}


TARGET="$1"
NVIDIA_COMPUTE="${2:-}"

if [ -z "$TARGET" ]; then
    printUsage
    exit 1
fi

IMAGE_NAME="quay.io/edgecase/sut"
BASE_TAG="darknet-ros"

THIS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"



if [ "${TARGET}" == "gpu" ]; then

  if [ -z "$NVIDIA_COMPUTE" ]; then
      printUsage
      exit 1
  fi
    # Build the GPU base image

    FULL_IMAGE_NAME="${IMAGE_NAME}:${BASE_TAG}-${TARGET}-${NVIDIA_COMPUTE}"


fi

if [ "${TARGET}" == "cpu" ]; then

    FULL_IMAGE_NAME="${IMAGE_NAME}:${BASE_TAG}-${TARGET}"

fi

echo "Pushing image: \"${FULL_IMAGE_NAME}\""

echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin quay.io
docker push "${FULL_IMAGE_NAME}"

echo "Pushed image: \"${FULL_IMAGE_NAME}\""