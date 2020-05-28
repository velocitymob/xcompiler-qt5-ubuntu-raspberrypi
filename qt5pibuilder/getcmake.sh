#!/bin/bash 

# download cmake from source
if [ ! 'FALSE' ]; then 
wget  https://github.com/Kitware/CMake/releases/download/v3.14.1/cmake-3.14.1.tar.gz \
  && tar -kx  -f cmake-3.14.1.tar.gz \
  && rm -rf *.tar.* \
  && mv cmake* /opt  \
  && cd /opt/cmake-3.14.1 \
	&& ls \
 	&& /bin/bash -c ./bootstrap \
  && make -j $(nproc) \
	&& make install  \
  && cmake --version
else
	CMAKE_VERSION='3.14.1'
	wget https://github.com/Kitware/CMake/releases/download/v${CMAKE_VERSION}/cmake-${CMAKE_VERSION}-Linux-x86_64.sh 
	/bin/bash  cmake-${CMAKE_VERSION}-Linux-x86_64.sh --skip-license --include-subdir --prefix= /usr/bin/cmake
	rm cmake-*-*.sh 
fi

