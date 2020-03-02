package com.phoenix.lotterys.my.bean;

import java.util.List;

/**
 * Greated by Luke
 * on 2019/8/28
 */
public class TransferinterestBean {

    /**
     * code : 0
     * msg : 额度转换成功
     * data : {"list":[{"id":"53457","username":"flb2014","gameName":"HG视讯","amount":"100.00","actionTime":"2019-08-28 21:11:45","status":"1","isAuto":"0"},{"id":"53456","username":"flb2014","gameName":"DG视讯","amount":"-100.00","actionTime":"2019-08-28 21:11:45","status":"1","isAuto":"0"},{"id":"53455","username":"flb2014","gameName":"HG视讯","amount":"100.00","actionTime":"2019-08-28 21:11:32","status":"1","isAuto":"0"},{"id":"53454","username":"flb2014","gameName":"OG视讯","amount":"100.00","actionTime":"2019-08-28 21:11:20","status":"1","isAuto":"0"},{"id":"53453","username":"flb2014","gameName":"DG视讯","amount":"100.00","actionTime":"2019-08-28 21:11:14","status":"1","isAuto":"0"},{"id":"53452","username":"flb2014","gameName":"VR彩票","amount":"100.00","actionTime":"2019-08-28 21:11:08","status":"1","isAuto":"0"},{"id":"53451","username":"flb2014","gameName":"eBET视讯","amount":"100.00","actionTime":"2019-08-28 21:11:04","status":"1","isAuto":"0"},{"id":"53450","username":"flb2014","gameName":"BG视讯","amount":"100.00","actionTime":"2019-08-28 21:10:56","status":"1","isAuto":"0"},{"id":"53449","username":"flb2014","gameName":"BBIN视讯","amount":"100.00","actionTime":"2019-08-28 21:10:51","status":"1","isAuto":"0"},{"id":"53448","username":"flb2014","gameName":"玛雅视讯","amount":"100.00","actionTime":"2019-08-28 21:10:45","status":"1","isAuto":"0"},{"id":"53447","username":"flb2014","gameName":"RG皇家视讯","amount":"100.00","actionTime":"2019-08-28 21:10:39","status":"1","isAuto":"0"},{"id":"53446","username":"flb2014","gameName":"AG视讯","amount":"100.00","actionTime":"2019-08-28 21:10:26","status":"1","isAuto":"0"}],"total":12}
     * info : {"sqlList":["主库(5303)：SELECT id, username, game_id, amount, actionTime, success, result FROM `ssc_real_trans` WHERE  `uid` = :uid  AND actionTime >=1480521600 AND actionTime <=1567007999 ORDER BY actionTime DESC, id DESC limit 0,15  --Spent：0.70 ms","主库(5303)：SELECT  count(1) as total FROM `ssc_real_trans` WHERE  `uid` = :uid  AND actionTime >=1480521600 AND actionTime <=1567007999  --Spent：0.20 ms","从库(5304)：SELECT * FROM `ssc_real`   --Spent：0.39 ms"],"sqlTotalNum":3,"sqlTotalTime":"1.29 ms","traceBack":{"loader":"1.40 ms","initDi":"7.81 ms","settings":null,"access":"21.52 ms","dispatch":null},"runtime":"28.67 ms"}
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
         * list : [{"id":"53457","username":"flb2014","gameName":"HG视讯","amount":"100.00","actionTime":"2019-08-28 21:11:45","status":"1","isAuto":"0"},{"id":"53456","username":"flb2014","gameName":"DG视讯","amount":"-100.00","actionTime":"2019-08-28 21:11:45","status":"1","isAuto":"0"},{"id":"53455","username":"flb2014","gameName":"HG视讯","amount":"100.00","actionTime":"2019-08-28 21:11:32","status":"1","isAuto":"0"},{"id":"53454","username":"flb2014","gameName":"OG视讯","amount":"100.00","actionTime":"2019-08-28 21:11:20","status":"1","isAuto":"0"},{"id":"53453","username":"flb2014","gameName":"DG视讯","amount":"100.00","actionTime":"2019-08-28 21:11:14","status":"1","isAuto":"0"},{"id":"53452","username":"flb2014","gameName":"VR彩票","amount":"100.00","actionTime":"2019-08-28 21:11:08","status":"1","isAuto":"0"},{"id":"53451","username":"flb2014","gameName":"eBET视讯","amount":"100.00","actionTime":"2019-08-28 21:11:04","status":"1","isAuto":"0"},{"id":"53450","username":"flb2014","gameName":"BG视讯","amount":"100.00","actionTime":"2019-08-28 21:10:56","status":"1","isAuto":"0"},{"id":"53449","username":"flb2014","gameName":"BBIN视讯","amount":"100.00","actionTime":"2019-08-28 21:10:51","status":"1","isAuto":"0"},{"id":"53448","username":"flb2014","gameName":"玛雅视讯","amount":"100.00","actionTime":"2019-08-28 21:10:45","status":"1","isAuto":"0"},{"id":"53447","username":"flb2014","gameName":"RG皇家视讯","amount":"100.00","actionTime":"2019-08-28 21:10:39","status":"1","isAuto":"0"},{"id":"53446","username":"flb2014","gameName":"AG视讯","amount":"100.00","actionTime":"2019-08-28 21:10:26","status":"1","isAuto":"0"}]
         * total : 12
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
             * id : 53457
             * username : flb2014
             * gameName : HG视讯
             * amount : 100.00
             * actionTime : 2019-08-28 21:11:45
             * status : 1
             * isAuto : 0
             */

            private String id;
            private String username;
            private String gameName;
            private String amount;
            private String actionTime;
            private String status;
            private String isAuto;

            public String getId() {
                return id;
            }

            public void setId(String id) {
                this.id = id;
            }

            public String getUsername() {
                return username;
            }

            public void setUsername(String username) {
                this.username = username;
            }

            public String getGameName() {
                return gameName;
            }

            public void setGameName(String gameName) {
                this.gameName = gameName;
            }

            public String getAmount() {
                return amount;
            }

            public void setAmount(String amount) {
                this.amount = amount;
            }

            public String getActionTime() {
                return actionTime;
            }

            public void setActionTime(String actionTime) {
                this.actionTime = actionTime;
            }

            public String getStatus() {
                return status;
            }

            public void setStatus(String status) {
                this.status = status;
            }

            public String getIsAuto() {
                return isAuto;
            }

            public void setIsAuto(String isAuto) {
                this.isAuto = isAuto;
            }
        }
    }

    public static class InfoBean {
        /**
         * sqlList : ["主库(5303)：SELECT id, username, game_id, amount, actionTime, success, result FROM `ssc_real_trans` WHERE  `uid` = :uid  AND actionTime >=1480521600 AND actionTime <=1567007999 ORDER BY actionTime DESC, id DESC limit 0,15  --Spent：0.70 ms","主库(5303)：SELECT  count(1) as total FROM `ssc_real_trans` WHERE  `uid` = :uid  AND actionTime >=1480521600 AND actionTime <=1567007999  --Spent：0.20 ms","从库(5304)：SELECT * FROM `ssc_real`   --Spent：0.39 ms"]
         * sqlTotalNum : 3
         * sqlTotalTime : 1.29 ms
         * traceBack : {"loader":"1.40 ms","initDi":"7.81 ms","settings":null,"access":"21.52 ms","dispatch":null}
         * runtime : 28.67 ms
         */

        private int sqlTotalNum;
        private String sqlTotalTime;
        private TraceBackBean traceBack;
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

        public TraceBackBean getTraceBack() {
            return traceBack;
        }

        public void setTraceBack(TraceBackBean traceBack) {
            this.traceBack = traceBack;
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

        public static class TraceBackBean {
            /**
             * loader : 1.40 ms
             * initDi : 7.81 ms
             * settings : null
             * access : 21.52 ms
             * dispatch : null
             */

            private String loader;
            private String initDi;
            private Object settings;
            private String access;
            private Object dispatch;

            public String getLoader() {
                return loader;
            }

            public void setLoader(String loader) {
                this.loader = loader;
            }

            public String getInitDi() {
                return initDi;
            }

            public void setInitDi(String initDi) {
                this.initDi = initDi;
            }

            public Object getSettings() {
                return settings;
            }

            public void setSettings(Object settings) {
                this.settings = settings;
            }

            public String getAccess() {
                return access;
            }

            public void setAccess(String access) {
                this.access = access;
            }

            public Object getDispatch() {
                return dispatch;
            }

            public void setDispatch(Object dispatch) {
                this.dispatch = dispatch;
            }
        }
    }
}
