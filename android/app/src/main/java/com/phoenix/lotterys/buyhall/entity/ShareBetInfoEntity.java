package com.phoenix.lotterys.buyhall.entity;

import java.util.List;

/**
 * @author : Wu
 * @e-mail : wu_developer@outlook.com
 * @date : 2019/12/13 16:31
 * @description :
 */
public class ShareBetInfoEntity {

    /**
     * betParams : [{"money":"2.00","name":"总和大","odds":"1.9960","playId":"1101"}]
     * code : LM
     * ftime : 1576222740
     * gameId : 1
     * gameName : 重庆时时彩
     * playNameArray : [{"playName1":"总和-龙虎和-总和大","playName2":"总和大"}]
     * specialPlay : false
     * totalMoney : 2.00
     * totalNums : 1
     * turnNum : 20191213058
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

    public static class BetParamsBean {
        /**
         * money : 2.00
         * name : 总和大
         * odds : 1.9960
         * playId : 1101
         */

        private String money;
        private String name;
        private String odds;
        private String playId;

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
         * playName1 : 总和-龙虎和-总和大
         * playName2 : 总和大
         */

        private String playName1;
        private String playName2;

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
