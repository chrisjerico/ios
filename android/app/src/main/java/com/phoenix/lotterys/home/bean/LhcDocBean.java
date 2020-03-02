package com.phoenix.lotterys.home.bean;

import java.util.List;

/**
 * Greated by Luke
 * on 2019/11/25
 */
public class LhcDocBean {

    /**
     * code : 0
     * msg : 六合彩栏目列表获取成功
     * data : [{"id":"1","name":"高手论坛","alias":"forum","desc":"高手心水汇总","icon":"https://cdn01.mayihong.cn/images/lhc/icon_forum.png","isHot":"0","link":""},{"id":"2","name":"极品专贴","alias":"gourmet","desc":"超准资料免费转","icon":"https://cdn01.mayihong.cn/images/lhc/icon_gourmet.png","isHot":"0","link":""},{"id":"3","name":"每期资料","alias":"mystery","desc":"六合玄机破解","icon":"https://cdn01.mayihong.cn/images/lhc/icon_mystery.png","isHot":"0","link":""},{"id":"4","name":"公式规律","alias":"rule","desc":"公式规律大全","icon":"https://cdn01.mayihong.cn/images/lhc/icon_rule.png","isHot":"0","link":""},{"id":"5","name":"六合图库","alias":"sixpic","desc":"六合图库免費看","icon":"https://cdn01.mayihong.cn/images/lhc/icon_sixpic.png","isHot":"0","link":""},{"id":"6","name":"幽默猜测","alias":"humorGuess","desc":"猜一猜找特码","icon":"https://cdn01.mayihong.cn/images/lhc/icon_humorGuess.png","isHot":"0","link":""},{"id":"7","name":"跑狗玄机","alias":"rundog","desc":"新老跑狗交流分享","icon":"https://cdn01.mayihong.cn/images/lhc/icon_rundog.png","isHot":"0","link":""},{"id":"8","name":"四不像","alias":"fourUnlike","desc":"香港挂牌竞猜","icon":"https://cdn01.mayihong.cn/images/lhc/icon_fourUnlike.png","isHot":"0","link":""},{"id":"9","name":"老黃历","alias":"yellowCale","desc":"六合每期吉数黃历","icon":"https://cdn01.mayihong.cn/images/lhc/icon_yellowCale.png","isHot":"0","link":""},{"id":"10","name":"QQ客服","alias":"a3pMdna3","desc":"QQ客服","icon":"https://cdn01.mayihong.cn/upload/t010/customise/picture/lhcdoc/5dc955e9ca9c753.jpg","isHot":"0","link":"https://www.baidu.com/"},{"id":"11","name":"彩票大厅","alias":"aS8Lk998","desc":"彩票大厅","icon":"https://cdn01.mayihong.cn/upload/t010/customise/picture/lhcdoc/5dcba0b865a4364.jpg","isHot":"0","link":""}]
     * info : {"sqlList":["从库(5304)：SELECT id, name, title, value FROM `ssc_params`    --Spent：0.71 ms","从库(5304)：SELECT * FROM `ssc_blacklist`  WHERE  `type` = ip   --Spent：0.38 ms","从库(5304)：SELECT * FROM `ssc_cache`  WHERE `name` = block_country  LIMIT 0,1  --Spent：0.25 ms","主库(5303)：SELECT id,name,alias,`desc`,icon,isHot,link FROM `ssc_lhcdoc`  WHERE  `enable` = 1 AND `pid` = 0  ORDER BY sort,id  --Spent：0.46 ms"],"sqlTotalNum":4,"sqlTotalTime":"1.8 ms","traceBack":{"loader":"2.67 ms","initDi":"39.13 ms","settings":"63.72 ms","access":"71.59 ms","dispatch":null},"runtime":"73.38 ms"}
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
         * sqlList : ["从库(5304)：SELECT id, name, title, value FROM `ssc_params`    --Spent：0.71 ms","从库(5304)：SELECT * FROM `ssc_blacklist`  WHERE  `type` = ip   --Spent：0.38 ms","从库(5304)：SELECT * FROM `ssc_cache`  WHERE `name` = block_country  LIMIT 0,1  --Spent：0.25 ms","主库(5303)：SELECT id,name,alias,`desc`,icon,isHot,link FROM `ssc_lhcdoc`  WHERE  `enable` = 1 AND `pid` = 0  ORDER BY sort,id  --Spent：0.46 ms"]
         * sqlTotalNum : 4
         * sqlTotalTime : 1.8 ms
         * traceBack : {"loader":"2.67 ms","initDi":"39.13 ms","settings":"63.72 ms","access":"71.59 ms","dispatch":null}
         * runtime : 73.38 ms
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
             * loader : 2.67 ms
             * initDi : 39.13 ms
             * settings : 63.72 ms
             * access : 71.59 ms
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

    public static class DataBean {
        /**
         * id : 1
         * name : 高手论坛
         * alias : forum
         * desc : 高手心水汇总
         * icon : https://cdn01.mayihong.cn/images/lhc/icon_forum.png
         * isHot : 0
         * link :
         */

        private String id;
        private String name;
        private String alias;
        private String desc;
        private String icon;
        private String isHot;
        private String link;
        private String appLink;
        private String appLinkCode;

        private String contentId;
        private String thread_type;

        public String getThread_type() {
            return thread_type;
        }

        public void setThread_type(String thread_type) {
            this.thread_type = thread_type;
        }

        public String getContent_id() {
            return contentId;
        }

        public void setContent_id(String contentId) {
            this.contentId = contentId;
        }

        public String getAppLink() {
            return appLink;
        }

        public void setAppLink(String appLink) {
            this.appLink = appLink;
        }

        public String getAppLinkCode() {
            return appLinkCode;
        }

        public void setAppLinkCode(String appLinkCode) {
            this.appLinkCode = appLinkCode;
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

        public String getAlias() {
            return alias;
        }

        public void setAlias(String alias) {
            this.alias = alias;
        }

        public String getDesc() {
            return desc;
        }

        public void setDesc(String desc) {
            this.desc = desc;
        }

        public String getIcon() {
            return icon;
        }

        public void setIcon(String icon) {
            this.icon = icon;
        }

        public String getIsHot() {
            return isHot;
        }

        public void setIsHot(String isHot) {
            this.isHot = isHot;
        }

        public String getLink() {
            return link;
        }

        public void setLink(String link) {
            this.link = link;
        }
    }
}
