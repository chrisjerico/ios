#!/bin/sh

__OutputFile1=$1
__OutputFile2=$2
__OutputFile3=$3
__OutputFile4=$4

__Path=$5
__APPVersion=$6
__Log=$7
__Environment=$8
__KeyFile=$9


cd $__Path


# 随便改点东西（要是跟上个包一摸一样会提交不成功）
echo "console.log($RANDOM);" >> js/rn/tmp.js

#echo $PATH
export PATH=/usr/local/bin:$PATH
#echo $PATH


# 更新依赖库
yarn install

#【Bundle打包】
react-native bundle --entry-file index.ios.js --bundle-output ./bundle/main.jsbundle --platform ios --assets-dest ./bundle --dev false > /dev/null

# 发布到测试环境（私钥签名）
code-push release-react $__Environment ios --t $__APPVersion --des "$__Log" -k $__KeyFile > /dev/null
# 发布到正式环境
#code-push release-react $__Environment ios --t $__APPVersion --dev false --d Production --des "$__Log" --m true
#其中参数--t为二进制(.ipa与apk)安装包的的版本；--dev为是否启用开发者模式(默认为false)；--d是要发布更新的环境分Production与Staging(默认为Staging)；--des为更新说明；--m 是强制更新。
# 把测试环境的更新包推送到正式环境
#code-push promote $__Environment Staging Production
