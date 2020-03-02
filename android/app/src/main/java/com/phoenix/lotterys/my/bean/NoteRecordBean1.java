package com.phoenix.lotterys.my.bean;

import java.io.Serializable;
import java.util.List;

/**
 * 文件描述:
 * 创建者: IAN
 * 创建时间: 2019/7/11 12:24
 */
public class NoteRecordBean1 implements Serializable {

    /**
     * code : 0
     * msg : 获取彩票统计数据成功
     * data : {"tickets":[{"date":"2019-11-12","dayOfWeek":"星期二","betCount":"2","winCount":"1","winAmount":"1.7900","winLoseAmount":"-0.11"},{"date":"2019-11-13","dayOfWeek":"星期三","betCount":"0","winCount":"0","winAmount":0,"winLoseAmount":"0.00"},{"date":"2019-11-14","dayOfWeek":"星期四","betCount":"2","winCount":"0","winAmount":0,"winLoseAmount":"-200.00"},{"date":"2019-11-15","dayOfWeek":"星期五","betCount":"0","winCount":"0","winAmount":0,"winLoseAmount":"0.00"},{"date":"2019-11-16","dayOfWeek":"星期六","betCount":"13","winCount":"4","winAmount":"63.5600","winLoseAmount":"-3.44"},{"date":"2019-11-17","dayOfWeek":"星期日","betCount":"0","winCount":"0","winAmount":0,"winLoseAmount":"0.00"},{"date":"2019-11-18","dayOfWeek":"星期一","betCount":"37","winCount":"17","winAmount":"45.6340","winLoseAmount":"2.08"}],"totalBetCount":"54","totalWinAmount":"-201.46"}
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
         * tickets : [{"date":"2019-11-12","dayOfWeek":"星期二","betCount":"2","winCount":"1","winAmount":"1.7900","winLoseAmount":"-0.11"},{"date":"2019-11-13","dayOfWeek":"星期三","betCount":"0","winCount":"0","winAmount":0,"winLoseAmount":"0.00"},{"date":"2019-11-14","dayOfWeek":"星期四","betCount":"2","winCount":"0","winAmount":0,"winLoseAmount":"-200.00"},{"date":"2019-11-15","dayOfWeek":"星期五","betCount":"0","winCount":"0","winAmount":0,"winLoseAmount":"0.00"},{"date":"2019-11-16","dayOfWeek":"星期六","betCount":"13","winCount":"4","winAmount":"63.5600","winLoseAmount":"-3.44"},{"date":"2019-11-17","dayOfWeek":"星期日","betCount":"0","winCount":"0","winAmount":0,"winLoseAmount":"0.00"},{"date":"2019-11-18","dayOfWeek":"星期一","betCount":"37","winCount":"17","winAmount":"45.6340","winLoseAmount":"2.08"}]
         * totalBetCount : 54
         * totalWinAmount : -201.46
         */

        private String totalBetCount;
        private String totalWinAmount;
        private List<TicketsBean> tickets;

        public String getTotalBetCount() {
            return totalBetCount;
        }

        public void setTotalBetCount(String totalBetCount) {
            this.totalBetCount = totalBetCount;
        }

        public String getTotalWinAmount() {
            return totalWinAmount;
        }

        public void setTotalWinAmount(String totalWinAmount) {
            this.totalWinAmount = totalWinAmount;
        }

        public List<TicketsBean> getTickets() {
            return tickets;
        }

        public void setTickets(List<TicketsBean> tickets) {
            this.tickets = tickets;
        }

        public static class TicketsBean {
            /**
             * date : 2019-11-12
             * dayOfWeek : 星期二
             * betCount : 2
             * winCount : 1
             * winAmount : 1.7900
             * winLoseAmount : -0.11
             */

            private String date;
            private String dayOfWeek;
            private String betCount;
            private String winCount;
            private String winAmount;
            private String winLoseAmount;

            public String getDate() {
                return date;
            }

            public void setDate(String date) {
                this.date = date;
            }

            public String getDayOfWeek() {
                return dayOfWeek;
            }

            public void setDayOfWeek(String dayOfWeek) {
                this.dayOfWeek = dayOfWeek;
            }

            public String getBetCount() {
                return betCount;
            }

            public void setBetCount(String betCount) {
                this.betCount = betCount;
            }

            public String getWinCount() {
                return winCount;
            }

            public void setWinCount(String winCount) {
                this.winCount = winCount;
            }

            public String getWinAmount() {
                return winAmount;
            }

            public void setWinAmount(String winAmount) {
                this.winAmount = winAmount;
            }

            public String getWinLoseAmount() {
                return winLoseAmount;
            }

            public void setWinLoseAmount(String winLoseAmount) {
                this.winLoseAmount = winLoseAmount;
            }
        }
    }
}
