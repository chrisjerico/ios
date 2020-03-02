package com.phoenix.lotterys.my.bean;

import java.util.List;

/**
 * Greated by Luke
 * on 2019/11/14
 */
public class OneKeyTransferBean {

    /**
     * code : 0
     * msg : 获取需要一键转出的真人列表成功
     * data : {"games":[{"id":14,"name":"VR彩票"},{"id":19,"name":"乐游棋牌"},{"id":35,"name":"沙巴体育"},{"id":39,"name":"JDB电子"},{"id":42,"name":"BG视讯"},{"id":52,"name":"FG电子"},{"id":53,"name":"RG皇家视讯"},{"id":59,"name":"AG视讯"},{"id":60,"name":"DG视讯"},{"id":62,"name":"AG电子"},{"id":63,"name":"AG捕鱼"},{"id":68,"name":"乐游捕鱼"},{"id":73,"name":"MG电子"}]}
     * info : {"sqlList":["主库(5303)：SELECT * FROM `ssc_level`  WHERE `id` = -1  LIMIT 0,1  --Spent：0.69 ms","主库(5303)：SELECT * FROM `ssc_member_bank`  WHERE `uid` = 2078488  LIMIT 0,1  --Spent：0.57 ms","主库(5303)：SELECT game_id FROM `ssc_real_trans`  WHERE  `uid` = 2078488  AND amount > 0 AND actionTime > 1573109829 GROUP BY game_id  --Spent：1.00 ms","主库(5303)：SELECT * FROM `ssc_real`  WHERE  `id` IN ('14','19','35','39','42','52','53','59','60','62','63','68','73') AND `enable` = 1   --Spent：0.86 ms"],"sqlTotalNum":4,"sqlTotalTime":"3.12 ms","traceBack":{"loader":"4.25 ms","initDi":"162.91 ms","settings":null,"access":"207.70 ms","dispatch":null},"runtime":"219.52 ms"}
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
        private List<GamesBean> games;

        public List<GamesBean> getGames() {
            return games;
        }

        public void setGames(List<GamesBean> games) {
            this.games = games;
        }

        public static class GamesBean {
            /**
             * id : 14
             * name : VR彩票
             */

            private String id;
            private String name;

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
        }
    }

    public static class InfoBean {
        /**
         * sqlList : ["主库(5303)：SELECT * FROM `ssc_level`  WHERE `id` = -1  LIMIT 0,1  --Spent：0.69 ms","主库(5303)：SELECT * FROM `ssc_member_bank`  WHERE `uid` = 2078488  LIMIT 0,1  --Spent：0.57 ms","主库(5303)：SELECT game_id FROM `ssc_real_trans`  WHERE  `uid` = 2078488  AND amount > 0 AND actionTime > 1573109829 GROUP BY game_id  --Spent：1.00 ms","主库(5303)：SELECT * FROM `ssc_real`  WHERE  `id` IN ('14','19','35','39','42','52','53','59','60','62','63','68','73') AND `enable` = 1   --Spent：0.86 ms"]
         * sqlTotalNum : 4
         * sqlTotalTime : 3.12 ms
         * traceBack : {"loader":"4.25 ms","initDi":"162.91 ms","settings":null,"access":"207.70 ms","dispatch":null}
         * runtime : 219.52 ms
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
             * loader : 4.25 ms
             * initDi : 162.91 ms
             * settings : null
             * access : 207.70 ms
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
