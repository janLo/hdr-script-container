HDR creation container
======================

This container bundles the cript from
http://linuxdarkroom.tassy.net/hdr-creation-script/
with all its dependencies.

## Build

To build the cntainer you need to download opencv 2.x and
pfstools to the directory containing the dockerfile. It
is neccessary to build pfstools from scratch, because the
debian package does not contain the `pfscalibration` tool.

OpenCV must built from sources, because pfstools will not
build without the nonfree parts from openCV, which debian
does not ship.

Grab openCV 2.x (pfstools will not build with 3.x!) from
http://opencv.org/downloads.html

Pfstools can be downloaded from http://sourceforge.net/projects/pfstools/files/pfstools/

Build it using

    docker build -t hdr .

The build takes some time!

## Run

Just run the container in interactive mode and mount your
raw images as volume:

    docker run --rm -ti -v <my_raw_folder>:/home/user/raw hdr /bin/bash

Then just use the script:

    $ createHDR.sh -a ./hdr

Or you can use it in one command:

    docker run --rm -ti -v <my_raw_folder>:/home/user/raw hdr /usr/bin/createHDR.sh -a ./hdr
