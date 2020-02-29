import React, { Component } from "react";
import { View, FlatList } from "react-native";
import { createMaterialTopTabNavigator } from "@react-navigation/material-top-tabs";
import NetworkRequest1 from "../../网络/NetworkRequest1";
import { UGPromoteModel } from "../../Model/常规/UGPromoteModel";
import AppDefine from "../../通用/AppDefine";
import { Button, Text } from "react-native-elements";
import PromoteTableView from "./View/PromoteTableView";

interface IProps {}
interface IState {
  dataArray: Array<{ category?: number; title: string; list: Array<UGPromoteModel> }>;
}

export default class UGPromotionsController extends Component<IProps, IState> {
  Tab = createMaterialTopTabNavigator();
  style: "slide" | "popup" | "page" = "page"; // slide折叠、popup弹窗、page内页
  showTopBar = false;

  constructor(props) {
    super(props);
    this.state = {
      dataArray: []
    };
  }
  componentDidMount() {
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

    NetworkRequest1.systeam_promotions().then(data => {
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
        this.showTopBar = dataArray.length > 1;
        this.setState({ dataArray: dataArray });
      } else {
        this.setState({ dataArray: [{ title: "热门", list: data.list }] });
      }
    });
  }

  contentView({ route: { params } }) {
    var list: Array<UGPromoteModel> = Object.values(params);
    if (list.length) {
      return <FlatList data={list} renderItem={data => this.renderCell(data.item, data.index)} keyExtractor={(pm, idx) => `key${idx}`} ListFooterComponent={<View style={{ height: 100 }} />} />;
    }
    return <Text style={{ marginTop: 50, textAlign: "center", color: "gray" }}>暂无</Text>;
  }

  render() {
    if (this.state.dataArray.length == 0) {
      return null;
    }
    var contentViews = this.state.dataArray.map((plm, idx) => {
      return <this.Tab.Screen name={plm.title} component={PromoteTableView} initialParams={{ list: plm.list, style: this.style }} key={idx} />;
    });
    return (
      <this.Tab.Navigator
        tabBarOptions={{
          style: { backgroundColor: "transparent", height: this.showTopBar ? 50 : 0 },
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
