package com.phoenix.lotterys.my.bean;

import java.util.List;

/**
 * Greated by Luke
 * on 2019/8/23
 */
public class DepositBean {


    /**
     * code : 0
     * msg : 获取存款记录成功
     * data : {"list":[{"orderNo":"201908202150235835","amount":"1000000.00","applyTime":"2019-08-20 21:50:24","arriveTime":"2019-08-20 21:50:24","status":"充值成功 / 人工存入彩金","remark":null},{"orderNo":"201908202150234606","amount":"1000000.00","applyTime":"2019-08-20 21:50:23","arriveTime":"2019-08-20 21:50:23","status":"充值成功 / 人工存款","remark":null},{"orderNo":"889166","amount":"10000.00","applyTime":"2019-08-07 14:14:04","arriveTime":"2019-08-07 14:14:04","status":"充值成功 / 人工存入彩金","remark":null},{"orderNo":"496412","amount":"10000.00","applyTime":"2019-08-07 14:14:03","arriveTime":"2019-08-07 14:14:03","status":"充值成功 / 人工存款","remark":null}],"total":4}
     * info : {"sqlList":["从库(5304)：SELECT rechargeId, amount, actionTime, rechargeTime, state, user_comment FROM `ssc_member_recharge` WHERE  is_trial = 0  AND  isDelete = 0  AND  uid = 2679 AND  actionTime >=1480089600 AND  actionTime <=1566575999 ORDER BY actionTime DESC limit 0,20  --Spent：0.48 ms","主库(5303)：SELECT  count(1) as total FROM `ssc_member_recharge` WHERE  is_trial = 0  AND  isDelete = 0  AND  uid = 2679 AND  actionTime >=1480089600 AND  actionTime <=1566575999  --Spent：0.24 ms"],"sqlTotalNum":2,"sqlTotalTime":"0.72 ms","runtime":"24.44 ms"}
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
         * list : [{"orderNo":"201908202150235835","amount":"1000000.00","applyTime":"2019-08-20 21:50:24","arriveTime":"2019-08-20 21:50:24","status":"充值成功 / 人工存入彩金","remark":null},{"orderNo":"201908202150234606","amount":"1000000.00","applyTime":"2019-08-20 21:50:23","arriveTime":"2019-08-20 21:50:23","status":"充值成功 / 人工存款","remark":null},{"orderNo":"889166","amount":"10000.00","applyTime":"2019-08-07 14:14:04","arriveTime":"2019-08-07 14:14:04","status":"充值成功 / 人工存入彩金","remark":null},{"orderNo":"496412","amount":"10000.00","applyTime":"2019-08-07 14:14:03","arriveTime":"2019-08-07 14:14:03","status":"充值成功 / 人工存款","remark":null}]
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
             * orderNo : 201908202150235835
             * amount : 1000000.00
             * applyTime : 2019-08-20 21:50:24
             * arriveTime : 2019-08-20 21:50:24
             * status : 充值成功 / 人工存入彩金
             * remark : null
             */

            private String orderNo;
            private String amount;
            private String applyTime;
            private String arriveTime;
            private String status;
            private Object remark;
            private String category;
            private String bankName;
            private String bankCard;
            private String bankAccount;
            private String username;
            private String fee;

            public String getFee() {
                return fee;
            }

            public void setFee(String fee) {
                this.fee = fee;
            }

            public String getUsername() {
                return username;
            }

            public void setUsername(String username) {
                this.username = username;
            }

            public String getBankName() {
                return bankName;
            }

            public void setBankName(String bankName) {
                this.bankName = bankName;
            }

            public String getBankCard() {
                return bankCard;
            }

            public void setBankCard(String bankCard) {
                this.bankCard = bankCard;
            }

            public String getBankAccount() {
                return bankAccount;
            }

            public void setBankAccount(String bankAccount) {
                this.bankAccount = bankAccount;
            }

            public String getCategory() {
                return category;
            }

            public void setCategory(String category) {
                this.category = category;
            }

            public String getOrderNo() {
                return orderNo;
            }

            public void setOrderNo(String orderNo) {
                this.orderNo = orderNo;
            }

            public String getAmount() {
                return amount;
            }

            public void setAmount(String amount) {
                this.amount = amount;
            }

            public String getApplyTime() {
                return applyTime;
            }

            public void setApplyTime(String applyTime) {
                this.applyTime = applyTime;
            }

            public String getArriveTime() {
                return arriveTime;
            }

            public void setArriveTime(String arriveTime) {
                this.arriveTime = arriveTime;
            }

            public String getStatus() {
                return status;
            }

            public void setStatus(String status) {
                this.status = status;
            }

            public Object getRemark() {
                return remark;
            }

            public void setRemark(Object remark) {
                this.remark = remark;
            }
        }
    }

    public static class InfoBean {
        /**
         * sqlList : ["从库(5304)：SELECT rechargeId, amount, actionTime, rechargeTime, state, user_comment FROM `ssc_member_recharge` WHERE  is_trial = 0  AND  isDelete = 0  AND  uid = 2679 AND  actionTime >=1480089600 AND  actionTime <=1566575999 ORDER BY actionTime DESC limit 0,20  --Spent：0.48 ms","主库(5303)：SELECT  count(1) as total FROM `ssc_member_recharge` WHERE  is_trial = 0  AND  isDelete = 0  AND  uid = 2679 AND  actionTime >=1480089600 AND  actionTime <=1566575999  --Spent：0.24 ms"]
         * sqlTotalNum : 2
         * sqlTotalTime : 0.72 ms
         * runtime : 24.44 ms
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
