#!/bin/sh
# 该脚本使用方法
# 源码地址：https://github.com/stackhou
# step 1. 在工程根目录新建AutoPacking文件夹，在该文件夹中新建文件autopacking.sh，将该脚本复制到autopacking.sh文件并保存(或者直接复制该文件);
# step 2. 设置该脚本;
# step 2. cd 该脚本目录，运行chmod +x autopacking.sh;
# step 3. 终端运行 sh autopacking.sh;
# step 4. 选择不同选项....
# step 5. Success  🎉 🎉 🎉!
# 注意：可以全文搜索“配置”，看相关注释选择配置，因为不同的项目配置不同，最好有相关的基础知识

# ************************* 需要配置 Start ********************************


# 编译生成文件目录
__EXPORT_PATH=`pwd`
__EXPORT_PATH="$__EXPORT_PATH/AutoPackingDir"
echo $__EXPORT_PATH

# 从Xcode运行需要先cd到当前目录
if [ ! -n "$2" ] ;then
    echo "you have not input a word!"
else
    cd $2
fi

# 项目名称
__BUILD_TARGET="ug"
__SCHEME_NAME="ug"
__PROJECT_NAME="ug"

# 打包类型 Release Or Debug
__BUILD_CONFIGURATION="Release"

# 工程类型(1.xcworkspace项目; 2.xcodeproj项目)
__IS_WORKSPACE_OPTION=1

# 成功出包后是否自动打开文件夹 ("1.是" "2.否")
__IS_AUTO_OPENT_FILE_OPTION=0

# 【配置证书】(如果只有一个证书时该项 可选)
__CODE_SIGN_DISTRIBUTION="iPhone Distribution: AFFISHAUL WORLDWIDE, LLC"
__CODE_SIGN_DEVELOPMENT="Apple Development: syslink@affishaulworldwide.com (TVG8PUP9M8)"

# 发布APP Store 账号密码
__IOS_SUBMIT_ACCOUNT="syslink@affishaulworldwide.com"
__IOS_SUBMIT_PASSWORD="Z@yKYgR#0$!!"

# 打包类型 AdHoc, Enterprise
__PACK_TYPES=("1.AdHoc" "2.Enterprise")
__PACK_TYPE=$1
if [[ $__PACK_TYPE -eq 1 ]]; then
  __EXPORT_OPTIONS_PLIST_PATH="./AutoPacking/Plist/AdHocExportOptionsPlist.plist"
  __BUILD_METHOD_NAME="AdHoc"
elif [[ $__PACK_TYPE -eq 2 ]]; then
  __EXPORT_OPTIONS_PLIST_PATH="./AutoPacking/Plist/EnterpriseExportOptionsPlist.plist"
  __BUILD_METHOD_NAME="Enterprise"
fi







# ==================== 公共部分 =====================
# ######### 脚本样式 #############
__TITLE_LEFT_COLOR=""
__TITLE_RIGHT_COLOR=""

__OPTION_LEFT_COLOR=""
__OPTION_RIGHT_COLOR=""

__LINE_BREAK_LEFT=""
__LINE_BREAK_RIGHT=""

# 红底白字
__ERROR_MESSAGE_LEFT=""
__ERROR_MESSAGE_RIGHT=""


# 等待用户输入时间
__WAIT_ELECT_TIME=0.2

# 选择项输入方法 接收3个参数：1、选项标题 2、选项数组 3、选项数组的长度(0~256)
function READ_USER_INPUT() {
  title=$1
  options=$2
  maxValue=$3
  echo "${__TITLE_LEFT_COLOR}${title}${__TITLE_RIGHT_COLOR}"
  for option in ${options[*]}; do
    echo "${__OPTION_LEFT_COLOR}${option}${__OPTION_RIGHT_COLOR}"
  done
  read
  __INPUT=$REPLY
  expr $__INPUT "+" 10 &> /dev/null
  if [[ $? -eq 0 ]]; then
    if [[ $__INPUT -gt 0 && $__INPUT -le $maxValue ]]; then
      return $__INPUT
    else
      echo "${__ERROR_MESSAGE_LEFT}输入越界了，请重新输入${__ERROR_MESSAGE_RIGHT}"
      READ_USER_INPUT $title "${options[*]}" $maxValue
    fi
  else
    echo "${__ERROR_MESSAGE_LEFT}输入有误，请输入0~256之间的数字序号${__ERROR_MESSAGE_RIGHT}"
    READ_USER_INPUT $title "${options[*]}" $maxValue
  fi
}

# 打印信息
function printMessage() {
  pMessage=$1
  echo "${__LINE_BREAK_LEFT}${pMessage}${__LINE_BREAK_RIGHT}"
}









# ===============================自动打包部分=============================
# 打包计时
__CONSUME_TIME=0

__PROGECT_PATH=`pwd`

# 已经指定Target的Info.plist文件路径 【配置Info.plist的名称】
__CURRENT_INFO_PLIST_NAME="Info.plist"
# 获取 Info.plist 路径  【配置Info.plist的路径】
__CURRENT_INFO_PLIST_PATH="${__PROJECT_NAME}/Classes/Other/${__CURRENT_INFO_PLIST_NAME}"

# 获取版本号
__BUNDLE_VERSION=`/usr/libexec/PlistBuddy -c "Print CFBundleShortVersionString" ${__CURRENT_INFO_PLIST_PATH}`
# 获取编译版本号
__BUNDLE_BUILD_VERSION=`/usr/libexec/PlistBuddy -c "Print CFBundleVersion" ${__CURRENT_INFO_PLIST_PATH}`

# 指定输出文件目录不存在则创建
if test -d "${__EXPORT_PATH}" ; then
rm -rf ${__EXPORT_PATH}
else
mkdir -pv ${__EXPORT_PATH}
fi

# 归档文件路径
__EXPORT_ARCHIVE_PATH="${__EXPORT_PATH}/${__SCHEME_NAME}.xcarchive"
# ipa 导出路径
__EXPORT_IPA_PATH="${__EXPORT_PATH}"
# 获取时间 如:201706011145
__CURRENT_DATE="$(date +%Y%m%d_%H%M%S)"
# ipa 名字
__IPA_NAME="${__SCHEME_NAME}_${__CURRENT_DATE}"

function print_packing_message() {

  printMessage "打包类型 = ${__BUILD_CONFIGURATION}"
  printMessage "打包导出Plist路径 = ${__EXPORT_OPTIONS_PLIST_PATH}"
  printMessage "工程目录 = ${__PROGECT_PATH}"
  printMessage "当前Info.plist路径 = ${__CURRENT_INFO_PLIST_PATH}"
}

#print_packing_message

if [[ $__IS_WORKSPACE_OPTION -eq 1 ]]; then
  # pod install --verbose --no-repo-update

  if [[ ${__BUILD_CONFIGURATION} == "Debug" ]]; then
    # step 1. Clean
    xcodebuild clean  -workspace ${__PROJECT_NAME}.xcworkspace \
    -scheme ${__SCHEME_NAME} \
    -configuration ${__BUILD_CONFIGURATION}

    # step 2. Archive
    xcodebuild archive  -workspace ${__PROJECT_NAME}.xcworkspace \
    -scheme ${__SCHEME_NAME} \
    -configuration ${__BUILD_CONFIGURATION} \
    -archivePath ${__EXPORT_ARCHIVE_PATH} \
    CFBundleVersion=${__BUNDLE_BUILD_VERSION} \
    -destination generic/platform=ios \
    #CODE_SIGN_IDENTITY="${__CODE_SIGN_DEVELOPMENT}"

  elif [[ ${__BUILD_CONFIGURATION} == "Release" ]]; then
    # step 1. Clean
    printMessage "\n\n ———————— 正在Clean...  ———————— \n\n"
    xcodebuild clean  -workspace ${__PROJECT_NAME}.xcworkspace \
    -scheme ${__SCHEME_NAME} \
    -configuration ${__BUILD_CONFIGURATION} \
    > /dev/null
    
    printMessage "\n ———————— Clean完成，开始打包。。。  ———————— \n"
    printMessage "\n ———————— 打包耗时较长（3分钟左右），请耐心等待。。。  ———————— \n"
    printMessage "\n ———————— 优化 .pch文件、import 可以提高编译速度。  ———————— \n"

    # step 2. Archive
    xcodebuild archive  -workspace ${__PROJECT_NAME}.xcworkspace \
    -scheme ${__SCHEME_NAME} \
    -configuration ${__BUILD_CONFIGURATION} \
    -archivePath ${__EXPORT_ARCHIVE_PATH} \
    CFBundleVersion=1 \
    -destination generic/platform=ios \
    -allowProvisioningUpdates \
    -quiet \
#    > /dev/null
    
    #CODE_SIGN_IDENTITY="${__CODE_SIGN_DISTRIBUTION}"
  fi

else

  if [[ ${__BUILD_CONFIGURATION} == "Debug" ]] ; then
    # step 1. Clean
    xcodebuild clean  -project ${__PROJECT_NAME}.xcodeproj \
    -scheme ${__SCHEME_NAME} \
    -configuration ${__BUILD_CONFIGURATION} \
    #-alltargets

    # step 2. Archive
    xcodebuild archive  -project ${__PROJECT_NAME}.xcodeproj \
    -scheme ${__SCHEME_NAME} \
    -configuration ${__BUILD_CONFIGURATION} \
    -archivePath ${__EXPORT_ARCHIVE_PATH} \
    CFBundleVersion=${__BUNDLE_BUILD_VERSION} \
    -destination generic/platform=ios \
    #CODE_SIGN_IDENTITY="${__CODE_SIGN_DEVELOPMENT}"

  elif [[ ${__BUILD_CONFIGURATION} == "Release" ]]; then
    # step 1. Clean
    xcodebuild clean  -project ${__PROJECT_NAME}.xcodeproj \
    -scheme ${__SCHEME_NAME} \
    -configuration ${__BUILD_CONFIGURATION} \
    -alltargets
    # step 2. Archive
    xcodebuild archive  -project ${__PROJECT_NAME}.xcodeproj \
    -scheme ${__SCHEME_NAME} \
    -configuration ${__BUILD_CONFIGURATION} \
    -archivePath ${__EXPORT_ARCHIVE_PATH} \
    CFBundleVersion=${__BUNDLE_BUILD_VERSION} \
    -destination generic/platform=ios \
    #CODE_SIGN_IDENTITY="${__CODE_SIGN_DISTRIBUTION}"
  fi
fi

# 检查是否构建成功
# xcarchive 实际是一个文件夹不是一个文件所以使用 -d 判断
if test -d "${__EXPORT_ARCHIVE_PATH}" ; then
  printMessage "\n\n ———————— 项目构建成功 🚀 🚀 🚀 ———————— \n\n"
else
  printMessage "\n\n ———————— 项目构建失败 😢 😢 😢 ———————— \n\n"
  exit 1
fi

printMessage "开始导出ipa文件"

xcodebuild -exportArchive -archivePath ${__EXPORT_ARCHIVE_PATH} \
-exportPath ${__EXPORT_IPA_PATH} \
-destination generic/platform=ios \
-exportOptionsPlist ${__EXPORT_OPTIONS_PLIST_PATH} \
-allowProvisioningUpdates

# 修改ipa文件名称
mv ${__EXPORT_IPA_PATH}/${__SCHEME_NAME}.ipa ${__EXPORT_IPA_PATH}/${__IPA_NAME}.ipa

# 检查文件是否存在
if test -f "${__EXPORT_IPA_PATH}/${__IPA_NAME}.ipa" ; then

  printMessage "导出 ${__IPA_NAME}.ipa 包成功 🎉 🎉 🎉"

  # 自动打开文件夹
  if [[ $__IS_AUTO_OPENT_FILE_OPTION -eq 1 ]]; then
    open ${__EXPORT_IPA_PATH}
  fi

else
  printMessage "导出 ${__IPA_NAME}.ipa 包失败 😢 😢 😢"
  exit 1
fi

# 输出打包总用时
printMessage "使用YJShell脚本打包总耗时: ${SECONDS}s"

# 拷贝到ug.ipa
rm -rf ug.ipa
rm -rf ug.xcarchive
mv $__EXPORT_ARCHIVE_PATH ug.xcarchive
mv "$__EXPORT_PATH/$__IPA_NAME.ipa" ug.ipa
