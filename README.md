# ros2-dev-setup

While building my ROS 2 package from source for different ROS 2 distributions, I found myself repeating the same steps (my *best practices*) over and over again. So I decided to put in a script and make them public.

## What it does

This [script](./ubuntu-ros-2-developer-setup.sh) is basically automating what is documented in [Building ROS 2 on Linux¶](https://index.ros.org/doc/ros2/Installation/Crystal/Linux-Development-Setup/). It asks you some questions, e.g., which of the ROS 2 distributions you want to install, and tries to do most of the rest conveniently in the background. Additionally, after installation, it will provide two scripts for your convenience:  

1. A script in your home folder that sets some essential environment variables, sources the correct files, and brings you your ROS 2 installation folder. This script is for you to call whenever you want to start working (building) with ROS 2: `~/ros2{distro}.sh`
1. A script that resides in your ROS 2 workspace and does an upgrade of your distribution whenever you feel like it: `./workspace-upgrade.sh`
1. Introduces the aliases `colcon_build` and `colcon_test` that call colcon in a proper way. If you use these aliases for all your package builds, you should be fine. 

## Usage

Usage of the script is fairly simple. Clone this repository and within its root folder, call:  

`./ubuntu-ros-2-developer-setup.sh {distro} {folder}`

`{distro}` is the code name of your desired ROS 2 disrtibution, e.g., `foxy` or `rolling`, `{folder}` is the target folder of your installation.
