FROM debian:jessie

MAINTAINER Jan Losinski <losinski@wh2.tu-dresden.de>

ADD sources.list /etc/apt/sources.list

RUN apt-get update
RUN apt-get -y install ufraw enfuse jhead gimp build-essential cmake git libgtk2.0-dev pkg-config libavcodec-dev libavformat-dev libswscale-dev python-dev python-numpy libtbb2 libtbb-dev libjpeg-dev libpng-dev libtiff-dev libjasper-dev libdc1394-22-dev unzip
#RUN apt-get -y install openjdk-7-jre
#RUN apt-get -y build-dep libcv2.4
#RUN apt-get -y build-dep pfstools
#RUN apt-get -y install libgsl0-dev
#RUN apt-get -y remove liboctave-dev
RUN apt-get clean

WORKDIR /tmp

ADD opencv-2.4.11.zip ./

RUN unzip -x opencv-2.4.11.zip && \
	cd opencv-2.4.11 && \
	mkdir build && cd build && \
	cmake -D CMAKE_BUILD_TYPE=RELEASE -D CMAKE_INSTALL_PREFIX=/usr/local .. && \
	make && make install && \
	cd /tmp && rm -rf opencv-2.4.11


ADD pfstools-2.0.4.tgz ./   

RUN cd pfstools-2.0.4 && \
	mkdir build && cd  build && \
	cmake -D CMAKE_BUILD_TYPE=RELEASE -D CMAKE_INSTALL_PREFIX=/usr/local .. && \
	make && make install && \
	cd /tmp && rm -rf pfstools-2.0.4

RUN groupadd user && \
	useradd --uid 1000 --create-home --home-dir /home/user -g user user

RUN apt-get -y install dcraw ufraw-batch hugin-tools

ADD createHDR.sh /usr/bin/
ADD processBrackets.sh /usr/bin/

RUN chmod 755 /usr/bin/createHDR.sh /usr/bin/processBrackets.sh

USER user

WORKDIR /home/user	

