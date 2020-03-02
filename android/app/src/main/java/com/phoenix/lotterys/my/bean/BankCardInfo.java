package com.phoenix.lotterys.my.bean;

import java.util.List;

/**
 * Greated by Luke
 * on 2019/7/17
 */
public class BankCardInfo {

    /**
     * code : 0
     * msg : 银行卡信息获取成功！
     * data : {"bankId":"29","ownerName":"放大","bankCard":"6225154532122222","bankAddr":"辅导费放大","bankName":"宁波银行"}
     * info : {"sqlList":["主库(5303)：SELECT * FROM `ssc_member_bank`  WHERE `uid` = '2679'    --Spent：1.74 ms","主库(5303)：SELECT id, name, logo, home FROM `ssc_bank_list`  ORDER BY sort ASC  --Spent：43.49 ms"],"sqlTotalNum":2,"sqlTotalTime":"45.23 ms","runtime":"596.80 ms"}
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
         * bankId : 29
         * ownerName : 放大
         * bankCard : 6225154532122222
         * bankAddr : 辅导费放大
         * bankName : 宁波银行
         */

        private String bankId;
        private String ownerName;
        private String bankCard;
        private String bankAddr;
        private String bankName;

        public String getBankId() {
            return bankId;
        }

        public void setBankId(String bankId) {
            this.bankId = bankId;
        }

        public String getOwnerName() {
            return ownerName;
        }

        public void setOwnerName(String ownerName) {
            this.ownerName = ownerName;
        }

        public String getBankCard() {
            return bankCard;
        }

        public void setBankCard(String bankCard) {
            this.bankCard = bankCard;
        }

        public String getBankAddr() {
            return bankAddr;
        }

        public void setBankAddr(String bankAddr) {
            this.bankAddr = bankAddr;
        }

        public String getBankName() {
            return bankName;
        }

        public void setBankName(String bankName) {
            this.bankName = bankName;
        }
    }

    public static class InfoBean {
        /**
         * sqlList : ["主库(5303)：SELECT * FROM `ssc_member_bank`  WHERE `uid` = '2679'    --Spent：1.74 ms","主库(5303)：SELECT id, name, logo, home FROM `ssc_bank_list`  ORDER BY sort ASC  --Spent：43.49 ms"]
         * sqlTotalNum : 2
         * sqlTotalTime : 45.23 ms
         * runtime : 596.80 ms
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
