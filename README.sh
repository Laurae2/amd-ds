# amd-dl
# AMD GPU Deep Learning: Setup Caffe + OpenCL

# Spent time to get a script doing all the needed stuff for Deep Learning on a hybrid AMD GPU: 150 hours or so (spread over 1 year)
# Easiest solution was using DeepCL (installs on Windows, installs on Linux without issues...), but clearly the OpenCL Caffe version is about 50x(?) faster for convultions, which is what I need.

# Confirmed working on:
# * Ubuntu 14.04 flavors
# * Elementary OS 0.32 (Ubuntu 14.04)

# Do not try with Python 3.5, it causes errors
# Do NOT install Anaconda before, it causes compilation issues that are barely solvable
# Do NOT install anything else before compiling Caffe, it causes errors randomly
# ALWAYS use a fresh machine
# It is not super optimized for maximum speed (e.g OpenCV pre-compiled for OpenCL<2, etc.)
# Change all "laurae-linux" to $HOME or to your user username in Linux
# Something not working? Reboot and retry, it takes only 20 seconds. Still not working? Check missing dependencies with the error messages.
# Want to apply .bashrc immediately without rebooting/relaunching a terminal? Use the following: source ~/.bashrc
# Got a permission error? Prepend the command with the following: sudo
# Wanna use R for xgboost? You are out of luck, I never managed to compile it correctly:
# error: unable to load shared object '/usr/local/lib/R/site-library/xgboost/libs/xgboost.so':
#   /usr/local/lib/R/site-library/xgboost/libs/xgboost.so: undefined symbol: _ZN7xgboost4data10SparsePage6Writer5AllocEPSt10unique_ptrIS1_St14default_deleteIS1_EE
# Not happy without the bleeding edge xgboost R? Use Windows because it works perfectly there...
# If you really need xgboost in Linux+R, use the typical online R package on CRAN

# There are manual steps!!! Check out all the comments every time
# Run this at the beginning to make sure you are at a stable LTS version:
sudo apt-get update
sudo apt-get dist-upgrade


#.bashrc edits
sudo gedit ~/.bashrc

#insert this in .bashrc:
export LD_LIBRARY_PATH="/usr/local/lib64/:$LD_LIBRARY_PATH"
export CLFFT_INCLUDE_DIR="/usr/local/include"
export PYTHONPATH="/home/laurae-linux/Downloads/caffe/python/:$PYTHONPATH"

#install pre-reqs
sudo apt-get install gfortran aptitude default-jdk dkms lib32gcc1 unzip libX11-dev mesa-common-dev build-essential doxygen protobuf-compiler libgl1-mesa-dev mesa-utils gcc g++ git libopenblas-base libopenblas-dev libblas-dev valgrind
sudo apt-get install libprotobuf-dev libleveldb-dev libsnappy-dev libopencv-dev libboost-all-dev libhdf5-serial-dev libopenblas-dev
sudo apt-get install libgflags-dev libgoogle-glog-dev liblmdb-dev protobuf-compiler checkinstall cmake make git python qt5-default libqt4-dev
sudo apt-get install python-pip
sudo pip install --upgrade pip setuptools
sudo pip install protobuf

#install AMD Toolkit: if you need to use fglrx/fglrx-updates to install AMD OpenCL toolkit, install AMD OpenCL Toolkit AFTER rebooting
#if you still have issues, force Linux to use AMD GPU using the following for the WHOLE steps: https://github.com/beidl/amd-indicator

#clFFTW
sudo apt-get install libfftw3-dev

#clFFT (OpenCL)
cd $HOME/Downloads
git clone https://github.com/clMathLibraries/clFFT
cd clFFT
mkdir build
cd build
cmake ../src
make
sudo checkinstall --pkgname=clfft

#install MTL4
cd $HOME/Downloads
http://www.simunova.com/downloads/mtl4/MTL-4.0.9555-Linux.deb

#install Eigen 3
sudo apt-get install libeigen3-dev

#download first cmake-3.5.2
cd $HOME/Downloads
wget http://www.cmake.org/files/v3.5/cmake-3.5.2.tar.gz
#uncompress cmake-3.5.2
cd cmake-3.5.2
./bootstrap --qt-gui
make
sudo make install
sudo update-alternatives --install /usr/bin/cmake cmake /usr/local/bin/cmake 1 --force
sudo update-alternatives --install /usr/bin/cmake-gui cmake-gui /usr/local/bin/cmake-gui 1 --force
cmake --version

#install ViennaCL
cd $HOME/Downloads
git clone https://github.com/viennacl/viennacl-dev
#move /viennacl in /usr/include/viennacl, no need to build in fact

#prepare Caffe
cd $HOME/Downloads
git clone -b opencl https://github.com/BVLC/caffe
cd caffe
cp Makefile.config.example Makefile.config
for req in $(cat python/requirements.txt); do sudo pip install $req; done

#setup Makefile.config
#line 10: uncomment: USE_CUDA, and set to 0 (USE_CUDA := 1)
#line 18: add: VIENNACL_DIR = /usr/include/viennacl
#line 19: add: OPENCL_INCLUDE_DIRS=/opt/AMDAPPSDK-3.0/include
#line 37: uncomment: USE_FFT := 1
#line 81: change: BLAS := open
#line 100: change: /usr/local/lib/python2.7/dist-packages/numpy/core/include/
#line 122: uncomment: WITH_PYTHON_LAYER := 1

#compile and test
make all
make test
make runtest
make pycaffe

#Install missing Anaconda features
pip install -r python/requirements.txt

#Install Caffe Python
make pycaffe

#fix ~/.bashrc, change accordingly
export CAFFE_ROOT=/home/laurae-linux/caffe

#install Anaconda 2.7

#fix Anaconda 2.7
sudo chown -R laurae-linux /home/laurae-linux/anaconda2
sudo chmod -R +x /home/laurae-linux/anaconda2
conda update conda
conda update --all
#update Anaconda 2.7 with pre-reqs
for req in $(cat python/requirements.txt); do conda install $req; done

#xgboost installation + Python xgboost
cd $HOME/Downloads
git clone --recursive https://github.com/dmlc/xgboost
cd xgboost
make
cd python-package
python setup.py install
