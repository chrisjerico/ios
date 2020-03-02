package com.phoenix.lotterys.my.bean;

import java.io.Serializable;
import java.util.List;

/**
 * 文件描述:
 * 创建者: IAN
 * 创建时间: 2019/12/1 15:48
 */
public class DetailBean implements Serializable {


    /**
     * code : 0
     * msg : 获取帖子详情成功
     * data : {"id":"78","uid":"405529","nickname":"js****6","headImg":"https://cdn01.nadekouqiang.com/images/icon_1.png","title":"114四不像玄机图","content":"<p><span style=\"font-family: \"Helvetica Neue\", Helvetica, \"PingFang SC\", \"Hiragino Sans GB\", \"Microsoft YaHei\", 微软雅黑, Arial, sans-serif; font-size: 20px; white-space: pre-wrap;\">四不像玄机图<\/span><\/p>","contentPic":["https://cdn01.nadekouqiang.com/upload/t019/customise/picture/lhcdoc/5d99ac148377124.jpg"],"periods":"114","isHot":"1","createTime":"2019-10-06 16:55:29","replyCount":null,"isLike":0,"isFav":0,"isFollow":0,"likeNum":"4","viewNum":"228","price":"0.00","isLhcdocVip":0,"hasPay":1,"topAdPc":null,"bottomAdPc":null,"topAdWap":{"id":"13","addTime":"1574771556","cid":"8","pic":"https://cdn01.nadekouqiang.com/upload/t019/customise/picture/lhcdoc/5ddd1b64e15e498.jpg","isShow":"1","position":"1","targetType":"1","link":""},"bottomAdWap":{"id":"14","addTime":"1574771563","cid":"8","pic":"https://cdn01.nadekouqiang.com/upload/t019/customise/picture/lhcdoc/5ddd1b6b33ee326.jpg","isShow":"1","position":"2","targetType":"1","link":""},"vote":[{"animalFlag":1,"animal":"鼠","num":0,"percent":0},{"animalFlag":2,"animal":"牛","num":0,"percent":0},{"animalFlag":3,"animal":"虎","num":0,"percent":0},{"animalFlag":4,"animal":"兔","num":0,"percent":0},{"animalFlag":5,"animal":"龙","num":0,"percent":0},{"animalFlag":6,"animal":"蛇","num":0,"percent":0},{"animalFlag":7,"animal":"马","num":0,"percent":0},{"animalFlag":8,"animal":"羊","num":0,"percent":0},{"animalFlag":9,"animal":"猴","num":0,"percent":0},{"animalFlag":10,"animal":"鸡","num":0,"percent":0},{"animalFlag":11,"animal":"狗","num":0,"percent":0},{"animalFlag":12,"animal":"猪","num":0,"percent":0}]}
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

    public static class DataBean  implements Serializable{
        /**
         * id : 78
         * uid : 405529
         * nickname : js****6
         * headImg : https://cdn01.nadekouqiang.com/images/icon_1.png
         * title : 114四不像玄机图
         * content : <p><span style="font-family: "Helvetica Neue", Helvetica, "PingFang SC", "Hiragino Sans GB", "Microsoft YaHei", 微软雅黑, Arial, sans-serif; font-size: 20px; white-space: pre-wrap;">四不像玄机图</span></p>
         * contentPic : ["https://cdn01.nadekouqiang.com/upload/t019/customise/picture/lhcdoc/5d99ac148377124.jpg"]
         * periods : 114
         * isHot : 1
         * createTime : 2019-10-06 16:55:29
         * replyCount : null
         * isLike : 0
         * isFav : 0
         * isFollow : 0
         * likeNum : 4
         * viewNum : 228
         * price : 0.00
         * isLhcdocVip : 0
         * hasPay : 1
         * topAdPc : null
         * bottomAdPc : null
         * topAdWap : {"id":"13","addTime":"1574771556","cid":"8","pic":"https://cdn01.nadekouqiang.com/upload/t019/customise/picture/lhcdoc/5ddd1b64e15e498.jpg","isShow":"1","position":"1","targetType":"1","link":""}
         * bottomAdWap : {"id":"14","addTime":"1574771563","cid":"8","pic":"https://cdn01.nadekouqiang.com/upload/t019/customise/picture/lhcdoc/5ddd1b6b33ee326.jpg","isShow":"1","position":"2","targetType":"1","link":""}
         * vote : [{"animalFlag":1,"animal":"鼠","num":0,"percent":0},{"animalFlag":2,"animal":"牛","num":0,"percent":0},{"animalFlag":3,"animal":"虎","num":0,"percent":0},{"animalFlag":4,"animal":"兔","num":0,"percent":0},{"animalFlag":5,"animal":"龙","num":0,"percent":0},{"animalFlag":6,"animal":"蛇","num":0,"percent":0},{"animalFlag":7,"animal":"马","num":0,"percent":0},{"animalFlag":8,"animal":"羊","num":0,"percent":0},{"animalFlag":9,"animal":"猴","num":0,"percent":0},{"animalFlag":10,"animal":"鸡","num":0,"percent":0},{"animalFlag":11,"animal":"狗","num":0,"percent":0},{"animalFlag":12,"animal":"猪","num":0,"percent":0}]
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
        private String replyCount;
        private String isLike;
        private String isFav;
        private String isFollow;
        private String likeNum;
        private String viewNum;
        private String price;
        private String isLhcdocVip;
        private String hasPay;
        private String topAdPc;
        private String bottomAdPc;
        private TopAdWapBean topAdWap;
        private BottomAdWapBean bottomAdWap;
        private List<String> contentPic;
        private List<VoteBean> vote;

        private String isBigFav;

        public String getIsBigFav() {
            return isBigFav;
        }

        public void setIsBigFav(String isBigFav) {
            this.isBigFav = isBigFav;
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

        public String getReplyCount() {
            return replyCount;
        }

        public void setReplyCount(String replyCount) {
            this.replyCount = replyCount;
        }

        public String getIsLike() {
            return isLike;
        }

        public void setIsLike(String isLike) {
            this.isLike = isLike;
        }

        public String getIsFav() {
            return isFav;
        }

        public void setIsFav(String isFav) {
            this.isFav = isFav;
        }

        public String getIsFollow() {
            return isFollow;
        }

        public void setIsFollow(String isFollow) {
            this.isFollow = isFollow;
        }

        public String getLikeNum() {
            return likeNum;
        }

        public void setLikeNum(String likeNum) {
            this.likeNum = likeNum;
        }

        public String getViewNum() {
            return viewNum;
        }

        public void setViewNum(String viewNum) {
            this.viewNum = viewNum;
        }

        public String getPrice() {
            return price;
        }

        public void setPrice(String price) {
            this.price = price;
        }

        public String getIsLhcdocVip() {
            return isLhcdocVip;
        }

        public void setIsLhcdocVip(String isLhcdocVip) {
            this.isLhcdocVip = isLhcdocVip;
        }

        public String getHasPay() {
            return hasPay;
        }

        public void setHasPay(String hasPay) {
            this.hasPay = hasPay;
        }

        public Object getTopAdPc() {
            return topAdPc;
        }

        public void setTopAdPc(String topAdPc) {
            this.topAdPc = topAdPc;
        }

        public Object getBottomAdPc() {
            return bottomAdPc;
        }

        public void setBottomAdPc(String bottomAdPc) {
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

        public List<String> getContentPic() {
            return contentPic;
        }

        public void setContentPic(List<String> contentPic) {
            this.contentPic = contentPic;
        }

        public List<VoteBean> getVote() {
            return vote;
        }

        public void setVote(List<VoteBean> vote) {
            this.vote = vote;
        }

        public static class TopAdWapBean {
            /**
             * id : 13
             * addTime : 1574771556
             * cid : 8
             * pic : https://cdn01.nadekouqiang.com/upload/t019/customise/picture/lhcdoc/5ddd1b64e15e498.jpg
             * isShow : 1
             * position : 1
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

        public static class BottomAdWapBean {
            /**
             * id : 14
             * addTime : 1574771563
             * cid : 8
             * pic : https://cdn01.nadekouqiang.com/upload/t019/customise/picture/lhcdoc/5ddd1b6b33ee326.jpg
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

        public static class VoteBean  implements Serializable{
            /**
             * animalFlag : 1
             * animal : 鼠
             * num : 0
             * percent : 0
             */

            private int animalFlag;
            private String animal;
            private int num;
            private String percent;

            private boolean isSele;

            public boolean isSele() {
                return isSele;
            }

            public void setSele(boolean sele) {
                isSele = sele;
            }

            public int getAnimalFlag() {
                return animalFlag;
            }

            public void setAnimalFlag(int animalFlag) {
                this.animalFlag = animalFlag;
            }

            public String getAnimal() {
                return animal;
            }

            public void setAnimal(String animal) {
                this.animal = animal;
            }

            public int getNum() {
                return num;
            }

            public void setNum(int num) {
                this.num = num;
            }

            public String getPercent() {
                return percent;
            }

            public void setPercent(String percent) {
                this.percent = percent;
            }
        }
    }
}
