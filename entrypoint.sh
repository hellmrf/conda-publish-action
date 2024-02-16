#!/bin/bash

set -ex
set -o pipefail

check_if_setup_file_exists() {
    if [ ! -f setup.py ]; then
        echo "setup.py must exist in the directory that is being packaged and published."
        exit 1
    fi
}

check_if_meta_yaml_file_exists() {
    if [ ! -f meta.yaml ]; then
        echo "meta.yaml must exist in the directory that is being packaged and published."
        exit 1
    fi
}

set_env(){
    export ANACONDA_API_TOKEN=$INPUT_ANACONDATOKEN
    if [ -f environment.yml ]; then
        conda env create -f environment.yml
        conda activate $(head -1 environment.yml | cut -d' ' -f2)
    fi
    conda install -y anaconda-client conda-build conda-verify
    conda config --set anaconda_upload yes
}

build_package(){
    # Build for Linux
    conda build $INPUT_ADDITIONAL_PARAMS --output-folder . .

    # Convert to other platforms: OSX, WIN
    if [[ $INPUT_PLATFORMS == *"osx"* ]]; then
    conda convert -p osx-64 linux-64/*.tar.bz2
    fi
    if [[ $INPUT_PLATFORMS == *"win"* ]]; then
    conda convert -p win-64 linux-64/*.tar.bz2
    fi
}

check_if_setup_file_exists
check_if_meta_yaml_file_exists
set_env
build_package
