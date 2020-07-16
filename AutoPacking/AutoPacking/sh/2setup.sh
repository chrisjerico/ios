#!/bin/sh

__OutputFile1=$1
__OutputFile2=$2
__OutputFile3=$3
__OutputFile4=$4

__Path=$5
__SiteId=$6
__DisplayName=$7
__Version=$8
__BundleId=$9

cd $__Path


# 替换站点ID
sed "s/#define __SiteID__.*$/#define __SiteID__ @\"$__SiteId\"/g" ug/Classes/Helper/FishUtility/define/AppDefine.m > tmp.txt
mv tmp.txt ug/Classes/Helper/FishUtility/define/AppDefine.m

# 替换APP名
/usr/libexec/PlistBuddy -c "Set :CFBundleDisplayName $__DisplayName" ug/Classes/Other/Info.plist

# 替换版本号
/usr/libexec/PlistBuddy -c "Set :CFBundleVersion $__Version" ug/Classes/Other/Info.plist
/usr/libexec/PlistBuddy -c "Set :CFBundleShortVersionString $__Version" ug/Classes/Other/Info.plist

# 替换BundleId（修改project.pbxproj文件）
sed "s/PRODUCT_BUNDLE_IDENTIFIER.*$/PRODUCT_BUNDLE_IDENTIFIER = $__BundleId;/g" UGBWApp.xcodeproj/project.pbxproj > tmp.txt
mv tmp.txt UGBWApp.xcodeproj/project.pbxproj

# 替换AppIcon
rm -rf ug/Classes/Resources/Assets.xcassets/AppIcon.appiconset
cp -rf "AutoPacking/打包文件/各站点AppIcon（拷贝出来使用）/$__SiteId/AppIcon.appiconset" ug/Classes/Resources/Assets.xcassets/AppIcon.appiconset

# 删除开发者的用户名
/usr/libexec/PlistBuddy -c 'Delete :Dev1' ug/Classes/Other/Info.plist
