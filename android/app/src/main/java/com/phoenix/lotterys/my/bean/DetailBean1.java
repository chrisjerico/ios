package com.phoenix.lotterys.my.bean;

import java.io.Serializable;
import java.util.List;

/**
 * 文件描述:
 * 创建者: IAN
 * 创建时间: 2019/12/1 15:48
 */
public class DetailBean1 implements Serializable {


    /**
     * code : 0
     * msg : 获取帖子详情成功
     * data : {"id":"459","uid":"0","nickname":"管理员","headImg":"https://cdn01.mayihong.cn/images/icon_0.png","title":"第075期另版跑狗图","content":"2019","contentPic":["https://cdn01.mayihong.cn/upload/t010/customise/picture/lhcdoc/23a28050a8f0a5988b197adfdbdcf02a.jpg"],"periods":"75","isHot":"0","createTime":"2019-12-06 21:31:42","replyCount":null,"isLike":0,"isFav":0,"isFollow":0,"likeNum":null,"viewNum":null,"price":"0.00","isLhcdocVip":1,"hasPay":1,"topAdPc":null,"bottomAdPc":null,"topAdWap":{"id":"9","addTime":"1575988674","cid":"5","pic":"https://cdn01.mayihong.cn/upload/t010/customise/picture/lhcdoc/5defadc2c7fff24.jpg","isShow":"1","position":"1","targetType":"1","link":"www.baidu.com"},"bottomAdWap":{"id":"10","addTime":"1575988687","cid":"5","pic":"https://cdn01.mayihong.cn/upload/t010/customise/picture/lhcdoc/5defadcf81ac252.jpg","isShow":"1","position":"2","targetType":"1","link":""},"isBigFav":0,"alias":"sixpic","vote":null}
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
         * id : 459
         * uid : 0
         * nickname : 管理员
         * headImg : https://cdn01.mayihong.cn/images/icon_0.png
         * title : 第075期另版跑狗图
         * content : 2019
         * contentPic : ["https://cdn01.mayihong.cn/upload/t010/customise/picture/lhcdoc/23a28050a8f0a5988b197adfdbdcf02a.jpg"]
         * periods : 75
         * isHot : 0
         * createTime : 2019-12-06 21:31:42
         * replyCount : null
         * isLike : 0
         * isFav : 0
         * isFollow : 0
         * likeNum : null
         * viewNum : null
         * price : 0.00
         * isLhcdocVip : 1
         * hasPay : 1
         * topAdPc : null
         * bottomAdPc : null
         * topAdWap : {"id":"9","addTime":"1575988674","cid":"5","pic":"https://cdn01.mayihong.cn/upload/t010/customise/picture/lhcdoc/5defadc2c7fff24.jpg","isShow":"1","position":"1","targetType":"1","link":"www.baidu.com"}
         * bottomAdWap : {"id":"10","addTime":"1575988687","cid":"5","pic":"https://cdn01.mayihong.cn/upload/t010/customise/picture/lhcdoc/5defadcf81ac252.jpg","isShow":"1","position":"2","targetType":"1","link":""}
         * isBigFav : 0
         * alias : sixpic
         * vote : null
         */

        private String id;
        private String uid;
        private String nickname;
        private String headImg;
        private String title;
        private String content;
        private String periods;
        private String isHot;
        private String createTime;
        private Object replyCount;
        private int isLike;
        private int isFav;
        private int isFollow;
        private Object likeNum;
        private Object viewNum;
        private String price;
        private int isLhcdocVip;
        private int hasPay;
        private Object topAdPc;
        private Object bottomAdPc;
        private TopAdWapBean topAdWap;
        private BottomAdWapBean bottomAdWap;
        private int isBigFav;
        private String alias;
        private Object vote;
        private List<String> contentPic;

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

        public String getTitle() {
            return title;
        }

        public void setTitle(String title) {
            this.title = title;
        }

        public String getContent() {
            return content;
        }

        public void setContent(String content) {
            this.content = content;
        }

        public String getPeriods() {
            return periods;
        }

        public void setPeriods(String periods) {
            this.periods = periods;
        }

        public String getIsHot() {
            return isHot;
        }

        public void setIsHot(String isHot) {
            this.isHot = isHot;
        }

        public String getCreateTime() {
            return createTime;
        }

        public void setCreateTime(String createTime) {
            this.createTime = createTime;
        }

        public Object getReplyCount() {
            return replyCount;
        }

        public void setReplyCount(Object replyCount) {
            this.replyCount = replyCount;
        }

        public int getIsLike() {
            return isLike;
        }

        public void setIsLike(int isLike) {
            this.isLike = isLike;
        }

        public int getIsFav() {
            return isFav;
        }

        public void setIsFav(int isFav) {
            this.isFav = isFav;
        }

        public int getIsFollow() {
            return isFollow;
        }

        public void setIsFollow(int isFollow) {
            this.isFollow = isFollow;
        }

        public Object getLikeNum() {
            return likeNum;
        }

        public void setLikeNum(Object likeNum) {
            this.likeNum = likeNum;
        }

        public Object getViewNum() {
            return viewNum;
        }

        public void setViewNum(Object viewNum) {
            this.viewNum = viewNum;
        }

        public String getPrice() {
            return price;
        }

        public void setPrice(String price) {
            this.price = price;
        }

        public int getIsLhcdocVip() {
            return isLhcdocVip;
        }

        public void setIsLhcdocVip(int isLhcdocVip) {
            this.isLhcdocVip = isLhcdocVip;
        }

        public int getHasPay() {
            return hasPay;
        }

        public void setHasPay(int hasPay) {
            this.hasPay = hasPay;
        }

        public Object getTopAdPc() {
            return topAdPc;
        }

        public void setTopAdPc(Object topAdPc) {
            this.topAdPc = topAdPc;
        }

        public Object getBottomAdPc() {
            return bottomAdPc;
        }

        public void setBottomAdPc(Object bottomAdPc) {
            this.bottomAdPc = bottomAdPc;
        }

        public TopAdWapBean getTopAdWap() {
            return topAdWap;
        }

        public void setTopAdWap(TopAdWapBean topAdWap) {
            this.topAdWap = topAdWap;
        }

        public BottomAdWapBean getBottomAdWap() {
            return bottomAdWap;
        }

        public void setBottomAdWap(BottomAdWapBean bottomAdWap) {
            this.bottomAdWap = bottomAdWap;
        }

        public int getIsBigFav() {
            return isBigFav;
        }

        public void setIsBigFav(int isBigFav) {
            this.isBigFav = isBigFav;
        }

        public String getAlias() {
            return alias;
        }

        public void setAlias(String alias) {
            this.alias = alias;
        }

        public Object getVote() {
            return vote;
        }

        public void setVote(Object vote) {
            this.vote = vote;
        }

        public List<String> getContentPic() {
            return contentPic;
        }

        public void setContentPic(List<String> contentPic) {
            this.contentPic = contentPic;
        }

        public static class TopAdWapBean {
            /**
             * id : 9
             * addTime : 1575988674
             * cid : 5
             * pic : https://cdn01.mayihong.cn/upload/t010/customise/picture/lhcdoc/5defadc2c7fff24.jpg
             * isShow : 1
             * position : 1
             * targetType : 1
             * link : www.baidu.com
             */

            private String id;
            private String addTime;
            private String cid;
            private String pic;
            private String isShow;
            private String position;
            private String targetType;
            private String link;

            public String getId() {
                return id;
            }

            public void setId(String id) {
                this.id = id;
            }

            public String getAddTime() {
                return addTime;
            }

            public void setAddTime(String addTime) {
                this.addTime = addTime;
            }

            public String getCid() {
                return cid;
            }

            public void setCid(String cid) {
                this.cid = cid;
            }

            public String getPic() {
                return pic;
            }

            public void setPic(String pic) {
                this.pic = pic;
            }

            public String getIsShow() {
                return isShow;
            }

            public void setIsShow(String isShow) {
                this.isShow = isShow;
            }

            public String getPosition() {
                return position;
            }

            public void setPosition(String position) {
                this.position = position;
            }

            public String getTargetType() {
                return targetType;
            }

            public void setTargetType(String targetType) {
                this.targetType = targetType;
            }

            public String getLink() {
                return link;
            }

            public void setLink(String link) {
                this.link = link;
            }
        }

        public static class BottomAdWapBean {
            /**
             * id : 10
             * addTime : 1575988687
             * cid : 5
             * pic : https://cdn01.mayihong.cn/upload/t010/customise/picture/lhcdoc/5defadcf81ac252.jpg
             * isShow : 1
             * position : 2
             * targetType : 1
             * link :
             */

            private String id;
            private String addTime;
            private String cid;
            private String pic;
            private String isShow;
            private String position;
            private String targetType;
            private String link;

            public String getId() {
                return id;
            }

            public void setId(String id) {
                this.id = id;
            }

            public String getAddTime() {
                return addTime;
            }

            public void setAddTime(String addTime) {
                this.addTime = addTime;
            }

            public String getCid() {
                return cid;
            }

            public void setCid(String cid) {
                this.cid = cid;
            }

            public String getPic() {
                return pic;
            }

            public void setPic(String pic) {
                this.pic = pic;
            }

            public String getIsShow() {
                return isShow;
            }

            public void setIsShow(String isShow) {
                this.isShow = isShow;
            }

            public String getPosition() {
                return position;
            }

            public void setPosition(String position) {
                this.position = position;
            }

            public String getTargetType() {
                return targetType;
            }

            public void setTargetType(String targetType) {
                this.targetType = targetType;
            }

            public String getLink() {
                return link;
            }

            public void setLink(String link) {
                this.link = link;
            }
        }
    }
}
