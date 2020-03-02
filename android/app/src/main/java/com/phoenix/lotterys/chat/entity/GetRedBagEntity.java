package com.phoenix.lotterys.chat.entity;

/**
 * @author : W
 * @e-mail :
 * @date : 2019/12/06 14:22
 * @description :
 */
public class GetRedBagEntity {

    /**
     * code : 0
     * msg : success
     * data : {"redBagId":264,"miniRedBagAmount":"4","miniRedBagId":1,"isMine":false,"isMax":true,"time":1575602696,"uid":"63408","status":2}
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
         * redBagId : 264
         * miniRedBagAmount : 4
         * miniRedBagId : 1
         * isMine : false
         * isMax : true
         * time : 1575602696
         * uid : 63408
         * status : 2
         */

        private String redBagId;
        private String miniRedBagAmount;
        private int miniRedBagId;
        private boolean isMine;
        private boolean isMax;
        private int time;
        private String uid;
        private int status;

        public String getRedBagId() {
            return redBagId;
        }

        public void setRedBagId(String redBagId) {
            this.redBagId = redBagId;
        }

        public String getMiniRedBagAmount() {
            return miniRedBagAmount;
        }

        public void setMiniRedBagAmount(String miniRedBagAmount) {
            this.miniRedBagAmount = miniRedBagAmount;
        }

        public int getMiniRedBagId() {
            return miniRedBagId;
        }

        public void setMiniRedBagId(int miniRedBagId) {
            this.miniRedBagId = miniRedBagId;
        }

        public boolean isIsMine() {
            return isMine;
        }

        public void setIsMine(boolean isMine) {
            this.isMine = isMine;
        }

        public boolean isIsMax() {
            return isMax;
        }

        public void setIsMax(boolean isMax) {
            this.isMax = isMax;
        }

        public int getTime() {
            return time;
        }

        public void setTime(int time) {
            this.time = time;
        }

        public String getUid() {
            return uid;
        }

        public void setUid(String uid) {
            this.uid = uid;
        }

        public int getStatus() {
            return status;
        }

        public void setStatus(int status) {
            this.status = status;
        }
    }
}
