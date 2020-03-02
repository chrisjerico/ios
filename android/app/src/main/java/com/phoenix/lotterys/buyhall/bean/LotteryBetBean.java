package com.phoenix.lotterys.buyhall.bean;

import java.util.List;

/**
 * Created by Luke
 * on 2019/6/21
 */
public class LotteryBetBean {

    /**
     * token : S6c6D2h3oHfj3DRcf9AHfdg3
     * gameId : 66
     * betIssue : 958583
     * endTime : 1561020260
     * totalNum : 2
     * totalMoney : 200
     * betBean : [{"playId":"6611201","money":"100","betInfo":"","playIds":""},{"playId":"6611205","money":"100","betInfo":""}]
     */

    private String token;
    private String gameId;
    private String betIssue;
    private String endTime;
    private String totalNum;
    private String totalMoney;
    private String sign;
    private List<BetBeanBean> betBean;

    public String getSign() {
        return sign;
    }

    public void setSign(String sign) {
        this.sign = sign;
    }

    public String getToken() {
        return token;
    }

    public void setToken(String token) {
        this.token = token;
    }

    public String getGameId() {
        return gameId;
    }

    public void setGameId(String gameId) {
        this.gameId = gameId;
    }

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

    public String getTotalNum() {
        return totalNum;
    }

    public void setTotalNum(String totalNum) {
        this.totalNum = totalNum;
    }

    public String getTotalMoney() {
        return totalMoney;
    }

    public void setTotalMoney(String totalMoney) {
        this.totalMoney = totalMoney;
    }

    public List<BetBeanBean> getBetBean(BetBeanBean betBeanBean) {
        return betBean;
    }

    public void setBetBean(List<BetBeanBean> betBean) {
        this.betBean = betBean;
    }

    public static class BetBeanBean {
        /**
         * playId : 6611201
         * money : 100
         * betInfo :
         * playIds :
         */

        private String playId;
        private String money;
        private String betInfo;
        private String playIds;
        private String odds;

        public BetBeanBean(String playId, String money, String betInfo,String odds,int s ) {
            this.playId = playId;
            this.money = money;
            this.betInfo = betInfo;
            this.odds = odds;
        }
        public BetBeanBean(String playId, String money, String betInfo, String playIds,String odds) {
            this.playId = playId;
            this.money = money;
            this.betInfo = betInfo;
            this.playIds = playIds;
            this.odds = odds;
        }
        public BetBeanBean(String playId, String money,  String playIds) {
            this.playId = playId;
            this.money = money;
            this.playIds = playIds;
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

        public String getMoney() {
            return money;
        }

        public void setMoney(String money) {
            this.money = money;
        }

        public String getBetInfo() {
            return betInfo;
        }

        public void setBetInfo(String betInfo) {
            this.betInfo = betInfo;
        }

        public String getPlayIds() {
            return playIds;
        }

        public void setPlayIds(String playIds) {
            this.playIds = playIds;
        }
    }
}
