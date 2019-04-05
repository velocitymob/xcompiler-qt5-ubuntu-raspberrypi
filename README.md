# Cross-compile-toolchain 

This image is used to compile projects related to qt modules for the Target armv7l (raspberry pi3 B+). The Host environment is based in Ubuntu x86_64. The Qt modules are created with the help from the gcc-linaro compiler, version 7.3.1.
- TODO: compile the qt-modules with clang. 

This image contain:
- gcc-linaro v7.3.1
- qtbase
- qtxmlpatterns 
- qtdeclarative 
- qtserialport 
- qtquickcontrols

# Step to Docker Hub


* step 1: create account on [hub.docker.com]
* step 2: create a new repository on GitHub
* step 3: create a Dockerfile on your repo, add, commit push
* step 4: on your machine use `docker built -t {NAME_ORG}/{NAME_YOUR_REPO} .`
* step 5: if the image was successful, now you can push your image on the DockerHub
* step 6: It is necessary create an account for the organization ! 
 
To run this image, uses:
'''
docker run -it {ThePreviousName} /bin/bash
'''
If you want to modify the version from Qt 5 or the Version of the compiler. You need to re-build this image with:
`docker built -t velocitymob/xcompiler-qt5-ubuntu-raspberrypi:v1 .`
 # Docker Uses Commands: 
* to see all created containers:
 `docker ps -a ` 
 * To remove all existing containers :
 `docker rm $(docker ps -aq)`
* To remove images 
`docker rmi NAME_OF_IMAGE`
