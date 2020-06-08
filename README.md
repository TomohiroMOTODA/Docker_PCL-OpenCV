# Docker_PCL-OpenCV
Docker for  PCL-1.8 and Open3 on Ubuntu16


# Usage
Please download the source code of OpenCV3.2(https://opencv.org/opencv-3-2/), put it on the same directory. 

# Build and Run
In the case that user's name is usr: 

$ docker build -t [image name] . 

$ docker run -it -v /home/usr/src:/root/usr [image name]:latest /bin/bash 
