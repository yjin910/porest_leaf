echo "Install YOLO"
cd model
sudo rm coco.names
sudo rm yolov3.cfg
sudo rm yolov3.weights

wget https://pjreddie.com/media/files/yolov3.weights
wget https://github.com/pjreddie/darknet/blob/master/cfg/yolov3.cfg?raw=true -O ./yolov3.cfg
wget https://github.com/pjreddie/darknet/blob/master/data/coco.names?raw=true -O ./coco.names

echo "Install OpenCV"

# Clean opencv
cd ~/
rm -rf ~/opencv

# Update packages

echo "Update packages"

sudo apt -y update
sudo apt -y upgrade


# Install OS Libraries

echo "---------------------"
echo "---------------------"
echo "Install OS Libraries"

sudo apt-get -y install build-essential cmake
sudo apt-get -y install libjpeg-dev libtiff5-dev libjasper-dev libpng12-dev
sudo apt-get -y install libavcodec-dev libavformat-dev libswscale-dev libxvidcore-dev libx264-dev libxine2-dev
sudo apt-get -y install libv4l-dev v4l-utils
sudo apt-get -y install libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev
sudo apt-get -y install libgtk2.0-dev
sudo apt-get -y install mesa-utils libgl1-mesa-dri libgtkg12.0-dev libgtkglext1-dev
sudo apt-get -y install libatlas-base-dev gfortran libeigen3-dev
sudo apt-get -y install python2.7-dev python3-dev python-numpy python3-numpy

# Download OpenCV and OpenCV_Contrib
mkdir opencv
cd opencv

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
      -D WITH_1394=OFF \
      -D BUILD_WITH_DEBUG_INFO=OFF \
      -D BUILD_DOCS=OFF \
      -D INSTALL_C_EXAMPLES=ON \
      -D INSTALL_PYTHON_EXAMPLES=ON \
      -D BUILD_EXAMPLES=OFF \
      -D BUILD_TESTS=OFF \
      -D BUILD_PERF_TESTS=OFF \
      -D ENABLE_NEON=ON \
      -D WITH_QT=OFF \
      -D WITH_GTK=ON \
      -D WITH_OPENGL=ON \
      -D OPENCV_ENABLE_NONFREE=ON \
      -D OPENCV_EXTRA_MODULES_PATH=../../opencv_contrib-4.2.0/modules \
      -D WITH_V4L=ON \
      -D WITH_FFMPEG=ON \
      -D WITH_XINE=ON \
      -D ENABLE_PRECOMPILED_HEADERS=OFF \
      -D BUILD_NEW_PYTHON_SUPPORT=ON \
      -D OPENCV_GENERATE_PKGCONFIG=ON ../

# Reset swap file

echo "Reset swap file"
sudo sed -i 's/CONF_SWAPSIZE=100/CONF_SWAPSIZE=1024/g' /etc/dphys-swapfile
sudo /etc/init.d/dphys-swapfile stop
sudo /etc/init.d/dphys-swapfile start

# make

make
sudo make install 

sudo sh -c 'echo '/usr/local/lib' > /etc/ld.so.conf.d/opencv.conf'
sudo ldconfig


# Reset swap file

echo "Reset swap file"

sudo sed -i 's/CONF_SWAPSIZE=1024/CONF_SWAPSIZE=100/g' /etc/dphys-swapfile
sudo /etc/init.d/dphys-swapfile stop
sudo /etc/init.d/dphys-swapfile start


echo "sudo modprobe bcm2835-v4l2" >> ~/.profile


echo "Done!"
