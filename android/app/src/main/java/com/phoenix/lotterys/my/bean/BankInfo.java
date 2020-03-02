package com.phoenix.lotterys.my.bean;

import java.util.List;

/**
 * Created by Luke
 * on 2019/6/21
 */
public class BankInfo {

    /**
     * code : 0
     * msg : 银行列表获取成功！
     * data : [{"id":"29","name":"宁波银行","logo":"","home":""},{"id":"28","name":"农商银行","logo":"","home":""},{"id":"27","name":"平安银行","logo":"payh_logo.png","home":"http://bank.pingan.com/"},{"id":"1","name":"工商银行","logo":"upload/bank-icons/bank-gh.jpg","home":"http://www.icbc.com.cn"},{"id":"7","name":"招商银行","logo":"upload/bank-icons/bank-zh.jpg","home":"http://www.cmbchina.com/"},{"id":"8","name":"中国银行","logo":"upload/bank-icons/bank_25.png","home":"http://www.boc.cn/"},{"id":"4","name":"农业银行","logo":"upload/bank-icons/bank-nh.jpg","home":"http://www.abchina.com"},{"id":"6","name":"建设银行","logo":"upload/bank-icons/bank-jh.jpg","home":"http://www.ccb.com"},{"id":"5","name":"交通银行","logo":"upload/bank-icons/bank-jt.jpg","home":"http://www.bankcomm.com"},{"id":"21","name":"民生银行","logo":"","home":""},{"id":"24","name":"兴业银行","logo":"","home":""},{"id":"25","name":"光大银行","logo":"","home":""},{"id":"11","name":"广发银行","logo":"upload/bank-icons/bank_16.png","home":"http://www.ccb.com"},{"id":"9","name":"中信银行","logo":"upload/bank-icons/bank_23.png","home":"http://bank.ecitic.com/"},{"id":"10","name":"浦发银行","logo":"upload/bank-icons/bank_24.png","home":"http://www.bankcomm.com"},{"id":"16","name":"华夏银行","logo":"upload/bank-icons/bank_33.png","home":"http://www.hxb.com.cn/"},{"id":"17","name":"深圳发展银行","logo":"upload/bank-icons/bank_26.png","home":"http://www.sdb.com.cn/"},{"id":"23","name":"邮政银行","logo":"","home":""},{"id":"22","name":"农村信用社","logo":"","home":""},{"id":"26","name":"东莞银行","logo":"","home":""},{"id":"30","name":"农村商业银行","logo":"","home":""}]
     * info : {"sqlList":["主库(5303)：SELECT id, name, logo, home FROM `ssc_bank_list` WHERE  `isDelete` = :isDelete  ORDER BY sort ASC  --Spent：21.12 ms"],"sqlTotalNum":1,"sqlTotalTime":"21.12 ms","runtime":"198.47 ms"}
     */

    private int code;
    private String msg;
    private InfoBean info;
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

    public InfoBean getInfo() {
        return info;
    }

    public void setInfo(InfoBean info) {
        this.info = info;
    }

    public List<DataBean> getData() {
        return data;
    }

    public void setData(List<DataBean> data) {
        this.data = data;
    }

    public static class InfoBean {
        /**
         * sqlList : ["主库(5303)：SELECT id, name, logo, home FROM `ssc_bank_list` WHERE  `isDelete` = :isDelete  ORDER BY sort ASC  --Spent：21.12 ms"]
         * sqlTotalNum : 1
         * sqlTotalTime : 21.12 ms
         * runtime : 198.47 ms
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

    public static class DataBean {
        /**
         * id : 29
         * name : 宁波银行
         * logo :
         * home :
         */

        private String id;
        private String name;
        private String logo;
        private String home;
        boolean isSelect;

        public boolean isSelect() {
            return isSelect;
        }

        public void setSelect(boolean select) {
            isSelect = select;
        }

        public String getId() {
            return id;
        }

        public void setId(String id) {
            this.id = id;
        }

        public String getName() {
            return name;
        }

        public void setName(String name) {
            this.name = name;
        }

        public String getLogo() {
            return logo;
        }

        public void setLogo(String logo) {
            this.logo = logo;
        }

        public String getHome() {
            return home;
        }

        public void setHome(String home) {
            this.home = home;
        }
    }
}
