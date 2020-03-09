import React, {Component} from 'react';
import {View, Image} from 'react-native';
import {Skin1} from '../../公共类/UGSkinManagers';
import AppDefine from '../../公共类/AppDefine';
import {Button, Card, Text} from 'react-native-elements';
import LinearGradient from 'react-native-linear-gradient';

export default class MGJMyVC extends Component {
  componentDidMount() {
    AppDefine.navController?.setOptions({
      title: '我的',
      headerStyle: {backgroundColor: Skin1.navBarBgColor},
      headerLeft: () => (
        <Button
          icon={{name: 'chevron-left', size: 32, color: 'white'}}
          iconContainerStyle={{marginLeft: -2}}
          buttonStyle={{backgroundColor: 'transparent'}}
          onPress={() => {
            if (AppDefine.navController.canGoBack()) {
              AppDefine.navController.goBack();
            } else {
              AppDefine.ocCall('UGNavigationController.current.popViewControllerAnimated:', [true]);
            }
          }}
        />
      ),
    });
  }

  render() {
    console.log('颜色：');
    console.log(Skin1.menuHeadViewColor);
    return (
      <View style={{flex: 1}}>
        <LinearGradient colors={Skin1.bgColor} start={{x: 0, y: 1}} end={{x: 1, y: 1}} style={{flex: 1, padding: 16}}>
          <Card containerStyle={{margin: 0, borderRadius: 4}}>
            <View style={{flexDirection: 'row'}}>
              <Image source={{uri: ''}} resizeMode="stretch" style={{width: 56, height: 56, backgroundColor: Skin1.placeholderColor}} />
              <View style={{marginLeft: 16}}>
                <View style={{marginTop: 4, flexDirection: 'row'}}>
                  <Text style={{fontWeight: '500', fontSize: 16}}>Adam</Text>
                  <Image source={{uri: ''}} resizeMode="stretch" style={{marginLeft: 8, marginTop: 1, width: 42, height: 17, backgroundColor: Skin1.placeholderColor}} />
                </View>
                <View style={{marginTop: 10, flexDirection: 'row'}}>
                  <Text style={{fontSize: 12}}>头衔：</Text>
                  <Text style={{fontSize: 12, color: Skin1.redColor}}>初行者</Text>
                </View>
              </View>
            </View>
            <View style={{marginLeft: -15, marginTop: 18, flexDirection: 'row', alignItems: 'center'}}>
              <View style={{flex: 1, alignItems: 'center'}}>
                <Image source={{uri: ''}} style={{width: 28, height: 21, backgroundColor: Skin1.placeholderColor}} />
                <Text style={{marginTop: 11, fontSize: 12}}>存款</Text>
              </View>
              <View style={{flex: 1, alignItems: 'center'}}>
                <Image source={{uri: ''}} style={{width: 28, height: 21, backgroundColor: Skin1.placeholderColor}} />
                <Text style={{marginTop: 11, fontSize: 12}}>额度转换</Text>
              </View>
              <View style={{flex: 1, alignItems: 'center'}}>
                <Image source={{uri: ''}} style={{width: 28, height: 21, backgroundColor: Skin1.placeholderColor}} />
                <Text style={{marginTop: 11, fontSize: 12}}>取款</Text>
              </View>
              <View style={{flex: 1, alignItems: 'center'}}>
                <Image source={{uri: ''}} style={{width: 28, height: 21, backgroundColor: Skin1.placeholderColor}} />
                <Text style={{marginTop: 11, fontSize: 12}}>资金管理</Text>
              </View>
              <View style={{flex: 1.5, alignItems: 'center'}}>
                <Image source={{uri: ''}} style={{width: 28, height: 21, backgroundColor: Skin1.placeholderColor}} />
                <Text style={{marginTop: 11, fontSize: 12}}>中心钱包</Text>
              </View>
            </View>
          </Card>
          <View style={{marginTop: 12, flexDirection: 'row', justifyContent: 'space-between'}}>
            <Card containerStyle={{margin: 0, borderRadius: 4}}>
              <Text style={{marginTop: -3, fontSize: 14}}>全员福利</Text>
              <Text style={{marginTop: 4, fontSize: 10}}>现金奖励等你拿</Text>
              <Image source={{uri: ''}} style={{marginTop: 9, marginBottom: -8, width: 80, height: 53, backgroundColor: Skin1.placeholderColor}} />
            </Card>
            <Card containerStyle={{margin: 0, borderRadius: 4}}>
              <Text style={{marginTop: -3, fontSize: 14}}>全员福利</Text>
              <Text style={{marginTop: 4, fontSize: 10}}>现金奖励等你拿</Text>
              <Image source={{uri: ''}} style={{marginTop: 9, marginBottom: -8, width: 92, height: 53, backgroundColor: Skin1.placeholderColor}} />
            </Card>
            <Card containerStyle={{margin: 0, borderRadius: 4}}>
              <Text style={{marginTop: -3, fontSize: 14}}>全员福利</Text>
              <Text style={{marginTop: 4, fontSize: 10}}>现金奖励等你拿</Text>
              <Image source={{uri: ''}} style={{marginTop: 9, marginBottom: -8, width: 92, height: 53, backgroundColor: Skin1.placeholderColor}} />
            </Card>
          </View>

          <Card containerStyle={{margin: 0, marginTop: 12, borderRadius: 4, padding: 0}}>
            <View style={{flexDirection: 'row'}}>
              <Image source={{uri: ''}} style={{margin: 8, marginLeft: 13, width: 28, height: 28, backgroundColor: Skin1.placeholderColor}} />
              <Text style={{marginTop: 14, marginLeft: 6}}>利息宝</Text>
            </View>
            <View style={{marginLeft: 55, height: 0.5, backgroundColor: Skin1.placeholderColor}} />
            <View style={{flexDirection: 'row'}}>
              <Image source={{uri: ''}} style={{margin: 8, marginLeft: 13, width: 28, height: 28, backgroundColor: Skin1.placeholderColor}} />
              <Text style={{marginTop: 14, marginLeft: 6}}>利息宝</Text>
            </View>
            <View style={{marginLeft: 55, height: 0.5, backgroundColor: Skin1.placeholderColor}} />
            <View style={{flexDirection: 'row'}}>
              <Image source={{uri: ''}} style={{margin: 8, marginLeft: 13, width: 28, height: 28, backgroundColor: Skin1.placeholderColor}} />
              <Text style={{marginTop: 14, marginLeft: 6}}>利息宝</Text>
            </View>
            <View style={{marginLeft: 55, height: 0.5, backgroundColor: Skin1.placeholderColor}} />
            <View style={{flexDirection: 'row'}}>
              <Image source={{uri: ''}} style={{margin: 8, marginLeft: 13, width: 28, height: 28, backgroundColor: Skin1.placeholderColor}} />
              <Text style={{marginTop: 14, marginLeft: 6}}>利息宝</Text>
            </View>
            <View style={{marginLeft: 55, height: 0.5, backgroundColor: Skin1.placeholderColor}} />
          </Card>
        </LinearGradient>
      </View>
    );
  }
}
