import React, {Component} from 'react';
import {View, Image, Alert, AlertButton} from 'react-native';
import {Skin1} from '../../公共类/UGSkinManagers';
import AppDefine from '../../公共类/AppDefine';
import {Button, Card, Text, Avatar} from 'react-native-elements';
import LinearGradient from 'react-native-linear-gradient';
import {TouchableOpacity, ScrollView} from 'react-native-gesture-handler';
import FastImage from 'react-native-fast-image';
import {UGUserCenterItem} from '../../Model/全局/UGSysConfModel';
import NetworkRequest1 from '../../公共类/网络/NetworkRequest1';
import {UserI} from '../../Model/全局/UGUserModel';

export default class XBJMineVC extends Component {
  dataArray: Array<UGUserCenterItem> = [];

  componentDidMount() {
    AppDefine.navController?.setOptions({
      title: '我的',
      headerStyle: {backgroundColor: Skin1.navBarBgColor[0]},
      headerLeft: null,
      headerRight: () => (
        <TouchableOpacity
          onPress={() => {
            UGUserCenterItem.pushViewController(9);
          }}>
          <FastImage source={{uri: 'https://i.ibb.co/q0Pgt4B/2x.png'}} style={{marginRight: 16, width: 20, height: 20}} />
        </TouchableOpacity>
      ),
    });

    // 获取功能按钮列表
    AppDefine.ocCall('UGSystemConfigModel.currentConfig.userCenter').then((list: Array<UGUserCenterItem>) => {
      this.dataArray = list.map(item => new UGUserCenterItem(item));
      this.setState({});
    });

    NetworkRequest1.user_info().then(user => {
      console.log('获取用户信息');
      console.log(user);
      Object.assign(UserI, user);
      this.setState({});
    });
  }

  render() {
    //
    var cells = this.dataArray.map(item => {
      return [
        <TouchableOpacity
          style={{flexDirection: 'row'}}
          onPress={() => {
            item.pushViewController();
          }}>
          <FastImage source={{uri: item.logo}} style={{margin: 10, marginLeft: 13, width: 26, height: 26}} />
          <Text style={{marginTop: 14, marginLeft: 6}}>{item.name}</Text>
        </TouchableOpacity>,
        <View style={{marginLeft: 55, height: 0.5, backgroundColor: '#AAA'}} />,
      ];
    });

    return (
      <LinearGradient colors={Skin1.bgColor} start={{x: 0, y: 1}} end={{x: 1, y: 1}} style={{flex: 1}}>
        <ScrollView style={{flex: 1, padding: 16}}>
          <View style={{padding: 16, borderRadius: 4, backgroundColor: Skin1.homeContentColor}}>
            <View style={{flexDirection: 'row'}}>
              <Avatar source={{uri: UserI.avatar}} rounded showEditButton size={56} onPress={() => {}} />
              <View style={{marginLeft: 16}}>
                <View style={{marginTop: 4, flexDirection: 'row'}}>
                  <Text style={{fontWeight: '500', fontSize: 16}}>{UserI.usr}</Text>
                  <LinearGradient colors={['#FFEAC3', '#FFE09A']} start={{x: 0, y: 1}} end={{x: 1, y: 1}} style={{marginLeft: 8, marginTop: 1, borderRadius: 3, width: 42, height: 17}}>
                    <Text style={{marginTop: 0.5, textAlign: 'center', color: '#8F6832', fontStyle: 'italic', fontWeight: '600', fontSize: 13}}>{UserI.curLevelGrade}</Text>
                  </LinearGradient>
                </View>
                <View style={{marginTop: 10, flexDirection: 'row'}}>
                  <Text style={{fontSize: 12}}>头衔：</Text>
                  <Text style={{fontSize: 12, color: Skin1.redColor}}>{UserI.curLevelTitle}</Text>
                </View>
              </View>
            </View>
            <View style={{marginLeft: -15, marginTop: 18, flexDirection: 'row', justifyContent: 'space-around'}}>
              <TouchableOpacity
                style={{alignItems: 'center'}}
                onPress={() => {
                  UGUserCenterItem.pushViewController(1);
                }}>
                <FastImage source={{uri: 'https://i.ibb.co/1MzcBGd/2x.png'}} style={{width: 28, height: 21}} />
                <Text style={{marginTop: 11, fontSize: 12}}>存款</Text>
              </TouchableOpacity>
              <TouchableOpacity
                style={{alignItems: 'center'}}
                onPress={() => {
                  UGUserCenterItem.pushViewController(8);
                }}>
                <FastImage source={{uri: 'https://i.ibb.co/VNm1G2s/2x.png'}} style={{width: 28, height: 21}} />
                <Text style={{marginTop: 11, fontSize: 12}}>额度转换</Text>
              </TouchableOpacity>
              <TouchableOpacity
                style={{alignItems: 'center'}}
                onPress={() => {
                  UGUserCenterItem.pushViewController(2);
                }}>
                <FastImage source={{uri: 'https://i.ibb.co/mJjNngx/2x.png'}} style={{width: 28, height: 21}} />
                <Text style={{marginTop: 11, fontSize: 12}}>取款</Text>
              </TouchableOpacity>
              <TouchableOpacity
                style={{alignItems: 'center'}}
                onPress={() => {
                  UGUserCenterItem.pushViewController(1);
                }}>
                <FastImage source={{uri: 'https://i.ibb.co/RGXm0sc/2x.png'}} style={{width: 28, height: 21}} />
                <Text style={{marginTop: 11, fontSize: 12}}>资金管理</Text>
              </TouchableOpacity>
              <TouchableOpacity style={{alignItems: 'center', borderRadius: 100}}>
                <Text style={{marginTop: 4, fontWeight: '500', color: Skin1.redColor}}>{'¥' + UserI.balance}</Text>
                <Text style={{marginTop: 11, fontSize: 12}}>中心钱包</Text>
              </TouchableOpacity>
            </View>
          </View>
          <View style={{marginTop: 12, flexDirection: 'row', flex: 1}}>
            <TouchableOpacity
              containerStyle={{padding: 12, borderRadius: 4, backgroundColor: Skin1.homeContentColor, flex: 1, marginRight: 12}}
              onPress={() => {
                UGUserCenterItem.pushViewController(17);
              }}>
              <Text style={{marginTop: -3, fontSize: 14}}>全员福利</Text>
              <Text style={{marginTop: 4, fontSize: 10}}>现金奖励等你拿</Text>
              <FastImage source={{uri: 'https://i.ibb.co/WHXtKwK/2x.png'}} style={{marginTop: 9, marginBottom: -8, width: 80, height: 53}} />
            </TouchableOpacity>
            <TouchableOpacity
              containerStyle={{padding: 12, borderRadius: 4, backgroundColor: Skin1.homeContentColor, flex: 1, marginRight: 12}}
              onPress={() => {
                UGUserCenterItem.pushViewController(15);
              }}>
              <Text style={{marginTop: -3, fontSize: 14}}>彩金申请</Text>
              <Text style={{marginTop: 4, fontSize: 10}}>新手有好礼</Text>
              <FastImage source={{uri: 'https://i.ibb.co/Jz0F2nV/2x.png'}} style={{marginTop: 9, marginBottom: -8, width: 92, height: 53}} />
            </TouchableOpacity>
            <TouchableOpacity
              containerStyle={{padding: 12, borderRadius: 4, backgroundColor: Skin1.homeContentColor, flex: 1}}
              onPress={() => {
                UGUserCenterItem.pushViewController(11);
              }}>
              <Text style={{marginTop: -3, fontSize: 14}}>任务中心</Text>
              <Text style={{marginTop: 4, fontSize: 10}}>领取丰富大奖</Text>
              <FastImage source={{uri: 'https://i.ibb.co/mNs6pFN/2x.png'}} style={{marginTop: 9, marginBottom: -8, width: 92, height: 53}} />
            </TouchableOpacity>
          </View>
          <View style={{marginTop: 12, borderRadius: 4, backgroundColor: Skin1.homeContentColor}}>{cells}</View>
          <Button
            title="退出登录"
            style={{marginTop: 12}}
            buttonStyle={{backgroundColor: Skin1.homeContentColor, borderRadius: 4, height: 48}}
            titleStyle={{color: Skin1.redColor}}
            onPress={() => {
              Alert.alert('温馨提示', '确定退出账号', [
                {text: '取消', style: 'cancel'},
                {
                  text: '确定',
                  onPress: () => {
                    NetworkRequest1.user_logout();
                    AppDefine.ocCall('UGUserModel.setCurrentUser:', [null]);
                    AppDefine.ocCall('NSNotificationCenter.defaultCenter.postNotificationName:object:', ['UGNotificationUserLogout']);
                  },
                },
              ]);
            }}
          />
          <View style={{height: 150}} />
        </ScrollView>
      </LinearGradient>
    );
  }
}
