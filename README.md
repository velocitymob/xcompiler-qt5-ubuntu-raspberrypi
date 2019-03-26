# Cross-compile-toolchain 

To run this image, uses:
'''
docker run -it {ThePreviousName} /bin/bash
'''

# Step to Docker Hub

* step 1: create account on [hub.docker.com]
* step 2: create a new repository on GitHub
* step 3: create a Dockerfile on your repo, add, commit  push
* step 4: on your machine use `docker built -t {NAME_ORG}/{NAME_YOUR_REPO} .`
* step 5: if the image was successful, now you can push your image on the DockerHub
* step 6: It is  necessary create an account for the organization ! 
