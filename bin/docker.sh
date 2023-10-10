#!/bin/bash
########################################
CURR_DIR=$(pwd)
CURR_OS=$(uname)
########################################
# Sanity check
if [[ "$CURR_OS" != *"Linux"* ]]; then
    echo "ERROR --> Incorrect OS detected for this target!"
    exit
fi
########################################
echo "LOG --> Creating directories..."
mkdir ~/.ssh
########################################
# Move config files around.
cp ./etc/config ~/.ssh
cp ./etc/.vimrc ~
########################################
# Install dependencies
echo "LOG --> Installing dependencies and updating..."
sudo apt update -y
sudo apt upgrade -y
sudo apt install build-essential -y
sudo apt install wget -y
########################################
# Install Miniforge3
if [[ ! -d "~/.miniforge3" ]]; then
    MF3_PATH="$HOME/.miniforge3"
    echo "LOG --> Installing Miniforge3..."
    mkdir $MF3_PATH
    wget "https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-$(uname)-$(uname -m).sh"
    chmod 700 "./Miniforge3-$(uname)-$(uname -m).sh"
    ./Miniforge3-$(uname)-$(uname -m).sh -b -p $MF3_PATH -f
    rm ./Miniforge3*
    $MF3_PATH/bin/conda init bash
fi
########################################
# Post Run Instructions
echo "DONE"
