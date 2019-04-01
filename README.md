# Cross-compile-toolchain 

To run this image, uses:
'''
docker run -it {ThePreviousName} /bin/bash
'''
If you want to modify the version from Qt 5 or the Version of the compiler. You need to re-build this image with:
`docker built -t velocitymob/xcompiler-qt5-ubuntu-raspberrypi:v1 .`


# Step to Docker Hub

* step 1: create account on [hub.docker.com]
* step 2: create a new repository on GitHub
* step 3: create a Dockerfile on your repo, add, commit  push
* step 4: on your machine use `docker built -t {NAME_ORG}/{NAME_YOUR_REPO} .`
* step 5: if the image was successful, now you can push your image on the DockerHub
* step 6: It is  necessary create an account for the organization ! 

# Docker Uses Commands: 
* to see all created containers:
 `docker ps -a ` 
 * To remove all existing containers :
 docker rm $(docker ps -aq)
* To remove images 
docker rmi NAME_OF_IMAGE
