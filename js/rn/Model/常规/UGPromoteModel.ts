export class UGPromoteListModel {
  categories: { [x: number]: string }; // 分类列表
  list: Array<UGPromoteModel>; // 优惠列表
  showCategory: boolean; // 是否显示分类
  style: "slide" | "popup" | "page"; // slide折叠、popup弹窗、page内页
}

export class UGPromoteModel {
  clsName: string = "UGPromoteModel";
  promoteId: string; // 优惠ID
  title: string; // 优惠标题
  content: string; // 优惠内容
  pic: string; // 浮动按钮图片
  linkUrl: string; // 浮动按钮链接
  category: number; // 优惠分类:0=未分类;1=综合活动;2=棋牌活动;3=视讯活动;4=体育活动;5=电子活动;6=捕鱼活动
  linkCategory: number; // linkCategory: 跳转分类。1=彩票游戏；2=真人视讯；3=捕鱼游戏；4=电子游戏；5=棋牌游戏；6=体育赛事；7=导航链接
  linkPosition: number; // linkPosition：跳转位置。linkCategory=1-6代表游戏ID，linkCategory=7, 导航链接明细：1=存取款；2=APP下载；3=聊天室；4=在线客服；5=长龙助手；6=推荐收益；7=开奖网；8=利息宝；9=优惠活动；10=游戏记录；11=QQ客服 13任务大厅

  // 自定义属性
  picHeight?: number;
  webViewHeight?: number;
}
