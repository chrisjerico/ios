package com.phoenix.lotterys.my.bean;

import java.io.Serializable;

/**
 * 文件描述:
 * 创建者: IAN
 * 创建时间: 2019/9/6 13:06
 */
public class AgencyBean implements Serializable {


    /**
     * code : 0
     * msg : 获取会员申请记录
     * data : {"agent_apply":"1567745984","uid":"5068","isAgent":false,"username":"ceshi5","qq":"","phone":null,"comment":"eegsfdgregregdsge","admin_comment":""}
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
         * agent_apply : 1567745984
         * uid : 5068
         * isAgent : false
         * username : ceshi5
         * qq :
         * phone : null
         * comment : eegsfdgregregdsge
         * admin_comment :
         */

        private String agent_apply;
        private String uid;
        private boolean isAgent;
        private String username;
        private String qq;
        private String phone;
        private String comment;
        private String admin_comment;

        private String mobile;
        private String applyReason;
        private String reviewResult;
        private String reviewStatus;

        public String getMobile() {
            return mobile;
        }

        public void setMobile(String mobile) {
            this.mobile = mobile;
        }

        public String getApplyReason() {
            return applyReason;
        }

        public void setApplyReason(String applyReason) {
            this.applyReason = applyReason;
        }

        public String getReviewResult() {
            return reviewResult;
        }

        public void setReviewResult(String reviewResult) {
            this.reviewResult = reviewResult;
        }

        public String getReviewStatus() {
            return reviewStatus;
        }

        public void setReviewStatus(String reviewStatus) {
            this.reviewStatus = reviewStatus;
        }

        public boolean isAgent() {
            return isAgent;
        }

        public void setAgent(boolean agent) {
            isAgent = agent;
        }

        public String getAgent_apply() {
            return agent_apply;
        }

        public void setAgent_apply(String agent_apply) {
            this.agent_apply = agent_apply;
        }

        public String getUid() {
            return uid;
        }

        public void setUid(String uid) {
            this.uid = uid;
        }

        public boolean isIsAgent() {
            return isAgent;
        }

        public void setIsAgent(boolean isAgent) {
            this.isAgent = isAgent;
        }

        public String getUsername() {
            return username;
        }

        public void setUsername(String username) {
            this.username = username;
        }

        public String getQq() {
            return qq;
        }

        public void setQq(String qq) {
            this.qq = qq;
        }

        public String getPhone() {
            return phone;
        }

        public void setPhone(String phone) {
            this.phone = phone;
        }

        public String getComment() {
            return comment;
        }

        public void setComment(String comment) {
            this.comment = comment;
        }

        public String getAdmin_comment() {
            return admin_comment;
        }

        public void setAdmin_comment(String admin_comment) {
            this.admin_comment = admin_comment;
        }
    }
}
