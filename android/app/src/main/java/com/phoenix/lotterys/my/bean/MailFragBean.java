package com.phoenix.lotterys.my.bean;

import com.google.gson.annotations.SerializedName;

import java.io.Serializable;
import java.util.List;

/**
 * 文件描述:
 * 创建者: IAN
 * 创建时间: 2019/7/11 12:24
 */
public class MailFragBean implements Serializable {


    /**
     * code : 0
     * msg : ok
     * data : {"list":[{"id":"8486","title":"QQ客服【陈梦】暂停服务通知！","summary":"尊敬的49彩票用户您","content":"尊敬的49彩票用户您好，我司QQ客服：2499990092    昵称【陈梦】已暂停服务，最新QQ客服：2301809615   昵称【囚迷记事】，如有疑问请联系7*24小时在线客服，感谢您的支持，谢谢！","updateTime":"2019-07-09 19:30:22","readTime":"","isRead":0},{"id":"8485","title":"周年庆签到活动彩金派送到账通知！","summary":"尊敬的49彩票集团用","content":"尊敬的49彩票集团用户您好，【17周年庆典 天天签到送好礼】凡是在2019年7月8号有登录过游戏账户的会员，周年庆登陆签到礼金系统已随机派送至会员账号，请注意查收，感谢您对49彩票集团的大力支持，祝您生活愉快、盈利多多～","updateTime":"2019-07-09 15:38:09","readTime":"","isRead":0},{"id":"8480","title":"周年庆签到活动彩金派送到账通知！","summary":"尊敬的49彩票集团用","content":"尊敬的49彩票集团用户您好，【17周年庆典 天天签到送好礼】活动彩金系统已随机派送至会员账号内，请注意查收，感谢您对49彩票集团的大力支持，祝您生活愉快、盈利多多～","updateTime":"2019-07-08 16:40:31","readTime":"","isRead":0},{"id":"8474","title":"17周年庆典活动通知!","summary":"尊敬的49彩票用户：","content":"尊敬的49彩票用户：在此感谢广大用户对49彩票集团支持，我司于7月7日隆重推出庆祝17周年庆典活动，亿元现金等您来领，周年庆典活动倒计时【5小时】，赶快来加入吧！","updateTime":"2019-07-07 19:03:30","readTime":"","isRead":0},{"id":"8473","title":"17周年庆典活动通知!","summary":"尊敬的49彩票用户：","content":"尊敬的49彩票用户：在此感谢广大用户对49彩票集团支持，我司于7月7日隆重推出庆祝17周年庆典活动，亿元现金等您来领，周年庆典活动火热进行中，赶快来加入吧！","updateTime":"2019-07-07 17:44:23","readTime":"","isRead":0}],"total":5,"readTotal":0}
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

    public static class DataBean implements Serializable{
        /**
         * list : [{"id":"8486","title":"QQ客服【陈梦】暂停服务通知！","summary":"尊敬的49彩票用户您","content":"尊敬的49彩票用户您好，我司QQ客服：2499990092    昵称【陈梦】已暂停服务，最新QQ客服：2301809615   昵称【囚迷记事】，如有疑问请联系7*24小时在线客服，感谢您的支持，谢谢！","updateTime":"2019-07-09 19:30:22","readTime":"","isRead":0},{"id":"8485","title":"周年庆签到活动彩金派送到账通知！","summary":"尊敬的49彩票集团用","content":"尊敬的49彩票集团用户您好，【17周年庆典 天天签到送好礼】凡是在2019年7月8号有登录过游戏账户的会员，周年庆登陆签到礼金系统已随机派送至会员账号，请注意查收，感谢您对49彩票集团的大力支持，祝您生活愉快、盈利多多～","updateTime":"2019-07-09 15:38:09","readTime":"","isRead":0},{"id":"8480","title":"周年庆签到活动彩金派送到账通知！","summary":"尊敬的49彩票集团用","content":"尊敬的49彩票集团用户您好，【17周年庆典 天天签到送好礼】活动彩金系统已随机派送至会员账号内，请注意查收，感谢您对49彩票集团的大力支持，祝您生活愉快、盈利多多～","updateTime":"2019-07-08 16:40:31","readTime":"","isRead":0},{"id":"8474","title":"17周年庆典活动通知!","summary":"尊敬的49彩票用户：","content":"尊敬的49彩票用户：在此感谢广大用户对49彩票集团支持，我司于7月7日隆重推出庆祝17周年庆典活动，亿元现金等您来领，周年庆典活动倒计时【5小时】，赶快来加入吧！","updateTime":"2019-07-07 19:03:30","readTime":"","isRead":0},{"id":"8473","title":"17周年庆典活动通知!","summary":"尊敬的49彩票用户：","content":"尊敬的49彩票用户：在此感谢广大用户对49彩票集团支持，我司于7月7日隆重推出庆祝17周年庆典活动，亿元现金等您来领，周年庆典活动火热进行中，赶快来加入吧！","updateTime":"2019-07-07 17:44:23","readTime":"","isRead":0}]
         * total : 5
         * readTotal : 0
         */

        private int total;
        private int readTotal;
        private List<ListBean> list;
        @SerializedName("hot_list")
        private List<ListBean> hotList;

        private ListBean realTime;

        public ListBean getRealTime() {
            return realTime;
        }

        public void setRealTime(ListBean realTime) {
            this.realTime = realTime;
        }

        public List<ListBean> getHotList() {
            return hotList;
        }

        public void setHotList(List<ListBean> hotList) {
            this.hotList = hotList;
        }

        public int getTotal() {
            return total;
        }

        public void setTotal(int total) {
            this.total = total;
        }

        public int getReadTotal() {
            return readTotal;
        }

        public void setReadTotal(int readTotal) {
            this.readTotal = readTotal;
        }

        public List<ListBean> getList() {
            return list;
        }

        public void setList(List<ListBean> list) {
            this.list = list;
        }

        public static class ListBean implements Serializable{
            /**
             * id : 8486
             * title : QQ客服【陈梦】暂停服务通知！
             * summary : 尊敬的49彩票用户您
             * content : 尊敬的49彩票用户您好，我司QQ客服：2499990092    昵称【陈梦】已暂停服务，最新QQ客服：2301809615   昵称【囚迷记事】，如有疑问请联系7*24小时在线客服，感谢您的支持，谢谢！
             * updateTime : 2019-07-09 19:30:22
             * readTime :
             * isRead : 0
             */

            private String id;
            private String title;
            private String summary;
            private String content;
            private String updateTime;
            private String readTime;
            private int isRead;

            private String name;
            private String cover;


            private String alias;

            private String letters;

//              "id" : "58",
//                      "priceMin" : "0.00",
//                      "priceMax" : "0.00",
//                      "topAdWap" : "",
//                      "appLinkCode" : "",
//                      "topAdPc" : "",
//                      "desc" : "先锋报",
//                      "bottomAdPc" : "",
//                      "content_id" : "0",
//                      "isBigFav" : 0,
//                      "alias" : "xfb",
//                      "isUpdate" : 0,
//                      "appLink" : "",
//                      "bottomAdWap" : "",
//                      "cover" : "https:\/\/cdn01.mayihong.cn\/upload\/t010\/customise\/picture\/lhcdoc\/noPic.jpg",
//                      "name" : "先锋报"


            public String getLetters() {
                return letters;
            }

            public void setLetters(String letters) {
                this.letters = letters;
            }

            public String getAlias() {
                return alias;
            }

            public void setAlias(String alias) {
                this.alias = alias;
            }

            public String getName() {
                return name;
            }

            public void setName(String name) {
                this.name = name;
            }

            public String getCover() {
                return cover;
            }

            public void setCover(String cover) {
                this.cover = cover;
            }

            public String getId() {
                return id;
            }

            public void setId(String id) {
                this.id = id;
            }

            public String getTitle() {
                return title;
            }

            public void setTitle(String title) {
                this.title = title;
            }

            public String getSummary() {
                return summary;
            }

            public void setSummary(String summary) {
                this.summary = summary;
            }

            public String getContent() {
                return content;
            }

            public void setContent(String content) {
                this.content = content;
            }

            public String getUpdateTime() {
                return updateTime;
            }

            public void setUpdateTime(String updateTime) {
                this.updateTime = updateTime;
            }

            public String getReadTime() {
                return readTime;
            }

            public void setReadTime(String readTime) {
                this.readTime = readTime;
            }

            public int getIsRead() {
                return isRead;
            }

            public void setIsRead(int isRead) {
                this.isRead = isRead;
            }
        }
    }
}
