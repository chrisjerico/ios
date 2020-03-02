package com.phoenix.lotterys.chat.entity;

import com.google.gson.JsonObject;
import com.google.gson.annotations.SerializedName;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

/**
 * @author : W
 * @e-mail :
 * @date : 2019/11/26 16:05
 * @description :
 */
public class ChatEntity {

    /**
     * code : 0
     * msg : success
     * data : [{"id":"3","messageCode":"1574056074_63408","chat_type":"1","data_type":"text","uid":"63408","dataId":"63409","ip":"","createTime":"1574056074","updateTime":"1574056074","shareBillFlag":false,"betFollowFlag":false,"isRead":"0","msg":"qqq","extfield":"","chatUid":"63409","avator":"https://cdn01.junbaozhaishanghang.com/upload/t003/customise/picture/chat/chatAvatar/51e8f8b5ac925bae951776401fdf8818.jpeg","isManager":true,"username":"王哈","usernameBak":"bob001","fullname":"","level":"1","betUrl":null,"t":"1574056074","time":"13:47:54","levelImg":""},{"id":"1","messageCode":"1573914452_63408","chat_type":"1","data_type":"text","uid":"63408","dataId":"63409","ip":"","createTime":"1573906592","updateTime":"1573906592","shareBillFlag":false,"betFollowFlag":false,"isRead":"0","msg":"qwer","extfield":"","chatUid":"63409","avator":"https://cdn01.junbaozhaishanghang.com/upload/t003/customise/picture/chat/chatAvatar/51e8f8b5ac925bae951776401fdf8818.jpeg","isManager":true,"username":"王哈","usernameBak":"bob001","fullname":"","level":"1","betUrl":null,"t":"1573906592","time":"20:16:32","levelImg":""},{"id":"2","messageCode":"1573914462_63408","chat_type":"1","data_type":"text","uid":"63408","dataId":"63409","ip":"","createTime":"1573906592","updateTime":"1573906592","shareBillFlag":false,"betFollowFlag":false,"isRead":"0","msg":"asdf","extfield":"","chatUid":"63409","avator":"https://cdn01.junbaozhaishanghang.com/upload/t003/customise/picture/chat/chatAvatar/51e8f8b5ac925bae951776401fdf8818.jpeg","isManager":true,"username":"王哈","usernameBak":"bob001","fullname":"","level":"1","betUrl":null,"t":"1573906592","time":"20:16:32","levelImg":""}]
     */

    private int code;
    private String msg;
    private List<DataBean> data;

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

    public List<DataBean> getData() {
        return data;
    }

    public void setData(List<DataBean> data) {
        this.data = data;
    }

    public static class DataBean implements Serializable {
        /**
         * id : 3
         * messageCode : 1574056074_63408
         * chat_type : 1
         * data_type : text
         * uid : 63408
         * dataId : 63409
         * ip :
         * createTime : 1574056074
         * updateTime : 1574056074
         * shareBillFlag : false
         * betFollowFlag : false
         * isRead : 0
         * msg : qqq
         * extfield :
         * chatUid : 63409
         * avator : https://cdn01.junbaozhaishanghang.com/upload/t003/customise/picture/chat/chatAvatar/51e8f8b5ac925bae951776401fdf8818.jpeg
         * isManager : true
         * username : 王哈
         * usernameBak : bob001
         * fullname :
         * level : 1
         * betUrl : null
         * t : 1574056074
         * time : 13:47:54
         * levelImg :
         */

        private String id;
        private String messageCode;
        private String chat_type;
        private String data_type;
        private String uid;
        private String dataId;
        private String ip;
        private String createTime;
        private String updateTime;
        private boolean shareBillFlag;
        private boolean betFollowFlag;
        private String isRead;
        private String msg;
        private String extfield;
        private String chatUid;
        private String avator;
        private boolean isManager;
        private String username;
        private String usernameBak;
        private String fullname;
        private String level;
        private long t;
        private String time;
        private String levelImg;
        private String roomId;
        private RedBagBean redBag;
        private JsonObject betUrl;
        private TicketListEntity.DataBean msgJson;

        private transient List<JsonObject> betList;

        public void convertBetList() {
            if (betFollowFlag && betList == null) {
                betList = new ArrayList<>();
                int totalNum = Integer.valueOf(betUrl.get("totalNums").getAsString());
                for (int i = 0; i < totalNum - 1; i++) {
                    JsonObject json = new JsonObject();

                    String head = "betBean[" + i + "]";

                    json.addProperty("name", betUrl.get(head + "[name]").getAsString());
                    json.addProperty("betNum", betUrl.get(head + "[betNum]").getAsString());
                    json.addProperty("playId", betUrl.get(head + "[playId]").getAsString());
                    json.addProperty("money", betUrl.get(head + "[money]").getAsString());
                    json.addProperty("betInfo", betUrl.get(head + "[betInfo]").getAsString());
                    json.addProperty("playIds", betUrl.get(head + "[playIds]").getAsString());
                    if (betUrl.get(head + "[odds]") != null) {
                        json.addProperty("odds", betUrl.get(head + "[odds]").getAsString());
                    }

                    betList.add(json);
                }
            }
        }

        public List<JsonObject> getBetList() {
            return betList;
        }

        public TicketListEntity.DataBean getMsgJson() {
            return msgJson;
        }

        public void setMsgJson(TicketListEntity.DataBean msgJson) {
            this.msgJson = msgJson;
        }

        public String getRoomId() {
            return roomId;
        }

        public void setRoomId(String roomId) {
            this.roomId = roomId;
        }

        private transient boolean showName;

        public boolean isManager() {
            return isManager;
        }

        public void setManager(boolean manager) {
            isManager = manager;
        }

        public boolean isShowName() {
            return showName;
        }

        public void setShowName(boolean showName) {
            this.showName = showName;
        }

        public String getId() {
            return id;
        }

        public void setId(String id) {
            this.id = id;
        }

        public String getMessageCode() {
            return messageCode;
        }

        public void setMessageCode(String messageCode) {
            this.messageCode = messageCode;
        }

        public String getChat_type() {
            return chat_type;
        }

        public void setChat_type(String chat_type) {
            this.chat_type = chat_type;
        }

        public String getData_type() {
            return data_type;
        }

        public void setData_type(String data_type) {
            this.data_type = data_type;
        }

        public String getUid() {
            return uid;
        }

        public void setUid(String uid) {
            this.uid = uid;
        }

        public String getDataId() {
            return dataId;
        }

        public void setDataId(String dataId) {
            this.dataId = dataId;
        }

        public String getIp() {
            return ip;
        }

        public void setIp(String ip) {
            this.ip = ip;
        }

        public String getCreateTime() {
            return createTime;
        }

        public void setCreateTime(String createTime) {
            this.createTime = createTime;
        }

        public String getUpdateTime() {
            return updateTime;
        }

        public void setUpdateTime(String updateTime) {
            this.updateTime = updateTime;
        }

        public boolean isShareBillFlag() {
            return shareBillFlag;
        }

        public void setShareBillFlag(boolean shareBillFlag) {
            this.shareBillFlag = shareBillFlag;
        }

        public boolean isBetFollowFlag() {
            return betFollowFlag;
        }

        public void setBetFollowFlag(boolean betFollowFlag) {
            this.betFollowFlag = betFollowFlag;
        }

        public String getIsRead() {
            return isRead;
        }

        public void setIsRead(String isRead) {
            this.isRead = isRead;
        }

        public String getMsg() {
            return msg;
        }

        public void setMsg(String msg) {
            this.msg = msg;
        }

        public String getExtfield() {
            return extfield;
        }

        public void setExtfield(String extfield) {
            this.extfield = extfield;
        }

        public String getChatUid() {
            return chatUid;
        }

        public void setChatUid(String chatUid) {
            this.chatUid = chatUid;
        }

        public String getAvator() {
            return avator;
        }

        public void setAvator(String avator) {
            this.avator = avator;
        }

        public boolean isIsManager() {
            return isManager;
        }

        public void setIsManager(boolean isManager) {
            this.isManager = isManager;
        }

        public String getUsername() {
            return username;
        }

        public void setUsername(String username) {
            this.username = username;
        }

        public String getUsernameBak() {
            return usernameBak;
        }

        public void setUsernameBak(String usernameBak) {
            this.usernameBak = usernameBak;
        }

        public String getFullname() {
            return fullname;
        }

        public void setFullname(String fullname) {
            this.fullname = fullname;
        }

        public String getLevel() {
            return level;
        }

        public void setLevel(String level) {
            this.level = level;
        }

        public JsonObject getBetUrl() {
            return betUrl;
        }

        public void setBetUrl(JsonObject betUrl) {
            this.betUrl = betUrl;
        }

        public long getT() {
            return t;
        }

        public void setT(long t) {
            this.t = t;
        }

        public String getTime() {
            return time;
        }

        public void setTime(String time) {
            this.time = time;
        }

        public String getLevelImg() {
            return levelImg;
        }

        public void setLevelImg(String levelImg) {
            this.levelImg = levelImg;
        }

        public RedBagBean getRedBag() {
            return redBag;
        }

        public void setRedBag(RedBagBean redBag) {
            this.redBag = redBag;
        }

        public static class RedBagBean implements Serializable {

            /**
             * roomId : 4
             * uid : 63408
             * title : 恭喜发财，大吉大利
             * genre : 1
             * amount : 1
             * quantity : 1
             * createTime : 1575088470
             * expireTime : 1575088770
             * updateTime : 1575088470
             * status : 1
             * id : 124
             * grabList : []
             */

            private String roomId;
            private String uid;
            private String title;
            private String genre;
            private String amount;
            private int quantity;
            private int createTime;
            private int expireTime;
            private int updateTime;
            private int status;
            private String id;
            @SerializedName("is_grab")
            private int isGrab;
            @SerializedName("grab_amount")
            private String grabAmount;
            private List<GrabBean> grabList;

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

            public int getIsGrab() {
                return isGrab;
            }

            public void setIsGrab(int isGrab) {
                this.isGrab = isGrab;
            }

            public String getGrabAmount() {
                return grabAmount;
            }

            public void setGrabAmount(String grabAmount) {
                this.grabAmount = grabAmount;
            }

            public List<GrabBean> getGrabList() {
                return grabList;
            }

            public void setGrabList(List<GrabBean> grabList) {
                this.grabList = grabList;
            }

            public static class GrabBean implements Serializable {

                /**
                 * redBagId : 264
                 * miniRedBagAmount : 4
                 * miniRedBagId : 1
                 * isMine : false
                 * isMax : true
                 * time : 1575602696
                 * uid : 63408
                 * nickname : 王哈
                 * avatar : https://cdn01.junbaozhaishanghang.com/upload/t003/customise/picture/chat/chatAvatar/51e8f8b5ac925bae951776401fdf8818.jpeg
                 * date : 11:24:56
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
                private int status;

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
}
