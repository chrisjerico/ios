package com.phoenix.lotterys.home.bean;

import java.util.List;

/**
 * Greated by Luke
 * on 2019/9/12
 */
public class BbsInfoListBean {

    /**
     * code : 0
     * msg : 游戏资讯列表获取成功
     * data : {"list":[{"id":"11","title_b":"","title_i":"","title_u":"","title_color":"#222222","title":"热热温热嗯嗯按照新刷新","click":"24","amount":"22.00","accessRule":"guest","belongDate":"2019-09-06","createTime":"2019-09-06 16:53:49","updateTime":"2019-09-09 23:00:21"},{"id":"10","title_b":"","title_i":"","title_u":"","title_color":"#222222","title":"呀呀呀呀呀呀所","click":"22","amount":"30.00","accessRule":"guest","belongDate":"2019-09-06","createTime":"2019-09-06 16:48:44","updateTime":"2019-09-06 19:27:48"},{"id":"3","title_b":"","title_i":"","title_u":"","title_color":"#222222","title":"赢家通赢第三课 - 看透事务本质的能力","click":"24","amount":"0.00","accessRule":"guest","belongDate":"2019-09-03","createTime":"2019-09-03 16:04:03","updateTime":"2019-09-05 22:59:55"},{"id":"2","title_b":"","title_i":"","title_u":"","title_color":"#222222","title":"赢家通赢第二课 - 你思考过你的思考吗","click":"11","amount":"888.00","accessRule":"user","belongDate":"2019-09-03","createTime":"2019-09-03 16:02:21","updateTime":"2019-09-06 19:20:02"},{"id":"1","title_b":"","title_i":"","title_u":"","title_color":"#222222","title":"赢家通赢第一课 - 升级你的思维模型","click":"9","amount":"888.00","accessRule":"user","belongDate":"2019-09-03","createTime":"2019-09-03 16:01:31","updateTime":"2019-09-06 16:38:46"}],"total":5}
     * info : {"sqlList":["主库(5303)：SELECT * FROM `ssc_doc_content` WHERE `category` = 1 AND `enable` = 1 ORDER BY on_top DESC, dateline DESC, id DESC limit 0,20  --Spent：0.50 ms","主库(5303)：SELECT  count(1) as total FROM `ssc_doc_content` WHERE `category` = 1 AND `enable` = 1  --Spent：0.17 ms"],"sqlTotalNum":2,"sqlTotalTime":"0.67 ms","traceBack":{"loader":"1.39 ms","initDi":"7.94 ms","settings":null,"access":"16.52 ms","dispatch":null},"runtime":"18.16 ms"}
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
         * list : [{"id":"11","title_b":"","title_i":"","title_u":"","title_color":"#222222","title":"热热温热嗯嗯按照新刷新","click":"24","amount":"22.00","accessRule":"guest","belongDate":"2019-09-06","createTime":"2019-09-06 16:53:49","updateTime":"2019-09-09 23:00:21"},{"id":"10","title_b":"","title_i":"","title_u":"","title_color":"#222222","title":"呀呀呀呀呀呀所","click":"22","amount":"30.00","accessRule":"guest","belongDate":"2019-09-06","createTime":"2019-09-06 16:48:44","updateTime":"2019-09-06 19:27:48"},{"id":"3","title_b":"","title_i":"","title_u":"","title_color":"#222222","title":"赢家通赢第三课 - 看透事务本质的能力","click":"24","amount":"0.00","accessRule":"guest","belongDate":"2019-09-03","createTime":"2019-09-03 16:04:03","updateTime":"2019-09-05 22:59:55"},{"id":"2","title_b":"","title_i":"","title_u":"","title_color":"#222222","title":"赢家通赢第二课 - 你思考过你的思考吗","click":"11","amount":"888.00","accessRule":"user","belongDate":"2019-09-03","createTime":"2019-09-03 16:02:21","updateTime":"2019-09-06 19:20:02"},{"id":"1","title_b":"","title_i":"","title_u":"","title_color":"#222222","title":"赢家通赢第一课 - 升级你的思维模型","click":"9","amount":"888.00","accessRule":"user","belongDate":"2019-09-03","createTime":"2019-09-03 16:01:31","updateTime":"2019-09-06 16:38:46"}]
         * total : 5
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
             * id : 11
             * title_b :
             * title_i :
             * title_u :
             * title_color : #222222
             * title : 热热温热嗯嗯按照新刷新
             * click : 24
             * amount : 22.00
             * accessRule : guest
             * belongDate : 2019-09-06
             * createTime : 2019-09-06 16:53:49
             * updateTime : 2019-09-09 23:00:21
             */

            private String id;
            private String title_b;
            private String title_i;
            private String title_u;
            private String title_color;
            private String title;
            private String click;
            private String amount;
            private String accessRule;
            private String belongDate;
            private String createTime;
            private String updateTime;

            public String getId() {
                return id;
            }

            public void setId(String id) {
                this.id = id;
            }

            public String getTitle_b() {
                return title_b;
            }

            public void setTitle_b(String title_b) {
                this.title_b = title_b;
            }

            public String getTitle_i() {
                return title_i;
            }

            public void setTitle_i(String title_i) {
                this.title_i = title_i;
            }

            public String getTitle_u() {
                return title_u;
            }

            public void setTitle_u(String title_u) {
                this.title_u = title_u;
            }

            public String getTitle_color() {
                return title_color;
            }

            public void setTitle_color(String title_color) {
                this.title_color = title_color;
            }

            public String getTitle() {
                return title;
            }

            public void setTitle(String title) {
                this.title = title;
            }

            public String getClick() {
                return click;
            }

            public void setClick(String click) {
                this.click = click;
            }

            public String getAmount() {
                return amount;
            }

            public void setAmount(String amount) {
                this.amount = amount;
            }

            public String getAccessRule() {
                return accessRule;
            }

            public void setAccessRule(String accessRule) {
                this.accessRule = accessRule;
            }

            public String getBelongDate() {
                return belongDate;
            }

            public void setBelongDate(String belongDate) {
                this.belongDate = belongDate;
            }

            public String getCreateTime() {
                return createTime;
            }

            public void setCreateTime(String createTime) {
                this.createTime = createTime;
            }

            public String getUpdateTime() {
                return updateTime;
            }

            public void setUpdateTime(String updateTime) {
                this.updateTime = updateTime;
            }
        }
    }

    public static class InfoBean {
        /**
         * sqlList : ["主库(5303)：SELECT * FROM `ssc_doc_content` WHERE `category` = 1 AND `enable` = 1 ORDER BY on_top DESC, dateline DESC, id DESC limit 0,20  --Spent：0.50 ms","主库(5303)：SELECT  count(1) as total FROM `ssc_doc_content` WHERE `category` = 1 AND `enable` = 1  --Spent：0.17 ms"]
         * sqlTotalNum : 2
         * sqlTotalTime : 0.67 ms
         * traceBack : {"loader":"1.39 ms","initDi":"7.94 ms","settings":null,"access":"16.52 ms","dispatch":null}
         * runtime : 18.16 ms
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
             * initDi : 7.94 ms
             * settings : null
             * access : 16.52 ms
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
