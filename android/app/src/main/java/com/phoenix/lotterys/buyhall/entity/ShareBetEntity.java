package com.phoenix.lotterys.buyhall.entity;

import java.util.List;

/**
 * @author : Wu
 * @e-mail : wu_developer@outlook.com
 * @date : 2019/12/13 16:34
 * @description :
 */
public class ShareBetEntity {

    /**
     * betBean : [{"money":"2.00","odds":"1.9960","playId":"1101","playIds":"1"},{"money":"3.00","odds":"1.9960","playId":"1103","playIds":"1"},{"money":"4.00","odds":"1.9960","playId":"1102","playIds":"1"}]
     * betIssue : 20191213064
     * endTime : 1576226340
     * gameId : 1
     * token : 33tw3tl1ftTGtPT713WiRWfw
     * totalMoney : 9.00
     * totalNum : 3
     */

    private String betIssue;
    private String endTime;
    private String gameId;
    private String token;
    private String totalMoney;
    private String totalNum;
    private List<BetBeanBean> betBean;

    public String getBetIssue() {
        return betIssue;
    }

    public void setBetIssue(String betIssue) {
        this.betIssue = betIssue;
    }

    public String getEndTime() {
        return endTime;
    }

    public void setEndTime(String endTime) {
        this.endTime = endTime;
    }

    public String getGameId() {
        return gameId;
    }

    public void setGameId(String gameId) {
        this.gameId = gameId;
    }

    public String getToken() {
        return token;
    }

    public void setToken(String token) {
        this.token = token;
    }

    public String getTotalMoney() {
        return totalMoney;
    }

    public void setTotalMoney(String totalMoney) {
        this.totalMoney = totalMoney;
    }

    public String getTotalNum() {
        return totalNum;
    }

    public void setTotalNum(String totalNum) {
        this.totalNum = totalNum;
    }

    public List<BetBeanBean> getBetBean() {
        return betBean;
    }

    public void setBetBean(List<BetBeanBean> betBean) {
        this.betBean = betBean;
    }

    public static class BetBeanBean {
        /**
         * money : 2.00
         * odds : 1.9960
         * playId : 1101
         * playIds : 1
         */

        private String money;
        private String odds;
        private String playId;
        private String playIds;

        public String getMoney() {
            return money;
        }

        public void setMoney(String money) {
            this.money = money;
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

        public String getPlayIds() {
            return playIds;
        }

        public void setPlayIds(String playIds) {
            this.playIds = playIds;
        }
    }
}
