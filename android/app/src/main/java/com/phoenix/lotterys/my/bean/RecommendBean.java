package com.phoenix.lotterys.my.bean;

import java.io.Serializable;

/**
 * 文件描述:
 * 创建者: IAN
 * 创建时间: 2019/8/26 16:10
 */
public class RecommendBean implements Serializable {


    /**
     * code : 0
     * msg : 获取代理推荐成功
     * data : {"username":"test08","rid":"4645","uid":"4645","link_i":"http://test10.6yc.com/?4645","link_r":"http://test10.6yc.com/?4645&r","fandian_intro":"一级下线:0.00%, 二级下线:0.00%, 三级下线:0.00%","fanDian":"0.00","month_earn":"0.00","month_member":"一级下线:0, 二级下线:0, 三级下线:0","total_member":"一级下线:0, 二级下线:0, 三级下线:0"}
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
         * username : test08
         * rid : 4645
         * uid : 4645
         * link_i : http://test10.6yc.com/?4645
         * link_r : http://test10.6yc.com/?4645&r
         * fandian_intro : 一级下线:0.00%, 二级下线:0.00%, 三级下线:0.00%
         * fanDian : 0.00
         * month_earn : 0.00
         * month_member : 一级下线:0, 二级下线:0, 三级下线:0
         * total_member : 一级下线:0, 二级下线:0, 三级下线:0
         */

        private String username;
        private String rid;
        private String uid;
        private String link_i;
        private String link_r;
        private String fandian_intro;
        private String fandian;
        private String month_earn;
        private String month_member;
        private String total_member;

        public String getUsername() {
            return username;
        }

        public void setUsername(String username) {
            this.username = username;
        }

        public String getRid() {
            return rid;
        }

        public void setRid(String rid) {
            this.rid = rid;
        }

        public String getUid() {
            return uid;
        }

        public void setUid(String uid) {
            this.uid = uid;
        }

        public String getLink_i() {
            return link_i;
        }

        public void setLink_i(String link_i) {
            this.link_i = link_i;
        }

        public String getLink_r() {
            return link_r;
        }

        public void setLink_r(String link_r) {
            this.link_r = link_r;
        }

        public String getFandian_intro() {
            return fandian_intro;
        }

        public void setFandian_intro(String fandian_intro) {
            this.fandian_intro = fandian_intro;
        }

        public String getFanDian() {
            return fandian;
        }

        public void setFanDian(String fandian) {
            this.fandian = fandian;
        }

        public String getMonth_earn() {
            return month_earn;
        }

        public void setMonth_earn(String month_earn) {
            this.month_earn = month_earn;
        }

        public String getMonth_member() {
            return month_member;
        }

        public void setMonth_member(String month_member) {
            this.month_member = month_member;
        }

        public String getTotal_member() {
            return total_member;
        }

        public void setTotal_member(String total_member) {
            this.total_member = total_member;
        }
    }
}
