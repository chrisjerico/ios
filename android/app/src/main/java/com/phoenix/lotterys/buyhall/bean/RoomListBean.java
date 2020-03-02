package com.phoenix.lotterys.buyhall.bean;

import java.util.List;

/**
 * Greated by Luke
 * on 2020/2/5
 */
public class RoomListBean {


    /**
     * code : 0
     * msg : success
     * data : {"username":"flb2019","nickname":"fl****9","uid":"465710","testFlag":"0","chatAry":[{"roomId":"0","roomName":"彩壹万互动娱乐空间站","password":null,"isChatBan":false,"typeId":"0","sortId":-1,"chatRedBagSetting":{"isRedBag":1,"maxAmount":"100","minAmount":"1","maxQuantity":"999"},"isMine":0,"minAmount":0,"maxAmount":0,"oddsRate":0,"quantity":"6"},{"roomId":"2","roomName":"菲律宾5分赛车","password":null,"isChatBan":true,"typeId":"0","sortId":1,"chatRedBagSetting":{"isRedBag":0,"maxAmount":0,"minAmount":0,"maxQuantity":0},"isMine":0,"minAmount":"0.00","maxAmount":"0.00","oddsRate":"0.00","quantity":0},{"roomId":"3","roomName":"菲律宾5分时彩","password":null,"isChatBan":true,"typeId":"0","sortId":2,"chatRedBagSetting":{"isRedBag":0,"maxAmount":0,"minAmount":0,"maxQuantity":0},"isMine":0,"minAmount":"0.00","maxAmount":"0.00","oddsRate":"0.00","quantity":0},{"roomId":"4","roomName":"五分快三","password":null,"isChatBan":true,"typeId":"0","sortId":3,"chatRedBagSetting":{"isRedBag":0,"maxAmount":0,"minAmount":0,"maxQuantity":0},"isMine":0,"minAmount":"0.00","maxAmount":"0.00","oddsRate":"0.00","quantity":0},{"roomId":"5","roomName":"幸运飞艇","password":null,"isChatBan":true,"typeId":"0","sortId":5,"chatRedBagSetting":{"isRedBag":0,"maxAmount":0,"minAmount":0,"maxQuantity":0},"isMine":0,"minAmount":"0.00","maxAmount":"0.00","oddsRate":"0.00","quantity":0},{"roomId":"8","roomName":"六合资料","password":null,"isChatBan":true,"typeId":"0","sortId":6,"chatRedBagSetting":{"isRedBag":0,"maxAmount":0,"minAmount":0,"maxQuantity":0},"isMine":0,"minAmount":"0.00","maxAmount":"0.00","oddsRate":"0.00","quantity":0}],"announce":[{"title":"彩壹万娱乐集团","content":"号外！号外！每天聊天室将招募各种彩票.真人视讯.棋牌.电子.体育.计划大神高手带计划，平台将送丰厚彩金或大礼包！  "}],"ip":"49.157.2.55","token":"15958e71716ccf22097815c311cbb936","tokenImg":"56c9520d0c9a05f25130b4edc505c531","tokenTxt":"f70dfd965ca931d6f2aab02a997d20e0","level":1,"isManager":false,"isAllBan":false,"isPicBan":"1","isShareBill":"1","roomName":"彩壹万互动娱乐空间站","placeholderFlag":false,"placeholder":"禁言中（可私聊管理员）","sendRedBagUserType":"manager,trial,player","showRedBagDetailConfig":"totalNum,totalAmount,remainingNum,otherUserGetMoney","titleStatus":1,"redBagMineRule":""}
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
         * username : flb2019
         * nickname : fl****9
         * uid : 465710
         * testFlag : 0
         * chatAry : [{"roomId":"0","roomName":"彩壹万互动娱乐空间站","password":null,"isChatBan":false,"typeId":"0","sortId":-1,"chatRedBagSetting":{"isRedBag":1,"maxAmount":"100","minAmount":"1","maxQuantity":"999"},"isMine":0,"minAmount":0,"maxAmount":0,"oddsRate":0,"quantity":"6"},{"roomId":"2","roomName":"菲律宾5分赛车","password":null,"isChatBan":true,"typeId":"0","sortId":1,"chatRedBagSetting":{"isRedBag":0,"maxAmount":0,"minAmount":0,"maxQuantity":0},"isMine":0,"minAmount":"0.00","maxAmount":"0.00","oddsRate":"0.00","quantity":0},{"roomId":"3","roomName":"菲律宾5分时彩","password":null,"isChatBan":true,"typeId":"0","sortId":2,"chatRedBagSetting":{"isRedBag":0,"maxAmount":0,"minAmount":0,"maxQuantity":0},"isMine":0,"minAmount":"0.00","maxAmount":"0.00","oddsRate":"0.00","quantity":0},{"roomId":"4","roomName":"五分快三","password":null,"isChatBan":true,"typeId":"0","sortId":3,"chatRedBagSetting":{"isRedBag":0,"maxAmount":0,"minAmount":0,"maxQuantity":0},"isMine":0,"minAmount":"0.00","maxAmount":"0.00","oddsRate":"0.00","quantity":0},{"roomId":"5","roomName":"幸运飞艇","password":null,"isChatBan":true,"typeId":"0","sortId":5,"chatRedBagSetting":{"isRedBag":0,"maxAmount":0,"minAmount":0,"maxQuantity":0},"isMine":0,"minAmount":"0.00","maxAmount":"0.00","oddsRate":"0.00","quantity":0},{"roomId":"8","roomName":"六合资料","password":null,"isChatBan":true,"typeId":"0","sortId":6,"chatRedBagSetting":{"isRedBag":0,"maxAmount":0,"minAmount":0,"maxQuantity":0},"isMine":0,"minAmount":"0.00","maxAmount":"0.00","oddsRate":"0.00","quantity":0}]
         * announce : [{"title":"彩壹万娱乐集团","content":"号外！号外！每天聊天室将招募各种彩票.真人视讯.棋牌.电子.体育.计划大神高手带计划，平台将送丰厚彩金或大礼包！  "}]
         * ip : 49.157.2.55
         * token : 15958e71716ccf22097815c311cbb936
         * tokenImg : 56c9520d0c9a05f25130b4edc505c531
         * tokenTxt : f70dfd965ca931d6f2aab02a997d20e0
         * level : 1
         * isManager : false
         * isAllBan : false
         * isPicBan : 1
         * isShareBill : 1
         * roomName : 彩壹万互动娱乐空间站
         * placeholderFlag : false
         * placeholder : 禁言中（可私聊管理员）
         * sendRedBagUserType : manager,trial,player
         * showRedBagDetailConfig : totalNum,totalAmount,remainingNum,otherUserGetMoney
         * titleStatus : 1
         * redBagMineRule :
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
        private String sendRedBagUserType;
        private String showRedBagDetailConfig;
        private int titleStatus;
        private String redBagMineRule;
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

        public String getSendRedBagUserType() {
            return sendRedBagUserType;
        }

        public void setSendRedBagUserType(String sendRedBagUserType) {
            this.sendRedBagUserType = sendRedBagUserType;
        }

        public String getShowRedBagDetailConfig() {
            return showRedBagDetailConfig;
        }

        public void setShowRedBagDetailConfig(String showRedBagDetailConfig) {
            this.showRedBagDetailConfig = showRedBagDetailConfig;
        }

        public int getTitleStatus() {
            return titleStatus;
        }

        public void setTitleStatus(int titleStatus) {
            this.titleStatus = titleStatus;
        }

        public String getRedBagMineRule() {
            return redBagMineRule;
        }

        public void setRedBagMineRule(String redBagMineRule) {
            this.redBagMineRule = redBagMineRule;
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
             * roomName : 彩壹万互动娱乐空间站
             * password : null
             * isChatBan : false
             * typeId : 0
             * sortId : -1
             * chatRedBagSetting : {"isRedBag":1,"maxAmount":"100","minAmount":"1","maxQuantity":"999"}
             * isMine : 0
             * minAmount : 0
             * maxAmount : 0
             * oddsRate : 0
             * quantity : 6
             */

            private String roomId;
            private String roomName;
            private String password;
            private boolean isChatBan;
            private boolean isShareBet;
            private boolean isShareBill;
            private String typeId;
            private int sortId;
            private ChatRedBagSettingBean chatRedBagSetting;
            private String isMine;
            private String minAmount;
            private String maxAmount;
            private String oddsRate;
            private String quantity;

            @Override
            public Object clone() throws CloneNotSupportedException {
                return super.clone();
            }

            public boolean isShareBet() {
                return isShareBet;
            }

            public void setShareBet(boolean shareBet) {
                isShareBet = shareBet;
            }

            public boolean isShareBill() {
                return isShareBill;
            }

            public void setShareBill(boolean shareBill) {
                isShareBill = shareBill;
            }

            public boolean isChatBan() {
                return isChatBan;
            }

            public void setChatBan(boolean chatBan) {
                isChatBan = chatBan;
            }

            public String getIsMine() {
                return isMine;
            }

            public void setIsMine(String isMine) {
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

            public String getOddsRate() {
                return oddsRate;
            }

            public void setOddsRate(String oddsRate) {
                this.oddsRate = oddsRate;
            }

            public String getRoomId() {
                return roomId;
            }

            public String getPassword() {
                return password;
            }

            public void setPassword(String password) {
                this.password = password;
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

            public String getQuantity() {
                return quantity;
            }

            public void setQuantity(String quantity) {
                this.quantity = quantity;
            }

            public static class ChatRedBagSettingBean {
                /**
                 * isRedBag : 1
                 * maxAmount : 100
                 * minAmount : 1
                 * maxQuantity : 999
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
             * title : 彩壹万娱乐集团
             * content : 号外！号外！每天聊天室将招募各种彩票.真人视讯.棋牌.电子.体育.计划大神高手带计划，平台将送丰厚彩金或大礼包！
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
