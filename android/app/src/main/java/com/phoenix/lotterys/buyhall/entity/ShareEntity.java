package com.phoenix.lotterys.buyhall.entity;

import java.util.List;

/**
 * @author : W
 * @e-mail :
 * @date : 2019/11/12 16:47
 * @description :
 */
public class ShareEntity {

    /**
     * betParams : [{"money":"3.00","name":"特大","odds":"1.9800","playId":"708601"},{"money":"2.00","name":"特单","odds":"1.9800","playId":"708603"}]
     * code : LM
     * ftime : 1573738200
     * gameId : 70
     * gameName : 香港六合彩
     * playNameArray : [{"playName1":"两面-特大","playName2":"特大"},{"playName1":"两面-特单","playName2":"特单"}]
     * specialPlay : false
     * totalMoney : 5.00
     * totalNums : 2
     * turnNum : 2019125
     */

    private String code;
    private String ftime;
    private String gameId;
    private String gameName;
    private boolean specialPlay;
    private String totalMoney;
    private String totalNums;
    private String turnNum;
    private List<BetParamsBean> betParams;
    private List<PlayNameArrayBean> playNameArray;
    private String isInstant;

    @Override
    public String toString() {
        return "ShareEntity{" +
                "code='" + code + '\'' +
                ", ftime='" + ftime + '\'' +
                ", gameId='" + gameId + '\'' +
                ", gameName='" + gameName + '\'' +
                ", specialPlay=" + specialPlay +
                ", totalMoney='" + totalMoney + '\'' +
                ", totalNums='" + totalNums + '\'' +
                ", turnNum='" + turnNum + '\'' +
                ", betParams=" + betParams +
                ", playNameArray=" + playNameArray +
                ", isInstant='" + isInstant + '\'' +
                '}';
    }

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public String getFtime() {
        return ftime;
    }

    public void setFtime(String ftime) {
        this.ftime = ftime;
    }

    public String getGameId() {
        return gameId;
    }

    public void setGameId(String gameId) {
        this.gameId = gameId;
    }

    public String getGameName() {
        return gameName;
    }

    public void setGameName(String gameName) {
        this.gameName = gameName;
    }

    public boolean isSpecialPlay() {
        return specialPlay;
    }

    public void setSpecialPlay(boolean specialPlay) {
        this.specialPlay = specialPlay;
    }

    public String getTotalMoney() {
        return totalMoney;
    }

    public void setTotalMoney(String totalMoney) {
        this.totalMoney = totalMoney;
    }

    public String getTotalNums() {
        return totalNums;
    }

    public void setTotalNums(String totalNums) {
        this.totalNums = totalNums;
    }

    public String getTurnNum() {
        return turnNum;
    }

    public void setTurnNum(String turnNum) {
        this.turnNum = turnNum;
    }

    public List<BetParamsBean> getBetParams() {
        return betParams;
    }

    public void setBetParams(List<BetParamsBean> betParams) {
        this.betParams = betParams;
    }

    public List<PlayNameArrayBean> getPlayNameArray() {
        return playNameArray;
    }

    public void setPlayNameArray(List<PlayNameArrayBean> playNameArray) {
        this.playNameArray = playNameArray;
    }

    public String getIsInstant() {
        return isInstant;
    }

    public void setIsInstant(String isInstant) {
        this.isInstant = isInstant;
    }

    public static class BetParamsBean {
        /**
         * money : 3.00
         * name : 特大
         * odds : 1.9800
         * playId : 708601
         */

        private String money;
        private String name;
        private String odds;
        private String playId;

        @Override
        public String toString() {
            return "BetParamsBean{" +
                    "money='" + money + '\'' +
                    ", name='" + name + '\'' +
                    ", odds='" + odds + '\'' +
                    ", playId='" + playId + '\'' +
                    '}';
        }

        public String getMoney() {
            return money;
        }

        public void setMoney(String money) {
            this.money = money;
        }

        public String getName() {
            return name;
        }

        public void setName(String name) {
            this.name = name;
        }

        public String getOdds() {
            return odds;
        }

        public void setOdds(String odds) {
            this.odds = odds;
        }

        public String getPlayId() {
            return playId;
        }

        public void setPlayId(String playId) {
            this.playId = playId;
        }
    }

    public static class PlayNameArrayBean {
        /**
         * playName1 : 两面-特大
         * playName2 : 特大
         */

        private String playName1;
        private String playName2;

        @Override
        public String toString() {
            return "PlayNameArrayBean{" +
                    "playName1='" + playName1 + '\'' +
                    ", playName2='" + playName2 + '\'' +
                    '}';
        }

        public String getPlayName1() {
            return playName1;
        }

        public void setPlayName1(String playName1) {
            this.playName1 = playName1;
        }

        public String getPlayName2() {
            return playName2;
        }

        public void setPlayName2(String playName2) {
            this.playName2 = playName2;
        }
    }
}
