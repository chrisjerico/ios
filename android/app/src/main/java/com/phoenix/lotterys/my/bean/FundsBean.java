package com.phoenix.lotterys.my.bean;

import java.util.List;

/**
 * Greated by Luke
 * on 2019/8/23
 */
public class FundsBean {

    /**
     * code : 0
     * msg : 获取资金明细成功
     * data : {"list":[{"time":"2019-08-20 21:50:23","changeMoney":"1000000.00","balance":"1001170.10","category":"存款"},{"time":"2019-08-07 14:14:03","changeMoney":"10000.00","balance":"10000.00","category":"存款"}],"total":2,"groups":[{"id":1,"name":"存款"},{"id":2,"name":"提款"},{"id":3,"name":"彩金"},{"id":4,"name":"彩票投注/中奖/撤单"},{"id":5,"name":"彩票返点/退水"},{"id":6,"name":"真人下注/转换/反水"},{"id":7,"name":"其他下注/消费"}]}
     * info : {"sqlList":["从库(5304)：SELECT coin, userCoin, liqType, actionTime FROM `ssc_coin_log` WHERE  `liqType` IN ('1','9','109','110')  AND  is_trial = 0 AND  uid = 2679 AND  actionTime >=1480089600 AND  actionTime <=1566575999 ORDER BY actionTime DESC, id DESC limit 0,20  --Spent：0.63 ms","主库(5303)：SELECT  count(1) as total FROM `ssc_coin_log` WHERE  `liqType` IN ('1','9','109','110')  AND  is_trial = 0 AND  uid = 2679 AND  actionTime >=1480089600 AND  actionTime <=1566575999  --Spent：0.38 ms"],"sqlTotalNum":2,"sqlTotalTime":"1.01 ms","runtime":"23.44 ms"}
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
         * list : [{"time":"2019-08-20 21:50:23","changeMoney":"1000000.00","balance":"1001170.10","category":"存款"},{"time":"2019-08-07 14:14:03","changeMoney":"10000.00","balance":"10000.00","category":"存款"}]
         * total : 2
         * groups : [{"id":1,"name":"存款"},{"id":2,"name":"提款"},{"id":3,"name":"彩金"},{"id":4,"name":"彩票投注/中奖/撤单"},{"id":5,"name":"彩票返点/退水"},{"id":6,"name":"真人下注/转换/反水"},{"id":7,"name":"其他下注/消费"}]
         */

        private int total;
        private List<ListBean> list;
        private List<GroupsBean> groups;

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

        public List<GroupsBean> getGroups() {
            return groups;
        }

        public void setGroups(List<GroupsBean> groups) {
            this.groups = groups;
        }

        public static class ListBean {
            /**
             * time : 2019-08-20 21:50:23
             * changeMoney : 1000000.00
             * balance : 1001170.10
             * category : 存款
             */

            private String time;
            private String changeMoney;
            private String balance;
            private String category;

            public String getTime() {
                return time;
            }

            public void setTime(String time) {
                this.time = time;
            }

            public String getChangeMoney() {
                return changeMoney;
            }

            public void setChangeMoney(String changeMoney) {
                this.changeMoney = changeMoney;
            }

            public String getBalance() {
                return balance;
            }

            public void setBalance(String balance) {
                this.balance = balance;
            }

            public String getCategory() {
                return category;
            }

            public void setCategory(String category) {
                this.category = category;
            }
        }

        public static class GroupsBean {
            /**
             * id : 1
             * name : 存款
             */

            private int id;
            private String name;

            public int getId() {
                return id;
            }

            public void setId(int id) {
                this.id = id;
            }

            public String getName() {
                return name;
            }

            public void setName(String name) {
                this.name = name;
            }
        }
    }

    public static class InfoBean {
        /**
         * sqlList : ["从库(5304)：SELECT coin, userCoin, liqType, actionTime FROM `ssc_coin_log` WHERE  `liqType` IN ('1','9','109','110')  AND  is_trial = 0 AND  uid = 2679 AND  actionTime >=1480089600 AND  actionTime <=1566575999 ORDER BY actionTime DESC, id DESC limit 0,20  --Spent：0.63 ms","主库(5303)：SELECT  count(1) as total FROM `ssc_coin_log` WHERE  `liqType` IN ('1','9','109','110')  AND  is_trial = 0 AND  uid = 2679 AND  actionTime >=1480089600 AND  actionTime <=1566575999  --Spent：0.38 ms"]
         * sqlTotalNum : 2
         * sqlTotalTime : 1.01 ms
         * runtime : 23.44 ms
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
