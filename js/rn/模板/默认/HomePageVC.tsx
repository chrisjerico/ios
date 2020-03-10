import React, { Component } from "react";
import { View, StyleSheet, Image, TouchableOpacity, FlatList } from "react-native";
import { Button, Text } from "react-native-elements";
import WebView from "react-native-webview";

import { LHPostCommentModel } from "../../Model/LHPostCommentModel";
import { LHPostModel } from "../../Model/LHPostModel";
import NetworkRequest1 from "../../公共类/网络/NetworkRequest1";
import AppDefine from "../../公共类/AppDefine";
import FastImage from "react-native-fast-image";

interface IProps {
  navigation: NavigationHelpersCommon;
}
interface IState {
  pm: LHPostModel;
  dataArray: Array<LHPostCommentModel>;
  imgSizeArray: Array<{ w: number; h: number }>;
  webViewHeight: number;
}

export default class HomePageVC extends Component<IProps, IState> {
  constructor(props: any) {
    super(props);
    this.state = {
      pm: {}, // 帖子详情
      dataArray: [], // 评论列表
      imgSizeArray: [],
      webViewHeight: 50
    };
  }

  componentDidMount() {
    
    console.log("this.props = ");
    console.log(this.props);

    // var nr = new NetworkRequest1();
    // nr.lhdoc_contentDetail("2").then((data: any) => {
    //   var { imgSizeArray = [] } = this.state;
    //   var pm = data.data;

    //   // 获取图片大小并刷新UI
    //   pm.contentPic.map((ele: string, idx: number) => {
    //     Image.getSize(
    //       ele,
    //       (w, h) => {
    //         imgSizeArray[idx] = { w, h };
    //         this.setState({
    //           imgSizeArray: imgSizeArray
    //         });
    //       },
    //       () => null
    //     );
    //   });

    //   // 刷新帖子UI
    //   this.setState({
    //     pm: pm
    //   });
    // });
    // nr.lhcdoc_contentReplyList("2").then((data: any) => {
    //   this.setState({
    //     dataArray: data.data.list
    //   });
    // });
  }

  // 评论Cell
  renderCommentCell(data: LHPostCommentModel): any {
    var { secReplyList = [] } = data;
    // console.log(secReplyList);
    return [
      <View style={{ flexDirection: "row" }}>
        <FastImage
          style={{ marginLeft: 10, marginTop: 15, marginRight: 10, height: 40, width: 40, backgroundColor: "#EEE" }}
          source={{
            uri: data.headImg
          }}
        />
        <View style={{ flex: 1 }}>
          <Text style={{ marginTop: 15, fontSize: 14, color: "#777" }}>{data.nickname}</Text>
          <Text style={{ marginTop: 8, fontSize: 12, color: "#AAA" }}>{data.actionTime}</Text>
          <Text style={{ marginTop: 6, fontSize: 14, color: "#555", lineHeight: 18 }}>{data.content}</Text>
          <Button title="回复" titleStyle={{ fontSize: 12, marginTop: -3, color: "#444" }} buttonStyle={{ backgroundColor: "#EEE" }} style={{ marginTop: 9, width: 60, height: 27 }} />
          {!secReplyList.length ? null : (
            <View style={{ marginTop: 8, backgroundColor: "#EEE", padding: 10 }}>
              {secReplyList.map((item, index) => {
                if (index == 3) {
                  return (
                    <Button
                      title="查看全部回复 >"
                      titleStyle={{ color: "#007AFF", fontSize: 14, marginLeft: -20, marginBottom: -10 }}
                      buttonStyle={{ backgroundColor: "transparent" }}
                      style={{ width: 120, height: 30 }}
                    />
                  );
                } else if (index > 3) {
                  return null;
                }
                var marginTop = index == 0 ? 0 : 6;
                return (
                  <View style={{ flexDirection: "row", marginTop: marginTop }}>
                    <FastImage
                      style={{ height: 25, width: 25, backgroundColor: "#EEE" }}
                      source={{
                        uri: item.headImg
                      }}
                    />
                    <Text style={{ color: "#007AFF", marginTop: 4, marginLeft: 4 }}>{item.nickname}</Text>
                    <Text style={{ color: "#555", marginTop: 3, marginLeft: 6, flex: 1 }}>{item.content}</Text>
                  </View>
                );
              })}
            </View>
          )}
        </View>
      </View>,
      <View style={{ height: 0.5, backgroundColor: "#DDD", marginTop: 12 }} />
    ];
  }

  // TableViewHeader
  renderTableViewHeader(pm: LHPostModel) {
    var { contentPic = [] } = pm;
    var w = AppDefine.width - 40;
    var { imgSizeArray } = this.state;
    // var {webViewHeight}

    return (
      <View>
        <View style={{ marginLeft: 20, marginRight: 20 }}>
          {/* 报码器 */}
          {/* 顶部广告 */
          pm.topAdWap && (
            <TouchableOpacity>
              <FastImage style={{ height: 100, backgroundColor: "#EEE" }} source={{ uri: pm.topAdWap.pic }} />
            </TouchableOpacity>
          )}

          {/* 标题 */}
          <View style={{ marginTop: 20, alignItems: "center" }}>
            <Text style={{ fontSize: 21, fontWeight: "bold" }}>{pm.title}</Text>
          </View>
          {/* 内容WebView */}
          <View style={{ height: this.state.webViewHeight, marginTop: 15 }}>
            <WebView
              onNavigationStateChange={title => {
                this.setState({
                  webViewHeight: parseInt(title.title) || 50
                });
              }}
              style={{ flex: 1 }}
              source={{
                html:
                  `<head>
                    <meta name='viewport' content='initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no'>
                    <style>img{width:auto !important;max-width:100%;height:auto !important}</style>
                    <style>body{width:100%;word-break: break-all;word-wrap: break-word;vertical-align: middle;overflow: hidden;}</style>
                  </head>` +
                  `<script>
                    window.onload = function () {
                      window.location.hash = 1;
                      document.title = document.body.scrollHeight;
                    }
                  </script>` +
                  pm.content
              }}
            />
          </View>
          {/* 图片 */
          contentPic &&
            contentPic.map((ele, idx) => {
              var h = 150;
              if (imgSizeArray[idx]) {
                var h = (w / imgSizeArray[idx].w) * imgSizeArray[idx].h;
              }
              return <FastImage style={{ height: h, backgroundColor: "#EEE", marginBottom: 10 }} source={{ uri: ele }} />;
            })}

          {/* 备用网址 */}
          <Text style={{ marginTop: 15 }}>本站备用网址一:www.889777.com</Text>
          <Text style={{ marginTop: 15 }}>本站备用网址二:www.889777.com</Text>
          {/* 投票 */}

          {/* 底部广告 */
          pm.bottomAdWap && (
            <TouchableOpacity>
              <FastImage style={{ height: 100, backgroundColor: "#EEE" }} source={{ uri: pm.bottomAdWap.pic }} />
            </TouchableOpacity>
          )}
          {/* 全部评论 */}
          <View style={{ marginTop: 40, marginBottom: 10 }}>
            <Text style={{ fontSize: 17, fontWeight: "700" }}>全部评论</Text>
            <View style={{ height: 2, marginTop: 13, width: 69, backgroundColor: "black" }} />
          </View>
        </View>
      </View>
    );
  }

  // 主UI
  render() {
    return (
      <View>
        {/* 顶部作者信息 */}
        <View style={styles.作者信息View}>
          <FastImage style={styles.作者头像} source={{ uri: this.state.pm.headImg }} />
          <View style={{ flex: 1 }}>
            <Text numberOfLines={1} style={{ marginLeft: 10, top: 9 }}>
              {this.state.pm.nickname}
            </Text>
            <Text numberOfLines={1} style={{ marginLeft: 10, top: 20, marginRight: 10 }}>
              楼主 {this.state.pm.createTime}
            </Text>
          </View>
          <TouchableOpacity onPress={() => null}>
            <FastImage style={{ height: 50, width: 50, marginTop: 8, marginRight: 10 }} source={{ uri: "https://i.ibb.co/JdsQGpn/redBag.png" }} />
          </TouchableOpacity>
          <Button title="关注楼主" buttonStyle={styles.关注按钮} titleStyle={{ fontSize: 15 }} />
        </View>
        <View style={{ height: 0.5, backgroundColor: "gray" }} />
        <FlatList
          renderItem={data => this.renderCommentCell(data.item)}
          data={this.state.dataArray}
          ListHeaderComponent={this.renderTableViewHeader(this.state.pm)}
          ListFooterComponent={this.state.dataArray.length ? <View style={{ height: 150 }} /> : <Text style={{ textAlign: "center", color: "#777", marginTop: 30 }}>暂无评论</Text>}
        />
      </View>
    );
  }
}

const styles = StyleSheet.create({
  // 顶部作者信息
  作者信息View: {
    margin: 15,
    height: 60,
    // flex: 1,
    // backgroundColor: "gray",
    flexDirection: "row"
  },
  作者头像: {
    // flex: 1,
    width: 60,
    height: 60,
    borderRadius: 30
  },
  关注按钮: {
    marginLeft: 5,
    top: 13.5,
    width: 75,
    height: 33,
    borderRadius: 4
  }
});
