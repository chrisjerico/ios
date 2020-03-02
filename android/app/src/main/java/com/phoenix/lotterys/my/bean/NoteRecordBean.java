package com.phoenix.lotterys.my.bean;

import com.google.gson.annotations.SerializedName;

import java.io.Serializable;
import java.util.List;

/**
 * 文件描述:
 * 创建者: IAN
 * 创建时间: 2019/7/11 12:24
 */
public class NoteRecordBean implements Serializable {

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
        @SerializedName("tickets")
        private List<ListBean> tickets;
        @SerializedName("total")
        private int total;
        @SerializedName("readTotal")
        private int readTotal;
        @SerializedName("list")
        private List<ListBean> list;
        @SerializedName("totalBetAmount")
        private  String total_money;
       @SerializedName("totalWinAmount")
        private  String settleAmount;

//        public String getTotalBetCount() {
//            return totalBetCount;
//        }
//
//        public void setTotalBetCount(String totalBetCount) {
//            this.totalBetCount = totalBetCount;
//        }
//
//        public String getTotalWinAmount() {
//            return totalWinAmount;
//        }
//
//        public void setTotalWinAmount(String totalWinAmount) {
//            this.totalWinAmount = totalWinAmount;
//        }

        public List<ListBean> getTickets() {
            return tickets;
        }

        public void setTickets(List<ListBean> tickets) {
            this.tickets = tickets;
        }

        public String getSettleAmount() {
            return settleAmount;
        }

        public void setSettleAmount(String settleAmount) {
            this.settleAmount = settleAmount;
        }

        public String getTotal_money() {
            return total_money;
        }

        public void setTotal_money(String total_money) {
            this.total_money = total_money;
        }

        public int getTotal() {
            return total;
        }

        public void setTotal(int total) {
            this.total = total;
        }

        public int getReadTotal() {
            return readTotal;
        }

        public void setReadTotal(int readTotal) {
            this.readTotal = readTotal;
        }

        public List<ListBean> getList() {
            return list;
        }

        public void setList(List<ListBean> list) {
            this.list = list;
        }

        public static class ListBean {

            /**
             * id : 105
             * gameName : PC蛋蛋
             * issue : 962636
             * playGroupName : 特码
             * playName : 26
             * betAmount : 10.00
             * rebateAmount : 0.0000
             * expectAmount : 2990.0000
             * winAmount : 0.0000
             * settleAmount : -10.0000
             * odds : 300.0000
             * betInfo :
             * status : 1
             * isCancel : 0
             */
            private  String lotteryNo;
            private String id;
            private String gameName;
            private String gameTypeName;
            private String issue;
            private String playGroupName;
            private String playName;
            private String betAmount;
            private String rebateAmount;
            private String expectAmount;
            private String winAmount;
            private String settleAmount;
            private String odds;
            private String betInfo;
            private String status;
            private String isCancel;
            private String validBetAmount;
            private String betTime;

            private  boolean isAllowCancel;
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
            private String winLoseAmount;

            public boolean isAllowCancel() {
                return isAllowCancel;
            }

            public void setAllowCancel(boolean allowCancel) {
                isAllowCancel = allowCancel;
            }

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


            public String getWinLoseAmount() {
                return winLoseAmount;
            }

            public void setWinLoseAmount(String winLoseAmount) {
                this.winLoseAmount = winLoseAmount;
            }


            public String getGameTypeName() {
                return gameTypeName;
            }

            public void setGameTypeName(String gameTypeName) {
                this.gameTypeName = gameTypeName;
            }

            public String getBetTime() {
                return betTime;
            }

            public void setBetTime(String betTime) {
                this.betTime = betTime;
            }

            public String getValidBetAmount() {
                return validBetAmount;
            }

            public void setValidBetAmount(String validBetAmount) {
                this.validBetAmount = validBetAmount;
            }

            public String getLotteryNo() {
                return lotteryNo;
            }

            public void setLotteryNo(String lotteryNo) {
                this.lotteryNo = lotteryNo;
            }

            public String getId() {
                return id;
            }

            public void setId(String id) {
                this.id = id;
            }

            public String getGameName() {
                return gameName;
            }

            public void setGameName(String gameName) {
                this.gameName = gameName;
            }

            public String getIssue() {
                return issue;
            }

            public void setIssue(String issue) {
                this.issue = issue;
            }

            public String getPlayGroupName() {
                return playGroupName;
            }

            public void setPlayGroupName(String playGroupName) {
                this.playGroupName = playGroupName;
            }

            public String getPlayName() {
                return playName;
            }

            public void setPlayName(String playName) {
                this.playName = playName;
            }

            public String getBetAmount() {
                return betAmount;
            }

            public void setBetAmount(String betAmount) {
                this.betAmount = betAmount;
            }

            public String getRebateAmount() {
                return rebateAmount;
            }

            public void setRebateAmount(String rebateAmount) {
                this.rebateAmount = rebateAmount;
            }

            public String getExpectAmount() {
                return expectAmount;
            }

            public void setExpectAmount(String expectAmount) {
                this.expectAmount = expectAmount;
            }

            public String getWinAmount() {
                return winAmount;
            }

            public void setWinAmount(String winAmount) {
                this.winAmount = winAmount;
            }

            public String getSettleAmount() {
                return settleAmount;
            }

            public void setSettleAmount(String settleAmount) {
                this.settleAmount = settleAmount;
            }

            public String getOdds() {
                return odds;
            }

            public void setOdds(String odds) {
                this.odds = odds;
            }

            public String getBetInfo() {
                return betInfo;
            }

            public void setBetInfo(String betInfo) {
                this.betInfo = betInfo;
            }

            public String getStatus() {
                return status;
            }

            public void setStatus(String status) {
                this.status = status;
            }

            public String getIsCancel() {
                return isCancel;
            }

            public void setIsCancel(String isCancel) {
                this.isCancel = isCancel;
            }
        }
    }
}
