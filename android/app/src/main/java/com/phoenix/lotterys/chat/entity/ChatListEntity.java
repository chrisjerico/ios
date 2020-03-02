package com.phoenix.lotterys.chat.entity;

import com.google.gson.Gson;
import com.google.gson.JsonArray;
import com.google.gson.JsonDeserializationContext;
import com.google.gson.JsonDeserializer;
import com.google.gson.JsonElement;
import com.google.gson.JsonParseException;
import com.google.gson.annotations.SerializedName;

import java.io.Serializable;
import java.lang.reflect.Type;
import java.util.List;

/**
 * @author : W
 * @e-mail :
 * @date : 2019/11/26 10:34
 * @description :
 */
public class ChatListEntity {

    /**
     * code : 0
     * msg : success
     * data : {"conversationList":[{"roomName":"香港六合彩","roomId":6,"unreadCount":"15","memberCount":9,"type":1,"sort":2},{"roomName":"极速六合彩","roomId":10,"unreadCount":0,"memberCount":4,"type":1,"sort":1},{"class":1,"roomName":"主房间","roomId":0,"unreadCount":"113","memberCount":24,"type":1,"sort":1},{"roomName":"幸运飞艇","roomId":9,"unreadCount":0,"memberCount":3,"type":1,"sort":1},{"roomName":"1号雷区","roomId":8,"unreadCount":"4","memberCount":8,"type":1,"sort":1},{"roomName":"测试1","roomId":4,"unreadCount":"10","memberCount":6,"type":1,"sort":1},{"roomName":"测试2","roomId":5,"unreadCount":"5","memberCount":8,"type":1,"sort":1},{"roomName":"香港跑马","roomId":11,"unreadCount":0,"memberCount":3,"type":1,"sort":0},{"type":2,"unreadCount":0,"uid":63408,"username":"bob001","nickname":"王哈"},{"type":2,"unreadCount":0,"uid":63446,"username":"ouyang001","nickname":"嘿嘿"},{"type":2,"unreadCount":0,"uid":63451,"username":"ouyang004","nickname":"ou****4"},{"type":3,"unreadCount":0,"uid":63409,"username":"bob002","nickname":"bo****2"}]}
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
        private List<ConversationListBean> conversationList;

        public List<ConversationListBean> getConversationList() {
            return conversationList;
        }

        public void setConversationList(List<ConversationListBean> conversationList) {
            this.conversationList = conversationList;
        }

        public static class ConversationListBean implements Serializable {
            /**
             * roomName : 香港六合彩
             * roomId : 6
             * unreadCount : 15
             * memberCount : 9
             * type : 1
             * sort : 2
             * class : 1
             * uid : 63408
             * username : bob001
             * nickname : 王哈
             */

            private String roomName;
            private int roomId;
            private int unreadCount;
            private int memberCount;
            private int type;
            private int sort;
            @SerializedName("class")
            private int classX;
            private int uid;
            private String username;
            private String nickname;
            private RedBagSetting chatRedBagSetting;
            private int isMine;
            private String minAmount;
            private String maxAmount;

            private transient LastMessageInfo lastMessageInfo;

            public String getRoomName() {
                return roomName;
            }

            public void setRoomName(String roomName) {
                this.roomName = roomName;
            }

            public int getRoomId() {
                return roomId;
            }

            public void setRoomId(int roomId) {
                this.roomId = roomId;
            }

            public int getUnreadCount() {
                return unreadCount;
            }

            public void setUnreadCount(int unreadCount) {
                this.unreadCount = unreadCount;
            }

            public int getMemberCount() {
                return memberCount;
            }

            public void setMemberCount(int memberCount) {
                this.memberCount = memberCount;
            }

            public int getType() {
                return type;
            }

            public void setType(int type) {
                this.type = type;
            }

            public int getSort() {
                return sort;
            }

            public void setSort(int sort) {
                this.sort = sort;
            }

            public int getClassX() {
                return classX;
            }

            public void setClassX(int classX) {
                this.classX = classX;
            }

            public int getUid() {
                return uid;
            }

            public void setUid(int uid) {
                this.uid = uid;
            }

            public String getUsername() {
                return username;
            }

            public void setUsername(String username) {
                this.username = username;
            }

            public String getNickname() {
                return nickname;
            }

            public void setNickname(String nickname) {
                this.nickname = nickname;
            }

            public RedBagSetting getChatRedBagSetting() {
                return chatRedBagSetting;
            }

            public void setChatRedBagSetting(RedBagSetting chatRedBagSetting) {
                this.chatRedBagSetting = chatRedBagSetting;
            }

            public int getIsMine() {
                return isMine;
            }

            public void setIsMine(int isMine) {
                this.isMine = isMine;
            }

            public String getMinAmount() {
                return minAmount;
            }

            public void setMinAmount(String minAmount) {
                this.minAmount = minAmount;
            }

            public String getMaxAmount() {
                return maxAmount;
            }

            public void setMaxAmount(String maxAmount) {
                this.maxAmount = maxAmount;
            }

            public LastMessageInfo getLastMessageInfo() {
                return lastMessageInfo;
            }

            public void setLastMessageInfo(LastMessageInfo lastMessageInfo) {
                this.lastMessageInfo = lastMessageInfo;
            }

            public static class LastMessageInfo implements Serializable {

                /**
                 * code : 0001
                 * messageCode : 1575792697_63408
                 * roomId : 10
                 * uid : 63408
                 * time : 16:11:37
                 * isManager : true
                 * ip : 47.56.126.240
                 * t : 1575792697
                 * chat_type : 0
                 * data_type : text
                 * msg : [em_6]
                 * avator : https://cdn01.junbaozhaishanghang.com/upload/t003/customise/picture/chat/chatAvatar/51e8f8b5ac925bae951776401fdf8818.jpeg
                 * username : 王哈
                 * usernameBak : bob001
                 * fullname :
                 * levelImg :
                 * level : 0
                 */

                private String code;
                private String messageCode;
                private String roomId;
                private String uid;
                private String time;
                private boolean isManager;
                private String ip;
                private int t;
                private int chat_type;
                private String data_type;
                private String msg;
                private String avator;
                private String username;
                private String usernameBak;
                private String fullname;
                private String levelImg;
                private String level;
                private boolean betFollowFlag;

                @Override
                public String toString() {
                    return "LastMessageInfo{" +
                            "code='" + code + '\'' +
                            ", messageCode='" + messageCode + '\'' +
                            ", roomId='" + roomId + '\'' +
                            ", uid='" + uid + '\'' +
                            ", time='" + time + '\'' +
                            ", isManager=" + isManager +
                            ", ip='" + ip + '\'' +
                            ", t=" + t +
                            ", chat_type=" + chat_type +
                            ", data_type='" + data_type + '\'' +
                            ", msg='" + msg + '\'' +
                            ", avator='" + avator + '\'' +
                            ", username='" + username + '\'' +
                            ", usernameBak='" + usernameBak + '\'' +
                            ", fullname='" + fullname + '\'' +
                            ", levelImg='" + levelImg + '\'' +
                            ", level='" + level + '\'' +
                            ", betFollowFlag=" + betFollowFlag +
                            '}';
                }

                public String getCode() {
                    return code;
                }

                public void setCode(String code) {
                    this.code = code;
                }

                public String getMessageCode() {
                    return messageCode;
                }

                public void setMessageCode(String messageCode) {
                    this.messageCode = messageCode;
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

                public String getTime() {
                    return time;
                }

                public void setTime(String time) {
                    this.time = time;
                }

                public boolean isIsManager() {
                    return isManager;
                }

                public void setIsManager(boolean isManager) {
                    this.isManager = isManager;
                }

                public String getIp() {
                    return ip;
                }

                public void setIp(String ip) {
                    this.ip = ip;
                }

                public int getT() {
                    return t;
                }

                public void setT(int t) {
                    this.t = t;
                }

                public int getChat_type() {
                    return chat_type;
                }

                public void setChat_type(int chat_type) {
                    this.chat_type = chat_type;
                }

                public String getData_type() {
                    return data_type;
                }

                public void setData_type(String data_type) {
                    this.data_type = data_type;
                }

                public String getMsg() {
                    return msg;
                }

                public void setMsg(String msg) {
                    this.msg = msg;
                }

                public String getAvator() {
                    return avator;
                }

                public void setAvator(String avator) {
                    this.avator = avator;
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

                public String getLevelImg() {
                    return levelImg;
                }

                public void setLevelImg(String levelImg) {
                    this.levelImg = levelImg;
                }

                public String getLevel() {
                    return level;
                }

                public void setLevel(String level) {
                    this.level = level;
                }

                public boolean isManager() {
                    return isManager;
                }

                public void setManager(boolean manager) {
                    isManager = manager;
                }

                public boolean isBetFollowFlag() {
                    return betFollowFlag;
                }

                public void setBetFollowFlag(boolean betFollowFlag) {
                    this.betFollowFlag = betFollowFlag;
                }
            }

            public static class RedBagSetting implements Serializable {
                private int isRedBag;
                private int maxAmount;
                private int minAmount;
                private int maxQuantity;

                public int getIsRedBag() {
                    return isRedBag;
                }

                public void setIsRedBag(int isRedBag) {
                    this.isRedBag = isRedBag;
                }

                public int getMaxAmount() {
                    return maxAmount;
                }

                public void setMaxAmount(int maxAmount) {
                    this.maxAmount = maxAmount;
                }

                public int getMinAmount() {
                    return minAmount;
                }

                public void setMinAmount(int minAmount) {
                    this.minAmount = minAmount;
                }

                public int getMaxQuantity() {
                    return maxQuantity;
                }

                public void setMaxQuantity(int maxQuantity) {
                    this.maxQuantity = maxQuantity;
                }
            }
        }
    }

    public static class Adapter implements JsonDeserializer<ChatListEntity> {
        @Override
        public ChatListEntity deserialize(JsonElement json, Type typeOfT, JsonDeserializationContext context) throws JsonParseException {
            ChatListEntity entity = new Gson().fromJson(json, typeOfT);
            try {
                JsonArray jsonArray = json.getAsJsonObject().get("data").getAsJsonObject().get("conversationList").getAsJsonArray();
                for (int i = 0; i < jsonArray.size(); i++) {
                    JsonElement lastMessageJson = jsonArray.get(i).getAsJsonObject().get("lastMessageInfo");
                    if (lastMessageJson != null && lastMessageJson.isJsonObject()) {
                        entity.getData().getConversationList().get(i).setLastMessageInfo(new Gson().fromJson(lastMessageJson, ChatListEntity.DataBean.ConversationListBean.LastMessageInfo.class));

                    }
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
            return entity;
        }
    }
}
