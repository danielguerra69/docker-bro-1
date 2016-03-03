#!/bin/sh

SOURCE=/source
BUILD_DIR=$SOURCE/build
PREFIX=/usr/local

BRO_DIR=$BUILD_DIR/bro
AF_PACKET_DIR=$BRO_DIR/aux/plugins/af_packet
FINAL_DIR=$SOURCE/final

echo "===> Applying patches..."
rm -rf $BRO_DIR
cp -r ../bro .
cd $BRO_DIR
git submodule update --init  --recursive --remote
patch -p1 < $SOURCE/bro-musl.patch

cd $BRO_DIR/aux/binpac
patch -p1 < $SOURCE/binpac-musl.patch

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

echo "===> Packaging..."
strip -s /usr/local/bin/bro
tar zcvf $FINAL_DIR/bro.tar.gz $PREFIX

