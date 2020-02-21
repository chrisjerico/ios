export interface LHPostCommentModel {
  pid: string; // 评论ID
  uid: string; // 发起评论的用户ID
  nickname: string; // 用户昵称
  headImg: string; // 评论用户头像
  content: string; // 内容
  actionTime: string; // 评论时间
  replyCount: number; // 回复数
  likeNum: number; // 点赞数
  isLike: boolean; // 是否已点赞 1是 0否
  secReplyList: Array<LHPostCommentReplyModel>; // 回复数组
}

export interface LHPostCommentReplyModel {
  id: string;
  uid: string;
  content: string;
  actionTime: string;
  replyPId: string;
  nickname: string;
  headImg: string;
}
