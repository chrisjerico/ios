package com.phoenix.lotterys.home.bean;

import java.util.List;

/**
 * Greated by Luke
 * on 2019/8/30
 */
public class OnLineBean {

    /**
     * code : 0
     * msg : 获取在线人数成功
     * data : {"onlineSwitch":1,"onlineUserCount":1}
     * info : {"sqlList":["从库(5304)：SELECT name, value FROM `ssc_params` WHERE  `name` IN ('m_promote_people','m_promote_people_real','m_promote_people_realbeishu','m_promote_people_realsone','m_promote_people_realstwo')   --Spent：0.36 ms","主库(5303)：SELECT  count(1) as total FROM `ssc_member_session` WHERE  `isOnLine` = :isOnLine  AND accessTime > 1567173391  --Spent：0.25 ms"],"sqlTotalNum":2,"sqlTotalTime":"0.61 ms","traceBack":{"loader":"1.49 ms","initDi":"8.13 ms","settings":null,"access":"17.42 ms","dispatch":null},"runtime":"19.69 ms"}
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
         * onlineSwitch : 1
         * onlineUserCount : 1
         */

        private String onlineSwitch;
        private String onlineUserCount;

        public String getOnlineSwitch() {
            return onlineSwitch;
        }

        public void setOnlineSwitch(String onlineSwitch) {
            this.onlineSwitch = onlineSwitch;
        }

        public String getOnlineUserCount() {
            return onlineUserCount;
        }

        public void setOnlineUserCount(String onlineUserCount) {
            this.onlineUserCount = onlineUserCount;
        }
    }

    public static class InfoBean {
        /**
         * sqlList : ["从库(5304)：SELECT name, value FROM `ssc_params` WHERE  `name` IN ('m_promote_people','m_promote_people_real','m_promote_people_realbeishu','m_promote_people_realsone','m_promote_people_realstwo')   --Spent：0.36 ms","主库(5303)：SELECT  count(1) as total FROM `ssc_member_session` WHERE  `isOnLine` = :isOnLine  AND accessTime > 1567173391  --Spent：0.25 ms"]
         * sqlTotalNum : 2
         * sqlTotalTime : 0.61 ms
         * traceBack : {"loader":"1.49 ms","initDi":"8.13 ms","settings":null,"access":"17.42 ms","dispatch":null}
         * runtime : 19.69 ms
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
             * loader : 1.49 ms
             * initDi : 8.13 ms
             * settings : null
             * access : 17.42 ms
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
