#!/bin/bash
# Edge Case Research LLC. Copyright (C) 2018. All Rights Reserved

set -ueo pipefail

function printUsage() {
    echo "Usage:  "
    echo "  build_image.sh <target> [<nvidia_compute>]"
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

    docker build \
      --build-arg "NVIDIA_COMPUTE=compute_${NVIDIA_COMPUTE}" \
      -f "${THIS_DIR}/Dockerfile.gpu-base" \
      -t "gpu-base:ros-kinetic-cuda-9.0" \
      "${THIS_DIR}"

    echo "------------------------------------------------------"

    docker build \
      --build-arg "BASE_IMAGE=gpu-base" \
      --build-arg "BASE_IMAGE_TAG=ros-kinetic-cuda-9.0" \
      -f "${THIS_DIR}/Dockerfile" \
      -t "${FULL_IMAGE_NAME}" \
      "${THIS_DIR}"

fi

if [ "${TARGET}" == "cpu" ]; then

    FULL_IMAGE_NAME="${IMAGE_NAME}:${BASE_TAG}-${TARGET}"

    docker build \
      --build-arg "BASE_IMAGE=ros" \
      --build-arg "BASE_IMAGE_TAG=kinetic" \
      -f "${THIS_DIR}/Dockerfile" \
      -t "${FULL_IMAGE_NAME}" \
      "${THIS_DIR}"
fi

echo "Create image: \"${FULL_IMAGE_NAME}\""