#!/bin/sh

__SiteId=$1
__DisplayName=$2
__BundleId=$3

# 从Xcode运行需要先cd到当前目录
if [ ! -n "$4" ] ;then
    echo "you have not input a word!"
else
    cd $4
fi




# 替换站点ID
sed "s/#define __SiteID__.*$/#define __SiteID__ @\"$__SiteId\"/g" ug/Classes/Helper/FishUtility/define/AppDefine.m > tmp.txt
mv tmp.txt ug/Classes/Helper/FishUtility/define/AppDefine.m

# 替换APP名
/usr/libexec/PlistBuddy -c "Set :CFBundleDisplayName $__DisplayName" ug/Classes/Other/Info.plist

# 替换BundleId（修改project.pbxproj文件）
sed "s/PRODUCT_BUNDLE_IDENTIFIER.*$/PRODUCT_BUNDLE_IDENTIFIER = $__BundleId;/g" ug.xcodeproj/project.pbxproj > tmp.txt
mv tmp.txt ug.xcodeproj/project.pbxproj

# 替换AppIcon
rm -rf ug/Classes/Resources/Assets.xcassets/AppIcon.appiconset
cp -rf "AutoPacking/打包文件/各站点AppIcon（拷贝出来使用）/$__SiteId/AppIcon.appiconset" ug/Classes/Resources/Assets.xcassets/AppIcon.appiconset

