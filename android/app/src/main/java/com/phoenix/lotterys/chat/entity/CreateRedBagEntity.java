package com.phoenix.lotterys.chat.entity;

/**
 * @author : W
 * @e-mail :
 * @date : 2019/11/30 13:15
 * @description :
 */
public class CreateRedBagEntity {

    /**
     * code : 0
     * msg : success
     * data : {"genre":"1","roomId":"0","uid":"63408","amount":"10","quantity":2,"title":"10-2","createTime":1573822466,"expireTime":1573908866,"status":1,"id":"7"}
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
         * genre : 1
         * roomId : 0
         * uid : 63408
         * amount : 10
         * quantity : 2
         * title : 10-2
         * createTime : 1573822466
         * expireTime : 1573908866
         * status : 1
         * id : 7
         */

        private String genre;
        private String roomId;
        private String uid;
        private String amount;
        private int quantity;
        private String title;
        private int createTime;
        private int expireTime;
        private int status;
        private String id;

        public String getGenre() {
            return genre;
        }

        public void setGenre(String genre) {
            this.genre = genre;
        }

        public String getRoomId() {
            return roomId;
        }

        public void setRoomId(String roomId) {
            this.roomId = roomId;
        }

        public String getUid() {
            return uid;
        }

        public void setUid(String uid) {
            this.uid = uid;
        }

        public String getAmount() {
            return amount;
        }

        public void setAmount(String amount) {
            this.amount = amount;
        }

        public int getQuantity() {
            return quantity;
        }

        public void setQuantity(int quantity) {
            this.quantity = quantity;
        }

        public String getTitle() {
            return title;
        }

        public void setTitle(String title) {
            this.title = title;
        }

        public int getCreateTime() {
            return createTime;
        }

        public void setCreateTime(int createTime) {
            this.createTime = createTime;
        }

        public int getExpireTime() {
            return expireTime;
        }

        public void setExpireTime(int expireTime) {
            this.expireTime = expireTime;
        }

        public int getStatus() {
            return status;
        }

        public void setStatus(int status) {
            this.status = status;
        }

        public String getId() {
            return id;
        }

        public void setId(String id) {
            this.id = id;
        }
    }
}
