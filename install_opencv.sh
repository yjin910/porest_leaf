echo "Install YOLO"
cd model
sudo rm coco.names
sudo rm yolov3.cfg
sudo rm yolov3.weights

wget https://pjreddie.com/media/files/yolov3.weights
wget https://github.com/pjreddie/darknet/blob/master/cfg/yolov3.cfg?raw=true -O ./yolov3.cfg
wget https://github.com/pjreddie/darknet/blob/master/data/coco.names?raw=true -O ./coco.names

echo "Install OpenCV"

# Clean build directories
cd ~/
rm -rf ~/opencv/build

# Update packages

echo "Update packages"

sudo apt -y update
sudo apt -y upgrade


# Install OS Libraries

echo "---------------------"
echo "---------------------"
echo "Install OS Libraries"

sudo apt-get -y install build-essential cmake
sudo apt-get -y install cmake
sudo apt-get -y install pkg-config

sudo apt-get -y install libpng12-dev libjpeg-dev libtiff5-dev libjasper-dev
sudo apt-get -y install libavformat-dev libxvidcore-dev libswscale-dev libxine2-dev libavcodec-dev libx264-dev
sudo apt-get -y install libv4l-dev v4l-utils libpng-dev libtiff-dev
sudo apt-get -y install libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev
sudo apt-get -y install libqt4-dev mesa-utils libgl1-mesa-dri libqt4-opengl-dev libgtk-3-dev
sudo apt-get -y install libatlas-base-dev gfortran libeigen3-dev
sudo apt-get -y install libopencv-core-dev libfontconfig1-dev libcairo2-dev
sudo apt-get -y install libgdk-pixbuf2.0-dev libpango1.0-dev libgtk2.0-dev 
sudo apt-get -y install libqtgui4 libqtwebkit4 libqt4-test python3-pyqt5 ffmpeg

# Install Python Libraries

sudo apt-get -y install python-dev python2.7-dev python3-dev libpython3-dev libpython3.4-dev libpython3.5-dev python-numpy python3-numpy


# Download OpenCV and OpenCV_Contrib
mkdir opencv
cd opencv
rm opencv.zip
rm opencv_contrib.zip
rm -rf opencv-4.2.0
rm -rf opencv_contrib-4.2.0

wget -O opencv.zip https://github.com/opencv/opencv/archive/4.2.0.zip
unzip opencv.zip

wget -O opencv_contrib.zip https://github.com/opencv/opencv_contrib/archive/4.2.0.zip
unzip opencv_contrib.zip

# Compile and install OpenCV with contrib modules

cd opencv-4.2.0
mkdir build
cd build

# Start the compilation and installation process

echo "Start compilation and installation process"

cmake -D CMAKE_BUILD_TYPE=RELEASE \
      -D CMAKE_INSTALL_PREFIX=/usr/local \
      -D WITH_TBB=OFF \
      -D WITH_IPP=OFF \
      -D BUILD_WITH_DEBUG_INFO=OFF \
      -D BUILD_DOCS=OFF \
      -D INSTALL_C_EXAMPLES=ON \
      -D INSTALL_PYTHON_EXAMPLES=ON \
      -D BUILD_EXAMPLES=OFF \
      -D BUILD_TESTS=OFF \
      -D BUILD_PERF_TESTS=OFF \
      -D ENABLE_NEON=ON \
      -D WITH_QT=ON \
      -D WITH_OPENGL=ON \
      -D OPENCV_EXTRA_MODULES_PATH=../../opencv_contrib-4.2.0/modules \
      -D WITH_V4L=ON \
      -D WITH_FFMPEG=ON \
      -D WITH_XINE=ON \
      -D BUILD_NEW_PYTHON_SUPPORT=ON \
      -D PYTHON2_INCLUDE_DIR=/usr/include/python2.7 \
      -D PYTHON2_NUMPY_INCLUDE_DIRS=/usr/lib/python2.7/dist-packages/numpy/core/include/ \
      -D PYTHON2_PACKAGES_PATH=/usr/lib/python2.7/dist-packages \
      -D PYTHON2_LIBRARY=/usr/lib/arm-linux-gnueabihf/libpython2.7.so \
      -D PYTHON3_INCLUDE_DIR=/usr/include/python3.5m \
      -D PYTHON3_NUMPY_INCLUDE_DIRS=/usr/lib/python3/dist-packages/numpy/core/include/ \
      -D PYTHON3_PACKAGES_PATH=/usr/lib/python3.5/dist-packages \
      -D PYTHON3_LIBRARY=/usr/lib/arm-linux-gnueabihf/libpython3.5m.so \
      ../


make -j$(nproc) 
sudo make install 

sudo sh -c 'echo '/usr/local/lib' > /etc/ld.so.conf.d/opencv.conf'
sudo ldconfig


# Reset swap file

echo "Reset swap file"

sudo sed -i 's/CONF_SWAPSIZE=1024/CONF_SWAPSIZE=100/g' /etc/dphys-swapfile
sudo /etc/init.d/dphys-swapfile stop
sudo /etc/init.d/dphys-swapfile start


echo "sudo modprobe bcm2835-v4l2" >> ~/.profile


# create opencv4 file
sudo cp -rf opencv4.pc /usr/local/lib/

echo "Done!"
