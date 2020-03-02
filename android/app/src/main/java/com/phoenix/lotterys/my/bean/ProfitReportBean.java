package com.phoenix.lotterys.my.bean;

import java.util.List;

/**
 * Greated by Luke
 * on 2019/8/24
 */
public class ProfitReportBean {


    /**
     * code : 0
     * msg : 获取收益报表成功
     * data : {"list":[{"balance":"280.0006575348","settleBalance":"280.0006575348","profitAmount":"0.0001917811","settleTime":"2019-08-24 19:52:10"},{"balance":"280.0004657537","settleBalance":"280.0004657537","profitAmount":"0.0001917810","settleTime":"2019-08-24 19:51:18"},{"balance":"200.0002739727","settleBalance":"200.0002739727","profitAmount":"0.0001369864","settleTime":"2019-08-24 19:50:27"},{"balance":"200.0001369863","settleBalance":"200.0001369863","profitAmount":"0.0001369863","settleTime":"2019-08-24 19:49:35"}],"total":4}
     * info : {"sqlList":["从库(5304)：SELECT id, name, title, value FROM `ssc_params`   --Spent：0.44 ms","从库(5304)：SELECT * FROM `ssc_blacklist` WHERE  `type` = :type   --Spent：0.28 ms","从库(5304)：SELECT * FROM `ssc_cache`  WHERE `name` = 'block_country'    --Spent：0.16 ms","主库(5303)：SELECT balance, settle_balance, profit_amount, created FROM `ssc_member_yuebao_settle` WHERE uid=2679 AND created >=1480176000 AND created <=1566662399 ORDER BY created DESC, id DESC limit 0,20  --Spent：0.68 ms","主库(5303)：SELECT  count(1) as total FROM `ssc_member_yuebao_settle` WHERE uid=2679 AND created >=1480176000 AND created <=1566662399  --Spent：0.28 ms"],"sqlTotalNum":5,"sqlTotalTime":"1.84 ms","runtime":"38.36 ms"}
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
         * list : [{"balance":"280.0006575348","settleBalance":"280.0006575348","profitAmount":"0.0001917811","settleTime":"2019-08-24 19:52:10"},{"balance":"280.0004657537","settleBalance":"280.0004657537","profitAmount":"0.0001917810","settleTime":"2019-08-24 19:51:18"},{"balance":"200.0002739727","settleBalance":"200.0002739727","profitAmount":"0.0001369864","settleTime":"2019-08-24 19:50:27"},{"balance":"200.0001369863","settleBalance":"200.0001369863","profitAmount":"0.0001369863","settleTime":"2019-08-24 19:49:35"}]
         * total : 4
         */

        private int total;
        private List<ListBean> list;

        public int getTotal() {
            return total;
        }

        public void setTotal(int total) {
            this.total = total;
        }

        public List<ListBean> getList() {
            return list;
        }

        public void setList(List<ListBean> list) {
            this.list = list;
        }

        public static class ListBean {
            /**
             * balance : 280.0006575348
             * settleBalance : 280.0006575348
             * profitAmount : 0.0001917811
             * settleTime : 2019-08-24 19:52:10
             */

            private String balance;
            private String settleBalance;
            private String profitAmount;
            private String settleTime;

            public String getBalance() {
                return balance;
            }

            public void setBalance(String balance) {
                this.balance = balance;
            }

            public String getSettleBalance() {
                return settleBalance;
            }

            public void setSettleBalance(String settleBalance) {
                this.settleBalance = settleBalance;
            }

            public String getProfitAmount() {
                return profitAmount;
            }

            public void setProfitAmount(String profitAmount) {
                this.profitAmount = profitAmount;
            }

            public String getSettleTime() {
                return settleTime;
            }

            public void setSettleTime(String settleTime) {
                this.settleTime = settleTime;
            }
        }
    }

    public static class InfoBean {
        /**
         * sqlList : ["从库(5304)：SELECT id, name, title, value FROM `ssc_params`   --Spent：0.44 ms","从库(5304)：SELECT * FROM `ssc_blacklist` WHERE  `type` = :type   --Spent：0.28 ms","从库(5304)：SELECT * FROM `ssc_cache`  WHERE `name` = 'block_country'    --Spent：0.16 ms","主库(5303)：SELECT balance, settle_balance, profit_amount, created FROM `ssc_member_yuebao_settle` WHERE uid=2679 AND created >=1480176000 AND created <=1566662399 ORDER BY created DESC, id DESC limit 0,20  --Spent：0.68 ms","主库(5303)：SELECT  count(1) as total FROM `ssc_member_yuebao_settle` WHERE uid=2679 AND created >=1480176000 AND created <=1566662399  --Spent：0.28 ms"]
         * sqlTotalNum : 5
         * sqlTotalTime : 1.84 ms
         * runtime : 38.36 ms
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
