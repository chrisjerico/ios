#!/bin/sh

__SiteId=$1
__DisplayName=$2
__BundleId=$3

__ProjectDir=$4
__InfoPlist="$4/ug/Classes/Other/Info.plist"


# 替换站点ID
/usr/libexec/PlistBuddy -c "Add :SiteId string $__SiteId" $__InfoPlist
/usr/libexec/PlistBuddy -c "Set :SiteId $__SiteId" $__InfoPlist
# 替换APP名
/usr/libexec/PlistBuddy -c "Set :CFBundleDisplayName $__DisplayName" $__InfoPlist
# 替换BundleId
/usr/libexec/PlistBuddy -c "Set :CFBundleIdentifier $__BundleId" $__InfoPlist
# 替换AppIcon
rm -rf "$__ProjectDir/ug/Classes/Resources/Assets.xcassets/AppIcon.appiconset"
cp -rf "$__ProjectDir/AutoPacking/打包文件/各站点AppIcon（拷贝出来使用）/$__SiteId/AppIcon.appiconset" "$__ProjectDir/ug/Classes/Resources/Assets.xcassets/AppIcon.appiconset"

