package com.phoenix.lotterys.chat.entity;

import java.io.Serializable;
import java.util.List;

/**
 * @author : W
 * @e-mail :
 * @date : 2019/12/11 16:24
 * @description :
 */
public class TicketListEntity {

    /**
     * code : 0
     * msg : success
     * data : [{"gameId":"70","turnNum":"2019137","totalMoney":12,"totalNums":2,"betBean":[{"name":"--特小双--","betNum":"1","playId":"708614","money":"6.00","betInfo":"","playIds":""},{"name":"--特小单--","betNum":"1","playId":"708613","money":"6.00","betInfo":"","playIds":""}]}]
     */

    private int code;
    private String msg;
    private List<DataBean> data;

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

    public List<DataBean> getData() {
        return data;
    }

    public void setData(List<DataBean> data) {
        this.data = data;
    }

    public static class DataBean implements Serializable {
        /**
         * gameId : 70
         * turnNum : 2019137
         * totalMoney : 12
         * totalNums : 2
         * betBean : [{"name":"--特小双--","betNum":"1","playId":"708614","money":"6.00","betInfo":"","playIds":""},{"name":"--特小单--","betNum":"1","playId":"708613","money":"6.00","betInfo":"","playIds":""}]
         */

        private String gameId;
        private String gameName;
        private String turnNum;
        private String totalMoney;
        private String totalNums;
        private List<BetBeanBean> betBean;

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

        public String getTurnNum() {
            return turnNum;
        }

        public void setTurnNum(String turnNum) {
            this.turnNum = turnNum;
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

        public List<BetBeanBean> getBetBean() {
            return betBean;
        }

        public void setBetBean(List<BetBeanBean> betBean) {
            this.betBean = betBean;
        }

        public static class BetBeanBean implements Serializable {
            /**
             * name : --特小双--
             * betNum : 1
             * playId : 708614
             * money : 6.00
             * betInfo :
             * playIds :
             */

            private String name;
            private String betNum;
            private String playId;
            private String money;
            private String betInfo = "";
            private String playIds;
            private String odds;

            public String getName() {
                return name;
            }

            public void setName(String name) {
                this.name = name;
            }

            public String getBetNum() {
                return betNum;
            }

            public void setBetNum(String betNum) {
                this.betNum = betNum;
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

            public String getOdds() {
                return odds;
            }

            public void setOdds(String odds) {
                this.odds = odds;
            }
        }
    }
}
