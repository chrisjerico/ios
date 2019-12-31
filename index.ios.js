
import CodePush from 'react-native-code-push';
import React, { Component } from 'react';
import {
  AppRegistry,  //注册
  StyleSheet,   //样式
  Text,         //文本组件
  View,          //视图组件
  Image,
  TouchableOpacity,
  Alert
} from 'react-native';

CodePush.sync({
  updateDialog: {
    appendReleaseDescription: true,
    descriptionPrefix:'\n\n更新内容：\n',
    title:'更新',
    mandatoryUpdateMessage:'',
    mandatoryContinueButtonLabel:'更新',
  },
  mandatoryInstallMode:CodePush.InstallMode.IMMEDIATE,
  deploymentKey: 'X1IUnBRRjstEdSE-C0UeUClh3tKxJmPjSmqHy',
});

 class Demo extends Component {
// 这函数可以不看
static navigationOptions = (navigation)=>({
headerStyle: {
// 如果想去掉安卓导航条底部阴影可以添加elevation: 0，
// iOS下用shadowOpacity: 0。
borderBottomWidth: 0,
shadowOpacity: 0,
elevation: 0,
backgroundColor: '#ff2d55',} });


 // componentWillMount(){
 //    // 页面加载的禁止重启，在加载完了可以允许重启
 //    CodePush.disallowRestart();
 // }
 componentDidMount() {
    // 在加载完了可以允许重启
    CodePush.allowRestart();
 }

 /** Update pops a confirmation dialog, and then immediately reboots the app 一键更新，加入的配置项 */
 syncImmediate = () => {
    let deploymentKey = 'X1IUnBRRjstEdSE-C0UeUClh3tKxJmPjSmqHy';

  CodePush.checkForUpdate(deploymentKey).then((update) => {

         if (!update) {
            Alert.alert("提示", "已是最新版本--", [
               {
                  text: "Ok", onPress: () => {
                     console.log("点了OK");
                  }
               }
            ]);
         } else {
            CodePush.sync(
                {
                   deploymentKey: deploymentKey,
                   updateDialog: {
                      // true 表示在发布更新时的描述会显示到更新对话框上让用户可见
                      appendReleaseDescription: true,
                      title: '更新提示',

                      // 非强制更新设置的内容提示信息
                      optionalIgnoreButtonLabel: '稍后',
                      optionalInstallButtonLabel: '立即更新',
                      optionalUpdateMessage: '有新版本了，是否更新？',

                      // 强制更新设置的内容信息
                      mandatoryUpdateMessage:'有新版本了，必须进行更新，才能使用',
                      mandatoryContinueButtonLabel:'立即更新',

                   },
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
                   installMode: CodePush.InstallMode.IMMEDIATE,

                },
                (status) => {
                   switch (status) {
                      case CodePush.SyncStatus.DOWNLOADING_PACKAGE:
                         console.log("DOWNLOADING_PACKAGE");
                         break;
                      case CodePush.SyncStatus.INSTALLING_UPDATE:
                         console.log(" INSTALLING_UPDATE");
                         break;
                   }
                },
                (progress) => {
                   console.log(progress.receivedBytes + " of " + progress.totalBytes + " received.");
                }
            );
         }
  }).catch((error)=>{
     alert(error)
  });
};

// styles这里就不写出来
render() {
  return (
      <View style={styles.container}>
         <Image
             source={{uri: 'https://app.wdheco.cn/img/c085/c085.png'}}
             style={{width: 200, height: 120}}
             resizeMode={'contain'}
         />
          <Text style={styles.welcome}>
            可以在此做修改文本内容, 后打包 更新
          </Text>

          <TouchableOpacity
            // 点击按钮进行更新
             onPress={this.syncImmediate}
          >
            <Text style={styles.syncButton}>点击更新</Text>
         </TouchableOpacity>
      </View>
    );
  }
}
let CodePushOptions = {
 //设置检查更新的频率
 //ON_APP_RESUME APP恢复到前台的时候
 //ON_APP_START APP开启的时候
 //MANUAL 手动检查
 checkFrequency : CodePush.CheckFrequency.MANUAL
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    backgroundColor: '#F5FCFF',
  },
  welcome: {
    fontSize: 20,
    textAlign: 'center',
    margin: 10,
  },
  instructions: {
    textAlign: 'center',
    color: '#333333',
    marginBottom: 5,
  },
});

// 这一行必须要写
Demo = CodePush(CodePushOptions)(Demo);

export default Demo;


//注意这里的名字需要和项目名字一致
AppRegistry.registerComponent('Demo', () => Demo);





