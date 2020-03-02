package com.phoenix.lotterys.my.bean;

import java.io.Serializable;

/**
 * Greated by Luke
 * on 2019/8/28
 */
public class ApplyParticularsBean implements Serializable {

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
         * id : 47
         * uid : 4165
         * username : admin000
         * winId : 26
         * winName : 彩金送
         * amount : 10.00
         * userComment : fdsfdsfass
         * adminComment :
         * operator :
         * state : 审核中
         * updateTime : 2019-09-05 13:41:08
         * checkTime : 0
         */

        private String id;
        private String uid;
        private String username;
        private String winId;
        private String winName;
        private String amount;
        private String userComment;
        private String adminComment;
        private String operator;
        private String state;
        private String updateTime;
        private String checkTime;

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

        public String getUsername() {
            return username;
        }

        public void setUsername(String username) {
            this.username = username;
        }

        public String getWinId() {
            return winId;
        }

        public void setWinId(String winId) {
            this.winId = winId;
        }

        public String getWinName() {
            return winName;
        }

        public void setWinName(String winName) {
            this.winName = winName;
        }

        public String getAmount() {
            return amount;
        }

        public void setAmount(String amount) {
            this.amount = amount;
        }

        public String getUserComment() {
            return userComment;
        }

        public void setUserComment(String userComment) {
            this.userComment = userComment;
        }

        public String getAdminComment() {
            return adminComment;
        }

        public void setAdminComment(String adminComment) {
            this.adminComment = adminComment;
        }

        public String getOperator() {
            return operator;
        }

        public void setOperator(String operator) {
            this.operator = operator;
        }

        public String getState() {
            return state;
        }

        public void setState(String state) {
            this.state = state;
        }

        public String getUpdateTime() {
            return updateTime;
        }

        public void setUpdateTime(String updateTime) {
            this.updateTime = updateTime;
        }

        public String getCheckTime() {
            return checkTime;
        }

        public void setCheckTime(String checkTime) {
            this.checkTime = checkTime;
        }
    }
}
