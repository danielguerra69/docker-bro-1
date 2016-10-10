#!/bin/sh

SOURCE=/source
PREFIX=/usr/local

BUILD_DIR=/build
FINAL_DIR=/final

mkdir -p $BUILD_DIR

BRO_DIR=$BUILD_DIR/bro
AF_PACKET_DIR=$BRO_DIR/aux/plugins/af_packet
ES_DIR=$BRO_DIR/aux/plugins/elasticsearch
TCPRS_DIR=$BRO_DIR/aux/plugins/tcprs


echo "===> Cloning bro..."

cd $BUILD_DIR
git clone --recursive git://git.bro.org/bro

echo "===> Applying patches..."

cd $BRO_DIR
patch -p1 < $SOURCE/bro-musl.patch

cd $BRO_DIR/aux/binpac
patch -p1 < $SOURCE/binpac-musl.patch

cd $BRO_DIR/aux/plugins/elasticsearch/src/
patch -p1 ElasticSearch.cc < $SOURCE/ElasticSearch.cc.patch

cd $BRO_DIR
cp $SOURCE/FindFTS.cmake cmake

echo "===> Compiling bro..."
CC=clang ./configure --disable-broker \
  --disable-broctl --disable-broccoli \
  --disable-auxtools --prefix=$PREFIX
make
make install

echo "===> Compiling af_packet plugin..."
cd $AF_PACKET_DIR
make distclean
CC=clang ./configure --with-kernel=/usr
make
make install

echo "===> Compiling elasticsearch plugin..."
cd $ES_DIR
make distclean
CC=clang ./configure
make
make install

echo "===> Compiling tcprs plugin..."
cd $TCPRS_DIR
make distclean
CC=clang ./configure
make
make install

echo "===> Packaging..."
strip -s /usr/local/bin/bro
tar zcvf $FINAL_DIR/bro.tar.gz $PREFIX

echo "===> Copying Dockerfile..."
cp -v -f $SOURCE/Dockerfile.final $FINAL_DIR/Dockerfile
