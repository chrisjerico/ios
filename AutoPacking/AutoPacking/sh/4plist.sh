#!/bin/sh

__OutputFile1=$1
__OutputFile2=$2
__OutputFile3=$3
__OutputFile4=$4

__PlistFile=$5
__IpaUrl=$6
__LogoUrl=$7
__BundleId=$8
__DisplayName=$9


# 替换ipa路径
/usr/libexec/PlistBuddy -c "Set :items:0:assets:0:url $__IpaUrl" $__PlistFile

# 替换logo路径
/usr/libexec/PlistBuddy -c "Set :items:0:assets:1:url $__LogoUrl" $__PlistFile
/usr/libexec/PlistBuddy -c "Set :items:0:assets:2:url $__LogoUrl" $__PlistFile

# 替换bundleId
/usr/libexec/PlistBuddy -c "Set :items:0:metadata:bundle-identifier $__BundleId" $__PlistFile

# 替换APP名
/usr/libexec/PlistBuddy -c "Set :items:0:metadata:title $__DisplayName" $__PlistFile
