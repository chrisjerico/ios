package com.phoenix.lotterys.my.bean;

import java.util.List;

/**
 * Greated by Luke
 * on 2019/8/24
 */
public class TransFerLogsBean {

    /**
     * code : 0
     * msg : 获取转入转出记录成功
     * data : {"list":[{"amount":"45.0000000000","oldBalance":"235.0002739727","newBalance":"280.0002739727","changeTime":"2019-08-24 19:50:57","category":"转入"},{"amount":"45.0000000000","oldBalance":"190.0002739727","newBalance":"235.0002739727","changeTime":"2019-08-24 19:50:52","category":"转入"},{"amount":"5.0000000000","oldBalance":"185.0002739727","newBalance":"190.0002739727","changeTime":"2019-08-24 19:50:49","category":"转入"},{"amount":"4.0000000000","oldBalance":"189.0002739727","newBalance":"185.0002739727","changeTime":"2019-08-24 19:50:46","category":"转出"},{"amount":"4.0000000000","oldBalance":"193.0002739727","newBalance":"189.0002739727","changeTime":"2019-08-24 19:50:42","category":"转出"},{"amount":"5.0000000000","oldBalance":"198.0002739727","newBalance":"193.0002739727","changeTime":"2019-08-24 19:50:38","category":"转出"},{"amount":"2.0000000000","oldBalance":"200.0002739727","newBalance":"198.0002739727","changeTime":"2019-08-24 19:50:33","category":"转出"},{"amount":"300.0000000000","oldBalance":"500.0000000000","newBalance":"200.0000000000","changeTime":"2019-08-24 19:49:13","category":"转出"},{"amount":"500.0000000000","oldBalance":"0.0000000000","newBalance":"500.0000000000","changeTime":"2019-08-24 19:49:07","category":"转入"}],"total":9}
     * info : {"sqlList":["主库(5303)：SELECT id, amount, old_balance, created, type as category, new_balance, is_settled FROM `ssc_member_yuebao_cashlog` WHERE  `uid` = :uid  AND created >=1480176000 AND created <=1566662399 ORDER BY created DESC, id DESC limit 0,20  --Spent：2.56 ms","主库(5303)：SELECT  count(1) as total FROM `ssc_member_yuebao_cashlog` WHERE  `uid` = :uid  AND created >=1480176000 AND created <=1566662399  --Spent：0.32 ms"],"sqlTotalNum":2,"sqlTotalTime":"2.88 ms","runtime":"34.99 ms"}
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
         * list : [{"amount":"45.0000000000","oldBalance":"235.0002739727","newBalance":"280.0002739727","changeTime":"2019-08-24 19:50:57","category":"转入"},{"amount":"45.0000000000","oldBalance":"190.0002739727","newBalance":"235.0002739727","changeTime":"2019-08-24 19:50:52","category":"转入"},{"amount":"5.0000000000","oldBalance":"185.0002739727","newBalance":"190.0002739727","changeTime":"2019-08-24 19:50:49","category":"转入"},{"amount":"4.0000000000","oldBalance":"189.0002739727","newBalance":"185.0002739727","changeTime":"2019-08-24 19:50:46","category":"转出"},{"amount":"4.0000000000","oldBalance":"193.0002739727","newBalance":"189.0002739727","changeTime":"2019-08-24 19:50:42","category":"转出"},{"amount":"5.0000000000","oldBalance":"198.0002739727","newBalance":"193.0002739727","changeTime":"2019-08-24 19:50:38","category":"转出"},{"amount":"2.0000000000","oldBalance":"200.0002739727","newBalance":"198.0002739727","changeTime":"2019-08-24 19:50:33","category":"转出"},{"amount":"300.0000000000","oldBalance":"500.0000000000","newBalance":"200.0000000000","changeTime":"2019-08-24 19:49:13","category":"转出"},{"amount":"500.0000000000","oldBalance":"0.0000000000","newBalance":"500.0000000000","changeTime":"2019-08-24 19:49:07","category":"转入"}]
         * total : 9
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
             * amount : 45.0000000000
             * oldBalance : 235.0002739727
             * newBalance : 280.0002739727
             * changeTime : 2019-08-24 19:50:57
             * category : 转入
             */

            private String amount;
            private String oldBalance;
            private String newBalance;
            private String changeTime;
            private String category;

            public String getAmount() {
                return amount;
            }

            public void setAmount(String amount) {
                this.amount = amount;
            }

            public String getOldBalance() {
                return oldBalance;
            }

            public void setOldBalance(String oldBalance) {
                this.oldBalance = oldBalance;
            }

            public String getNewBalance() {
                return newBalance;
            }

            public void setNewBalance(String newBalance) {
                this.newBalance = newBalance;
            }

            public String getChangeTime() {
                return changeTime;
            }

            public void setChangeTime(String changeTime) {
                this.changeTime = changeTime;
            }

            public String getCategory() {
                return category;
            }

            public void setCategory(String category) {
                this.category = category;
            }
        }
    }

    public static class InfoBean {
        /**
         * sqlList : ["主库(5303)：SELECT id, amount, old_balance, created, type as category, new_balance, is_settled FROM `ssc_member_yuebao_cashlog` WHERE  `uid` = :uid  AND created >=1480176000 AND created <=1566662399 ORDER BY created DESC, id DESC limit 0,20  --Spent：2.56 ms","主库(5303)：SELECT  count(1) as total FROM `ssc_member_yuebao_cashlog` WHERE  `uid` = :uid  AND created >=1480176000 AND created <=1566662399  --Spent：0.32 ms"]
         * sqlTotalNum : 2
         * sqlTotalTime : 2.88 ms
         * runtime : 34.99 ms
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
