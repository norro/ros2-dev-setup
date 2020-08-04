#!/bin/bash

# distribution
D=("crystal" "dashing" "eloquent" "foxy" "galactic" "rolling")
if [[ ! " ${D[@]} " =~ " $1 " ]]; then
  echo 'Unknown ROS 2 distribution' $1 '- choose one of:' ${D[@]}
  exit 1
fi
DISTRIB=$1
M=("galactic" "rolling")
if [[ " ${M[@]} " =~ " $DISTRIB " ]]
then
  DL="master"
else
  DL=$DISTRIB
fi

# target folder
if [[ -d $2 ]]; then
  echo '... folder' $2 'exists. Overwrite?'
  read -r -p ' [y/N] ' response
  if [[ ! "$response" =~ ^([yY][eE][sS]|[yY])$ ]]
  then
      exit 1
  fi
fi
if [[ ! -d $2 ]]; then
  echo '... folder' $2 'does not exist, yet. Create?'
  read -r -p ' [Y/n] ' response
  if [[ ! "$response" =~ ^([nN][oO]|[nN])$ ]]
  then
    mkdir -p $2
  else
      exit 1
  fi
fi
FOLDER=$2

echo 'Setting up ROS 2' $DISTRIB 'in' $FOLDER '...'
sudo locale-gen en_US en_US.UTF-8
sudo update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8
export LANG=en_US.UTF-8

# Update system before anything happens
# This is also to gain admin rights right from the start
sudo sh -c 'echo "deb [arch=$(dpkg --print-architecture)] http://packages.ros.org/ros2/ubuntu $(lsb_release -cs) main" > /etc/apt/sources.list.d/ros2-latest.list'
sudo apt -y update
sudo apt -y upgrade
sudo apt -y install curl gnupg2 lsb-release

# Install development tools and ROS tools¶
curl -s https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | sudo apt-key add -
sudo apt update && sudo apt install -y \
  build-essential \
  cmake \
  git \
  python3-colcon-common-extensions \
  python3-lark-parser \
  python3-pip \
  python-rosdep \
  python3-vcstool \
  wget
# install some pip packages needed for testing
python3 -m pip install -U \
  argcomplete \
  flake8 \
  flake8-blind-except \
  flake8-builtins \
  flake8-class-newline \
  flake8-comprehensions \
  flake8-deprecated \
  flake8-docstrings \
  flake8-import-order \
  flake8-quotes \
  pytest-repeat \
  pytest-rerunfailures \
  pytest \
  pytest-cov \
  pytest-runner \
  setuptools
# install Fast-RTPS dependencies
sudo apt install --no-install-recommends -y \
  libasio-dev \
  libtinyxml2-dev

# ROS 2 folder
mkdir -p $FOLDER/src
cd $FOLDER

# convinience scripts
echo "#!/bin/bash
rm -rf ros2.repos
wget https://raw.githubusercontent.com/ros2/ros2/${DL}/ros2.repos
vcs custom --args remote update
vcs import src < ros2.repos
vcs pull src
" > workspace-upgrade.sh
chmod +x workspace-upgrade.sh
echo "export ROS_WS=${FOLDER}
cd \$ROS_WS
export ROS_DISTRO=${DISTRIB}
export ROS_PYTHON_VERSION=3

source \$ROS_WS/install/local_setup.bash

alias colcon_build=\"colcon build --symlink-install --cmake-args \\\" -DCMAKE_BUILD_TYPE=Debug\\\" --event-handler console_direct+ --base-path=src\"
alias colcon_build_nw=\"colcon build --symlink-install --cmake-args \\\" -DCMAKE_BUILD_TYPE=Debug\\\" --event-handler console_direct+ --base-path=src\"
alias colcon_test=\"colcon test --base-path=src --event-handlers console_direct+ --pytest-args \\\" --capture=no\\\"\"

export ROS_DISTRO=${DISTRIB}
export ROS_PYTHON_VERSION=3
" > ~/ros2${DISTRIB}.sh

source ~/ros2${DISTRIB}.sh
./workspace-upgrade.sh
