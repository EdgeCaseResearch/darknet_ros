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
    echo "      compute_61      Alienware's GeForce GTX 1070 Ti"
    echo "      compute_52      GeForce GTX 970M"
    echo "      compute_37      AWS's Tesla K30"

}


TARGET="$1"
NVIDIA_COMPUTE="${2:-}"

if [ -z "$TARGET" ]; then
    printUsage
    exit 1
fi

IMAGE_NAME="darknet_ros"
GPU_TAG="gpu"
CPU_TAG="cpu"

THIS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"



if [ "${TARGET}" == "gpu" ]; then

  if [ -z "$NVIDIA_COMPUTE" ]; then
      printUsage
      exit 1
  fi
    # Build the GPU base image


    docker build \
      --build-arg "NVIDIA_COMPUTE=${NVIDIA_COMPUTE}" \
      -f "${THIS_DIR}/Dockerfile.gpu-base" \
      -t "gpu-base:ros-kinetic-cuda-9.0" \
      "${THIS_DIR}"

    echo "------------------------------------------------------"

    docker build \
      --build-arg "BASE_IMAGE=gpu-base" \
      --build-arg "BASE_IMAGE_TAG=ros-kinetic-cuda-9.0" \
      -f "${THIS_DIR}/Dockerfile" \
      -t "${IMAGE_NAME}:${GPU_TAG}" \
      "${THIS_DIR}"

fi

if [ "${TARGET}" == "cpu" ]; then

    docker build \
      --build-arg "BASE_IMAGE=ros" \
      --build-arg "BASE_IMAGE_TAG=kinetic" \
      -f "${THIS_DIR}/Dockerfile" \
      -t "${IMAGE_NAME}:${CPU_TAG}" \
      "${THIS_DIR}"
fi