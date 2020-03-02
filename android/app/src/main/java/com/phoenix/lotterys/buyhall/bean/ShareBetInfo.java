package com.phoenix.lotterys.buyhall.bean;

import java.util.List;

/**
 * Greated by Luke
 * on 2019/9/23
 */
public class ShareBetInfo {
    /**
     * betParams : [{"money":1,"name":11,"odds":"M","playId":"Tom","rebate":"Tom"},{"money":1,"name":11,"odds":"M","playId":"Tom","rebate":"Tom"}]
     * playNameArray : [{"playName1":"1","playName2":"1"},{"playName1":"1","playName2":"1"}]
     * singleAmount : 111
     * specialPlay : 111
     */
    String singleAmount;
    boolean specialPlay;
    String totalMoney;
    String totalNums;
    String turnNum;
    String betSrc;
    String ftime;
    String gameId;
    String paneCode;
    String gameName;
    String code;

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public boolean isSpecialPlay() {
        return specialPlay;
    }

    public void setSpecialPlay(boolean specialPlay) {
        this.specialPlay = specialPlay;
    }

    public String getGameName() {
        return gameName;
    }

    public void setGameName(String gameName) {
        this.gameName = gameName;
    }

    private List<BetParamsBean> betParams;
    private List<PlayNameArrayBean> playNameArray;
    private SelectSubBean selectSub;

    public SelectSubBean getSelectSub() {
        return selectSub;
    }

    public void setSelectSub(SelectSubBean selectSub) {
        this.selectSub = selectSub;
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

    public String getBetSrc() {
        return betSrc;
    }

    public void setBetSrc(String betSrc) {
        this.betSrc = betSrc;
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

    public String getPaneCode() {
        return paneCode;
    }

    public void setPaneCode(String paneCode) {
        this.paneCode = paneCode;
    }

    public String getSingleAmount() {
        return singleAmount;
    }

    public void setSingleAmount(String singleAmount) {
        this.singleAmount = singleAmount;
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

    public static class SelectSubBean {
        String id;
        String max;
        String min;
        String text;
        String type;

        @Override
        public String toString() {
            return "SelectSubBean{" +
                    "id='" + id + '\'' +
                    ", max='" + max + '\'' +
                    ", min='" + min + '\'' +
                    ", text='" + text + '\'' +
                    ", type='" + type + '\'' +
                    '}';
        }

        public String getId() {
            return id;
        }

        public void setId(String id) {
            this.id = id;
        }

        public String getMax() {
            return max;
        }

        public void setMax(String max) {
            this.max = max;
        }

        public String getMin() {
            return min;
        }

        public void setMin(String min) {
            this.min = min;
        }

        public String getText() {
            return text;
        }

        public void setText(String text) {
            this.text = text;
        }

        public String getType() {
            return type;
        }

        public void setType(String type) {
            this.type = type;
        }
    }

    public static class BetParamsBean {
        /**
         * money : 1
         * name : 11
         * odds : M
         * playId : Tom
         * rebate : Tom
         */

        private String money;
        private String name;
        private String odds;
        private String playId;
        private String rebate;
        private String playIds;

        public BetParamsBean(String playId, String betMoney, String name, String odds, String playIds) {
            this.money = betMoney;
            this.playId = playId;
            this.name = name;
            this.odds = odds;
            this.playIds = playIds;
        }

        public String getPlayIds() {
            return playIds;
        }

        public void setPlayIds(String playIds) {
            this.playIds = playIds;
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

        public String getRebate() {
            return rebate;
        }

        public void setRebate(String rebate) {
            this.rebate = rebate;
        }
    }

    public static class PlayNameArrayBean {
        /**
         * playName1 : 1
         * playName2 : 1
         */

        private String playName1;
        private String playName2;

        public PlayNameArrayBean(String playName1, String playName2) {
            this.playName1 = playName1;
            this.playName2 = playName2;
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
