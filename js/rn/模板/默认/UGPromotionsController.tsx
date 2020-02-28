import React, { Component, ComponentType } from "react";
import { View, FlatList, Image, TouchableOpacity } from "react-native";
import { createMaterialTopTabNavigator } from "@react-navigation/material-top-tabs";
import NetworkRequest1 from "../../网络/NetworkRequest1";
import { UGPromoteModel, UGPromoteListModel } from "../../Model/常规/UGPromoteModel";
import { array } from "prop-types";
import AppDefine from "../../通用/AppDefine";
import { NavigationContainer } from "@react-navigation/native";
import { Button, Text, Icon } from "react-native-elements";
import FastImage from "react-native-fast-image";

interface IProps {}
interface IState {
  dataArray: Array<{ category?: number; title: string; list: Array<UGPromoteModel> }>;
}

export default class UGPromotionsController extends Component<IProps, IState> {
  Tab = createMaterialTopTabNavigator();
  style: "slide" | "popup" | "page" = "page"; // slide折叠、popup弹窗、page内页
  showTabBar = false;

  constructor(props) {
    super(props);
    this.state = {
      dataArray: []
    };
  }
  componentDidMount() {
    NetworkRequest1.systeam_promotions().then(data => {
      console.log("分类优惠活动数据：");
      console.log(data);
      this.style = data.style;

      if (data.showCategory) {
        var temp: { [x: number]: Array<UGPromoteModel> } = [];
        data.list.map(pm => {
          var list = (temp[pm.category] = temp[pm.category] ?? []);
          list.push(pm);
        });
        var dataArray = [];
        for (var k in temp) {
          dataArray.push({ category: k, title: data.categories[k] ?? "其他", list: temp[k] });
        }
        this.showTabBar = dataArray.length > 1;
        this.setState({ dataArray: dataArray });
      } else {
        this.setState({ dataArray: [{ title: "热门", list: data.list }] });
      }
    });

    AppDefine.navController.setOptions({
      title: "优惠活动",
      headerStyle: { backgroundColor: AppDefine.themeColor },
      headerLeft: () => (
        <Button
          icon={{ name: "chevron-left", size: 32, color: "white" }}
          iconContainerStyle={{ marginLeft: -2 }}
          buttonStyle={{ backgroundColor: "transparent" }}
          onPress={() => {
            if (AppDefine.navController.canGoBack()) {
              AppDefine.navController.goBack();
            } else {
              AppDefine.ocCall("UGNavigationController.current.popViewControllerAnimated:", [true]);
            }
          }}
        />
      )
    });
  }

  renderCell(pm: UGPromoteModel) {
    return (
      <TouchableOpacity
        activeOpacity={0.9}
        style={{ margin: 10 }}
        onPress={() => {
          if (!pm.clsName) {
            pm.clsName = "UGPromoteModel";
          }

          switch (this.style) {
            case "page": {
              AppDefine.ocCall(({ vc }) => ({
                vc: {
                  selectors: "UGPromoteDetailController.new[setItem:]",
                  args1: [pm]
                },
                ret: {
                  selectors: "UGNavigationController.current.pushViewController:animated:",
                  args1: [vc, true]
                }
              }));
              break;
            }
            case "popup": {
              // AppDefine.ocCall("PromotePopView.alloc.initWithFrame:[setItem:].show", [{ ocType:'CGRet', x: 20, y: 120, w: AppDefine.width - 40, h: AppDefine.height * 0.85 }]);
              break;
            }
            case "slide": {
              break;
            }
          }
        }}
      >
        <Text style={{ marginTop: 0, marginLeft: 5, color: "gray" }}>{pm.title}</Text>
        <FastImage
          style={{ height: pm.picHeight ?? 100, backgroundColor: "#EEE" }}
          source={{ uri: pm.pic }}
          onLoad={e => {
            if (!pm.picHeight) {
              pm.picHeight = ((AppDefine.width - 20) / e.nativeEvent.width) * e.nativeEvent.height ?? 100;
              this.setState({});
            }
          }}
        />
      </TouchableOpacity>
    );
  }

  contentView({ route: { params } }) {
    var list: Array<UGPromoteModel> = Object.values(params);
    if (list.length) {
      return <FlatList data={list} renderItem={data => this.renderCell(data.item)} keyExtractor={(pm, idx) => `key${idx}`} ListFooterComponent={<View style={{ height: 100 }} />} />;
    }
    return <Text style={{ marginTop: 50, textAlign: "center", color: "gray" }}>暂无</Text>;
  }

  render() {
    if (this.state.dataArray.length == 0) {
      return null;
    }
    var contentViews = this.state.dataArray.map((plm, idx) => {
      return <this.Tab.Screen name={plm.title} component={this.contentView.bind(this)} initialParams={plm.list} key={idx} />;
    });
    return (
      <this.Tab.Navigator
        tabBarOptions={{
          style: { backgroundColor: "transparent", height: this.showTabBar ? 50 : 0 },
          labelStyle: { fontSize: 15 },
          tabStyle: { width: 60 },
          scrollEnabled: true,
          indicatorStyle: { marginBottom: 12, marginLeft: 10, height: 26, width: 42, borderRadius: 2, backgroundColor: AppDefine.themeColor },
          inactiveTintColor: "#555",
          activeTintColor: "white"
        }}
      >
        {contentViews}
      </this.Tab.Navigator>
    );
  }
}
