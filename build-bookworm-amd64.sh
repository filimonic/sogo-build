#!/bin/bash

# SOGo repo MUST cloned to /w/SOGo
# SOPE repo MUST cloned to /w/SOPE
# During build, SOPE libs will be installed.

DEBIAN_FRONTEND=noninteractive
export DEBIAN_FRONTEND=noninteractive
DEBEMAIL=sogo-builds@filimonic.net
export DEBEMAIL=sogo-builds@filimonic.net
VERSION=$2
APT_GET_COMMON_FLAGS="--no-install-recommends --no-install-suggests --quiet=2 --assume-yes --allow-change-held-packages --allow-downgrades -o Dpkg::Use-Pty=0"
mkdir --parent /w

case $1 in
    install-prerequisites)
    apt-get update $APT_GET_COMMON_FLAGS && \
    apt-get install $APT_GET_COMMON_FLAGS \
      git zip wget make debhelper gnustep-make libssl-dev libgnustep-base-dev libldap2-dev libytnef0-dev zlib1g-dev libpq-dev wget \
      libmariadbclient-dev-compat libmemcached-dev liblasso3-dev libcurl4-gnutls-dev devscripts libexpat1-dev libpopt-dev libsbjson-dev \
      libsbjson2.3 libcurl4 liboath-dev libsodium-dev libzip-dev libwbxml2-dev python3 python-is-python3 git build-essential tar \
      lsb-release && \
    apt-get $APT_GET_COMMON_FLAGS install --fix-broken
    ;;

    build-sope)
    cd /w/SOPE
    cp --no-dereference --preserve=links --recursive ./packaging/debian ./debian
    debchange --newversion "$VERSION" "Automated build for $VERSION"
    ./debian/rules
    dpkg-buildpackage --build=full \
      --compression=gzip --compression-level=9 
    ;;

    install-sope)
    cd /w
    dpkg --install libsope*.deb
    ;;

    build-sogo)
    cd /w/SOGo
    cp --no-dereference --preserve=links --recursive ./packaging/debian ./debian
    rm -f ./debian/source/format
    debchange --newversion "$VERSION" "Automated build for $VERSION"
    ./debian/rules
    dpkg-buildpackage --build=full \
      --compression=gzip --compression-level=9 
    ;;

    create-repo)
    cd /w
    mkdir --parent ./repo
    mv --force --target-directory=./repo --verbose ./*.deb
    dpkg-scanpackages ./repo /dev/null | gzip -9c > ./repo/Packages.gz
    ;;

    *)
    echo Run in this sequence:
    echo $0 install-prerequisites
    echo $0 build-sope version
    echo $0 install-sope 
    echo $0 build-sogo version
    echo $0 create-repo
    exit -1

esac





