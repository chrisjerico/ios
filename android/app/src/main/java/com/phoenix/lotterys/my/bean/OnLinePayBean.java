package com.phoenix.lotterys.my.bean;

/**
 * Greated by Luke
 * on 2019/9/1
 */
public class OnLinePayBean {
    /**
     * code : 0
     * msg : 获取在线支付地址成功
     * data : http://c91398.com/wjapp/api.php?c=recharge&a=payUrl&payId=500&gateway=3002&money=200&token=GscUqQdzwzb3WFCQcUwWNMUG
     */

    private int code;
    private String msg;
    private String data;

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

    public String getData() {
        return data;
    }

    public void setData(String data) {
        this.data = data;
    }

//
//    /**
//     * code : 0
//     * msg : 获取在线支付地址成功
//     * data : {"url":"http://t111f.fhptcdn.com/wjapp/api.php?c=recharge&a=payUrl&payId=654&gateway=3002&money=100&token=6bOK5IIsF7imFi4lObUNuIP7","controller":"recharge","action":"payUrl","params":{"payId":"654","gateway":"3002","money":"100","token":"6bOK5IIsF7imFi4lObUNuIP7"}}
//     */
//
//    private int code;
//    private String msg;
//    private DataBean data;
//
//    public int getCode() {
//        return code;
//    }
//
//    public void setCode(int code) {
//        this.code = code;
//    }
//
//    public String getMsg() {
//        return msg;
//    }
//
//    public void setMsg(String msg) {
//        this.msg = msg;
//    }
//
//    public DataBean getData() {
//        return data;
//    }
//
//    public void setData(DataBean data) {
//        this.data = data;
//    }
//
//    public static class DataBean {
//        /**
//         * url : http://t111f.fhptcdn.com/wjapp/api.php?c=recharge&a=payUrl&payId=654&gateway=3002&money=100&token=6bOK5IIsF7imFi4lObUNuIP7
//         * controller : recharge
//         * action : payUrl
//         * params : {"payId":"654","gateway":"3002","money":"100","token":"6bOK5IIsF7imFi4lObUNuIP7"}
//         */
//
//        private String url;
//        private String controller;
//        private String action;
//        private ParamsBean params;
//
//        public String getUrl() {
//            return url;
//        }
//
//        public void setUrl(String url) {
//            this.url = url;
//        }
//
//        public String getController() {
//            return controller;
//        }
//
//        public void setController(String controller) {
//            this.controller = controller;
//        }
//
//        public String getAction() {
//            return action;
//        }
//
//        public void setAction(String action) {
//            this.action = action;
//        }
//
//        public ParamsBean getParams() {
//            return params;
//        }
//
//        public void setParams(ParamsBean params) {
//            this.params = params;
//        }
//
//        public static class ParamsBean {
//            /**
//             * payId : 654
//             * gateway : 3002
//             * money : 100
//             * token : 6bOK5IIsF7imFi4lObUNuIP7
//             */
//
//            private String payId;
//            private String gateway;
//            private String money;
//            private String token;
//
//            public String getPayId() {
//                return payId;
//            }
//
//            public void setPayId(String payId) {
//                this.payId = payId;
//            }
//
//            public String getGateway() {
//                return gateway;
//            }
//
//            public void setGateway(String gateway) {
//                this.gateway = gateway;
//            }
//
//            public String getMoney() {
//                return money;
//            }
//
//            public void setMoney(String money) {
//                this.money = money;
//            }
//
//            public String getToken() {
//                return token;
//            }
//
//            public void setToken(String token) {
//                this.token = token;
//            }
//        }
//    }
}
