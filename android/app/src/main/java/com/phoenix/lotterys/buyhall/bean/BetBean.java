package com.phoenix.lotterys.buyhall.bean;

/**
 * Greated by Luke
 * on 2019/9/9
 */
public class BetBean {

    /**
     * code : 0
     * msg : 很遗憾，您未中奖，本期开奖结果为：5,3,3,9,9。请再接再厉哦~！
     * data : {"openNum":"5,3,3,9,9","bonus":0}
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
         * openNum : 5,3,3,9,9
         * bonus : 0
         */

        private String openNum;
        private String bonus;
        private String result;
        private String gameType;

        @Override
        public String toString() {
            return "DataBean{" +
                    "openNum='" + openNum + '\'' +
                    ", bonus='" + bonus + '\'' +
                    '}';
        }

        public String getResult() {
            return result;
        }

        public void setResult(String result) {
            this.result = result;
        }

        public String getGameType() {
            return gameType;
        }

        public void setGameType(String gameType) {
            this.gameType = gameType;
        }

        public String getOpenNum() {
            return openNum;
        }

        public void setOpenNum(String openNum) {
            this.openNum = openNum;
        }

        public String getBonus() {
            return bonus;
        }

        public void setBonus(String bonus) {
            this.bonus = bonus;
        }
    }
}
