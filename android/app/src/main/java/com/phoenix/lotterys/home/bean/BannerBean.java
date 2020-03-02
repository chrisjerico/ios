package com.phoenix.lotterys.home.bean;

import java.util.List;

/**
 * Created by Luke
 * on 2019/6/23
 */
public class BannerBean {


    /**
     * code : 0
     * data : {"interval":"10","list":[{"pic":"https://cdn01.hchejie.net/upload/t010/customise/images/pc_banner_1.jpg?v=1568469408","sort":"1","url":""},{"pic":"https://cdn01.hchejie.net/upload/t010/customise/images/pc_banner_2.jpg?v=1568469408","sort":"2","url":""},{"pic":"https://cdn01.hchejie.net/upload/t010/customise/images/pc_banner_3.jpg?v=1568469408","sort":"3","url":""},{"pic":"https://cdn01.hchejie.net/upload/t010/customise/images/pc_banner_4.jpg?v=1568469408","sort":"4","url":""},{"pic":"https://cdn01.hchejie.net/upload/t010/customise/images/pc_banner_5.jpg?v=1568469408","sort":"5","url":""},{"pic":"https://cdn01.hchejie.net/upload/t010/customise/images/pc_banner_6.jpg?v=1568469408","sort":"6","url":""}]}
     * info : {"runtime":"39.20 ms","sqlList":["从库(5304)：SELECT id, name, title, value FROM `ssc_params`   --Spent：0.64 ms","从库(5304)：SELECT * FROM `ssc_blacklist` WHERE  `type` = :type   --Spent：0.25 ms","从库(5304)：SELECT * FROM `ssc_cache`  WHERE `name` = 'block_country'    --Spent：0.15 ms","从库(5304)：SELECT * FROM `ssc_cache` WHERE name LIKE 'pc_banner_sort_%' ORDER BY content asc  --Spent：0.54 ms","从库(5304)：SELECT name, last_update FROM `ssc_upload` WHERE name LIKE '%pc_banner_%' AND last_update > 0 ORDER BY name ASC  --Spent：0.39 ms","主库(5303)：SELECT name, value FROM `ssc_params` WHERE title='slide_url_ary_pc' ORDER BY id asc  --Spent：0.16 ms"],"sqlTotalNum":6,"sqlTotalTime":"2.13 ms","traceBack":{"access":"36.12 ms","initDi":"8.53 ms","loader":"1.50 ms","settings":"30.04 ms"}}
     * msg : 获取首页轮播图成功
     */

    private int code;
    private DataBean data;
    private InfoBean info;
    private String msg;

    public int getCode() {
        return code;
    }

    public void setCode(int code) {
        this.code = code;
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

    public String getMsg() {
        return msg;
    }

    public void setMsg(String msg) {
        this.msg = msg;
    }

    public static class DataBean {
        /**
         * interval : 10
         * list : [{"pic":"https://cdn01.hchejie.net/upload/t010/customise/images/pc_banner_1.jpg?v=1568469408","sort":"1","url":""},{"pic":"https://cdn01.hchejie.net/upload/t010/customise/images/pc_banner_2.jpg?v=1568469408","sort":"2","url":""},{"pic":"https://cdn01.hchejie.net/upload/t010/customise/images/pc_banner_3.jpg?v=1568469408","sort":"3","url":""},{"pic":"https://cdn01.hchejie.net/upload/t010/customise/images/pc_banner_4.jpg?v=1568469408","sort":"4","url":""},{"pic":"https://cdn01.hchejie.net/upload/t010/customise/images/pc_banner_5.jpg?v=1568469408","sort":"5","url":""},{"pic":"https://cdn01.hchejie.net/upload/t010/customise/images/pc_banner_6.jpg?v=1568469408","sort":"6","url":""}]
         */

        private String interval;
        private List<ListBean> list;

        public String getInterval() {
            return interval;
        }

        public void setInterval(String interval) {
            this.interval = interval;
        }

        public List<ListBean> getList() {
            return list;
        }

        public void setList(List<ListBean> list) {
            this.list = list;
        }

        public static class ListBean {
            /**
             * pic : https://cdn01.hchejie.net/upload/t010/customise/images/pc_banner_1.jpg?v=1568469408
             * sort : 1
             * url :
             */

            private String pic;
            private String sort;
            private String url;
            private String linkCategory;
            private String linkPosition;
            private String lotteryGameType;
            private String realIsPopup;
            private String realSupportTrial;

            public String getLotteryGameType() {
                return lotteryGameType;
            }

            public void setLotteryGameType(String lotteryGameType) {
                this.lotteryGameType = lotteryGameType;
            }

            public String getRealIsPopup() {
                return realIsPopup;
            }

            public void setRealIsPopup(String realIsPopup) {
                this.realIsPopup = realIsPopup;
            }

            public String getRealSupportTrial() {
                return realSupportTrial;
            }

            public void setRealSupportTrial(String realSupportTrial) {
                this.realSupportTrial = realSupportTrial;
            }

            public String getLinkCategory() {
                return linkCategory;
            }

            public void setLinkCategory(String linkCategory) {
                this.linkCategory = linkCategory;
            }

            public String getLinkPosition() {
                return linkPosition;
            }

            public void setLinkPosition(String linkPosition) {
                this.linkPosition = linkPosition;
            }

            public String getPic() {
                return pic;
            }

            public void setPic(String pic) {
                this.pic = pic;
            }

            public String getSort() {
                return sort;
            }

            public void setSort(String sort) {
                this.sort = sort;
            }

            public String getUrl() {
                return url;
            }

            public void setUrl(String url) {
                this.url = url;
            }
        }
    }

    public static class InfoBean {
        /**
         * runtime : 39.20 ms
         * sqlList : ["从库(5304)：SELECT id, name, title, value FROM `ssc_params`   --Spent：0.64 ms","从库(5304)：SELECT * FROM `ssc_blacklist` WHERE  `type` = :type   --Spent：0.25 ms","从库(5304)：SELECT * FROM `ssc_cache`  WHERE `name` = 'block_country'    --Spent：0.15 ms","从库(5304)：SELECT * FROM `ssc_cache` WHERE name LIKE 'pc_banner_sort_%' ORDER BY content asc  --Spent：0.54 ms","从库(5304)：SELECT name, last_update FROM `ssc_upload` WHERE name LIKE '%pc_banner_%' AND last_update > 0 ORDER BY name ASC  --Spent：0.39 ms","主库(5303)：SELECT name, value FROM `ssc_params` WHERE title='slide_url_ary_pc' ORDER BY id asc  --Spent：0.16 ms"]
         * sqlTotalNum : 6
         * sqlTotalTime : 2.13 ms
         * traceBack : {"access":"36.12 ms","initDi":"8.53 ms","loader":"1.50 ms","settings":"30.04 ms"}
         */

        private String runtime;
        private int sqlTotalNum;
        private String sqlTotalTime;
        private TraceBackBean traceBack;
        private List<String> sqlList;

        public String getRuntime() {
            return runtime;
        }

        public void setRuntime(String runtime) {
            this.runtime = runtime;
        }

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

        public List<String> getSqlList() {
            return sqlList;
        }

        public void setSqlList(List<String> sqlList) {
            this.sqlList = sqlList;
        }

        public static class TraceBackBean {
            /**
             * access : 36.12 ms
             * initDi : 8.53 ms
             * loader : 1.50 ms
             * settings : 30.04 ms
             */

            private String access;
            private String initDi;
            private String loader;
            private String settings;

            public String getAccess() {
                return access;
            }

            public void setAccess(String access) {
                this.access = access;
            }

            public String getInitDi() {
                return initDi;
            }

            public void setInitDi(String initDi) {
                this.initDi = initDi;
            }

            public String getLoader() {
                return loader;
            }

            public void setLoader(String loader) {
                this.loader = loader;
            }

            public String getSettings() {
                return settings;
            }

            public void setSettings(String settings) {
                this.settings = settings;
            }
        }
    }
}
