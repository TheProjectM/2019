sudo apt-get install build-essential
sudo apt-get install cmake git libgtk2.0-dev pkg-config libavcodec-dev libavformat-dev libswscale-dev
cd ~
git clone https://github.com/opencv/opencv.git
cd opencv
OPENCV_DIR=$(pwd)
git checkout 3.1.0
mkdir build
cd build
cmake -D CMAKE_BUILD_TYPE=RELEASE -D CMAKE_INSTALL_PREFIX=${OPENCV_DIR} ..
make
sudo make install