#!/bin/bash

CWD=$(pwd)
PROJECT_DIR=$(dirname $0)/..
BUILD_DIR=$PROJECT_DIR/build/$(date +"%s")

mkdir $BUILD_DIR
cp $PROJECT_DIR/appspec.yml $BUILD_DIR
cp -r $PROJECT_DIR/bin $BUILD_DIR
cp -r $PROJECT_DIR/docroot $BUILD_DIR
rm -f $BUILD_DIR/docroot/index.php.dist

cd $BUILD_DIR
tar -zcvf output.tar.gz ./
cd $CWD

mv $BUILD_DIR/output.tar.gz $PROJECT_DIR
rm -rf $BUILD_DIR
