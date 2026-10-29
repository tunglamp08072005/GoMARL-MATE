#!/bin/bash
# Install PyTorch and Python Packages

# Recommended: Python 3.11.2
# conda create -n gomarl python=3.11.2 -y
# conda activate gomarl

conda install pytorch::pytorch torchvision pytorch::pytorch-cuda=12.1 -c pytorch -c nvidia -y
python -m pip install --upgrade pip
pip install -r requirements.txt
