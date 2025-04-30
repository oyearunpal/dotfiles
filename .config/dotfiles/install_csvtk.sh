#!/bin/bash

# Check if csvtk is already installed
if ! command -v csvtk &> /dev/null
then
    echo "Installing csvtk..."

    # Download and install csvtk if not already installed
    wget -q https://github.com/shenwei356/csvtk/releases/download/v0.33.0/csvtk_linux_amd64.tar.gz
    tar -xvf csvtk_linux_amd64.tar.gz
    sudo mv csvtk /usr/local/bin
    echo "Successfully installed csvtk"
else
    echo "csvtk is already installed"
fi
# Refer : https://bioinf.shenwei.me/csvtk/usage/
