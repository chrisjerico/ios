// 底部Tab按钮
export class UGTabbarItem {}

// 我的页功能按钮
export class UGUserCenterItem {}

// 六合发帖价格范围
export class LHPriceModel {}

export default class UGSysConfModel {
  static current: UGSysConfModel;

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
