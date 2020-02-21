export interface LHPostAdModel {
  aid: string; // 广告ID
  addTime: string; // 添加时间
  cid: string; // 帖子ID
  pic: string; // 图片
  position: string; // 位置
  link: string; // 跳转链接
  isShow: boolean; // 是否显示
  targetType: number; // 跳转方式：1本窗口 2 新窗口
}

export interface LHVoteModel {
  animalFlag: string; // 生肖ID
  animal: string; // 标题
  num: number; // 票数
  percent: number; // 百分比

  // 自定义参数
  selected: boolean;
}

export interface LHPostModel {
  // 《帖子列表》
  // c=lhcdoc&a=contentList
  cid: string; // 帖子ID
  alias: string; // 栏目别名
  uid: string; // 用户ID
  nickname: string; // 昵称
  headImg: string; // 头像
  title: string; // 帖子标题
  content: string; // 帖子详情
  periods: string; // 期数
  createTime: string; // 创建时间
  contentPic: Array<string>; // 帖子图片
  enable: boolean; // 是否可用
  isHot: boolean; // 是否热门
  isLike: boolean; // 是否已点赞
  isTop: boolean; // 是否置顶 '1'是 '0'否
  isLhcdocVip: boolean; // 作者是否V认证 1是 0否
  hasPay: boolean; // 是否已消费帖子 1是 0否
  price: number; // 帖子价格
  likeNum: number; // 点赞数
  viewNum: number; // 阅读数
  replyCount: number; // 回复数

  // 《获取帖子详情》
  // c=lhcdoc&a=contentDetail
  // id:string;         // 帖子ID
  // uid:string;        // 作者ID
  // nickname:string;   // 作者昵称
  // headImg:string;    // 作者头像
  // title:string;      // 帖子标题
  // content:string;    // 帖子内容
  // contentPic:string; // 帖子图片内容
  // periods:string;    // 期数
  // alias:string;      // 帖子所属栏目的别名
  topAdPc: LHPostAdModel; // pc端顶部广告
  bottomAdPc: LHPostAdModel; // pc端底部广告
  topAdWap: LHPostAdModel; // 手机端顶部广告
  bottomAdWap: LHPostAdModel; // 手机端底部广告
  vote: Array<LHVoteModel>; // 如果不是投票类型的帖子时，为null； 否则为数组
  // double price;      // 帖子价格
  // isLike: boolean;     // 是否已点赞 1是 0否
  // hasPay: boolean;     // 是否已支付 1是 0否
  // isHot: boolean;      // 是否热门 1是 0否
  isFav: boolean; // 是否收藏 1是 0否
  isBigFav: boolean; // 图库是否收藏 1是 0否
  isFollow: boolean; // 是否关注 1是 0否
  isLhcdoVip: boolean; // 作者是否V认证 1是 0否
  // createTime:string; // 文章创建时间
  // replyCount: number; // 评论数
  // likeNum: number;    // 点赞数
  // viewNum: number;    // 阅读数

  // 《我的历史帖子》
  // c=lhcdoc&a=historyContent
  // cid:string;        // 帖子ID
  // alias:string;      //  栏目别名
  // uid:string;        // 用户ID
  // nickname:string;   // 昵称
  // headImg:string;    // 头像
  // title:string;      // 帖子标题
  // content:string;    // 帖子详情
  // contentPic:string; // 帖子图片
  // periods:string;  // 期数
  // createTime:string; // 创建时间
  // enable: boolean;       //  是否可用
  // isHot: boolean;      // 是否热门
  // isLike: boolean;     // 是否已点赞
  // isTop: boolean;      // 是否置顶 '1'是 '0'否
  // isLhcdocVip: boolean;// 作者是否V认证 1是 0否
  // hasPay: boolean;     // 是否已消费帖子 1是 0否
  // double price;      // 帖子价格
  // likeNum: number;    // 点赞数
  // viewNum: number;    // 阅读数
  // replyCount: number; // 回复数

  // 《关注帖子列表》
  // c=lhcdoc&a=favContentList
  // cid:string;        // 帖子ID
  // alias:string;      //  栏目别名
  // uid:string;        // 用户ID
  // nickname:string;   // 昵称
  // headImg:string;    // 头像
  // title:string;      // 帖子标题
  // content:string;    // 帖子详情
  // contentPic:string; // 帖子图片
  // periods:string;  // 期数
  // createTime:string; // 创建时间
  // enable: boolean;       //  是否可用
  // isHot: boolean;      // 是否热门
  // isLike: boolean;     // 是否已点赞
  // isTop: boolean;      // 是否置顶 '1'是 '0'否
  // isLhcdocVip: boolean;// 作者是否V认证 1是 0否
  // hasPay: boolean;     // 是否已消费帖子 1是 0否
  // double price;      // 帖子价格
  // likeNum: number;    // 点赞数
  // viewNum: number;    // 阅读数
  // replyCount: number; // 回复数
  type: string; // 栏目ID
  type2: string; // 资料ID
  secReplyList: Array<LHPostModel>; // 回复数组
  link: string; // 分栏链接，用来判断是否加载解码器  根据 mystery/
}
