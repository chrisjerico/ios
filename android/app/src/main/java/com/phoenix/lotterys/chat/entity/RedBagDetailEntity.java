package com.phoenix.lotterys.chat.entity;

import java.util.List;

/**
 * @author : W
 * @e-mail :
 * @date : 2019/12/06 15:53
 * @description :
 */
public class RedBagDetailEntity {

    /**
     * code : 0
     * msg : success
     * data : {"roomId":"4","uid":"63408","title":"恭喜发财，大吉大利","genre":"1","amount":"4","quantity":1,"createDmlMultiple":"1","grabDmlMultiple":"10","grabLevels":"","createTime":1575614671,"expireTime":1575614971,"updateTime":1575614672,"status":2,"id":"282","is_grab":1,"grab_amount":"4","grabList":[{"redBagId":282,"miniRedBagAmount":"4","miniRedBagId":1,"isMine":false,"isMax":true,"time":1575614672,"uid":"63408","nickname":"王哈","avatar":"https://cdn01.junbaozhaishanghang.com/upload/t003/customise/picture/chat/chatAvatar/51e8f8b5ac925bae951776401fdf8818.jpeg","date":"14:44:32"}]}
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
         * roomId : 4
         * uid : 63408
         * title : 恭喜发财，大吉大利
         * genre : 1
         * amount : 4
         * quantity : 1
         * createDmlMultiple : 1
         * grabDmlMultiple : 10
         * grabLevels :
         * createTime : 1575614671
         * expireTime : 1575614971
         * updateTime : 1575614672
         * status : 2
         * id : 282
         * is_grab : 1
         * grab_amount : 4
         * grabList : [{"redBagId":282,"miniRedBagAmount":"4","miniRedBagId":1,"isMine":false,"isMax":true,"time":1575614672,"uid":"63408","nickname":"王哈","avatar":"https://cdn01.junbaozhaishanghang.com/upload/t003/customise/picture/chat/chatAvatar/51e8f8b5ac925bae951776401fdf8818.jpeg","date":"14:44:32"}]
         */

        private String roomId;
        private String uid;
        private String title;
        private String genre;
        private String amount;
        private int quantity;
        private String createDmlMultiple;
        private String grabDmlMultiple;
        private String grabLevels;
        private int createTime;
        private int expireTime;
        private int updateTime;
        private int status;
        private String id;
        private int is_grab;
        private String grab_amount;
        private List<GrabListBean> grabList;

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

        public String getTitle() {
            return title;
        }

        public void setTitle(String title) {
            this.title = title;
        }

        public String getGenre() {
            return genre;
        }

        public void setGenre(String genre) {
            this.genre = genre;
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

        public String getCreateDmlMultiple() {
            return createDmlMultiple;
        }

        public void setCreateDmlMultiple(String createDmlMultiple) {
            this.createDmlMultiple = createDmlMultiple;
        }

        public String getGrabDmlMultiple() {
            return grabDmlMultiple;
        }

        public void setGrabDmlMultiple(String grabDmlMultiple) {
            this.grabDmlMultiple = grabDmlMultiple;
        }

        public String getGrabLevels() {
            return grabLevels;
        }

        public void setGrabLevels(String grabLevels) {
            this.grabLevels = grabLevels;
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

        public int getUpdateTime() {
            return updateTime;
        }

        public void setUpdateTime(int updateTime) {
            this.updateTime = updateTime;
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

        public int getIs_grab() {
            return is_grab;
        }

        public void setIs_grab(int is_grab) {
            this.is_grab = is_grab;
        }

        public String getGrab_amount() {
            return grab_amount;
        }

        public void setGrab_amount(String grab_amount) {
            this.grab_amount = grab_amount;
        }

        public List<GrabListBean> getGrabList() {
            return grabList;
        }

        public void setGrabList(List<GrabListBean> grabList) {
            this.grabList = grabList;
        }

        public static class GrabListBean {
            /**
             * redBagId : 282
             * miniRedBagAmount : 4
             * miniRedBagId : 1
             * isMine : false
             * isMax : true
             * time : 1575614672
             * uid : 63408
             * nickname : 王哈
             * avatar : https://cdn01.junbaozhaishanghang.com/upload/t003/customise/picture/chat/chatAvatar/51e8f8b5ac925bae951776401fdf8818.jpeg
             * date : 14:44:32
             */

            private int redBagId;
            private String miniRedBagAmount;
            private int miniRedBagId;
            private boolean isMine;
            private boolean isMax;
            private int time;
            private String uid;
            private String nickname;
            private String avatar;
            private String date;

            public int getRedBagId() {
                return redBagId;
            }

            public void setRedBagId(int redBagId) {
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

            public String getNickname() {
                return nickname;
            }

            public void setNickname(String nickname) {
                this.nickname = nickname;
            }

            public String getAvatar() {
                return avatar;
            }

            public void setAvatar(String avatar) {
                this.avatar = avatar;
            }

            public String getDate() {
                return date;
            }

            public void setDate(String date) {
                this.date = date;
            }
        }
    }
}
