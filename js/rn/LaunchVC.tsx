import { NavigationContainer } from "@react-navigation/native";
import { createStackNavigator } from "@react-navigation/stack";
import AppDefine from "./通用/AppDefine";

// 页面
import UpdateVersionVC from "./UpdateVersionVC";
import HomePageVC from "./模板/默认/HomePageVC";

// UI控件
import React, { Component } from "react";
import { AppRegistry, View, Text } from "react-native";
import { Button } from "react-native-elements";

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

class Root extends Component {
  render() {
    return (
      <NavigationContainer>
        <Stack.Navigator initialRouteName="UpdateVersionVC" headerMode="screen" screenOptions={{ headerTintColor: "white", headerStyle: { backgroundColor: "tomato" } }}>
          <Stack.Screen name="Home3" component={HomePageVC} options={{ animationEnabled: false, headerStyle: { height: 80, backgroundColor: "green" } }} />
          <Stack.Screen name="Home2" component={Home2} options={{ animationEnabled: false }} />
          <Stack.Screen name="UGPromoteDetailController" component={HomeScreen} options={{ animationEnabled: false }} />
          <Stack.Screen name="UpdateVersionVC" component={UpdateVersionVC} options={{ animationEnabled: false, header: () => null }} />
        </Stack.Navigator>
      </NavigationContainer>
    );
  }
}


// 注册组件到原生APP（ReactNativeVC）
AppRegistry.registerComponent("Main", () => Root);

// 初始化 AppDefine
AppDefine.setup();
