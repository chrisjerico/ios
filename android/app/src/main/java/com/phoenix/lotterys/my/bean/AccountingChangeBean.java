package com.phoenix.lotterys.my.bean;

import java.io.Serializable;
import java.util.List;

/**
 * 文件描述:
 * 创建者: IAN
 * 创建时间: 2019/8/26 15:01
 */
public class AccountingChangeBean implements Serializable {


    /**
     * code : 0
     * msg : 获取积分账变
     * data : {"list":[{"id":"17121","mid":"0","type":"兑换人民币","integral":"-0.10","oldInt":"499999.8900","newInt":"499999.79","addTime":"2019-08-26 14:47:53"},{"id":"17120","mid":"0","type":"兑换人民币","integral":"-0.01","oldInt":"499999.9000","newInt":"499999.89","addTime":"2019-08-26 14:46:33"},{"id":"17119","mid":"0","type":"兑换人民币","integral":"-0.10","oldInt":"500000.0000","newInt":"499999.90","addTime":"2019-08-26 14:40:39"},{"id":"17067","mid":"0","type":"人工充入","integral":"+500000.00","oldInt":"0.0000","newInt":"500000.00","addTime":"2019-08-08 13:40:28"}],"total":4}
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
         * list : [{"id":"17121","mid":"0","type":"兑换人民币","integral":"-0.10","oldInt":"499999.8900","newInt":"499999.79","addTime":"2019-08-26 14:47:53"},{"id":"17120","mid":"0","type":"兑换人民币","integral":"-0.01","oldInt":"499999.9000","newInt":"499999.89","addTime":"2019-08-26 14:46:33"},{"id":"17119","mid":"0","type":"兑换人民币","integral":"-0.10","oldInt":"500000.0000","newInt":"499999.90","addTime":"2019-08-26 14:40:39"},{"id":"17067","mid":"0","type":"人工充入","integral":"+500000.00","oldInt":"0.0000","newInt":"500000.00","addTime":"2019-08-08 13:40:28"}]
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
             * id : 17121
             * mid : 0
             * type : 兑换人民币
             * integral : -0.10
             * oldInt : 499999.8900
             * newInt : 499999.79
             * addTime : 2019-08-26 14:47:53
             */

            private String id;
            private String mid;
            private String type;
            private String integral;
            private String oldInt;
            private String newInt;
            private String addTime;

            public String getId() {
                return id;
            }

            public void setId(String id) {
                this.id = id;
            }

            public String getMid() {
                return mid;
            }

            public void setMid(String mid) {
                this.mid = mid;
            }

            public String getType() {
                return type;
            }

            public void setType(String type) {
                this.type = type;
            }

            public String getIntegral() {
                return integral;
            }

            public void setIntegral(String integral) {
                this.integral = integral;
            }

            public String getOldInt() {
                return oldInt;
            }

            public void setOldInt(String oldInt) {
                this.oldInt = oldInt;
            }

            public String getNewInt() {
                return newInt;
            }

            public void setNewInt(String newInt) {
                this.newInt = newInt;
            }

            public String getAddTime() {
                return addTime;
            }

            public void setAddTime(String addTime) {
                this.addTime = addTime;
            }
        }
    }
}
