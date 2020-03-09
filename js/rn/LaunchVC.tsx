import { NavigationContainer } from "@react-navigation/native";
import { createStackNavigator } from "@react-navigation/stack";
import { createBottomTabNavigator } from "@react-navigation/bottom-tabs";
import AppDefine, { ProfileScreenNavigationProp } from "./公共类/AppDefine";

// 页面
import UpdateVersionVC from "./UpdateVersionVC";
import HomePageVC from "./模板/默认/HomePageVC";

// UI控件
import React, { Component } from "react";
import { AppRegistry, View, Text } from "react-native";
import { Button } from "react-native-elements";
import UGSysConfModel from "./Model/UGSysConfModel";
import UGPromotionsController from "./模板/默认/UGPromotionsController";
import MGJMyVC from "./模板/玫瑰金/MGJMyVC";
import UGSkinManagers, { Skin1 } from "./公共类/UGSkinManagers";

class Home2 extends Component {
  render() {
    return (
      <View style={{ flex: 1, alignItems: "center", justifyContent: "center" }}>
        <Button
          style={{ backgroundColor: "balck", height: 100, width: 100 }}
          title="3333"
          onPress={() => {
            const { navigation } = this.props;
            console.log(navigation);
            console.log("点击了按钮");
            navigation.navigate("Home3");
          }}
        />
        <Text>Home 2</Text>
      </View>
    );
  }
}

function HomeScreen() {
  return (
    <View style={{ flex: 1, alignItems: "center", justifyContent: "center" }}>
      <Text>Home Screen</Text>
    </View>
  );
}

const Stack = createStackNavigator();
const Tab = createBottomTabNavigator();

interface IProps {
  navigation?: ProfileScreenNavigationProp;
}
// TabbarController
class TabBarController extends Component<IProps> {
  constructor(props) {
    super(props);
    var { navigation } = this.props;
    AppDefine.navController = navigation;
  }

  render() {
    var { navigation } = this.props;
    AppDefine.navController = navigation;

    return (
      <Tab.Navigator initialRouteName="UpdateVersionVC" screenOptions={{ tabBarVisible: false }}>
        <Tab.Screen name="Home3" component={HomePageVC} options={{}} />
        <Tab.Screen name="MGJMyVC" component={MGJMyVC} options={{}} />
        <Tab.Screen name="UGPromotionsController" component={UGPromotionsController} options={{}} />
        <Tab.Screen name="UpdateVersionVC" component={UpdateVersionVC} options={{}} />
      </Tab.Navigator>
    );
  }
}

// NavController
class Root extends Component {
  render() {
    return (
      <NavigationContainer ref={AppDefine.navigationRef}>
        <Stack.Navigator headerMode="screen">
          <Stack.Screen name="Tabbar" component={TabBarController} options={{ headerStyle: { backgroundColor: "#48A9D8" }, headerTintColor: "white" }} />
        </Stack.Navigator>
      </NavigationContainer>
    );
  }
}

// 注册组件到原生APP（ReactNativeVC）
AppRegistry.registerComponent("Main", () => Root);

// 初始化 AppDefine
AppDefine.setup();

// 获得系统配置信息
AppDefine.ocBlocks["UGSystemConfigModel.currentConfig"] = (sysConf: UGSysConfModel) => {
  if (sysConf) {
    // 设置当前配置
    Object.assign(UGSysConfModel.current, sysConf);
    // 配置替换rn的页面
    AppDefine.setRnPageInfo();
    // 设置皮肤
    Object.assign(Skin1, UGSkinManagers.sysConf());
  }
};
