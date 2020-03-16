import {Dimensions} from 'react-native';
import {NativeEventEmitter, NativeModules} from 'react-native';
import {StackNavigationProp} from '@react-navigation/stack';
import React from 'react';
import objectPath from 'object-path';

type RootStackParamList = {
  Home: undefined;
  Profile: {userId: string};
  Feed: {sort: 'latest' | 'top'} | undefined;
};

export type ProfileScreenNavigationProp = StackNavigationProp<RootStackParamList, 'Profile'>;

class OCFuncVariable {
  vc: string = '';
  ret: string = '';

  static init(): OCFuncVariable {
    var obj: any = {};
    for (var key in new OCFuncVariable()) {
      obj[key] = `OCFuncVariable.${key}`;
    }
    return obj;
  }
}

interface OCFuncModel {
  obj?: string;
  selectors: string;
  args1?: Array<any | OCFuncModel>;
  args2?: Array<any | OCFuncModel>;
  args3?: Array<any | OCFuncModel>;
  args4?: Array<any | OCFuncModel>;
  args5?: Array<any | OCFuncModel>;
}

interface RnPageModel {
  // 替换oc页面
  vcName: string; // oc页面类名
  rnName: string; // rn页面类名
  fd_prefersNavigationBarHidden?: boolean; // 是否隐藏导航条
  允许游客访问?: boolean;
  允许未登录访问?: boolean;

  // 新增彩种
  gameType?: string; // 彩种类型

  // 新增我的页Item跳转
  userCenterItemCode?: number; // 页面标识
  userCenterItemIcon?: string; // 默认图标URL
  userCenterItemTitle?: string; // 默认标题

  // 新增TabbarItem跳转
  tabbarItemPath?: string; // 页面标识
  tabbarItemIcon?: string; // 默认图标URL
  tabbarItemTitle?: string; // 默认标题

  // 新增linkCategory跳转
  linkCategory?: number; // linkCategory ： 1=彩票游戏；2=真人视讯；3=捕鱼游戏；4=电子游戏；5=棋牌游戏；6=体育赛事；7=导航链接；8=电竞游戏；9=聊天室；10=手机资料栏目
  linkPosition?: number;
}

export default class AppDefine {
  static host = 'http://接口域名'; // 接口域名
  static siteId = '未知站点';
  static pageCount = 20;
  static width = Dimensions.get('window').width;
  static height = Dimensions.get('window').height;
  static statusBarHeight = 34;
  static bottomSafeHeight = 44;
  static isFish: boolean = false;

  //
  static ocHelper = NativeModules.ReactNativeHelper; // oc助手
  static ocEvent = new NativeEventEmitter(AppDefine.ocHelper); // oc事件
  static navigationRef = React.createRef<ProfileScreenNavigationProp>();
  static navController: ProfileScreenNavigationProp;
  static tabController: ProfileScreenNavigationProp;
  static ocBlocks = {};

  static setRnPageInfo() {
    // 配置需要被替换的oc页面（替换成rn）
    var pages: Array<RnPageModel> = [];

    // 优惠活动列表页
    pages.push({
      vcName: 'UGPromotionsController',
      rnName: 'UGPromotionsController',
      fd_prefersNavigationBarHidden: true,
      允许游客访问: true,
      允许未登录访问: true,
    });

    AppDefine.ocCall('AppDefine.shared.setRnPageInfos:', [pages]);
  }

  static setup() {
    // 监听原生发过来的事件通知
    AppDefine.ocEvent.addListener('EventReminder', (params: {_EventName: string; params: any}) => {
      console.log('rn收到oc通知：');
      console.log(params);
      var block = AppDefine.ocBlocks[params._EventName];
      if (typeof block == 'function') {
        block(params.params);
      }
    });

    // 跳转到指定页面
    AppDefine.ocEvent.addListener('SelectVC', (params: {vcName: string}) => {
      console.log('跳转到rn页面：');
      console.log(params.vcName);
      if (params.vcName) {
        // 退到root
        AppDefine.navController?.canGoBack() && AppDefine.navController?.popToTop();
        // 再push
        AppDefine.tabController?.navigate(params.vcName);
        AppDefine.navigationRef?.current?.navigate(params.vcName);
      }
    });

    // 移除页面
    AppDefine.ocEvent.addListener('RemoveVC', params => {});

    // 设置接口域名
    AppDefine.ocCall('AppDefine.shared.Host').then((host: string) => {
      AppDefine.host = host;
    });

    // 设置站点编号
    AppDefine.ocCall('AppDefine.shared.SiteId').then((siteId: string) => {
      AppDefine.siteId = siteId;
    });

    // isFish
    AppDefine.ocCall('AppDefine.shared.isFish').then((isFish: boolean) => {
      AppDefine.isFish = isFish;
      // 配置需要被替换的oc页面（替换成rn）
      AppDefine.setRnPageInfo();
    });

    // 必须在注册监听之后执行
    // AppDefine.ocHelper.launchFinish();
  }

  static ocCall(
    selectors: string | ((vars: OCFuncVariable) => {[x: string]: OCFuncModel}),
    args1: Array<any | OCFuncModel> = [],
    args2: Array<any | OCFuncModel> = [],
    args3: Array<any | OCFuncModel> = [],
  ): Promise<any> {
    var array = [];
    var temp: {[x: string]: OCFuncModel};
    if (typeof selectors === 'function') {
      temp = selectors(OCFuncVariable.init());
    } else {
      var sel: OCFuncModel = {selectors: selectors};
      args1.length && (sel['args1'] = args1);
      args2.length && (sel['args2'] = args2);
      args3.length && (sel['args3'] = args3);
      temp = {ret: sel};
    }
    for (let [key, value] of Object.entries(temp)) {
      var obj = {};
      obj[key] = value;
      array.push(obj);
    }
    return AppDefine.ocHelper.performSelectors(array);
  }
}

// OC结构体
export class NSValue {
  valueType: string;
  string: string;

  constructor(valueType: 'CGRect' | 'CGPoint' | 'CGSize' | 'UIEdgeInsets' | 'UIOffset' | 'CGAffineTransform' | 'CGVector', string: string) {
    this.valueType = valueType;
    this.string = string;
  }

  static CGRectMake(x: number, y: number, w: number, h: number): NSValue {
    return new NSValue('CGRect', `{{${x}, ${y}}, {${w}, ${h}}}`);
  }

  static CGPointMake(x: number, y: number): NSValue {
    return new NSValue('CGPoint', `{{${x}, ${y}}}`);
  }

  static CGSizeMake(w: number, h: number): NSValue {
    return new NSValue('CGSize', `{{${w}, ${h}}}`);
  }

  static UIEdgeInsetsMake(top: number, left: number, bottom: number, right: number): NSValue {
    return new NSValue('UIEdgeInsets', `{${top}, ${left}, ${bottom}, ${right}}`);
  }

  static UIOffsetMake(horizontal: number, vertical: number): NSValue {
    return new NSValue('UIOffset', `{${horizontal}, ${vertical}}`);
  }

  static CGAffineTransformMake(a: number, b: number, c: number, d: number, tx: number, ty: number): NSValue {
    return new NSValue('CGAffineTransform', `[${a}, ${b}, ${c}, ${d}, ${tx}, ${ty}]`);
  }

  static CGVectorMake(dx: number, dy: number): NSValue {
    return new NSValue('CGVector', `{${dx}, ${dy}}`);
  }
}
