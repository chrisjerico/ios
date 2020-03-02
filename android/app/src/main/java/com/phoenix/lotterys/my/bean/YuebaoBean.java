package com.phoenix.lotterys.my.bean;

import java.io.Serializable;
import java.util.List;

/**
 * Greated by Luke
 * on 2019/8/24
 */
public class YuebaoBean implements Serializable {

    /**
     * code : 0
     * msg : 获取统计数据成功
     * data : {"balance":"0.0000000000","giftBalance":"0.00","lastSettleTime":"2019-08-24 18:15:14","annualizedRate":"0.36","yuebaoName":"利息宝","todayProfit":"0.0000000000","weekProfit":"0.0000000000","monthProfit":"0.0000000000","totalProfit":"0.0000000000","minTransferInMoney":"147.00","maxTransferOutMoney":"5000.00","intro":"好消息，利息宝收益，已经运作8年欢迎大家理财！\n1、复利结算，利滚利，收益更高。\n2、结算快，每分钟结算一次，存入即开始收益。\n3、转入转出无限制，随时随地享收益。"}
     * info : {"sqlList":["主库(5303)：SELECT balance, gift_balance, last_settle_time, settleTotal FROM `ssc_member_yuebao` WHERE  `uid` = :uid   --Spent：0.18 ms","主库(5303)：SELECT * FROM `ssc_member_yuebao` WHERE  `uid` = :uid   --Spent：0.18 ms","主库(5303)：INSERT INTO `ssc_member_yuebao` SET `uid` = '2679', `balance` = '0', `gift_balance` = '0', `last_charge_time` = '1566641714', `last_withdraw_time` = '1566641714', `created` = '1566641714', `updated` = '1566641714';  --Spent：5.07 ms","从库(5304)：SELECT name, value FROM `ssc_params` WHERE  `name` IN ('lxbJson','lxbJson2','lxbType','year_rate')   --Spent：0.26 ms","从库(5304)：SELECT name, value FROM `ssc_params` WHERE  `name` IN ('maxYuebaoOut','minYuebaoIn','yuebaoContent','yuebao_name')   --Spent：0.13 ms","主库(5303)：SELECT SUM(profit_amount) AS profit FROM `ssc_member_yuebao_settle` WHERE  `uid` = :uid  AND created >= 1566576000 AND created <= 1566662399  --Spent：0.28 ms","主库(5303)：SELECT SUM(settleMoney) AS profit FROM `ssc_member_yuebao_stat` WHERE  `uid` = :uid  AND date >=20190819 AND date<=20190824  --Spent：0.29 ms","主库(5303)：SELECT SUM(settleMoney) AS profit FROM `ssc_member_yuebao_stat` WHERE  `uid` = :uid  AND date >=20190801 AND date<=20190824  --Spent：0.18 ms"],"sqlTotalNum":8,"sqlTotalTime":"6.57 ms","runtime":"38.82 ms"}
     */

    private int code;
    private String msg;
    private DataBean data;
    private InfoBean info;

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

    public InfoBean getInfo() {
        return info;
    }

    public void setInfo(InfoBean info) {
        this.info = info;
    }

    public static class DataBean {
        /**
         * balance : 0.0000000000
         * giftBalance : 0.00
         * lastSettleTime : 2019-08-24 18:15:14
         * annualizedRate : 0.36
         * yuebaoName : 利息宝
         * todayProfit : 0.0000000000
         * weekProfit : 0.0000000000
         * monthProfit : 0.0000000000
         * totalProfit : 0.0000000000
         * minTransferInMoney : 147.00
         * maxTransferOutMoney : 5000.00
         * intro : 好消息，利息宝收益，已经运作8年欢迎大家理财！
         1、复利结算，利滚利，收益更高。
         2、结算快，每分钟结算一次，存入即开始收益。
         3、转入转出无限制，随时随地享收益。
         */

        private String balance;
        private String giftBalance;
        private String lastSettleTime;
        private String annualizedRate;
        private String yuebaoName;
        private String todayProfit;
        private String weekProfit;
        private String monthProfit;
        private String totalProfit;
        private String minTransferInMoney;
        private String maxTransferOutMoney;
        private String intro;

        public String getBalance() {
            return balance;
        }

        public void setBalance(String balance) {
            this.balance = balance;
        }

        public String getGiftBalance() {
            return giftBalance;
        }

        public void setGiftBalance(String giftBalance) {
            this.giftBalance = giftBalance;
        }

        public String getLastSettleTime() {
            return lastSettleTime;
        }

        public void setLastSettleTime(String lastSettleTime) {
            this.lastSettleTime = lastSettleTime;
        }

        public String getAnnualizedRate() {
            return annualizedRate;
        }

        public void setAnnualizedRate(String annualizedRate) {
            this.annualizedRate = annualizedRate;
        }

        public String getYuebaoName() {
            return yuebaoName;
        }

        public void setYuebaoName(String yuebaoName) {
            this.yuebaoName = yuebaoName;
        }

        public String getTodayProfit() {
            return todayProfit;
        }

        public void setTodayProfit(String todayProfit) {
            this.todayProfit = todayProfit;
        }

        public String getWeekProfit() {
            return weekProfit;
        }

        public void setWeekProfit(String weekProfit) {
            this.weekProfit = weekProfit;
        }

        public String getMonthProfit() {
            return monthProfit;
        }

        public void setMonthProfit(String monthProfit) {
            this.monthProfit = monthProfit;
        }

        public String getTotalProfit() {
            return totalProfit;
        }

        public void setTotalProfit(String totalProfit) {
            this.totalProfit = totalProfit;
        }

        public String getMinTransferInMoney() {
            return minTransferInMoney;
        }

        public void setMinTransferInMoney(String minTransferInMoney) {
            this.minTransferInMoney = minTransferInMoney;
        }

        public String getMaxTransferOutMoney() {
            return maxTransferOutMoney;
        }

        public void setMaxTransferOutMoney(String maxTransferOutMoney) {
            this.maxTransferOutMoney = maxTransferOutMoney;
        }

        public String getIntro() {
            return intro;
        }

        public void setIntro(String intro) {
            this.intro = intro;
        }
    }

    public static class InfoBean {
        /**
         * sqlList : ["主库(5303)：SELECT balance, gift_balance, last_settle_time, settleTotal FROM `ssc_member_yuebao` WHERE  `uid` = :uid   --Spent：0.18 ms","主库(5303)：SELECT * FROM `ssc_member_yuebao` WHERE  `uid` = :uid   --Spent：0.18 ms","主库(5303)：INSERT INTO `ssc_member_yuebao` SET `uid` = '2679', `balance` = '0', `gift_balance` = '0', `last_charge_time` = '1566641714', `last_withdraw_time` = '1566641714', `created` = '1566641714', `updated` = '1566641714';  --Spent：5.07 ms","从库(5304)：SELECT name, value FROM `ssc_params` WHERE  `name` IN ('lxbJson','lxbJson2','lxbType','year_rate')   --Spent：0.26 ms","从库(5304)：SELECT name, value FROM `ssc_params` WHERE  `name` IN ('maxYuebaoOut','minYuebaoIn','yuebaoContent','yuebao_name')   --Spent：0.13 ms","主库(5303)：SELECT SUM(profit_amount) AS profit FROM `ssc_member_yuebao_settle` WHERE  `uid` = :uid  AND created >= 1566576000 AND created <= 1566662399  --Spent：0.28 ms","主库(5303)：SELECT SUM(settleMoney) AS profit FROM `ssc_member_yuebao_stat` WHERE  `uid` = :uid  AND date >=20190819 AND date<=20190824  --Spent：0.29 ms","主库(5303)：SELECT SUM(settleMoney) AS profit FROM `ssc_member_yuebao_stat` WHERE  `uid` = :uid  AND date >=20190801 AND date<=20190824  --Spent：0.18 ms"]
         * sqlTotalNum : 8
         * sqlTotalTime : 6.57 ms
         * runtime : 38.82 ms
         */

        private int sqlTotalNum;
        private String sqlTotalTime;
        private String runtime;
        private List<String> sqlList;

        public int getSqlTotalNum() {
            return sqlTotalNum;
        }

        public void setSqlTotalNum(int sqlTotalNum) {
            this.sqlTotalNum = sqlTotalNum;
        }

        public String getSqlTotalTime() {
            return sqlTotalTime;
        }

        public void setSqlTotalTime(String sqlTotalTime) {
            this.sqlTotalTime = sqlTotalTime;
        }

        public String getRuntime() {
            return runtime;
        }

        public void setRuntime(String runtime) {
            this.runtime = runtime;
        }

        public List<String> getSqlList() {
            return sqlList;
        }

        public void setSqlList(List<String> sqlList) {
            this.sqlList = sqlList;
        }
    }
}
