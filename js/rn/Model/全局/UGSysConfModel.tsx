import AppDefine from '../../公共类/AppDefine';
import {func} from 'prop-types';
import useFloatingHeaderHeight from '@react-navigation/stack/lib/typescript/src/utils/useHeaderHeight';
import NetworkRequest1 from '../../公共类/网络/NetworkRequest1';
import {Alert, AlertButton} from 'react-native';
import {color, diffClamp} from 'react-native-reanimated';

// 代理申请信息
export interface UGAgentApplyInfo {
  username: string; // 用户名
  qq: string; // qq
  mobile: string; // 手机号
  applyReason: string; // 申请理由
  reviewResult: string; // 拒绝的理由
  reviewStatus: number; // 0 未提交  1 待审核  2 审核通过 3 审核拒绝
  isAgent: boolean; // 是否是代理  true 是   false 否
}

// 底部Tab按钮
export class UGTabbarItem {}

export enum UGUserCenterType {
  存款 = 1,
  取款 = 2,
  银行卡管理 = 3,
  利息宝 = 4,
  推荐收益 = 5,
  彩票注单记录 = 6,
  其他注单记录 = 7,
  额度转换 = 8,
  站内信 = 9,
  安全中心 = 10,
  任务中心 = 11,
  个人信息 = 12,
  建议反馈 = 13,
  在线客服 = 14,
  活动彩金 = 15,
  长龙助手 = 16,
  全民竞猜 = 17,
  开奖走势 = 18,
  QQ客服 = 19,
}

// 我的页功能按钮
export class UGUserCenterItem {
  code: UGUserCenterType;
  logo?: string;
  name?: string;

  // 默认图标
  static defaultLogos: {[x: number]: string} = {
    1: 'https://i.ibb.co/hghhbCs/chongzhi-2x.png', // 存款
    2: 'https://i.ibb.co/4drXB18/tixian-2x.png', // 取款
    3: 'https://i.ibb.co/VVPPpRM/yinhangqia-2x.png', // 银行卡管理
    4: 'https://i.ibb.co/Hr4pGTZ/lixibao.png', // 利息宝
    5: 'https://i.ibb.co/PTCdZwH/shouyisel.png', // 推荐收益
    6: 'https://i.ibb.co/vYzZYx5/zdgl-2x.png', // 彩票注单记录
    7: 'https://i.ibb.co/vYzZYx5/zdgl-2x.png', // 其他注单记录
    8: 'https://i.ibb.co/DW9vdz6/change-2x.png', // 额度转换
    9: 'https://i.ibb.co/ZM0rtZ1/zhanneixin-2x.png', // 站内信
    10: 'https://i.ibb.co/CQY7GdL/ziyuan-2x.png', // 安全中心
    11: 'https://i.ibb.co/Km10DqM/renwuzhongxin.png', // 任务中心
    12: 'https://i.ibb.co/DwjwGJ2/gerenzhongxinxuanzhong.png', // 个人信息
    13: 'https://i.ibb.co/sQwhYtB/yijian.png', // 建议反馈
    14: 'https://i.ibb.co/T0VMxJV/zaixiankefu-2x.png', // 在线客服
    15: 'https://i.ibb.co/vYzZYx5/zdgl-2x.png', // 活动彩金
    16: 'https://i.ibb.co/0ZjBxJY/changlong-2x.png', // 长龙助手
    17: 'https://i.ibb.co/dJTkm3j/menu-activity.png', // 全民竞猜
    18: 'https://i.ibb.co/PWHWTB2/kj-trend.png', // 开奖走势
    19: 'https://i.ibb.co/7t3Cb6S/usr-Center-qq.png', // QQ客服
  };

  constructor(props: UGUserCenterItem) {
    Object.assign(this, props);
    // 设置默认图标
    if (this.logo?.indexOf('http') == -1) {
      this.logo = UGUserCenterItem.defaultLogos[props.code];
    }
  }

  static pushViewController(code: UGUserCenterType) {
    switch (code) {
      case UGUserCenterType.存款: {
        AppDefine.ocCall('UGNavigationController.current.pushViewController:animated:', [{selectors: 'UGFundsViewController.new[setSelectIndex:]', args1: [0]}, true]);
        break;
      }
      case UGUserCenterType.取款: {
        AppDefine.ocCall('UGNavigationController.current.pushViewController:animated:', [{selectors: 'UGFundsViewController.new[setSelectIndex:]', args1: [1]}, true]);
        break;
      }
      case UGUserCenterType.银行卡管理: {
        async function func1() {
          let hasBankCard: boolean = await AppDefine.ocCall('UGUserModel.currentUser.hasBankCard');
          let hasFundPwd: boolean = await AppDefine.ocCall('UGUserModel.currentUser.hasFundPwd');
          var vcName = hasBankCard ? 'UGBankCardInfoController' : hasFundPwd ? 'UGBindCardViewController' : 'UGSetupPayPwdController';
          AppDefine.ocCall('UGNavigationController.current.pushViewController:animated:', [{selectors: 'AppDefine.viewControllerWithStoryboardID:', args1: [vcName]}, true]);
        }
        func1();
        break;
      }
      case UGUserCenterType.利息宝: {
        AppDefine.ocCall('UGNavigationController.current.pushViewController:animated:', [{selectors: 'AppDefine.viewControllerWithStoryboardID:', args1: ['UGYubaoViewController']}, true]);
        break;
      }
      case UGUserCenterType.推荐收益: {
        async function func1() {
          let isTest: boolean = await AppDefine.ocCall('UGUserModel.currentUser.isTest');
          if (isTest) {
            // 试玩账号去阉割版的推荐收益页
            AppDefine.ocCall('UGNavigationController.current.pushViewController:animated:', [{selectors: 'UGPromotionIncomeController.new'}, true]);
          } else {
            // ShowLoading
            AppDefine.ocCall('SVProgressHUD.showWithStatus:');

            var info: UGAgentApplyInfo = await NetworkRequest1.team_agentApplyInfo();
            if (info.reviewStatus === 2) {
              // 去推荐收益页
              AppDefine.ocCall('UGNavigationController.current.pushViewController:animated:', [{selectors: 'UGPromotionIncomeController.new'}, true]);
            } else {
              let agent_m_apply = await AppDefine.ocCall('UGSystemConfigModel.currentConfig.agent_m_apply');
              if (parseInt(agent_m_apply) === 1) {
                AppDefine.ocCall('HUDHelper.showMsg:', ['在线注册代理已关闭']);
              } else {
                // 去申请代理
                info = Object.assign({clsName: 'UGagentApplyInfo'}, info);
                AppDefine.ocCall('UGNavigationController.current.pushViewController:animated:', [{selectors: 'UGAgentViewController.new[setItem:]', args1: []}, true]);
              }
            }
            // HideLoading
            AppDefine.ocCall('SVProgressHUD.dismiss');
          }
        }
        func1();
        break;
      }
      case UGUserCenterType.彩票注单记录: {
        AppDefine.ocCall('UGNavigationController.current.pushViewController:animated:', [{selectors: 'UGBetRecordViewController.new'}, true]);
        break;
      }
      case UGUserCenterType.其他注单记录: {
        AppDefine.ocCall('UGNavigationController.current.pushViewController:animated:', [
          {selectors: 'AppDefine.viewControllerWithStoryboardID:[setGameType:]', args1: ['UGRealBetRecordViewController', 'real']},
          true,
        ]);
        break;
      }
      case UGUserCenterType.额度转换: {
        AppDefine.ocCall('UGNavigationController.current.pushViewController:animated:', [{selectors: 'AppDefine.viewControllerWithStoryboardID:', args1: ['UGBalanceConversionController']}, true]);
        break;
      }
      case UGUserCenterType.站内信: {
        AppDefine.ocCall('UGNavigationController.current.pushViewController:animated:', [{selectors: 'UGMailBoxTableViewController.new'}, true]);
        break;
      }
      case UGUserCenterType.安全中心: {
        AppDefine.ocCall('UGNavigationController.current.pushViewController:animated:', [{selectors: 'UGSecurityCenterViewController.new'}, true]);
        break;
      }
      case UGUserCenterType.任务中心: {
        AppDefine.ocCall('UGNavigationController.current.pushViewController:animated:', [{selectors: 'AppDefine.viewControllerWithStoryboardID:', args1: ['UGMissionCenterViewController']}, true]);
        break;
      }
      case UGUserCenterType.个人信息: {
        AppDefine.ocCall('UGNavigationController.current.pushViewController:animated:', [{selectors: 'AppDefine.viewControllerWithStoryboardID:', args1: ['UGUserInfoViewController']}, true]);
        break;
      }
      case UGUserCenterType.建议反馈: {
        AppDefine.ocCall('UGNavigationController.current.pushViewController:animated:', [{selectors: 'AppDefine.viewControllerWithStoryboardID:', args1: ['UGFeedBackController']}, true]);
        break;
      }
      case UGUserCenterType.在线客服: {
        async function func1() {
          let urlStr: string = await AppDefine.ocCall('UGSystemConfigModel.currentConfig.zxkfUrl.stringByTrim');
          if (!urlStr.length) return;
          let hasHost = await AppDefine.ocCall('NSURL.URLWithString:.host.length', [urlStr]);
          let hasScheme = await AppDefine.ocCall('NSURL.URLWithString:.scheme.length', [urlStr]);
          // 补全URL
          if (!hasHost) {
            urlStr = AppDefine.host + urlStr;
          } else if (!hasScheme) {
            urlStr = 'http://' + urlStr;
          }
          AppDefine.ocCall('UGNavigationController.current.pushViewController:animated:', [{selectors: 'SLWebViewController.new[setUrlStr:]', args1: [urlStr]}, true]);
        }
        func1();
        break;
      }
      case UGUserCenterType.活动彩金: {
        AppDefine.ocCall('UGNavigationController.current.pushViewController:animated:', [{selectors: 'UGMosaicGoldViewController.new'}, true]);
        break;
      }
      case UGUserCenterType.长龙助手: {
        AppDefine.ocCall('UGNavigationController.current.pushViewController:animated:', [{selectors: 'UGChangLongController.new'}, true]);
        break;
      }
      case UGUserCenterType.全民竞猜: {
        AppDefine.ocCall('HUDHelper.showMsg:', ['敬请期待']);
        break;
      }
      case UGUserCenterType.开奖走势: {
        AppDefine.ocCall('HUDHelper.showMsg:', ['敬请期待']);
        break;
      }
      case UGUserCenterType.QQ客服: {
        AppDefine.ocCall('UGSystemConfigModel.currentConfig.qqs').then((qqs: Array<string> = []) => {
          if (!qqs.length) {
            AppDefine.ocCall('HUDHelper.showMsg:', ['敬请期待']);
          } else {
            var btns: Array<AlertButton> = qqs.map(
              (qq: string, idx: number): AlertButton => {
                return {
                  text: `QQ客服${idx + 1}：${parseInt(qq)}`,
                  onPress: () => {
                    AppDefine.ocCall('CMCommon.goQQ:', [qq]);
                  },
                };
              },
            );
            btns.push({text: '取消', style: 'cancel'});
            Alert.alert('请选择QQ客服', null, btns);
          }
        });
        break;
      }
    }
  }

  pushViewController?() {
    UGUserCenterItem.pushViewController(this.code);
  }
}

// 六合发帖价格范围
export class LHPriceModel {}

// 系统配置Model
export default class UGSysConfModel {
  static current: UGSysConfModel = new UGSysConfModel();

  zxkfUrl2: string; // 在线客服2
  zxkfUrl: string; // 在线客服
  minWithdrawMoney: string; // 最低提款金额
  maxWithdrawMoney: string; // 最高提款金额
  closeregreason: string; // 关闭注册功能提示内容
  missionName: string; // 哇咔豆
  missionBili: string;
  isIntToMoney: string; // 积分开关0=关闭；1=开启；
  missionSwitch: string; // 1=关闭；0=开启；任务中心
  myreco_img: string; // 1=关闭；0=开启；
  checkinSwitch: string; // 0=关闭；1=开启签到开关
  mkCheckinSwitch: string; // 0=开启；1=关闭 补签开关：
  agent_m_apply: string; // 允许会员中心申请代理
  mobile_logo: string; // 首页navBar 图片
  agentRegbutton: string; // 0=关闭；1=开启；  手机端注册页面显示“代理注册”
  oftenLoginArea: string; // 1=关闭；0=开启； 常用登录地
  mobileTemplateBackground: string; // 配色方案
  mobileTemplateCategory: string; // 模板号      9 简约
  mobileTemplateLhcStyle: string; // 六合配色方案
  mobileTemplateStyle: string; // 新年红 简约 配色方案
  webName: string; // 首页底部文字   网址名称*/;
  serviceQQ1: string; // QQ客服q1
  serviceQQ2: string; // QQ客服q2
  appPopupWechatNum: string; // 微信客服号
  appPopupWechatImg: string; // 微信客服二维码
  appPopupQqNum: string; // QQ客服号
  appPopupQqImg: string; // 微信客服二维码
  domainBindAgentId: string; // 如果这个属性大于0，则在注册邀请人输入框填入改ID，且无法更改
  homeTypeSelect: string; // 是否开启前台分类
  chatRoomName: string; // 聊天室名称
  chatMinFollowAmount: string; // 聊天室跟注最小金额*/
  easyRememberDomain: string; // 黑色模板易记的网址*/
  chatLink: string; // 聊天的链接*/

  hide_reco: number; // 代理人
  reg_name: number; // 真实姓名
  reg_fundpwd: number; // 取款密码
  reg_qq: number; // QQ
  reg_wx: number; // 微信
  reg_phone: number; // 手机
  reg_email: number; // 邮箱
  reg_vcode: number; // 0无验证码，1图形验证码 3点击显示图形验证码 2滑块验证码
  pass_limit: number; // 注册密码强度，0、不限制；1、数字字母；2、数字字母符合
  pass_length_min: number; // 注册密码最小长度
  pass_length_max: number; // 注册密码最大长度
  rankingListSwitch: number; // 是否显示中奖/投注排行榜

  googleVerifier: boolean; // 是否开启google 验证
  recharge: boolean; // 上级充值开关
  smsVerify: boolean; // 手机短信验证
  allowreg: boolean; // 是否开启注册功能。
  allowMemberCancelBet: boolean; // 是否允许会员撤单，1允许 0不允许
  m_promote_pos: boolean; // 优惠活动显示在首页还是内页，1首页，0内页
  yuebaoSwitch: boolean; // 未登录时是否允许访问利息宝
  chatFollowSwitch: boolean; // 是否允许聊天室跟注
  switchAgentRecharge: boolean; // 给下级会员充值开关

  lhcdocMiCard: boolean; // 六合彩开奖咪牌(默认状态)开关
  lhcdocLotteryStr: string; // 六合彩预备开奖文字
  lhcPriceList: Array<LHPriceModel>; // 六合发帖价格范围

  mobileMenu: Array<UGTabbarItem>; // 底部Tab按钮
  userCenter: Array<UGUserCenterItem>; // 我的页功能按钮
}

export var SysConf1 = UGSysConfModel.current;
