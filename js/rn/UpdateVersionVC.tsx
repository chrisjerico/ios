import CodePush, {RemotePackage} from 'react-native-code-push';
import React, {Component} from 'react';
import {View, Text, Image} from 'react-native';
import AppDefine, {ProfileScreenNavigationProp} from './公共类/AppDefine';
import {Button, Card} from 'react-native-elements';
import * as Progress from 'react-native-progress';
import LinearGradient from 'react-native-linear-gradient';
import {number} from 'prop-types';
import NetworkRequest1 from './公共类/网络/NetworkRequest1';
import {Skin1} from './公共类/UGSkinManagers';
import FastImage from 'react-native-fast-image';

interface IProps {
  navigation?: ProfileScreenNavigationProp;
}

interface IState {
  rnProgress: number;
  jspProgress: number;
}

export default class UpdateVersionVC extends Component<IProps, IState> {
  newVersion: string = '';

  constructor(props: IProps) {
    super(props);
    this.state = {
      rnProgress: 0,
      jspProgress: 0,
    };

    var {navigation} = this.props;
    AppDefine.tabController = navigation;

    // 必须在注册监听之后执行
    AppDefine.ocHelper.launchFinish();
    // AppDefine.ocCall("UGNavigationController.current.popViewControllerAnimated:", [true]);
  }

  updateJspatch() {
    this.setState({rnProgress: 1});
    CodePush.getUpdateMetadata(2)
      .then(localPackage => {
        console.log('rn版本号为：' + localPackage.description);
        // 开始更新jspatch
        AppDefine.ocCall('JSPatchHelper.updateVersion:progress:completion:', [localPackage.description]);
        AppDefine.ocBlocks['jsp下载进度'] = (progress: number) => {
          this.setState({jspProgress: progress});
        };
        AppDefine.ocBlocks['jsp更新结果'] = (ret: boolean) => {
          this.setState({jspProgress: 1});
          if (ret) {
            console.log('更新成功，重启APP生效');
            // 弹框提示。。。
            // AppDefine.ocCall("ReactNativeHelper.exit");
          } else {
            console.log('jsp下载失败');
            // 弹框让用户去外部链接下载
            // ...
          }
        };
      })
      .catch(err => {
        console.log('获取rn版本号失败, err = ');
        console.log(err);
      });
  }

  componentDidMount() {
    console.log('更新页面（rn）加载完毕');
    CodePush.sync(
      {
        deploymentKey: AppDefine.ocHelper.CodePushKey,
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
        installMode: CodePush.InstallMode.ON_NEXT_RESTART,
      },
      status => {
        switch (status) {
          case CodePush.SyncStatus.SYNC_IN_PROGRESS:
            console.log('当前已经在更新了，无须重复执行');
            break;
          case CodePush.SyncStatus.CHECKING_FOR_UPDATE:
            console.log('rn正在查找可用的更新');
            break;
          case CodePush.SyncStatus.AWAITING_USER_ACTION:
            console.log('rn弹了框让用户自己选择是否要更新');
            break;
          case CodePush.SyncStatus.UPDATE_IGNORED:
            console.log('rn忽略此热更新');
            this.updateJspatch();
            break;
          case CodePush.SyncStatus.UP_TO_DATE:
            console.log('rn已是最新版本');
            this.updateJspatch();
            break;
          case CodePush.SyncStatus.DOWNLOADING_PACKAGE:
            console.log('rn正在下载热更新');
            break;
          case CodePush.SyncStatus.INSTALLING_UPDATE:
            console.log('rn正在安装热更新');
            break;
          case CodePush.SyncStatus.UNKNOWN_ERROR:
            console.log('rn热更新出错❌');
            break;
          case CodePush.SyncStatus.UPDATE_INSTALLED:
            console.log('rn热更新安装成功下次启动生效');
            this.updateJspatch();
            // 弹框提示
            AppDefine.ocCall('AppDefine.shared.Test').then((isTest: boolean) => {
              isTest && AppDefine.ocCall('AlertHelper.showAlertView:msg:btnTitles:', ['更新提示', '热更新成功重启APP生效', ['确认']]);
            });
            break;
        }
      },
      progress => {
        var p = progress.receivedBytes / progress.totalBytes;
        this.setState({rnProgress: p});
        console.log('rn热更新包下载进度：' + p);
      },
    );
  }

  render() {
    var p = this.state.rnProgress * 0.5 + this.state.jspProgress * 0.5;
    return (
      <View style={{flex: 1}}>
        {/* 7F9493 , 5389B3 */}
        <LinearGradient colors={Skin1.bgColor} start={{x: 0, y: 1}} end={{x: 1, y: 1}} style={{flex: 1, padding: 25, justifyContent: 'center'}}>
          <Card containerStyle={{borderWidth: 8, borderRadius: 12}}>
            <FastImage source={{uri: 'https://i.ibb.co/0jFrhHw/1.png'}} resizeMode="stretch" style={{marginLeft: -16, marginRight: -16, marginTop: -51, height: 140}} />
            <View>
              <Text style={{margin: 10, fontSize: 15}}>更新内容：</Text>
              <Text style={{margin: 10, marginTop: 5, fontSize: 15, color: '#222'}}>1. 更新了太多人吐槽的界面。</Text>
              <Text style={{margin: 10, marginTop: 0, fontSize: 15, color: '#222'}}>2. 修复了一些bug。</Text>
              <Text style={{marginTop: 20, fontSize: 13, color: '#AAA', textAlign: 'center'}}>Wi-Fi情况下更新不到30秒哦</Text>
            </View>
            <Progress.Bar progress={p} borderWidth={0.5} borderRadius={9} unfilledColor="white" height={15} width={AppDefine.width - 130} style={{marginTop: 50}} />
            {p >= 1 ? (
              <Text style={{textAlign: 'center', marginTop: 15, marginBottom: 20, color: '#000'}}>更新完成，重启APP生效</Text>
            ) : (
              <Text style={{textAlign: 'center', marginTop: 15, marginBottom: 20, color: '#000'}}>版本正在努力更新中，请等候...</Text>
            )}
          </Card>
          <View style={{height: AppDefine.height * 0.11}} />
        </LinearGradient>
      </View>
    );
  }
}
