import React, {Component} from 'react';
import {View, Text} from 'react-native';
import AppDefine from '../../公共类/AppDefine';
import {TouchableOpacity} from 'react-native-gesture-handler';
import FastImage from 'react-native-fast-image';
import {Skin1} from '../../公共类/UGSkinManagers';
import LinearGradient from 'react-native-linear-gradient';
import {Button, Input, Icon} from 'react-native-elements';
import UGTextField from '../../公共类/UGTextField';
import {UGUserCenterItem, UGUserCenterType} from '../../Model/全局/UGSysConfModel';

interface IState {
  rememberPassword: boolean;
}

export default class XBJLoginVC extends Component<{}, IState> {
  constructor(props) {
    super(props);
    this.state = {rememberPassword: true};
  }
  componentDidMount() {
    AppDefine.navController?.setOptions({headerTransparent: true, title: ''});
  }
  render() {
    const accInput: {current: Input} = React.createRef();
    const pwdInput: {current: Input} = React.createRef();
    return (
      <LinearGradient colors={Skin1.bgColor} style={{flex: 1, justifyContent: 'center', marginTop: -AppDefine.height * 0.1}}>
        <FastImage source={{uri: 'https://i.ibb.co/PrsPnxF/m-logo.png'}} style={{marginLeft: AppDefine.width * 0.5 - 50, width: 100, height: 36}} />
        <View style={{marginLeft: 24, marginTop: 56, width: AppDefine.width - 48, borderRadius: 8, overflow: 'hidden', flexDirection: 'row'}}>
          <View style={{flex: 1, backgroundColor: 'rgba(255, 255, 255, 0.3)', padding: 24}}>
            <Text style={{fontSize: 20, fontWeight: '500', color: 'white', textAlign: 'center'}}>登录</Text>
            <UGTextField type="账号" placeholder="请输入账号" containerStyle={{marginTop: 24}} forbiddenCharacters="3a" />
            <UGTextField type="密码" />
            <UGTextField type="字母验证码" />
            <View style={{marginTop: 18, flexDirection: 'row', justifyContent: 'space-between'}}>
              <TouchableOpacity
                style={{flexDirection: 'row'}}
                onPress={() => {
                  this.setState({rememberPassword: !this.state.rememberPassword});
                }}>
                {this.state.rememberPassword ? (
                  <Icon name="radio-button-checked" type="materialIcon" color="rgba(0, 0, 0, 0.8)" size={16} />
                ) : (
                  <Icon name="radio-button-unchecked" type="materialIcon" color="rgba(0, 0, 0, 0.6)" size={16} />
                )}

                <Text style={{marginLeft: 6, color: 'white'}}>记住密码</Text>
              </TouchableOpacity>
              <Text
                style={{marginTop: -10, marginRight: -5, padding: 10, textAlign: 'right', color: 'white'}}
                onPress={() => {
                  UGUserCenterItem.pushViewController(UGUserCenterType.在线客服);
                }}>
                忘记密码
              </Text>
            </View>
            <Button
              style={{marginTop: 55}}
              buttonStyle={{borderRadius: 20, height: 40, borderWidth: 0.5, borderColor: '#B0937D'}}
              ViewComponent={LinearGradient}
              linearGradientProps={{colors: ['#B0937D', '#997961'], start: {x: 0, y: 1}, end: {x: 1, y: 1}}}
              titleStyle={{fontSize: 16}}
              title="登录"
            />
            <Button title="免费试玩" buttonStyle={{marginTop: 15, marginBottom: -5, backgroundColor: 'transparent'}} titleStyle={{fontSize: 12}} />
          </View>
          <TouchableOpacity
            style={{width: 52, flex: 1, backgroundColor: 'rgba(0, 0, 0, 0.3)', justifyContent: 'center'}}
            activeOpacity={1}
            onPress={() => {
              AppDefine.tabController?.navigate('XBJRegisterVC');
            }}>
            <FastImage source={{uri: 'https://i.ibb.co/W2tbj1Q/entry-login-toggle-btn.png'}} style={{marginLeft: 17, width: 20, height: 20, opacity: 0.6}} />
            <Text style={{marginLeft: 18, marginTop: 20, width: 20, fontSize: 16, lineHeight: 30, color: 'white', opacity: 0.6}}>注册新用户</Text>
          </TouchableOpacity>
        </View>
      </LinearGradient>
    );
  }
}
