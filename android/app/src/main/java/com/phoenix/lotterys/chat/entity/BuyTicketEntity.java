package com.phoenix.lotterys.chat.entity;

import java.util.ArrayList;
import java.util.List;

/**
 * @author : W
 * @e-mail :
 * @date : 2019/12/12 14:47
 * @description :
 */
public class BuyTicketEntity {

    /**
     * betBean : [{"money":"1.00","playId":1103,"playIds":"1"},{"money":"1.00","playId":1105,"playIds":"1"},{"money":"1.00","playId":1107,"playIds":"1"}]
     * betIssue : 20191209068
     * endTime : 1575883140
     * gameId : 1
     * totalMoney : 3.00
     * totalNum : 3
     * token : ini0sTZ0JjHC1QFvHHiJNQiI
     */

    private String betIssue;
    private int endTime;
    private int gameId;
    private String totalMoney;
    private int totalNum;
    private String token;
    private String sign;
    private List<BetBean> betBean = new ArrayList<>();

    public String getBetIssue() {
        return betIssue;
    }

    public void setBetIssue(String betIssue) {
        this.betIssue = betIssue;
    }

    public int getEndTime() {
        return endTime;
    }

    public void setEndTime(int endTime) {
        this.endTime = endTime;
    }

    public int getGameId() {
        return gameId;
    }

    public void setGameId(int gameId) {
        this.gameId = gameId;
    }

    public String getTotalMoney() {
        return totalMoney;
    }

    public void setTotalMoney(String totalMoney) {
        this.totalMoney = totalMoney;
    }

    public int getTotalNum() {
        return totalNum;
    }

    public void setTotalNum(int totalNum) {
        this.totalNum = totalNum;
    }

    public String getToken() {
        return token;
    }

    public void setToken(String token) {
        this.token = token;
    }

    public String getSign() {
        return sign;
    }

    public void setSign(String sign) {
        this.sign = sign;
    }

    public List<BetBean> getBetBean() {
        return betBean;
    }

    public void setBetBean(List<BetBean> betBean) {
        this.betBean = betBean;
    }

    public static class BetBean {
        /**
         * money : 1.00
         * playId : 1103
         * playIds : 1
         */

        private String money;
        private int playId;
        private String playIds;

        public String getMoney() {
            return money;
        }

        public void setMoney(String money) {
            this.money = money;
        }

        public int getPlayId() {
            return playId;
        }

        public void setPlayId(int playId) {
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
