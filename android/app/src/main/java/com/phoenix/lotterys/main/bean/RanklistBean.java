package com.phoenix.lotterys.main.bean;

import com.google.gson.annotations.SerializedName;

import java.util.List;

/**
 * Created by Luke
 * on 2019/6/23
 */
public class RanklistBean {


    /**
     * code : 0
     * msg : 获取排行榜数据成功
     * data : {"switch":true,"list":[{"username":"mic***ael","type":"秒秒彩","coin":"100.00","actionTime":"2019-08-28 13:37:26"},{"username":"mic***ael","type":"秒秒彩","coin":"100.00","actionTime":"2019-08-28 13:37:26"},{"username":"mic***ael","type":"秒秒彩","coin":"10.00","actionTime":"2019-09-02 14:17:58"},{"username":"mic***ael","type":"秒秒彩","coin":"10.00","actionTime":"2019-09-02 14:17:58"},{"username":"mic***ael","type":"秒秒彩","coin":"10.00","actionTime":"2019-09-02 14:17:58"},{"username":"mic***ael","type":"秒秒彩","coin":"10.00","actionTime":"2019-09-02 14:17:58"}]}
     * info : {"sqlList":["主库(5303)：SELECT id, name, title, value FROM `ssc_params`   --Spent：0.65 ms","主库(5303)：SELECT * FROM `ssc_blacklist` WHERE  `type` = :type   --Spent：0.34 ms","主库(5303)：SELECT * FROM `ssc_cache`  WHERE `name` = 'block_country'    --Spent：0.26 ms","主库(5303)：SELECT uid, `type`, money, actionTime FROM `ssc_bets` WHERE  `type` = :type  AND money >= 10 AND actionTime > 1566884293 ORDER BY money DESC LIMIT 20  --Spent：0.50 ms","主库(5303)：SELECT uid, username FROM `ssc_members` WHERE  `uid` IN ('1')   --Spent：0.17 ms","主库(5303)：SELECT id, title FROM `ssc_type`   --Spent：0.17 ms"],"sqlTotalNum":6,"sqlTotalTime":"2.09 ms","traceBack":{"loader":"3.92 ms","initDi":"24.84 ms","settings":"59.11 ms","access":"99.53 ms","dispatch":null},"runtime":"106.47 ms"}
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
         * switch : true
         * list : [{"username":"mic***ael","type":"秒秒彩","coin":"100.00","actionTime":"2019-08-28 13:37:26"},{"username":"mic***ael","type":"秒秒彩","coin":"100.00","actionTime":"2019-08-28 13:37:26"},{"username":"mic***ael","type":"秒秒彩","coin":"10.00","actionTime":"2019-09-02 14:17:58"},{"username":"mic***ael","type":"秒秒彩","coin":"10.00","actionTime":"2019-09-02 14:17:58"},{"username":"mic***ael","type":"秒秒彩","coin":"10.00","actionTime":"2019-09-02 14:17:58"},{"username":"mic***ael","type":"秒秒彩","coin":"10.00","actionTime":"2019-09-02 14:17:58"}]
         */

        @SerializedName("switch")
        private boolean switchX;
        private List<ListBean> list;

        public boolean isSwitchX() {
            return switchX;
        }

        public void setSwitchX(boolean switchX) {
            this.switchX = switchX;
        }

        public List<ListBean> getList() {
            return list;
        }

        public void setList(List<ListBean> list) {
            this.list = list;
        }

        public static class ListBean {
            /**
             * username : mic***ael
             * type : 秒秒彩
             * coin : 100.00
             * actionTime : 2019-08-28 13:37:26
             */

            private String username;
            private String type;
            private String coin;
            private String actionTime;
            int img;
            String num;

            public int getImg() {
                return img;
            }

            public void setImg(int img) {
                this.img = img;
            }

            public String getNum() {
                return num;
            }

            public void setNum(String num) {
                this.num = num;
            }

            public String getUsername() {
                return username;
            }

            public void setUsername(String username) {
                this.username = username;
            }

            public String getType() {
                return type;
            }

            public void setType(String type) {
                this.type = type;
            }

            public String getCoin() {
                return coin;
            }

            public void setCoin(String coin) {
                this.coin = coin;
            }

            public String getActionTime() {
                return actionTime;
            }

            public void setActionTime(String actionTime) {
                this.actionTime = actionTime;
            }
        }
    }

    public static class InfoBean {
        /**
         * sqlList : ["主库(5303)：SELECT id, name, title, value FROM `ssc_params`   --Spent：0.65 ms","主库(5303)：SELECT * FROM `ssc_blacklist` WHERE  `type` = :type   --Spent：0.34 ms","主库(5303)：SELECT * FROM `ssc_cache`  WHERE `name` = 'block_country'    --Spent：0.26 ms","主库(5303)：SELECT uid, `type`, money, actionTime FROM `ssc_bets` WHERE  `type` = :type  AND money >= 10 AND actionTime > 1566884293 ORDER BY money DESC LIMIT 20  --Spent：0.50 ms","主库(5303)：SELECT uid, username FROM `ssc_members` WHERE  `uid` IN ('1')   --Spent：0.17 ms","主库(5303)：SELECT id, title FROM `ssc_type`   --Spent：0.17 ms"]
         * sqlTotalNum : 6
         * sqlTotalTime : 2.09 ms
         * traceBack : {"loader":"3.92 ms","initDi":"24.84 ms","settings":"59.11 ms","access":"99.53 ms","dispatch":null}
         * runtime : 106.47 ms
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
             * loader : 3.92 ms
             * initDi : 24.84 ms
             * settings : 59.11 ms
             * access : 99.53 ms
             * dispatch : null
             */

            private String loader;
            private String initDi;
            private String settings;
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

            public String getSettings() {
                return settings;
            }

            public void setSettings(String settings) {
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
