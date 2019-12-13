#!/bin/sh


# 从Xcode运行需要先cd到当前目录
if [ ! -n "$5" ] ;then
    echo "you have not input a word!"
else
    cd $5
fi



__IpaUrl=$1
__LogoUrl=$2
__BundleId=$3
__DisplayName=$4





# 替换ipa路径
/usr/libexec/PlistBuddy -c "Set :items:0:assets:0:url $__IpaUrl" a.plist

# 替换logo路径
/usr/libexec/PlistBuddy -c "Set :items:0:assets:1:url $__LogoUrl" a.plist
/usr/libexec/PlistBuddy -c "Set :items:0:assets:2:url $__LogoUrl" a.plist

# 替换bundleId
/usr/libexec/PlistBuddy -c "Set :items:0:metadata:bundle-identifier $__BundleId" a.plist

# 替换APP名
/usr/libexec/PlistBuddy -c "Set :items:0:metadata:title $__DisplayName" a.plist
