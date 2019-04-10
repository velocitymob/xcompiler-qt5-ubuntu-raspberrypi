NAME 	 := $$(git remote -v | grep 'push' |cut -d:  -f2-| cut -d'.' -f1) 
TAG    := $$(git log -1 --pretty=%!H(MISSING))
IMG    := ${NAME}:${TAG}
LATEST := ${NAME}:latest
 
build:
  @docker build -t ${IMG} .
  @docker tag ${IMG} ${LATEST}
 
push:
  @docker push ${NAME}
 
login:
  @docker log -u ${DOCKER_USER} -p ${DOCKER_PASS}
