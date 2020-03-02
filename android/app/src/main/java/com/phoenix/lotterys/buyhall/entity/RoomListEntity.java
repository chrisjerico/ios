package com.phoenix.lotterys.buyhall.entity;

import java.util.List;

/**
 * @author : Wu
 * @e-mail : wu_developer@outlook.com
 * @date : 2020/01/07 14:17
 * @description :
 */
public class RoomListEntity {

    /**
     * code : 0
     * msg : success
     * data : {"username":"wu0001","nickname":"wu****1","uid":"503384","testFlag":"0","chatAry":[{"roomId":"0","roomName":"聊天室","password":null,"isChatBan":false,"typeId":"0","sortId":-1,"chatRedBagSetting":{"isRedBag":1,"maxAmount":"100","minAmount":"1","maxQuantity":"30"}},{"roomId":"21","roomName":"极速飞艇","password":null,"isChatBan":false,"typeId":"179","sortId":3,"chatRedBagSetting":{"isRedBag":0,"maxAmount":0,"minAmount":0,"maxQuantity":0}},{"roomId":"22","roomName":"极速时时彩","password":null,"isChatBan":false,"typeId":"178","sortId":4,"chatRedBagSetting":{"isRedBag":0,"maxAmount":0,"minAmount":0,"maxQuantity":0}},{"roomId":"23","roomName":"一分六合彩","password":null,"isChatBan":false,"typeId":"184","sortId":1,"chatRedBagSetting":{"isRedBag":0,"maxAmount":0,"minAmount":0,"maxQuantity":0}},{"roomId":"24","roomName":"一分快三","password":null,"isChatBan":false,"typeId":"188","sortId":2,"chatRedBagSetting":{"isRedBag":0,"maxAmount":0,"minAmount":0,"maxQuantity":0}},{"roomId":"26","roomName":"五分赛车","password":null,"isChatBan":false,"typeId":"199","sortId":5,"chatRedBagSetting":{"isRedBag":0,"maxAmount":0,"minAmount":0,"maxQuantity":0}},{"roomId":"27","roomName":"五分六合彩","password":null,"isChatBan":false,"typeId":"197","sortId":6,"chatRedBagSetting":{"isRedBag":0,"maxAmount":0,"minAmount":0,"maxQuantity":0}},{"roomId":"28","roomName":"幸运飞艇","password":null,"isChatBan":false,"typeId":"55","sortId":7,"chatRedBagSetting":{"isRedBag":0,"maxAmount":0,"minAmount":0,"maxQuantity":0}}],"announce":[{"title":"带上身边人发财","content":"加QQ 2546917990 介绍会员 送彩金最高能领99999彩金！加QQ 630550626 每期提前领取六合资料！"}],"ip":"47.56.126.240","token":"a2bff81b4caccc1c4038697f55a02120","tokenImg":"a54c25ab116c62f7a515f0b50df9e8c3","tokenTxt":"83074fe496b4fccd753c7b8c9727ecd0","level":1,"isManager":false,"isAllBan":false,"isPicBan":"1","isShareBill":"1","roomName":"聊天室","placeholderFlag":true,"placeholder":"发言条件：近30天打码量不少于100元"}
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
         * username : wu0001
         * nickname : wu****1
         * uid : 503384
         * testFlag : 0
         * chatAry : [{"roomId":"0","roomName":"聊天室","password":null,"isChatBan":false,"typeId":"0","sortId":-1,"chatRedBagSetting":{"isRedBag":1,"maxAmount":"100","minAmount":"1","maxQuantity":"30"}},{"roomId":"21","roomName":"极速飞艇","password":null,"isChatBan":false,"typeId":"179","sortId":3,"chatRedBagSetting":{"isRedBag":0,"maxAmount":0,"minAmount":0,"maxQuantity":0}},{"roomId":"22","roomName":"极速时时彩","password":null,"isChatBan":false,"typeId":"178","sortId":4,"chatRedBagSetting":{"isRedBag":0,"maxAmount":0,"minAmount":0,"maxQuantity":0}},{"roomId":"23","roomName":"一分六合彩","password":null,"isChatBan":false,"typeId":"184","sortId":1,"chatRedBagSetting":{"isRedBag":0,"maxAmount":0,"minAmount":0,"maxQuantity":0}},{"roomId":"24","roomName":"一分快三","password":null,"isChatBan":false,"typeId":"188","sortId":2,"chatRedBagSetting":{"isRedBag":0,"maxAmount":0,"minAmount":0,"maxQuantity":0}},{"roomId":"26","roomName":"五分赛车","password":null,"isChatBan":false,"typeId":"199","sortId":5,"chatRedBagSetting":{"isRedBag":0,"maxAmount":0,"minAmount":0,"maxQuantity":0}},{"roomId":"27","roomName":"五分六合彩","password":null,"isChatBan":false,"typeId":"197","sortId":6,"chatRedBagSetting":{"isRedBag":0,"maxAmount":0,"minAmount":0,"maxQuantity":0}},{"roomId":"28","roomName":"幸运飞艇","password":null,"isChatBan":false,"typeId":"55","sortId":7,"chatRedBagSetting":{"isRedBag":0,"maxAmount":0,"minAmount":0,"maxQuantity":0}}]
         * announce : [{"title":"带上身边人发财","content":"加QQ 2546917990 介绍会员 送彩金最高能领99999彩金！加QQ 630550626 每期提前领取六合资料！"}]
         * ip : 47.56.126.240
         * token : a2bff81b4caccc1c4038697f55a02120
         * tokenImg : a54c25ab116c62f7a515f0b50df9e8c3
         * tokenTxt : 83074fe496b4fccd753c7b8c9727ecd0
         * level : 1
         * isManager : false
         * isAllBan : false
         * isPicBan : 1
         * isShareBill : 1
         * roomName : 聊天室
         * placeholderFlag : true
         * placeholder : 发言条件：近30天打码量不少于100元
         */

        private String username;
        private String nickname;
        private String uid;
        private String testFlag;
        private String ip;
        private String token;
        private String tokenImg;
        private String tokenTxt;
        private int level;
        private boolean isManager;
        private boolean isAllBan;
        private String isPicBan;
        private String isShareBill;
        private String roomName;
        private boolean placeholderFlag;
        private String placeholder;
        private List<ChatAryBean> chatAry;
        private List<AnnounceBean> announce;

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

        public String getUid() {
            return uid;
        }

        public void setUid(String uid) {
            this.uid = uid;
        }

        public String getTestFlag() {
            return testFlag;
        }

        public void setTestFlag(String testFlag) {
            this.testFlag = testFlag;
        }

        public String getIp() {
            return ip;
        }

        public void setIp(String ip) {
            this.ip = ip;
        }

        public String getToken() {
            return token;
        }

        public void setToken(String token) {
            this.token = token;
        }

        public String getTokenImg() {
            return tokenImg;
        }

        public void setTokenImg(String tokenImg) {
            this.tokenImg = tokenImg;
        }

        public String getTokenTxt() {
            return tokenTxt;
        }

        public void setTokenTxt(String tokenTxt) {
            this.tokenTxt = tokenTxt;
        }

        public int getLevel() {
            return level;
        }

        public void setLevel(int level) {
            this.level = level;
        }

        public boolean isIsManager() {
            return isManager;
        }

        public void setIsManager(boolean isManager) {
            this.isManager = isManager;
        }

        public boolean isIsAllBan() {
            return isAllBan;
        }

        public void setIsAllBan(boolean isAllBan) {
            this.isAllBan = isAllBan;
        }

        public String getIsPicBan() {
            return isPicBan;
        }

        public void setIsPicBan(String isPicBan) {
            this.isPicBan = isPicBan;
        }

        public String getIsShareBill() {
            return isShareBill;
        }

        public void setIsShareBill(String isShareBill) {
            this.isShareBill = isShareBill;
        }

        public String getRoomName() {
            return roomName;
        }

        public void setRoomName(String roomName) {
            this.roomName = roomName;
        }

        public boolean isPlaceholderFlag() {
            return placeholderFlag;
        }

        public void setPlaceholderFlag(boolean placeholderFlag) {
            this.placeholderFlag = placeholderFlag;
        }

        public String getPlaceholder() {
            return placeholder;
        }

        public void setPlaceholder(String placeholder) {
            this.placeholder = placeholder;
        }

        public List<ChatAryBean> getChatAry() {
            return chatAry;
        }

        public void setChatAry(List<ChatAryBean> chatAry) {
            this.chatAry = chatAry;
        }

        public List<AnnounceBean> getAnnounce() {
            return announce;
        }

        public void setAnnounce(List<AnnounceBean> announce) {
            this.announce = announce;
        }

        public static class ChatAryBean implements Cloneable{
            /**
             * roomId : 0
             * roomName : 聊天室
             * password : null
             * isChatBan : false
             * typeId : 0
             * sortId : -1
             * chatRedBagSetting : {"isRedBag":1,"maxAmount":"100","minAmount":"1","maxQuantity":"30"}
             */

            private String roomId;
            private String roomName;
            private String password;
            private boolean isChatBan;
            private String typeId;
            private int sortId;
            private String isMine;
            private ChatRedBagSettingBean chatRedBagSetting;

            @Override
            public Object clone() throws CloneNotSupportedException {
                return super.clone();
            }

            public String getIsMine() {
                return isMine;
            }

            public void setIsMine(String isMine) {
                this.isMine = isMine;
            }

            public String getRoomId() {
                return roomId;
            }

            public void setRoomId(String roomId) {
                this.roomId = roomId;
            }

            public String getRoomName() {
                return roomName;
            }

            public void setRoomName(String roomName) {
                this.roomName = roomName;
            }

            public String getPassword() {
                return password;
            }

            public void setPassword(String password) {
                this.password = password;
            }

            public boolean isIsChatBan() {
                return isChatBan;
            }

            public void setIsChatBan(boolean isChatBan) {
                this.isChatBan = isChatBan;
            }

            public String getTypeId() {
                return typeId;
            }

            public void setTypeId(String typeId) {
                this.typeId = typeId;
            }

            public int getSortId() {
                return sortId;
            }

            public void setSortId(int sortId) {
                this.sortId = sortId;
            }

            public ChatRedBagSettingBean getChatRedBagSetting() {
                return chatRedBagSetting;
            }

            public void setChatRedBagSetting(ChatRedBagSettingBean chatRedBagSetting) {
                this.chatRedBagSetting = chatRedBagSetting;
            }

            public static class ChatRedBagSettingBean {
                /**
                 * isRedBag : 1
                 * maxAmount : 100
                 * minAmount : 1
                 * maxQuantity : 30
                 */

                private int isRedBag;
                private String maxAmount;
                private String minAmount;
                private String maxQuantity;

                public int getIsRedBag() {
                    return isRedBag;
                }

                public void setIsRedBag(int isRedBag) {
                    this.isRedBag = isRedBag;
                }

                public String getMaxAmount() {
                    return maxAmount;
                }

                public void setMaxAmount(String maxAmount) {
                    this.maxAmount = maxAmount;
                }

                public String getMinAmount() {
                    return minAmount;
                }

                public void setMinAmount(String minAmount) {
                    this.minAmount = minAmount;
                }

                public String getMaxQuantity() {
                    return maxQuantity;
                }

                public void setMaxQuantity(String maxQuantity) {
                    this.maxQuantity = maxQuantity;
                }
            }
        }

        public static class AnnounceBean {
            /**
             * title : 带上身边人发财
             * content : 加QQ 2546917990 介绍会员 送彩金最高能领99999彩金！加QQ 630550626 每期提前领取六合资料！
             */

            private String title;
            private String content;

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
        }
    }
}
