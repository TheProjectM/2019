arch=$(uname -m)
if [ "$arch" == "i686" -o "$arch" == "i386" -o "$arch" == "i486" -o "$arch" == "i586" ]; then
flag=1
else
flag=0
fi
echo "Installing OpenCV 2.4.10"
mkdir OpenCV
cd OpenCV
echo "Removing any pre-installed ffmpeg and x264"
sudo apt autoremove -y ffmpeg x264 libx264-dev

#sudo echo "deb http://archive.ubuntu.com/ubuntu/ trusty multiverse" >> /etc/apt/sources.list
#sudo echo "deb-src http://archive.ubuntu.com/ubuntu/ trusty multiverse" >> /etc/apt/sources.list

sudo apt-get install -y software-properties-common
sudo add-apt-repository -y ppa:mc3man/trusty-media
sudo apt-get update && apt-get install -y ffmpeg

echo "Installing Dependenices"
sudo apt-get -y install libopencv-dev
sudo apt-get -y install build-essential checkinstall cmake pkg-config yasm
sudo apt-get -y install libtiff4-dev libjpeg-dev libjasper-dev
sudo apt-get -y install libavcodec-dev libavformat-dev libswscale-dev libdc1394-22-dev libxine-dev libgstreamer0.10-dev libgstreamer-plugins-base0.10-dev lib
v4l-dev
sudo apt-get -y install python-dev python-numpy
sudo apt-get -y install libtbb-dev libeigen3-dev
sudo apt-get -y install libqt4-dev libgtk2.0-dev
sudo apt-get -y install libfaac-dev libmp3lame-dev libopencore-amrnb-dev libopencore-amrwb-dev libtheora-dev libvorbis-dev libxvidcore-dev
sudo apt-get -y install x264 v4l-utils
sudo apt-get -y install libgtk2.0-dev
echo "Downloading OpenCV 2.4.10"
if ! [ -f "OpenCV-2.4.10.zip" ]; then
  wget -O OpenCV-2.4.10.zip http://sourceforge.net/projects/opencvlibrary/files/opencv-unix/2.4.10/opencv-2.4.10.zip/download
fi
echo "Installing OpenCV 2.4.10"
if ! [ -d "opencv-2.4.10"]; then
  unzip OpenCV-2.4.10.zip
fi
#rm OpenCV-2.4.10.zip
cd opencv-2.4.10
rm -rf build
mkdir build
cd build
cmake -D BUILD_opencv_gpu=OFF -D WITH_CUDA=OFF -D WITH_1394=OFF -D CMAKE_BUILD_TYPE=RELEASE -D CMAKE_INSTALL_PREFIX=/usr/local -D WITH_TBB=ON -D BUILD_NEW_PY
THON_SUPPORT=ON -D WITH_V4L=ON -D BUILD_TIFF=ON -D WITH_QT=ON -D WITH_OPENGL=ON ..
make -j$(nproc)
sudo make install
sudo sh -c 'echo "/usr/local/lib" > /etc/ld.so.conf.d/opencv.conf'
sudo ldconfig
echo "OpenCV 2.4.10 ready to be used"