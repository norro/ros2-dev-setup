# ROS 2 Development Setup

While building my ROS 2 package from source for different ROS 2 distributions, I found myself repeating the same steps (my *best practices*) over and over again for the different distributions. So I decided to put them in a script and make them open-source ([Apache License Version 2.0](./LICENSE)).

## What it does

This [script](./ubuntu-ros-2-developer-setup.sh) is basically automating what is documented in [Building ROS 2 on Linux](https://index.ros.org/doc/ros2/Installation/Crystal/Linux-Development-Setup/). It asks you some questions, e.g., which of the ROS 2 distributions you want to install, and tries to do most of the rest conveniently in the background. Additionally, after installation, it will provide for your convenience:  

1. a script in your home folder that sets essential environment variables, sources the correct files, and brings you to your ROS 2 installation folder. This script is for you to call whenever you want to start working (building) with ROS 2: `~/ros2{distro}.sh`
1. a script that resides in your ROS 2 workspace and does an upgrade of your distribution whenever you feel like it: `{workspace}/workspace-upgrade.sh`
1. the aliases `colcon_build` and `colcon_test` that call colcon in a proper way. If you use these aliases for all your package builds, you should be fine. 

## Usage

Usage of the script is fairly simple. Clone this repository and within its root folder, call:  

`./ubuntu-ros-2-developer-setup.sh {distro} {workspace}`

`{distro}` is the code name of your desired ROS 2 disrtibution, e.g., `foxy` or `rolling`. `{workspace}` is the target folder of your ROS 2 setup. If everything worked out, a good thing to do is:

1. source the script that prepares your bash for development:  
  `source ~/ros2{distro}.sh`
1. *(optional)* check if your distribution is up-to-date:  
  `./workspace-upgrade.sh`
1. build your package:  
  `colcon_build --packages-up-to {your-ros2-package}`
1. test your package:  
  `colcon_test --packages-select {your-ros2-package}`

## License

The ROS 2 Development Setup scripts are open-sourced under the Apache-2.0 license. See the [LICENSE](./LICENSE) file for details.

## Known Issues/Limitations

Currently there is only one script that is fairly tested with recent ubuntu distributions and bash. Windows and Mac OS are currently not supported ([#1](https://github.com/norro/ros2-dev-setup/issues/1), [#2](https://github.com/norro/ros2-dev-setup/issues/2)), different linux environments might nor work as expected.
