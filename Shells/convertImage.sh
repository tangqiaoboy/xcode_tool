#! /bin/bash

# print usage
usage() {
    cat << EOF
    Usage:
        convertImage.sh <src directory> <dest directory>
EOF
}

if [ $# -ne 2 ]; then
    usage
    exit 1
fi

SRC_DIR=$1
DEST_DIR=$2

# check src dir
if [ ! -d $SRC_DIR ]; then
    echo "src directory not exist: $SRC_DIR"
    exit 1
fi

# check dest dir
if [ ! -d $DEST_DIR ]; then
    mkdir -p $DEST_DIR
fi

for src_file in $SRC_DIR/*.* ; do
    echo "process file name: $src_file"
    # 获得去掉文件名的纯路径
    src_path=`dirname $src_file`
    # 获得去掉路径的纯文件名
    filename=`basename $src_file`
    # 获得文件名字(不包括扩展名)
    name=`echo "$filename" | cut -d'.' -f1`
    # remove @2x in filename if there is
    name=`echo "$name" | cut -d"@" -f1`
    # 获得文件扩展名
    extension=`echo "$filename" | cut -d'.' -f2`
    dest_file="$DEST_DIR/${name}.${extension}"

    convert $src_file -resize 50% $dest_file
done
