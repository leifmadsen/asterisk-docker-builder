#!/usr/bin/env bash

build() {
    # this appears to be required to make sure we pull in correct cache
    yum clean --disablerepo=* --enablerepo=local all

    # build RPMs
    cd $BUILD_PATH
    fedpkg clone -a $1
    cd $1
    fedpkg sources
    fedpkg prep
    yum-builddep -y $1.spec
    fedpkg --dist=$DIST_TAG local
    if [ $? != 0 ]; then
        exit;
    fi

    mv $BUILD_PATH/$1/x86_64/* $BUILD_PATH/localrepo
    cd $BUILD_PATH/localrepo
    /usr/bin/createrepo .
}

# install development tools
$PKG_APP groupinstall "Development Tools" -y

# build speex
build speex

# build speexdsp
build speexdsp

# build dahdi
build dahdi-tools

# build libpri
build libpri

# build libresample
build libresample

#build libss7
build libss7

# build asterisk
build asterisk

# end the script
exit 0
