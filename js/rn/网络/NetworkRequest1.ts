import CCSessionModel from "./CCSessionModel";
import AppDefine from "../通用/AppDefine";

export default class NetworkRequest1 {
  // 获取下一期开奖数据
  static game_nextIssue(params: { abc?: "a123" | "abc" }) {
    // this.game_homeGames({ abc: "abc" });
  }

  // 获取首页游戏列表
  static game_homeGames(): Promise<void> {
    return CCSessionModel.req("c=game&a=homeGames", {}, false);
  }

  // 获取帖子详情
  static lhdoc_contentDetail(id: string) {
    return CCSessionModel.req("c=lhcdoc&a=contentDetail", { id: id }, false);
  }

  // 获取评论列表
  static lhcdoc_contentReplyList(
    contentId: string, // 帖子ID
    replyPId: string = "", // 回复ID
    page: number = 1, // 页码
    rows: number = AppDefine.pageCount // 每页条数
  ): Promise<void> {
    return CCSessionModel.req("c=lhcdoc&a=contentReplyList", { contentId: contentId, replyPId: replyPId, page: page, rows: rows }, false);
  }

  // 游客登录
  static user_guestLogin(): Promise<void> {
    return CCSessionModel.req(
      "c=user&a=guestLogin",
      {
        usr: "46da83e1773338540e1e1c973f6c8a68",
        pwd: "46da83e1773338540e1e1c973f6c8a68"
      },
      true
    );
  }

  // 上传错误日志
  static uploadErrorLog(log: string, title: string, tag: string): Promise<void> {
    return CCSessionModel.request(
      "https://www.showdoc.cc/server/api/item/updateByApi",
      {
        api_key: "8d36c0232492493fe13fad667eeb221f2104779671",
        api_token: "0a98a37b01f88f2afe9b9f5c052db169143601101",
        page_content: log, // 内容
        page_title: new Date().format("MM月dd日 hh:mm") + `（${title}）`, // 标题
        cat_name: tag, // 目录名
        s_number: new Date().format("yyyyMMddHHmm") // 序号，数字越小越靠前
      },
      true
    );
  }
}

Date.prototype.format = function(fmt) {
  var o = {
    "M+": this.getMonth() + 1, //月份
    "d+": this.getDate(), //日
    "h+": this.getHours(), //小时
    "m+": this.getMinutes(), //分
    "s+": this.getSeconds(), //秒
    "q+": Math.floor((this.getMonth() + 3) / 3), //季度
    S: this.getMilliseconds() //毫秒
  };
  if (/(y+)/.test(fmt)) {
    fmt = fmt.replace(RegExp.$1, (this.getFullYear() + "").substr(4 - RegExp.$1.length));
  }
  for (var k in o) {
    if (new RegExp("(" + k + ")").test(fmt)) {
      fmt = fmt.replace(RegExp.$1, RegExp.$1.length == 1 ? o[k] : ("00" + o[k]).substr(("" + o[k]).length));
    }
  }
  return fmt;
};
