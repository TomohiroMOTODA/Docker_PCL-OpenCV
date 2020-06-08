#
# pcl dockerfile
# Author: Tomohiro Motoda
# Pull base image.
FROM nvidia/cuda:8.0-devel

# Install neccessary tools
RUN apt-get update
RUN apt-get install -y \
  software-properties-common \ 
  ca-certificates \
  wget
RUN wget -O - http://apt.llvm.org/llvm-snapshot.gpg.key | apt-key add -
RUN apt-add-repository "deb http://apt.llvm.org/xenial/ llvm-toolchain-xenial-4.0 main"
RUN apt-get update
RUN apt-get install -y \ 
  build-essential \
  g++ \
  python-dev \
  autotools-dev \
  libicu-dev \
  libbz2-dev \
  libboost-all-dev 

RUN apt-get install -y  \
  mc \
  lynx \
  libqhull* \
  pkg-config \
  libxmu-dev \
  libxi-dev \
  --no-install-recommends --fix-missing

RUN apt-get install -y  \
  mesa-common-dev \
  cmake  \
  git  \
  mercurial \
  freeglut3-dev \
  libflann-dev \
  --no-install-recommends --fix-missing

RUN apt-get update && apt-get install -y --no-install-recommends \
    wget git cmake nano libeigen3-dev libgtk-3-dev qt5-default libvtk6-qt-dev libtbb-dev \
    libjpeg-dev libjasper-dev libpng++-dev libtiff-dev libopenexr-dev libwebp-dev \
    libhdf5-dev libopenblas-dev liblapacke-dev \
    && rm -rf /var/lib/apt/lists/*

RUN apt-get autoremove

# Install Eigen
RUN cd /opt && hg clone -r 3.2 https://bitbucket.org/eigen/eigen eigen
RUN mkdir -p /opt/eigen/build
RUN cd /opt/eigen/build && cmake ..
RUN cd /opt/eigen/build && make install

# Install VTK
RUN cd /opt && git clone https://github.com/Kitware/VTK.git VTK 
RUN cd /opt/VTK && git checkout tags/v8.0.0
RUN cd /opt/VTK && mkdir build
RUN cd /opt/VTK/build && cmake -DCMAKE_BUILD_TYPE:STRING=Release -D VTK_RENDERING_BACKEND=OpenGL ..
RUN cd /opt/VTK/build && make -j4 && make install

# Install OpenCV
COPY opencv-3.2.0.tar.gz .
RUN tar xfvz opencv-3.2.0.tar.gz
COPY opencv3.2_build-ubuntu16.04.sh /opencv-3.2.0/
RUN cd opencv-3.2.0 && chmod 777 opencv3.2_build-ubuntu16.04.sh && ./opencv3.2_build-ubuntu16.04.sh && cd build && make -j4
RUN cd opencv-3.2.0/build && make install && ldconfig


# Install PCL
RUN cd /opt
RUN \
    git config --global http.sslVerify false && \
    git clone --branch pcl-1.8.0 --depth 1 https://github.com/PointCloudLibrary/pcl.git pcl-trunk
# git clone https://github.com/PointCloudLibrary/pcl.git pcl-trunk
# git clone --branch pcl-1.8.0 --depth 1 https://github.com/PointCloudLibrary/pcl.git pcl-trunk
RUN cd pcl-trunk && \
    mkdir build && cd build && \
    cmake -DCMAKE_BUILD_TYPE=Release .. && \
    make -j 4 && make install && \
    make clean
