export class UGLoginModel {

}

export default class UGUserModel extends UGLoginModel {
  static mine = new UGUserModel();

  uid: string; // 用户ID
  avatar: string; // 头像
  balance: string; // 余额
  usr: string; // 昵称
  fullName: string; // 全名
  chatRoomNickname: string; // 聊天室昵称
  email: string; // email
  phone: string; // 手机号
  qq: string; // QQ号
  wx: string; // 微信号
  clientIp: string; // 用户当前的ip地址
  isLhcdocVip: string; // 是否是六合文档的VIP "1"
  curLevelInt: string; // 当级经验值 "100000"
  curLevelGrade: string; // 等级 "VIP4"
  curLevelTitle: string; // 头衔 "黄金"
  nextLevelInt: string; // 下级经验值 "100000"
  nextLevelGrade: string; // 等级 "VIP5"
  nextLevelTitle: string; // 头衔 "铂金"
  taskReward: string; // 成长值 "19073.0000"
  taskRewardTotal: string; // 总成长值 "20498.5000"
  taskRewardTitle: string; // 成长标题 "阿西"
  todayWinAmount: string; // 今日输赢金额 "0.00"
  unsettleAmount: string; // 未结金额 "10.00"

  playedRealGames: Array<string>; // 玩过的真人游戏

  allowMemberCancelBet: boolean; // 是否允许会员撤单
  chatRoomSwitch: boolean; // 是否是开启聊天室
  hasActLottery: boolean; // 是否显示活动彩金
  hasBankCard: boolean; // 是否已绑定银行卡
  hasFundPwd: boolean; // 是否已设置取款密码
  isAgent: boolean; // 是否是代理
  googleVerifier: boolean; // 是否开启google验证
  isBindGoogleVerifier: boolean; // 判断会员是否绑定谷歌验证码
  isTest: boolean; // 是否试玩账号
  yuebaoSwitch: boolean; // 是否是开启利息宝

  unreadFaq: number;
  unreadMsg: number; // 站内信未读消息数量
}

export var UserI = UGUserModel.mine;
