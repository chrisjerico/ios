package com.phoenix.lotterys.my.bean;

import java.io.Serializable;
import java.util.List;

/**
 * 文件描述:
 * 创建者: IAN
 * 创建时间: 2019/12/2 13:32
 */
public class CommentBean implements Serializable {


    /**
     * code : 0
     * msg : 获取帖子评论成功
     * data : {"list":[{"id":"51","uid":"405587","nickname":"咔咔咔咔咔咔","headImg":"https://cdn01.nadekouqiang.com/upload/t019/customise/images/memberFace9.jpg?v=1677774520","content":"双方都广东省广东省","actionTime":"2019-12-01 22:26:09","replyCount":1,"likeNum":null,"isLike":0}],"total":1}
     */

    private int code;
    private String msg;
    private DataBean data;

    public int getCode() {
        return code;
    }

    public void setCode(int code) {
        this.code = code;
    }

    public String getMsg() {
        return msg;
    }

    public void setMsg(String msg) {
        this.msg = msg;
    }

    public DataBean getData() {
        return data;
    }

    public void setData(DataBean data) {
        this.data = data;
    }

    public static class DataBean {
        /**
         * list : [{"id":"51","uid":"405587","nickname":"咔咔咔咔咔咔","headImg":"https://cdn01.nadekouqiang.com/upload/t019/customise/images/memberFace9.jpg?v=1677774520","content":"双方都广东省广东省","actionTime":"2019-12-01 22:26:09","replyCount":1,"likeNum":null,"isLike":0}]
         * total : 1
         */

        private int total;
        private List<ListBean> list;

        public int getTotal() {
            return total;
        }

        public void setTotal(int total) {
            this.total = total;
        }

        public List<ListBean> getList() {
            return list;
        }

        public void setList(List<ListBean> list) {
            this.list = list;
        }

        public static class ListBean implements Serializable {
            /**
             * id : 51
             * uid : 405587
             * nickname : 咔咔咔咔咔咔
             * headImg : https://cdn01.nadekouqiang.com/upload/t019/customise/images/memberFace9.jpg?v=1677774520
             * content : 双方都广东省广东省
             * actionTime : 2019-12-01 22:26:09
             * replyCount : 1
             * likeNum : null
             * isLike : 0
             */

            private String id;
            private String uid;
            private String nickname;
            private String headImg;
            private String content;
            private String actionTime;
            private String replyCount;
            private String likeNum;
            private String isLike;
            private String posterUid;

            private List<SecReplyList> secReplyList;

            public List<SecReplyList> getSecReplyList() {
                return secReplyList;
            }

            public void setSecReplyList(List<SecReplyList> secReplyList) {
                this.secReplyList = secReplyList;
            }

            public String getPosterUid() {
                return posterUid;
            }

            public void setPosterUid(String posterUid) {
                this.posterUid = posterUid;
            }

            public String getId() {
                return id;
            }

            public void setId(String id) {
                this.id = id;
            }

            public String getUid() {
                return uid;
            }

            public void setUid(String uid) {
                this.uid = uid;
            }

            public String getNickname() {
                return nickname;
            }

            public void setNickname(String nickname) {
                this.nickname = nickname;
            }

            public String getHeadImg() {
                return headImg;
            }

            public void setHeadImg(String headImg) {
                this.headImg = headImg;
            }

            public String getContent() {
                return content;
            }

            public void setContent(String content) {
                this.content = content;
            }

            public String getActionTime() {
                return actionTime;
            }

            public void setActionTime(String actionTime) {
                this.actionTime = actionTime;
            }

            public String getReplyCount() {
                return replyCount;
            }

            public void setReplyCount(String replyCount) {
                this.replyCount = replyCount;
            }

            public String getLikeNum() {
                return likeNum;
            }

            public void setLikeNum(String likeNum) {
                this.likeNum = likeNum;
            }

            public String getIsLike() {
                return isLike;
            }

            public void setIsLike(String isLike) {
                this.isLike = isLike;
            }
        }
            public static class SecReplyList implements Serializable {

                /**
                 * id : 5068
                 * uid : 3949
                 * content : 可惜了
                 * actionTime : 2020-01-03 21:50:22
                 * replyPId : 5061
                 * nickname : 星期欧
                 * headImg : https://cdn01.yingao-xu.cn/images/icon_1.png
                 */

                private String id;
                private String uid;
                private String content;
                private String actionTime;
                private String replyPId;
                private String nickname;
                private String headImg;

                public String getId() {
                    return id;
                }

                public void setId(String id) {
                    this.id = id;
                }

                public String getUid() {
                    return uid;
                }

                public void setUid(String uid) {
                    this.uid = uid;
                }

                public String getContent() {
                    return content;
                }

                public void setContent(String content) {
                    this.content = content;
                }

                public String getActionTime() {
                    return actionTime;
                }

                public void setActionTime(String actionTime) {
                    this.actionTime = actionTime;
                }

                public String getReplyPId() {
                    return replyPId;
                }

                public void setReplyPId(String replyPId) {
                    this.replyPId = replyPId;
                }

                public String getNickname() {
                    return nickname;
                }

                public void setNickname(String nickname) {
                    this.nickname = nickname;
                }

                public String getHeadImg() {
                    return headImg;
                }

                public void setHeadImg(String headImg) {
                    this.headImg = headImg;
                }
            }

    }
}
