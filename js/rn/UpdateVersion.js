import CodePush from "react-native-code-push";
import React, { Component } from "react";
import { View } from "react-native";
import { NativeModules } from "react-native";

var RNHelper = NativeModules.ReactNativeHelper;

export default class UpdateVersion extends Component {
  render() {
    if (this.props.willUpdate) {
      CodePush.sync(
        {
          deploymentKey: RNHelper.CodePushKey,
          /*
         * installMode (codePush.InstallMode)： 安装模式，用在向CodePush推送更新时没有设置强制更新(mandatory为true)的情况下，默认codePush.InstallMode.ON_NEXT_RESTART 即下一次启动的时候安装。
         * 在更新配置中通过指定installMode来决定安装完成的重启时机，亦即更新生效时机
           codePush.InstallMode.IMMEDIATE：表示安装完成立即重启更新(强制更新安装模式)
           codePush.InstallMode.ON_NEXT_RESTART：表示安装完成后会在下次重启后进行更新
           codePush.InstallMode.ON_NEXT_RESUME：表示安装完成后会在应用进入后台后重启更新
         *
         *
         * 强制更新模式(单独的抽出来设置 强制安装)
         * mandatoryInstallMode (codePush.InstallMode):强制更新,默认codePush.InstallMode.IMMEDIATE
         *
         * minimumBackgroundDuration (Number):该属性用于指定app处于后台多少秒才进行重启已完成更新。默认为0。该属性只在installMode为InstallMode.ON_NEXT_RESUME情况下有效
         *
         * */
          installMode: CodePush.InstallMode.ON_NEXT_RESTART
        },
        status => {
          switch (status) {
            case CodePush.SyncStatus.UP_TO_DATE:
              console.log("已是最新版本");
              RNHelper.updateFinish();
              break;
            case CodePush.SyncStatus.UPDATE_INSTALLED:
              console.log("热更新安装成功下次启动生效");
              RNHelper.updateFinish();
              break;
            case CodePush.SyncStatus.UPDATE_IGNORED:
              console.log("忽略此热更新");
              break;
            case CodePush.SyncStatus.UNKNOWN_ERROR:
              console.log("热更新出错❌");
              break;
            case CodePush.SyncStatus.SYNC_IN_PROGRESS:
              console.log("SYNC_IN_PROGRESS");
              break;
            case CodePush.SyncStatus.CHECKING_FOR_UPDATE:
              console.log("正在查找可用的更新");
              break;
            case CodePush.SyncStatus.AWAITING_USER_ACTION:
              console.log("弹了框让用户自己选择是否要更新");
              break;
            case CodePush.SyncStatus.DOWNLOADING_PACKAGE:
              console.log("正在下载热更新");
              break;
            case CodePush.SyncStatus.INSTALLING_UPDATE:
              console.log("正在安装热更新");
              break;
          }
        },
        progress => {
          var p = (progress.receivedBytes / progress.totalBytes) * 100;
          console.log("热更新包下载进度：" + p);
        }
      );
    }
    return <View />;
  }
}
