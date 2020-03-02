package com.phoenix.lotterys.home.bean;

import java.util.List;

/**
 * Greated by Luke
 * on 2019/9/13
 */
public class BbsDetails {

    /**
     * code : 0
     * msg : 内容获取失败
     * data : {"code":1,"title":null,"header":null,"content":null,"footer":null,"hasPayTip":null,"notPayTip":null,"hasPay":false,"canRead":false,"reason":"needPay","amount":"22.00"}
     * info : {"sqlList":["主库(5303)：SELECT * FROM `ssc_doc_content`  WHERE `id` = '11'    --Spent：0.33 ms","主库(5303)：SELECT * FROM `ssc_doc_category`  WHERE `id` = '1'    --Spent：0.14 ms","主库(5303)：SELECT * FROM `ssc_coin_log`  WHERE `uid` = '2679' AND `liqType` = '14' AND `extfield0` = '267911'    --Spent：0.13 ms"],"sqlTotalNum":3,"sqlTotalTime":"0.6 ms","traceBack":{"loader":"1.37 ms","initDi":"7.81 ms","settings":null,"access":"16.82 ms","dispatch":null},"runtime":"21.54 ms"}
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
         * code : 1
         * title : null
         * header : null
         * content : null
         * footer : null
         * hasPayTip : null
         * notPayTip : null
         * hasPay : false
         * canRead : false
         * reason : needPay
         * amount : 22.00
         */

        private int code;
        private String title;
        private String header;
        private String content;
        private String footer;
        private String hasPayTip;
        private String notPayTip;
        private boolean hasPay;
        private boolean canRead;
        private String reason;
        private String amount;

        public String getTitle() {
            return title;
        }

        public void setTitle(String title) {
            this.title = title;
        }

        public String getHeader() {
            return header;
        }

        public void setHeader(String header) {
            this.header = header;
        }

        public String getContent() {
            return content;
        }

        public void setContent(String content) {
            this.content = content;
        }

        public String getFooter() {
            return footer;
        }

        public void setFooter(String footer) {
            this.footer = footer;
        }

        public String getHasPayTip() {
            return hasPayTip;
        }

        public void setHasPayTip(String hasPayTip) {
            this.hasPayTip = hasPayTip;
        }

        public String getNotPayTip() {
            return notPayTip;
        }

        public void setNotPayTip(String notPayTip) {
            this.notPayTip = notPayTip;
        }

        public int getCode() {
            return code;
        }

        public void setCode(int code) {
            this.code = code;
        }


        public boolean isHasPay() {
            return hasPay;
        }

        public void setHasPay(boolean hasPay) {
            this.hasPay = hasPay;
        }

        public boolean isCanRead() {
            return canRead;
        }

        public void setCanRead(boolean canRead) {
            this.canRead = canRead;
        }

        public String getReason() {
            return reason;
        }

        public void setReason(String reason) {
            this.reason = reason;
        }

        public String getAmount() {
            return amount;
        }

        public void setAmount(String amount) {
            this.amount = amount;
        }
    }

    public static class InfoBean {
        /**
         * sqlList : ["主库(5303)：SELECT * FROM `ssc_doc_content`  WHERE `id` = '11'    --Spent：0.33 ms","主库(5303)：SELECT * FROM `ssc_doc_category`  WHERE `id` = '1'    --Spent：0.14 ms","主库(5303)：SELECT * FROM `ssc_coin_log`  WHERE `uid` = '2679' AND `liqType` = '14' AND `extfield0` = '267911'    --Spent：0.13 ms"]
         * sqlTotalNum : 3
         * sqlTotalTime : 0.6 ms
         * traceBack : {"loader":"1.37 ms","initDi":"7.81 ms","settings":null,"access":"16.82 ms","dispatch":null}
         * runtime : 21.54 ms
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
             * loader : 1.37 ms
             * initDi : 7.81 ms
             * settings : null
             * access : 16.82 ms
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
