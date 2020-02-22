import { Dimensions } from "react-native";
import { NativeEventEmitter, NativeModules } from "react-native";
import { StackNavigationProp } from "@react-navigation/stack";
import React from "react";

type RootStackParamList = {
  Home: undefined;
  Profile: { userId: string };
  Feed: { sort: "latest" | "top" } | undefined;
};

export type ProfileScreenNavigationProp = StackNavigationProp<RootStackParamList, "Profile">;

interface CallFuncType {
  class: string;
  selector: string;
  args: any | Array<CallFuncType>;
}

export default class AppDefine {
  static host = "http://test06.6yc.com"; // 接口域名
  static siteId = "test10";
  static pageCount = 20;
  static width = Dimensions.get("window").width;
  static height = Dimensions.get("window").height;
  static statusBarHeight = 34;
  static bottomSafeHeight = 44;

  static window = null;

  //
  static ocHelper = NativeModules.ReactNativeHelper; // oc助手
  static ocEvent = new NativeEventEmitter(AppDefine.ocHelper); // oc事件
  static navigationRef = React.createRef<ProfileScreenNavigationProp>();
  static navController: ProfileScreenNavigationProp;
  static tabController: ProfileScreenNavigationProp;
  static ocBlocks = {};

  static setup() {
    // 配置需要被替换的oc页面（替换成rn）
    AppDefine.ocHelper.performSelectors([
      {
        class: "AppDefine",
        selector: "shared.setRnPageInfos:",
        args: [
          [
            // {
            //   clsName: "UGPromoteDetailController",
            //   fd_prefersNavigationBarHidden: true,
            //   允许游客访问: true,
            //   允许未登录访问: true
            // }
          ]
        ]
      }
    ]);

    // 监听原生发过来的事件通知
    AppDefine.ocEvent.addListener("EventReminder", params => {
      console.log("rn收到oc通知：");
      console.log(params);
      AppDefine.ocBlocks[params._EventName](params.params);
    });

    // 跳转到指定页面
    AppDefine.ocEvent.addListener("SelectVC", params => {
      // 退到root
      AppDefine.navController?.canGoBack() && AppDefine.navController?.popToTop();
      // 再push
      AppDefine.navigationRef.current?.navigate(params.vcName);
    });

    // 移除页面
    AppDefine.ocEvent.addListener("RemoveVC", params => {
      
    });

    // 必须在注册监听之后执行
    AppDefine.ocHelper.launchFinish();
  }

  static ocCall(clsName: string, selector: string, args: Array<any | CallFuncType> = []): Promise<any> {
    return AppDefine.ocHelper.performSelectors([
      {
        class: clsName,
        selector: selector,
        args: args
      }
    ]);
  }
}
