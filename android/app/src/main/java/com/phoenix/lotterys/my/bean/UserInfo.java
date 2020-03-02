package com.phoenix.lotterys.my.bean;

import java.io.Serializable;

/**
 * Greated by Luke
 * on 2019/7/20
 */
public class UserInfo implements Serializable {

    /**
     * code : 0
     * msg : 用户信息获取成功
     * data : {"uid":"2940","usr":"dfgldfgdf54","fullName":"大幅度发","avatar":"","balance":"0.0000","qq":"","email":"","phone":"","isTest":false,"hasBankCard":true,"hasFundPwd":false,"unreadFaq":0,"unreadMsg":0,"curLevelTitle":"新手","curLevelGrade":"VIP1","curLevelInt":"0","nextLevelTitle":"初行者","nextLevelGrade":"无","nextLevelInt":"0.0000","taskRewardTitle":"积分","taskRewardTotal":"0.0000","googleVerifier":"0"}
     * info : {"sqlList":["主库(5303)：SELECT uid, parentId, admin, username, password, coinPassword, type, name, coin, email, qq, phone, testFlag, level_id, rebate FROM `ssc_members` WHERE  `username` = :username   --Spent：1.47 ms","从库(5304)：SELECT * FROM `ssc_member_append1` WHERE  `uid` = :uid   --Spent：0.27 ms","从库(5304)：SELECT * FROM `ssc_mission_levels`  ORDER BY integral DESC  --Spent：0.28 ms","从库(5304)：SELECT * FROM `ssc_mission_levels`  ORDER BY integral DESC  --Spent：0.15 ms","从库(5304)：SELECT * FROM `ssc_member_bank`  WHERE `uid` = '2940'    --Spent：0.20 ms"],"sqlTotalNum":5,"sqlTotalTime":"2.37 ms","runtime":"247.36 ms"}
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

    public static class DataBean  implements Serializable{
        /**
         * uid : 2940
         * usr : dfgldfgdf54
         * fullName : 大幅度发
         * avatar :
         * balance : 0.0000
         * qq :
         * email :
         * phone :
         * isTest : false
         * hasBankCard : true
         * hasFundPwd : false
         * unreadFaq : 0
         * unreadMsg : 0
         * curLevelTitle : 新手
         * curLevelGrade : VIP1
         * curLevelInt : 0
         * nextLevelTitle : 初行者
         * nextLevelGrade : 无
         * nextLevelInt : 0.0000
         * taskRewardTitle : 积分
         * taskRewardTotal : 0.0000
         * googleVerifier : 0
         */

        private boolean isAgent;

        private String uid;
        private String usr;
        private String fullName;
        private String avatar;
        private String balance;
        private String qq;
        private String email;
        private String phone;
        private boolean isTest;
        private boolean hasBankCard;

        private int unreadFaq;
        private int unreadMsg;
        private String curLevelTitle;
        private String curLevelGrade;
        private String curLevelInt;
        private String nextLevelTitle;
        private String nextLevelGrade;
        private String nextLevelInt;
        private String taskRewardTitle;
        private String taskRewardTotal;
        private boolean googleVerifier;
        private boolean hasFundPwd;
        private boolean yuebaoSwitch;
        private boolean hasActLottery;

        private String taskReward;

        private String unsettleAmount;
        private String todayWinAmount;

        private boolean isBindGoogleVerifier;

        private boolean allowMemberCancelBet;

        private String clientIp;

        public boolean isAllowMemberCancelBet() {
            return allowMemberCancelBet;
        }

        public void setAllowMemberCancelBet(boolean allowMemberCancelBet) {
            this.allowMemberCancelBet = allowMemberCancelBet;
        }

        public boolean isBindGoogleVerifier() {
            return isBindGoogleVerifier;
        }

        public void setBindGoogleVerifier(boolean bindGoogleVerifier) {
            isBindGoogleVerifier = bindGoogleVerifier;
        }

        public String getTodayWinAmount() {
            return todayWinAmount;
        }

        public void setTodayWinAmount(String todayWinAmount) {
            this.todayWinAmount = todayWinAmount;
        }

        public String getUnsettleAmount() {
            return unsettleAmount;
        }

        public void setUnsettleAmount(String unsettleAmount) {
            this.unsettleAmount = unsettleAmount;
        }

        public boolean isHasActLottery() {
            return hasActLottery;
        }

        public void setHasActLottery(boolean hasActLottery) {
            this.hasActLottery = hasActLottery;
        }

        public boolean isAgent() {
            return isAgent;
        }

        public void setAgent(boolean agent) {
            isAgent = agent;
        }

        public String getTaskReward() {
            return taskReward;
        }

        public void setTaskReward(String taskReward) {
            this.taskReward = taskReward;
        }

        public boolean isYuebaoSwitch() {
            return yuebaoSwitch;
        }

        public void setYuebaoSwitch(boolean yuebaoSwitch) {
            this.yuebaoSwitch = yuebaoSwitch;
        }

        public String getUid() {
            return uid;
        }

        public void setUid(String uid) {
            this.uid = uid;
        }

        public String getUsr() {
            return usr;
        }

        public void setUsr(String usr) {
            this.usr = usr;
        }

        public String getFullName() {
            return fullName;
        }

        public void setFullName(String fullName) {
            this.fullName = fullName;
        }

        public String getAvatar() {
            return avatar;
        }

        public void setAvatar(String avatar) {
            this.avatar = avatar;
        }

        public String getBalance() {
            return balance;
        }

        public void setBalance(String balance) {
            this.balance = balance;
        }

        public String getQq() {
            return qq;
        }

        public void setQq(String qq) {
            this.qq = qq;
        }

        public String getEmail() {
            return email;
        }

        public void setEmail(String email) {
            this.email = email;
        }

        public String getPhone() {
            return phone;
        }

        public void setPhone(String phone) {
            this.phone = phone;
        }

        public boolean isIsTest() {
            return isTest;
        }

        public void setIsTest(boolean isTest) {
            this.isTest = isTest;
        }

        public boolean isHasBankCard() {
            return hasBankCard;
        }

        public void setHasBankCard(boolean hasBankCard) {
            this.hasBankCard = hasBankCard;
        }

        public boolean isHasFundPwd() {
            return hasFundPwd;
        }

        public void setHasFundPwd(boolean hasFundPwd) {
            this.hasFundPwd = hasFundPwd;
        }

        public int getUnreadFaq() {
            return unreadFaq;
        }

        public void setUnreadFaq(int unreadFaq) {
            this.unreadFaq = unreadFaq;
        }

        public int getUnreadMsg() {
            return unreadMsg;
        }

        public void setUnreadMsg(int unreadMsg) {
            this.unreadMsg = unreadMsg;
        }

        public String getCurLevelTitle() {
            return curLevelTitle;
        }

        public void setCurLevelTitle(String curLevelTitle) {
            this.curLevelTitle = curLevelTitle;
        }

        public String getCurLevelGrade() {
            return curLevelGrade;
        }

        public void setCurLevelGrade(String curLevelGrade) {
            this.curLevelGrade = curLevelGrade;
        }

        public String getCurLevelInt() {
            return curLevelInt;
        }

        public void setCurLevelInt(String curLevelInt) {
            this.curLevelInt = curLevelInt;
        }

        public String getNextLevelTitle() {
            return nextLevelTitle;
        }

        public void setNextLevelTitle(String nextLevelTitle) {
            this.nextLevelTitle = nextLevelTitle;
        }

        public String getNextLevelGrade() {
            return nextLevelGrade;
        }

        public void setNextLevelGrade(String nextLevelGrade) {
            this.nextLevelGrade = nextLevelGrade;
        }

        public String getNextLevelInt() {
            return nextLevelInt;
        }

        public void setNextLevelInt(String nextLevelInt) {
            this.nextLevelInt = nextLevelInt;
        }

        public String getTaskRewardTitle() {
            return taskRewardTitle;
        }

        public void setTaskRewardTitle(String taskRewardTitle) {
            this.taskRewardTitle = taskRewardTitle;
        }

        public String getTaskRewardTotal() {
            return taskRewardTotal;
        }

        public void setTaskRewardTotal(String taskRewardTotal) {
            this.taskRewardTotal = taskRewardTotal;
        }

        public boolean getGoogleVerifier() {
            return googleVerifier;
        }

        public void setGoogleVerifier(boolean googleVerifier) {
            this.googleVerifier = googleVerifier;
        }

        public String getClientIp() {
            return clientIp;
        }

        public void setClientIp(String clientIp) {
            this.clientIp = clientIp;
        }

        @Override
        public String toString() {
            return "DataBean{" +
                    "uid='" + uid + '\'' +
                    ", usr='" + usr + '\'' +
                    ", fullName='" + fullName + '\'' +
                    ", avatar='" + avatar + '\'' +
                    ", balance='" + balance + '\'' +
                    ", qq='" + qq + '\'' +
                    ", email='" + email + '\'' +
                    ", phone='" + phone + '\'' +
                    ", isTest=" + isTest +
                    ", hasBankCard=" + hasBankCard +
                    ", hasFundPwd=" + hasFundPwd +
                    ", unreadFaq=" + unreadFaq +
                    ", unreadMsg=" + unreadMsg +
                    ", curLevelTitle='" + curLevelTitle + '\'' +
                    ", curLevelGrade='" + curLevelGrade + '\'' +
                    ", curLevelInt='" + curLevelInt + '\'' +
                    ", nextLevelTitle='" + nextLevelTitle + '\'' +
                    ", nextLevelGrade='" + nextLevelGrade + '\'' +
                    ", nextLevelInt='" + nextLevelInt + '\'' +
                    ", taskRewardTitle='" + taskRewardTitle + '\'' +
                    ", taskRewardTotal='" + taskRewardTotal + '\'' +
                    ", googleVerifier='" + googleVerifier + '\'' +
                    ", clientIp='" + clientIp + '\'' +
                    '}';
        }
    }
}
