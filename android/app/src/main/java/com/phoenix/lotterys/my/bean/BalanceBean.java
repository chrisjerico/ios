package com.phoenix.lotterys.my.bean;

import java.util.List;

/**
 * Greated by Luke
 * on 2019/8/28
 */
public class BalanceBean {


    /**
     * code : 0
     * msg : AG视讯-获取游戏余额获取成功
     * data : {"balance":"9.00"}
     * info : {"sqlList":["从库(5304)：SELECT id, name, title, value FROM `ssc_params`   --Spent：0.74 ms","从库(5304)：SELECT * FROM `ssc_blacklist` WHERE  `type` = :type   --Spent：0.27 ms","从库(5304)：SELECT * FROM `ssc_cache`  WHERE `name` = 'block_country'    --Spent：0.25 ms","主库(5303)：SELECT * FROM `ssc_real` WHERE  `id` = :id   --Spent：0.36 ms","主库(5303)：SELECT * FROM `ssc_real_account` WHERE  `uid` = :uid AND `game_type` = :game_type AND `game_cat` = :game_cat AND `game_username` = :game_username   --Spent：0.39 ms","主库(5303)：SELECT * FROM `ssc_api_settings`   --Spent：0.20 ms","主库(5303)：UPDATE `ssc_real_account` SET `balance` = '9' WHERE `uid` = '2679' AND `game_type` = 'ag4' AND `game_cat` = 'ag4' AND `game_username` = 'ag4t0102679';  --Spent：0.61 ms"],"sqlTotalNum":7,"sqlTotalTime":"2.82 ms","traceBack":{"loader":"1.39 ms","initDi":"8.66 ms","settings":"28.95 ms","access":"40.51 ms","dispatch":null},"runtime":"559.60 ms"}
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
         * balance : 9.00
         */

        private String balance;

        public String getBalance() {
            return balance;
        }

        public void setBalance(String balance) {
            this.balance = balance;
        }
    }

    public static class InfoBean {
        /**
         * sqlList : ["从库(5304)：SELECT id, name, title, value FROM `ssc_params`   --Spent：0.74 ms","从库(5304)：SELECT * FROM `ssc_blacklist` WHERE  `type` = :type   --Spent：0.27 ms","从库(5304)：SELECT * FROM `ssc_cache`  WHERE `name` = 'block_country'    --Spent：0.25 ms","主库(5303)：SELECT * FROM `ssc_real` WHERE  `id` = :id   --Spent：0.36 ms","主库(5303)：SELECT * FROM `ssc_real_account` WHERE  `uid` = :uid AND `game_type` = :game_type AND `game_cat` = :game_cat AND `game_username` = :game_username   --Spent：0.39 ms","主库(5303)：SELECT * FROM `ssc_api_settings`   --Spent：0.20 ms","主库(5303)：UPDATE `ssc_real_account` SET `balance` = '9' WHERE `uid` = '2679' AND `game_type` = 'ag4' AND `game_cat` = 'ag4' AND `game_username` = 'ag4t0102679';  --Spent：0.61 ms"]
         * sqlTotalNum : 7
         * sqlTotalTime : 2.82 ms
         * traceBack : {"loader":"1.39 ms","initDi":"8.66 ms","settings":"28.95 ms","access":"40.51 ms","dispatch":null}
         * runtime : 559.60 ms
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
             * loader : 1.39 ms
             * initDi : 8.66 ms
             * settings : 28.95 ms
             * access : 40.51 ms
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
