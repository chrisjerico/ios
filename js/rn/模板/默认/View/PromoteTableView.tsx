import React, {Component} from 'react';
import {UGPromoteModel} from '../../../Model/常规/UGPromoteModel';
import {FlatList, TouchableOpacity} from 'react-native-gesture-handler';
import {View} from 'react-native';
import {Button, Text, Icon, Card} from 'react-native-elements';
import AppDefine, {NSValue} from '../../../公共类/AppDefine';
import FastImage from 'react-native-fast-image';
import WebView from 'react-native-webview';

interface IProps {}
interface IState {
  selectedIndex: number;
}

export default class PromoteTableView extends Component<IProps, IState> {
  style1: '贴边' | '外边框' | '内间距' = '内间距';
  style2: 'slide' | 'popup' | 'page' = 'page'; // slide折叠、popup弹窗、page内页
  list: Array<UGPromoteModel> = [];

  constructor(props) {
    super(props);
    var {
      route: {
        params: {list, style},
      },
    } = props;

    if ('c190'.indexOf(AppDefine.siteId) != -1) {
      this.style1 = '贴边';
    } else if ('c199'.indexOf(AppDefine.siteId) != -1) {
      this.style1 = '外边框';
    }
    this.style2 = style;
    this.list = list.map((item: UGPromoteModel) => {
      return Object.assign({}, item);
    });
    this.state = {
      selectedIndex: -1,
    };
  }

  renderCell(pm: UGPromoteModel, idx: number) {
    var margin1 = this.style1 === '贴边' ? 0 : 10;
    var margin2 = this.style1 === '贴边' ? 0 : 5;
    let contentView = (
      <View style={{marginHorizontal: margin1, marginVertical: margin2}}>
        <TouchableOpacity
          activeOpacity={1}
          onPress={() => {
            if (!pm.clsName) {
              pm.clsName = 'UGPromoteModel';
            }
            switch (this.style2) {
              // 内页
              case 'page': {
                AppDefine.ocCall(({vc}) => ({
                  vc: {
                    selectors: 'UGPromoteDetailController.new[setItem:]',
                    args1: [pm],
                  },
                  ret: {
                    selectors: 'UGNavigationController.current.pushViewController:animated:',
                    args1: [vc, true],
                  },
                }));
                break;
              }
              // 弹框
              case 'popup': {
                AppDefine.ocCall('PromotePopView.alloc.initWithFrame:[setItem:].show', [NSValue.CGRectMake(20, AppDefine.height * 0.1, AppDefine.width - 40, AppDefine.height * 0.8)], [pm]);
                break;
              }
              // 折叠
              case 'slide': {
                this.setState({
                  selectedIndex: this.state.selectedIndex === idx ? -1 : idx,
                });
                break;
              }
            }
          }}>
          {pm.title?.length > 0 && <Text style={{marginTop: 10, marginBottom: 10, marginLeft: 5, color: 'gray'}}>{pm.title}</Text>}
          <FastImage
            style={{height: pm.picHeight ?? 100, backgroundColor: '#EEE'}}
            source={{uri: pm.pic}}
            onLoad={e => {
              if (!pm.picHeight) {
                pm.picHeight = ((AppDefine.width - 20) / e.nativeEvent.width) * e.nativeEvent.height ?? 100;
                this.setState({});
              }
            }}
          />
        </TouchableOpacity>
        <View style={{height: this.state.selectedIndex === idx ? pm.webViewHeight ?? 200 : 0}}>
          <WebView
            onNavigationStateChange={title => {
              if (!pm.webViewHeight && parseInt(title.title)) {
                pm.webViewHeight = parseInt(title.title);
                this.setState({});
              }
            }}
            style={{flex: 1}}
            source={{
              html:
                `<head>
                <meta name='viewport' content='initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no'>
                <style>img{width:auto !important;max-width:100%;height:auto !important}</style>
                <style>body{width:100%;word-break: break-all;word-wrap: break-word;vertical-align: middle;overflow: hidden;margin:0}</style>
              </head>` +
                `<script>
                window.onload = function () {
                  window.location.hash = 1;
                  document.title = document.body.scrollHeight;
                }
              </script>` +
                pm.content,
            }}
          />
        </View>
      </View>
    );

    if (this.style1 === '外边框') {
      return <Card containerStyle={{borderRadius: 8, padding: 3}}>{contentView}</Card>;
    }
    return contentView;
  }

  render() {
    if (!this.list.length) {
      return <Text style={{marginTop: 50, textAlign: 'center', color: 'gray'}}>暂无</Text>;
    }
    return <FlatList data={this.list} renderItem={data => this.renderCell(data.item, data.index)} keyExtractor={(pm, idx) => `key${idx}`} ListFooterComponent={<View style={{height: 100}} />} />;
  }
}
