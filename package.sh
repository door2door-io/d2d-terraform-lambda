#!/bin/bash

set -ex

RUNTIME="$1"
SRC_PATH="$2"
BUILD_PATH="$3"


function build_python {
    if [ -f "${BUILD_PATH}/requirements.txt" ]
    then
        docker run --rm --volume ${BUILD_PATH}:/var/task lambci/lambda:build-${RUNTIME} pip install -t /var/task -r requirements.txt
        find ${BUILD_PATH} \( -name \*.pyc -o -name \*.pyo -o -name __pycache__ \) -prune -exec rm -rf {} +
    fi
}


function build_nodejs {
    if [ -f "${BUILD_PATH}/package.json" ]
    then
        docker run --rm --volume ${BUILD_PATH}:/var/task lambci/lambda:build-${RUNTIME} npm install
    fi
}


# Prepare build directory
rm -rf "${BUILD_PATH}"
mkdir -p "$(dirname ${BUILD_PATH})"
cp -a "${SRC_PATH}" "${BUILD_PATH}"


case "$RUNTIME" in
    python2.7|python3.6)
        build_python
        ;;
    nodejs|nodejs4.3|nodejs6.10)
        build_nodejs
        ;;
esac
