import React, {Component} from 'react';
import {View, Text} from 'react-native';
import AppDefine from '../../公共类/AppDefine';
import {TouchableOpacity, ScrollView} from 'react-native-gesture-handler';
import FastImage from 'react-native-fast-image';
import {Skin1} from '../../公共类/UGSkinManagers';
import LinearGradient from 'react-native-linear-gradient';
import {Button, Input, Icon} from 'react-native-elements';
import UGTextField from '../../公共类/UGTextField';

export default class XBJRegisterVC extends Component {
  componentDidMount() {
    AppDefine.navController?.setOptions({headerTransparent: true, title: ''});
  }
  render() {
    const accInput: {current: Input} = React.createRef();
    const pwdInput: {current: Input} = React.createRef();
    return (
      <LinearGradient colors={Skin1.bgColor}>
        <ScrollView style={{paddingTop: 80, paddingBottom: 100}}>
          <FastImage source={{uri: 'https://i.ibb.co/PrsPnxF/m-logo.png'}} style={{marginLeft: AppDefine.width * 0.5 - 50, width: 100, height: 36}} />
          <View style={{marginLeft: 24, marginTop: 56, width: AppDefine.width - 48, borderRadius: 8, overflow: 'hidden', flexDirection: 'row'}}>
            <TouchableOpacity
              style={{width: 52, flex: 1, backgroundColor: 'rgba(0, 0, 0, 0.3)', justifyContent: 'center'}}
              activeOpacity={1}
              onPress={() => {
                AppDefine.tabController?.navigate('XBJLoginVC');
              }}>
              <FastImage source={{uri: 'https://i.ibb.co/W2tbj1Q/entry-login-toggle-btn.png'}} style={{marginLeft: 17, width: 20, height: 20, opacity: 0.6}} />
              <Text style={{marginLeft: 18, marginTop: 20, width: 20, fontSize: 16, lineHeight: 30, color: 'white', opacity: 0.6}}>返回登录</Text>
            </TouchableOpacity>
            <View style={{flex: 1, backgroundColor: 'rgba(255, 255, 255, 0.3)', padding: 24}}>
              <Text style={{fontSize: 20, fontWeight: '500', color: 'white', textAlign: 'center'}}>注册</Text>
              <UGTextField type="推荐人ID" containerStyle={{marginTop: 24}} />
              <UGTextField type="账号" placeholder="账号长度为6-15位" />
              <UGTextField type="密码" />
              <UGTextField type="密码" />
              <UGTextField type="真实姓名" />
              <UGTextField type="字母验证码" />
              <UGTextField type="手机号" />
              <UGTextField type="短信验证码" />
              <Button
                style={{marginTop: 24}}
                buttonStyle={{borderRadius: 20, height: 40, borderWidth: 0.5, borderColor: '#B0937D'}}
                ViewComponent={LinearGradient}
                linearGradientProps={{colors: ['#B0937D', '#997961'], start: {x: 0, y: 1}, end: {x: 1, y: 1}}}
                titleStyle={{fontSize: 16}}
                title="注册"
              />
            </View>
          </View>
          <View style={{height: 200}} />
        </ScrollView>
      </LinearGradient>
    );
  }
}
