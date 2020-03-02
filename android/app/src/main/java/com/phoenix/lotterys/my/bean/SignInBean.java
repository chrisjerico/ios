package com.phoenix.lotterys.my.bean;

import com.google.gson.annotations.SerializedName;

import java.io.Serializable;
import java.util.List;

/**
 * 文件描述:
 * 创建者: IAN
 * 创建时间: 2019/7/17 13:39
 */
public class SignInBean implements Serializable {

    /**
     * code : 0
     * msg : ok
     * data : {"checkinSwitch":true,"mkCheckinSwitch":true,"serverTime":"2019-08-24","level":[{"levelName":"VIP1","checkinCards":"0"},{"levelName":"VIP2","checkinCards":"0"},{"levelName":"VIP3","checkinCards":"0"},{"levelName":"VIP4","checkinCards":"0"},{"levelName":"VIP5","checkinCards":"1"},{"levelName":"VIP6","checkinCards":"1"},{"levelName":"VIP7","checkinCards":"2"},{"levelName":"VIP8","checkinCards":"2"},{"levelName":"VIP9","checkinCards":"3"},{"levelName":"VIP10","checkinCards":"0"}],"lastTime":"2019-08-18","checkinTimes":"1","checkinMoney":"5.00","checkinList":[{"week":"星期一","updateTime":"2019-08-19","integral":5,"isCheckin":false,"isMakeup":false},{"week":"星期二","updateTime":"2019-08-20","integral":2,"isCheckin":false,"isMakeup":false},{"week":"星期三","updateTime":"2019-08-21","integral":5,"isCheckin":false,"isMakeup":false},{"week":"星期四","updateTime":"2019-08-22","integral":2,"isCheckin":false,"isMakeup":false},{"week":"星期五","updateTime":"2019-08-23","integral":5,"isCheckin":false,"isMakeup":false},{"week":"星期六","updateTime":"2019-08-24","integral":2,"isCheckin":false,"isMakeup":false},{"week":"星期日","updateTime":"2019-08-25","integral":5,"isCheckin":false,"isMakeup":false}],"checkinBonus":[{"int":"18积分","switch":"1","isComplete":false},{"int":"28积分","switch":"1","isComplete":false}]}
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
         * checkinSwitch : true
         * mkCheckinSwitch : true
         * serverTime : 2019-08-24
         * level : [{"levelName":"VIP1","checkinCards":"0"},{"levelName":"VIP2","checkinCards":"0"},{"levelName":"VIP3","checkinCards":"0"},{"levelName":"VIP4","checkinCards":"0"},{"levelName":"VIP5","checkinCards":"1"},{"levelName":"VIP6","checkinCards":"1"},{"levelName":"VIP7","checkinCards":"2"},{"levelName":"VIP8","checkinCards":"2"},{"levelName":"VIP9","checkinCards":"3"},{"levelName":"VIP10","checkinCards":"0"}]
         * lastTime : 2019-08-18
         * checkinTimes : 1
         * checkinMoney : 5.00
         * checkinList : [{"week":"星期一","updateTime":"2019-08-19","integral":5,"isCheckin":false,"isMakeup":false},{"week":"星期二","updateTime":"2019-08-20","integral":2,"isCheckin":false,"isMakeup":false},{"week":"星期三","updateTime":"2019-08-21","integral":5,"isCheckin":false,"isMakeup":false},{"week":"星期四","updateTime":"2019-08-22","integral":2,"isCheckin":false,"isMakeup":false},{"week":"星期五","updateTime":"2019-08-23","integral":5,"isCheckin":false,"isMakeup":false},{"week":"星期六","updateTime":"2019-08-24","integral":2,"isCheckin":false,"isMakeup":false},{"week":"星期日","updateTime":"2019-08-25","integral":5,"isCheckin":false,"isMakeup":false}]
         * checkinBonus : [{"int":"18积分","switch":"1","isComplete":false},{"int":"28积分","switch":"1","isComplete":false}]
         */

        private boolean checkinSwitch;
        private boolean mkCheckinSwitch;
        private String serverTime;
        private String lastTime;
        private String checkinTimes;
        private String checkinMoney;
        private List<LevelBean> level;
        private List<CheckinListBean> checkinList;
        private List<CheckinBonusBean> checkinBonus;

        public boolean isCheckinSwitch() {
            return checkinSwitch;
        }

        public void setCheckinSwitch(boolean checkinSwitch) {
            this.checkinSwitch = checkinSwitch;
        }

        public boolean isMkCheckinSwitch() {
            return mkCheckinSwitch;
        }

        public void setMkCheckinSwitch(boolean mkCheckinSwitch) {
            this.mkCheckinSwitch = mkCheckinSwitch;
        }

        public String getServerTime() {
            return serverTime;
        }

        public void setServerTime(String serverTime) {
            this.serverTime = serverTime;
        }

        public String getLastTime() {
            return lastTime;
        }

        public void setLastTime(String lastTime) {
            this.lastTime = lastTime;
        }

        public String getCheckinTimes() {
            return checkinTimes;
        }

        public void setCheckinTimes(String checkinTimes) {
            this.checkinTimes = checkinTimes;
        }

        public String getCheckinMoney() {
            return checkinMoney;
        }

        public void setCheckinMoney(String checkinMoney) {
            this.checkinMoney = checkinMoney;
        }

        public List<LevelBean> getLevel() {
            return level;
        }

        public void setLevel(List<LevelBean> level) {
            this.level = level;
        }

        public List<CheckinListBean> getCheckinList() {
            return checkinList;
        }

        public void setCheckinList(List<CheckinListBean> checkinList) {
            this.checkinList = checkinList;
        }

        public List<CheckinBonusBean> getCheckinBonus() {
            return checkinBonus;
        }

        public void setCheckinBonus(List<CheckinBonusBean> checkinBonus) {
            this.checkinBonus = checkinBonus;
        }

        public static class LevelBean {
            /**
             * levelName : VIP1
             * checkinCards : 0
             */

            private String levelName;
            private String checkinCards;

            public String getLevelName() {
                return levelName;
            }

            public void setLevelName(String levelName) {
                this.levelName = levelName;
            }

            public String getCheckinCards() {
                return checkinCards;
            }

            public void setCheckinCards(String checkinCards) {
                this.checkinCards = checkinCards;
            }
        }

        public static class CheckinListBean {
            /**
             * week : 星期一
             * updateTime : 2019-08-19
             * integral : 5
             * isCheckin : false
             * isMakeup : false
             */

            private String week;
            private String updateTime;
            private String integral;
            private boolean isCheckin;
            private boolean isMakeup;

            public String getWeek() {
                return week;
            }

            public void setWeek(String week) {
                this.week = week;
            }

            public String getUpdateTime() {
                return updateTime;
            }

            public void setUpdateTime(String updateTime) {
                this.updateTime = updateTime;
            }

            public String getIntegral() {
                return integral;
            }

            public void setIntegral(String integral) {
                this.integral = integral;
            }

            public boolean isIsCheckin() {
                return isCheckin;
            }

            public void setIsCheckin(boolean isCheckin) {
                this.isCheckin = isCheckin;
            }

            public boolean isIsMakeup() {
                return isMakeup;
            }

            public void setIsMakeup(boolean isMakeup) {
                this.isMakeup = isMakeup;
            }
        }

        public static class CheckinBonusBean {
            /**
             * int : 18积分
             * switch : 1
             * isComplete : false
             */

            @SerializedName("int")
            private String intX;
            @SerializedName("switch")
            private String switchX;
            private boolean isComplete;
            private boolean isCheckin;
            private int postinon;

            public boolean isComplete() {
                return isComplete;
            }

            public void setComplete(boolean complete) {
                isComplete = complete;
            }

            public boolean isCheckin() {
                return isCheckin;
            }

            public void setCheckin(boolean checkin) {
                isCheckin = checkin;
            }

            public int getPostinon() {
                return postinon;
            }

            public void setPostinon(int postinon) {
                this.postinon = postinon;
            }

            public String getIntX() {
                return intX;
            }

            public void setIntX(String intX) {
                this.intX = intX;
            }

            public String getSwitchX() {
                return switchX;
            }

            public void setSwitchX(String switchX) {
                this.switchX = switchX;
            }

            public boolean isIsComplete() {
                return isComplete;
            }

            public void setIsComplete(boolean isComplete) {
                this.isComplete = isComplete;
            }
        }
    }
}
