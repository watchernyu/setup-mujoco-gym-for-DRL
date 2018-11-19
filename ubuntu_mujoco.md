## Additional notes on setting up Mujoco on Ubuntu
The process is very similar to setting up on HPC. However, you also need to make sure you have required system packages.

There is a list given on the mujoco-py page: 
https://github.com/openai/mujoco-py/blob/master/Dockerfile

You don't have to run everything in this dockerfile, but you might want to install the following:

```
sudo apt-get install curl \
    git \
    libgl1-mesa-dev \
    libgl1-mesa-glx \
    libglew-dev \
    libosmesa6-dev \
    software-properties-common \
    net-tools \
    unzip \
    vim \
    virtualenv \
    wget \
    xpra \
    xserver-xorg-dev \
    patchelf
```
