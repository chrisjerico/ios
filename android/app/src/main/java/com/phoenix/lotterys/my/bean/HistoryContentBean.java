package com.phoenix.lotterys.my.bean;

import java.io.Serializable;
import java.util.List;

/**
 * 文件描述:
 * 创建者: IAN
 * 创建时间: 2019/12/4 13:46
 */
public class HistoryContentBean implements Serializable {


    /**
     * code : 0
     * msg : 获取成功
     * data : {"list":[{"cid":"323","enable":"1","alias":"forum","uid":"405533","nickname":"啊实打实的啊","headImg":"https://cdn01.nadekouqiang.com/upload/t019/customise/images/memberFace15.jpg?v=1012566414","title":"不能在","content":"[em_4]￼[em_25]￼[em_25]一[em_25]天[em_25]就[em_4]￼[em_4]一[em_4]下[em_4]你[em_49]￼[em_49]太[em_49]原[em_56]￼[em_68]￼","contentPic":[],"periods":"201","isHot":"0","likeNum":"1","viewNum":"26","isLike":1,"createTime":"2019-12-03 21:30:19","replyCount":0,"isTop":"0","price":"0.00","isLhcdocVip":0,"hasPay":1},{"cid":"278","enable":"1","alias":"forum","uid":"405533","nickname":"啊实打实的啊","headImg":"https://cdn01.nadekouqiang.com/upload/t019/customise/images/memberFace15.jpg?v=1012566414","title":"这","content":"这","contentPic":["https://cdn01.nadekouqiang.com/upload/t019/customise/picture/lhcdoc/2920b5738e933b3f0e96203201c9471a.png"],"periods":"201","isHot":"0","likeNum":"1","viewNum":"42","isLike":0,"createTime":"2019-12-02 14:46:24","replyCount":0,"isTop":"0","price":"0.00","isLhcdocVip":0,"hasPay":1},{"cid":"276","enable":"1","alias":"forum","uid":"405533","nickname":"啊实打实的啊","headImg":"https://cdn01.nadekouqiang.com/upload/t019/customise/images/memberFace15.jpg?v=1012566414","title":"图片测试","content":"11111","contentPic":[],"periods":"201","isHot":"0","likeNum":"2","viewNum":"22","isLike":1,"createTime":"2019-12-02 14:31:30","replyCount":0,"isTop":"0","price":"0.00","isLhcdocVip":0,"hasPay":1}],"total":3}
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
         * list : [{"cid":"323","enable":"1","alias":"forum","uid":"405533","nickname":"啊实打实的啊","headImg":"https://cdn01.nadekouqiang.com/upload/t019/customise/images/memberFace15.jpg?v=1012566414","title":"不能在","content":"[em_4]￼[em_25]￼[em_25]一[em_25]天[em_25]就[em_4]￼[em_4]一[em_4]下[em_4]你[em_49]￼[em_49]太[em_49]原[em_56]￼[em_68]￼","contentPic":[],"periods":"201","isHot":"0","likeNum":"1","viewNum":"26","isLike":1,"createTime":"2019-12-03 21:30:19","replyCount":0,"isTop":"0","price":"0.00","isLhcdocVip":0,"hasPay":1},{"cid":"278","enable":"1","alias":"forum","uid":"405533","nickname":"啊实打实的啊","headImg":"https://cdn01.nadekouqiang.com/upload/t019/customise/images/memberFace15.jpg?v=1012566414","title":"这","content":"这","contentPic":["https://cdn01.nadekouqiang.com/upload/t019/customise/picture/lhcdoc/2920b5738e933b3f0e96203201c9471a.png"],"periods":"201","isHot":"0","likeNum":"1","viewNum":"42","isLike":0,"createTime":"2019-12-02 14:46:24","replyCount":0,"isTop":"0","price":"0.00","isLhcdocVip":0,"hasPay":1},{"cid":"276","enable":"1","alias":"forum","uid":"405533","nickname":"啊实打实的啊","headImg":"https://cdn01.nadekouqiang.com/upload/t019/customise/images/memberFace15.jpg?v=1012566414","title":"图片测试","content":"11111","contentPic":[],"periods":"201","isHot":"0","likeNum":"2","viewNum":"22","isLike":1,"createTime":"2019-12-02 14:31:30","replyCount":0,"isTop":"0","price":"0.00","isLhcdocVip":0,"hasPay":1}]
         * total : 3
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

        public static class ListBean implements Serializable{
            /**
             * cid : 323
             * enable : 1
             * alias : forum
             * uid : 405533
             * nickname : 啊实打实的啊
             * headImg : https://cdn01.nadekouqiang.com/upload/t019/customise/images/memberFace15.jpg?v=1012566414
             * title : 不能在
             * content : [em_4]￼[em_25]￼[em_25]一[em_25]天[em_25]就[em_4]￼[em_4]一[em_4]下[em_4]你[em_49]￼[em_49]太[em_49]原[em_56]￼[em_68]￼
             * contentPic : []
             * periods : 201
             * isHot : 0
             * likeNum : 1
             * viewNum : 26
             * isLike : 1
             * createTime : 2019-12-03 21:30:19
             * replyCount : 0
             * isTop : 0
             * price : 0.00
             * isLhcdocVip : 0
             * hasPay : 1
             */

            private String cid;
            private String enable;
            private String alias;
            private String uid;
            private String nickname;
            private String headImg;
            private String title;
            private String content;
            private String periods;
            private String isHot;
            private String likeNum;
            private String viewNum;
            private String isLike;
            private String createTime;
            private String replyCount;
            private String isTop;
            private String price;
            private String isLhcdocVip;
            private String hasPay;
            private String posterUid;

            private List<String> contentPic;

            public String getPosterUid() {
                return posterUid;
            }

            public void setPosterUid(String posterUid) {
                this.posterUid = posterUid;
            }

            public String getCid() {
                return cid;
            }

            public void setCid(String cid) {
                this.cid = cid;
            }

            public String getEnable() {
                return enable;
            }

            public void setEnable(String enable) {
                this.enable = enable;
            }

            public String getAlias() {
                return alias;
            }

            public void setAlias(String alias) {
                this.alias = alias;
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

            public String getIsLike() {
                return isLike;
            }

            public void setIsLike(String isLike) {
                this.isLike = isLike;
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

            public String getIsTop() {
                return isTop;
            }

            public void setIsTop(String isTop) {
                this.isTop = isTop;
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

            public List<String> getContentPic() {
                return contentPic;
            }

            public void setContentPic(List<String> contentPic) {
                this.contentPic = contentPic;
            }
        }
    }
}
