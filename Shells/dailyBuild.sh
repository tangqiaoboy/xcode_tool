#!/bin/bash
#
# This is the daily build script for an iOS project.
#
# Author: Tang Qiao
#

function usage() {
    echo "Usage:"
    echo "     dailyBuild.sh [target] [server] [tag]"
    echo "Argument:"
    echo "     target - the build target name"
    echo "     server - the server type, valid value are 'test_www', 'test_ape', 'online_ape'  and 'online' "
    echo "     tag - optional. if tag is not empty, the ipa file will be put the tags directory instead of year/month directory"
    echo "Example:"
    echo "     dailyBuild.sh Ape_kyzz test_www"
    echo "     dailyBuild.sh Ape_kyzz test_ape"
    echo "     dailyBuild.sh Ape_kyzz online_ape"
    echo "     dailyBuild.sh Ape_kyzz online"
    echo ""
    echo "Tag Example:"
    echo "     dailyBuild.sh Ape_kyzz test_www iPhone_1.0.0"
    exit 1
}

function processIcon() {
    echo "process icon: $1"
    targetIcon=$1
    if [[ ! -f $targetIcon ]]; then
        echo "$targetIcon is not exist"
        return
    fi
    width=`identify -format %w ${targetIcon}`
    build_date=$(date +%y%m%d)
    convert -background '#0008' -fill white -gravity center -size %${width}x40\
    caption:"${ICON_NAME} ${build_date}"\
    ${targetIcon} +swap -gravity south -composite ${targetIcon}
}

function checkDependency() {
    command -v convert  >/dev/null 2>&1 || { echo "please: brew install imagemagick" >&2; exit 1; }
    command -v identify >/dev/null 2>&1 || { echo "please: brew install ghostscript" >&2; exit 1; }
}


if [ $# -lt 2 ]; then
    usage
fi

checkDependency

TARGET=$1
SERVER=$2
TAG_NAME=$3

OUTPUT_PATH="fenbi@192.168.0.102:/var/www/apps/"
HTTP_TARGET="http://app.zhenguanyu.com"

PROJECT_HOME=`pwd`
BUILD_PATH="$PROJECT_HOME/build"
FOLDER_PREFIX="iphone"

# get bundle id
PROJECT_PLIST=`find . -type f -name "${TARGET}-Info.plist" -depth 2`
BUNDLE_ID=`grep "com.fenbi" $PROJECT_PLIST | head -1`
# remove the prefix <string> and suffix </string> and trim blankspaces
BUNDLE_ID=${BUNDLE_ID#*string>}
BUNDLE_ID=${BUNDLE_ID%</string>*}
if [ "$BUNDLE_ID" != "" ]; then
    echo "bundle id = $BUNDLE_ID"
else 
    echo "bundle id is not found"
    exit 1
fi

## clear old data
cd $PROJECT_HOME
rm -rf $BUILD_PATH

## set configuration
CONFIGURATION=""
ICON_NAME=""
if [ $SERVER == "test_www" ]; then
    CONFIGURATION="Debug_www"
    ICON_NAME="twww"
elif [ $SERVER == "test_ape" ]; then
    CONFIGURATION="Debug_ape"
    ICON_NAME="tape"
elif [ $SERVER == "online_ape" ]; then
    CONFIGURATION="Online_ape"
    ICON_NAME="oape"
elif [ $SERVER == "online" ]; then
    CONFIGURATION="Online"
    ICON_NAME="owww"
else
    echo "CONFIGURATION is not valid"
    usage
    exit 1
fi

## set .git log info
if [[ -d "$PROJECT_HOME/.git" ]]; then
    GIT_VERSION=$(git log --oneline -1 | cut -d" " -f1)
    COMMIT_LOG=`git log -7`
fi
echo "GIT_VERSION = $GIT_VERSION"

# mark build info to icon file
ICON_DONE="NO"
echo "mark build info to icon files..."
for file in $( find $TARGET -type f -name "Icon*.png" )
do
    processIcon $file
    ICON_DONE="YES"
done
if [[ "$ICON_DONE" == "NO" ]]; then
    for file in $( find . -type f -name "Icon*.png" )
    do
        processIcon $file
    done
fi

## build
echo "building...it will take several minutes."
xcodebuild -configuration $CONFIGURATION -target "$TARGET"  > /dev/null
BUILD_RES=$?


# mark build info to icon file
echo "recovery icon files..."
if [[ "$ICON_DONE" == "NO" ]]; then
    for file in $( find . -not -path "./build/*" -type f -name "Icon*.png" )
    do
        git checkout $file
    done
else
    for file in $( find $TARGET -type f -name "Icon*.png" )
    do
        git checkout $file
    done
fi

## check result
echo "BUILD_RES=$BUILD_RES"
if [ $BUILD_RES -ne 0 ]; then
    echo "Failed to build dailyBuild"
    exit 1
fi

if [ ! -d "$BUILD_PATH/${CONFIGURATION}-iphoneos" ]; then
    echo "${CONFIGURATION}-iphoneos directory is not exist"
    exit 1
fi

# get file name
PRODUCT_NAME=`find build -type dir -name "*.app"`
PRODUCT_NAME=`basename $PRODUCT_NAME`
if [ $PRODUCT_NAME == "" ]; then
    echo "can not get product name"
    exit 1
fi


# create ipa folder
FILE_NAME="${TARGET}_$(date +%y%m%d-%H%M)_r${GIT_VERSION}.ipa"
echo "build file using specified name: $FILE_NAME"

cd $BUILD_PATH
mkdir -p ipa/Payload
cp -r ./${CONFIGURATION}-iphoneos/$PRODUCT_NAME ./ipa/Payload/

# create ipa file
echo "creating $FILE_NAME"
cd ipa
zip -rq $FILE_NAME *

# create dSYM file
echo "creating dSYM.zip"
cd $BUILD_PATH/${CONFIGURATION}-iphoneos/
zip -rq dSYM.zip ${PRODUCT_NAME}.dSYM

# generate output folder
if [ "${TAG_NAME}" == "" ]; then
    YEAR=$(date +%Y)
    MONTH=$(date +%m)
    FOLDER="${FOLDER_PREFIX}/${TARGET}/${YEAR}/${MONTH}/${TARGET}_${SERVER}_$(date +%y%m%d-%H%M)"    
else
    FOLDER="${FOLDER_PREFIX}/${TARGET}/tags/${TARGET}_${SERVER}_${TAG_NAME}"
fi
echo "Output folder=${FOLDER}"

# copy ipa & dsym

cd $BUILD_PATH
mkdir -p $FOLDER
cp ipa/$FILE_NAME $FOLDER/
cp ${CONFIGURATION}-iphoneos/dSYM.zip $FOLDER/

# copy icon
ICON_FILE=`find . -type f -name "[iI]con.png" | head -1`
if [ "$ICON_FILE" == "" ]; then
    echo "icon file is not exit"
    exit 1
fi
cp $ICON_FILE $FOLDER/icon.png

# Create install html
cd $FOLDER
PLIST_PATH="/${FOLDER}/appInfo.plist"
# ${str//apple/APPLE}  # 替换所有apple,这里的apple是/，被转义成\/
PLIST_PATH=${PLIST_PATH//\//%2f}
cat << EOF > index.html
<!DOCTYPE HTML>
<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <title>安装此软件</title>
    <meta name="viewport" content="initial-scale=1.0, maximum-scale=1.0"/>
  </head>
  <body>
    <h1><center>$PRODUCT_NAME Daily Build</center></h1>
    <hr />
    <ul>
      <li>iOS设备直接安装:<a href="itms-services://?action=download-manifest&url=${HTTP_TARGET}${PLIST_PATH}">点击这里安装</a></li>
    </ul>
    <p>
    <ul>
      <li>下载此软件的ipa包:<br/><a href="${HTTP_TARGET}/${FOLDER}/$FILE_NAME">$FILE_NAME</a></li>
    </ul>
    <ul>
      <li>下载此软件的dSYM文件:<br/><a href="${HTTP_TARGET}/${FOLDER}/dSYM.zip">dSYM.zip</a></li>
    </ul>
    <hr />
    <p>
    <br />
    最近的提交Log:
    <pre>$COMMIT_LOG
    </pre>
  </body>
</html>
EOF

cat << EOF > appInfo.plist
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
   <key>items</key>
   <array>
       <dict>
           <key>assets</key>
           <array>
               <dict>
                   <key>kind</key>
                   <string>software-package</string>
                   <key>url</key>
                   <string>${HTTP_TARGET}/${FOLDER}/$FILE_NAME</string>
               </dict>
               <dict>
                   <key>kind</key>
                   <string>display-image</string>
                   <key>needs-shine</key>
                   <true/>
                   <key>url</key>
                   <string>${HTTP_TARGET}/${FOLDER}/icon.png</string>
               </dict>
           <dict>
                   <key>kind</key>
                   <string>full-size-image</string>
                   <key>needs-shine</key>
                   <true/>
                   <key>url</key>
                   <string>${HTTP_TARGET}/${FOLDER}/icon.png</string>
               </dict>
           </array><key>metadata</key>
           <dict>
               <key>bundle-identifier</key>
               <string>$BUNDLE_ID</string>
               <key>bundle-version</key>
               <string>1.0</string>
               <key>kind</key>
               <string>software</string>
               <key>subtitle</key>
               <string>$PRODUCT_NAME</string>
               <key>title</key>
               <string>$PRODUCT_NAME</string>
           </dict>
       </dict>
   </array>
</dict>
</plist>

EOF

# create latest link

cd "$BUILD_PATH/$FOLDER_PREFIX/$TARGET"
mkdir latest
find . -type f -name "appInfo.plist" | xargs -J % cp % latest/

cd $BUILD_PATH

if [ "$OUTPUT_PATH" != "" ]; then
    scp -r $FOLDER_PREFIX ${OUTPUT_PATH}
fi


echo "Daily build for $PRODUCT_NAME completed!"
