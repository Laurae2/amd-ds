# AMD GPU Deep Learning: Setup Caffe + OpenCL

# Spent time to get a script doing all the needed stuff for Deep Learning on a hybrid AMD GPU: 150 hours or so (spread over 1 year)
# Easiest solution was using DeepCL (installs on Windows, installs on Linux without issues...), but clearly the OpenCL Caffe version is about 50x(?) faster for convultions, which is what I need.
# With NVIDIA Card (@work) it took only 30 minutes to setup everything (from Linux installation to running a Caffe model), this is blatently so stupid it is so hard for OpenCL users (Intel HD Graphics / AMD Radeon)

# Confirmed working on:
# * Ubuntu 14.04 "typical flavors" (Kubuntu, etc.)
# * Elementary OS 0.32 (Ubuntu 14.04)

# What it does is the following:
# Install all pre-requisites, including Python 2.7 and pip and requirements we will never use
# Install Caffe against the pre-requirements
# Do post-installation tweaks by installation Anaconda, setting permissions, resetting pre-requirements to Anaconda
# Install xgboost
# Test everything against Anaconda

# Compilation problems? Set ~/.bashrc according to the end of this page.
# Installation prompts when creating .deb packages so you can reinstall QUICKLY...? Answer the following in order:
# - Documentation: n
# - Changes: Enter
# - Install: Enter
# - Stuff out of place: n
# - Ignore stuff out of place: y
# Installation works but using the library/package fails? Use the command provided after checkinstall to uninstall properly!

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
# DO NOT CLEAN UP ALL THE FOLDERS AFTER, OR YOU WILL KILL REQUIRED DEPENDENCIES. ADJUST THE SCRIPT IF YOU WANT TO PUT THE FILES ELSEWHERE.
# REMEMBER TO SWITCH YOUR GPU TO AMD (if you use hybrid graphics) IF YOU INTEND TO RUN Caffe ON GPU: YOU WILL RUN ON CPU OTHERWISE!!!

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

#install pre-reqs, more than needed but that is in case something goes wrong
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
#if you want to test viennacl (to make sure things are working), you need to build the test files (thanks to installing MTL4/Eigen 3 beforehand)
#cd viennacl-dev
#mkdir build
#cd build
#cmake .. -DENABLE_MTL4=ON -DENABLE_EIGEN=ON -DEIGEN_INCLUDE_DIR=/usr/include/eigen3 -DENABLE_OPENMP=ON
#cd tests
#./bisect-test-opencl
#................... (all the tests available you want in that folder)

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
#line 63: comment CUDA_DIR := /usr/local/cuda
#line 70-75: comment CUDA_ARCH
#line 81: change: BLAS := open
#line 100: change: /usr/local/lib/python2.7/dist-packages/numpy/core/include/
#line 122: uncomment: WITH_PYTHON_LAYER := 1

#compile and test: if make runtest does not fail, you are all good
make all
make test
make runtest
make pycaffe

#Install missing Python features
pip install -r python/requirements.txt

#Install Caffe Python
make pycaffe

#fix ~/.bashrc, change accordingly
export CAFFE_ROOT=/home/laurae-linux/caffe

#run the first doom test: you must get about 74-76% accuracy by the end of CIFAR-10 (depending on the RNG)
#there are 5000 iterations - 100 iterations take about 1 minute on a AMD Radeon 8730M 1GB GDDR5
#this is in line with the official documentation (~15 seconds for a beefed NVIDIA+CuDNN)
#because it's only 4x slower (in line also with AMD/OpenCL-Caffe CNN benchmarks), might be better because 8730M is a slow GPU
source ~/.bashrc
cd $CAFFE_ROOT
./data/cifar10/get_cifar10.sh
./examples/cifar10/create_cifar10.sh
./examples/cifar10/train_quick.sh

#Install Expresso if needed
#add $EXPRESSO_ROOT to the .bashrc: export EXPRESSO_ROOT="/home/laurae-linux/Downloads/expresso"
git clone https://github.com/Laurae2/expresso
sudo apt-get install python-qt4
sudo apt-get install pyqt4-dev-tools
sudo apt-get install libqt4-dev
sudo apt-get install python-h5py
sudo pip install pyqtgraph --upgrade
sudo pip install qtutils --upgrade
sh run_expresso.sh

#install Anaconda 2.7 yourself

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

#check if all good in Anaconda: use spyder, go to iPython Console to write the imports 1 by 1
#you might get boost ("to-Python") warning/error messages, ignore them it's normal
spyder
import numpy as np
import caffe #ignore "to-Python" error, does not matter
import xgboost
caffe.set_device(0) #this should throw an error if you are not on the AMD GPU
caffe.set_device(1) #same as previously
data = np.random.rand(5,10) # 5 entities, each contains 10 features
label = np.random.randint(2, size=5) # binary target
dtrain = xgb.DMatrix( data, label=label)
bst = xgboost.cv({'bst:max_depth':2, 'bst:eta':1, 'silent':1, 'objective':'binary:logistic'}, dtrain, 10, verbose_eval=1, nfold=2) #if you get an error here, you screwed up somewhere

#by the end your ~/.bashrc MUST look like this:
export LD_LIBRARY_PATH="/usr/local/lib64/:$LD_LIBRARY_PATH"
export CLFFT_INCLUDE_DIR="/usr/local/include"
export PYTHONPATH="/home/laurae-linux/Downloads/caffe/python/:$PYTHONPATH"
export CAFFE_ROOT="/home/laurae-linux/Downloads/caffe"
export PATH="/home/laurae-linux/anaconda2/bin:$PATH"

#You are done doing everything? Go ahead for massive RAM tweaks.
