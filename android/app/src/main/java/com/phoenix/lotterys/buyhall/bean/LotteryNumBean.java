package com.phoenix.lotterys.buyhall.bean;

import java.util.List;

/**
 * Created by Luke
 * on 2019/6/18
 */
public class LotteryNumBean {


    /**
     * code : 0
     * msg : 获取下期信息成功
     * data : {"id":"123","title":"极速六合彩","gameType":"lhc","isSeal":"0","serverTime":"2019-08-23 17:58:53","curIssue":"1908230865","curOpenTime":"2019-08-23 18:00:00","curCloseTime":"2019-08-23 17:59:55","zodiacNums":[{"key":"pig","name":"猪","nums":[1,13,25,37,49]},{"key":"dog","name":"狗","nums":[2,14,26,38]},{"key":"rooster","name":"鸡","nums":[3,15,27,39]},{"key":"monkey","name":"猴","nums":[4,16,28,40]},{"key":"goat","name":"羊","nums":[5,17,29,41]},{"key":"horse","name":"马","nums":[6,18,30,42]},{"key":"snake","name":"蛇","nums":[7,19,31,43]},{"key":"dragon","name":"龙","nums":[8,20,32,44]},{"key":"rabbit","name":"兔","nums":[9,21,33,45]},{"key":"tiger","name":"虎","nums":[10,22,34,46]},{"key":"ox","name":"牛","nums":[11,23,35,47]},{"key":"rat","name":"鼠","nums":[12,24,36,48]}],"fiveElements":[{"name":"金","key":"metal","nums":[5,6,19,20,27,28,35,36,49]},{"name":"木","key":"wood","nums":[1,2,9,10,17,18,31,32,39,40,47,48]},{"name":"水","key":"water","nums":[7,8,15,16,23,24,37,38,45,46]},{"name":"火","key":"fire","nums":[3,4,11,12,25,26,33,34,41,42]},{"name":"土","key":"earth","nums":[13,14,21,22,29,30,43,44]}],"preIsOpen":0,"preIssue":"1908230864","preOpenTime":"2019-08-23 17:58:45","preNum":"33,14,23,27,42,48,15","preResult":"兔,狗,牛,鸡,马,鼠,鸡","adEnable":0,"adPic":"","adLink":0,"adGameType":""}
     * info : {"sqlList":["主库(5303)：SELECT * FROM `ssc_type` WHERE  `id` = :id   --Spent：0.46 ms","主库(5303)：SELECT time, number, data FROM `ssc_data` WHERE  `type` = :type  AND time <= 1566554333 ORDER BY  number DESC  --Spent：5.53 ms"],"sqlTotalNum":2,"sqlTotalTime":"5.99 ms","runtime":"28.66 ms"}
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
         * id : 123
         * title : 极速六合彩
         * gameType : lhc
         * isSeal : 0
         * serverTime : 2019-08-23 17:58:53
         * curIssue : 1908230865
         * curOpenTime : 2019-08-23 18:00:00
         * curCloseTime : 2019-08-23 17:59:55
         * zodiacNums : [{"key":"pig","name":"猪","nums":[1,13,25,37,49]},{"key":"dog","name":"狗","nums":[2,14,26,38]},{"key":"rooster","name":"鸡","nums":[3,15,27,39]},{"key":"monkey","name":"猴","nums":[4,16,28,40]},{"key":"goat","name":"羊","nums":[5,17,29,41]},{"key":"horse","name":"马","nums":[6,18,30,42]},{"key":"snake","name":"蛇","nums":[7,19,31,43]},{"key":"dragon","name":"龙","nums":[8,20,32,44]},{"key":"rabbit","name":"兔","nums":[9,21,33,45]},{"key":"tiger","name":"虎","nums":[10,22,34,46]},{"key":"ox","name":"牛","nums":[11,23,35,47]},{"key":"rat","name":"鼠","nums":[12,24,36,48]}]
         * fiveElements : [{"name":"金","key":"metal","nums":[5,6,19,20,27,28,35,36,49]},{"name":"木","key":"wood","nums":[1,2,9,10,17,18,31,32,39,40,47,48]},{"name":"水","key":"water","nums":[7,8,15,16,23,24,37,38,45,46]},{"name":"火","key":"fire","nums":[3,4,11,12,25,26,33,34,41,42]},{"name":"土","key":"earth","nums":[13,14,21,22,29,30,43,44]}]
         * preIsOpen : 0
         * preIssue : 1908230864
         * preOpenTime : 2019-08-23 17:58:45
         * preNum : 33,14,23,27,42,48,15
         * preResult : 兔,狗,牛,鸡,马,鼠,鸡
         * adEnable : 0
         * adPic :
         * adLink : 0
         * adGameType :
         */

        private String id;
        private String title;
        private String gameType;
        private String isSeal;
        private String serverTime;
        private String curIssue;
        private String curOpenTime;
        private String curCloseTime;
        private String preIsOpen;
        private String preIssue;
        private String preOpenTime;
        private String preNum;
        private String preResult;
        private String adEnable;
        private String adPic;
        private String adLink;
        private String adGameType;
        private String adLinkType;
        private String isClose;
        private String serverTimestamp;
        private List<ZodiacNumsBean> zodiacNums;
        private List<FiveElementsBean> fiveElements;
        private List<String> winningPlayers;

        public String getServerTimestamp() {
            return serverTimestamp;
        }

        public void setServerTimestamp(String serverTimestamp) {
            this.serverTimestamp = serverTimestamp;
        }

        public String getIsClose() {
            return isClose;
        }

        public void setIsClose(String isClose) {
            this.isClose = isClose;
        }

        public String getAdLinkType() {
            return adLinkType;
        }

        public void setAdLinkType(String adLinkType) {
            this.adLinkType = adLinkType;
        }

        public String getAdEnable() {
            return adEnable;
        }

        public void setAdEnable(String adEnable) {
            this.adEnable = adEnable;
        }

        public String getPreIsOpen() {
            return preIsOpen;
        }

        public void setPreIsOpen(String preIsOpen) {
            this.preIsOpen = preIsOpen;
        }

        public String getAdLink() {
            return adLink;
        }

        public void setAdLink(String adLink) {
            this.adLink = adLink;
        }

        public List<String> getWinningPlayers() {
            return winningPlayers;
        }

        public void setWinningPlayers(List<String> winningPlayers) {
            this.winningPlayers = winningPlayers;
        }

        public String getId() {
            return id;
        }

        public void setId(String id) {
            this.id = id;
        }

        public String getTitle() {
            return title;
        }

        public void setTitle(String title) {
            this.title = title;
        }

        public String getGameType() {
            return gameType;
        }

        public void setGameType(String gameType) {
            this.gameType = gameType;
        }

        public String getIsSeal() {
            return isSeal;
        }

        public void setIsSeal(String isSeal) {
            this.isSeal = isSeal;
        }

        public String getServerTime() {
            return serverTime;
        }

        public void setServerTime(String serverTime) {
            this.serverTime = serverTime;
        }

        public String getCurIssue() {
            return curIssue;
        }

        public void setCurIssue(String curIssue) {
            this.curIssue = curIssue;
        }

        public String getCurOpenTime() {
            return curOpenTime;
        }

        public void setCurOpenTime(String curOpenTime) {
            this.curOpenTime = curOpenTime;
        }

        public String getCurCloseTime() {
            return curCloseTime;
        }

        public void setCurCloseTime(String curCloseTime) {
            this.curCloseTime = curCloseTime;
        }



        public String getPreIssue() {
            return preIssue;
        }

        public void setPreIssue(String preIssue) {
            this.preIssue = preIssue;
        }

        public String getPreOpenTime() {
            return preOpenTime;
        }

        public void setPreOpenTime(String preOpenTime) {
            this.preOpenTime = preOpenTime;
        }

        public String getPreNum() {
            return preNum;
        }

        public void setPreNum(String preNum) {
            this.preNum = preNum;
        }

        public String getPreResult() {
            return preResult;
        }

        public void setPreResult(String preResult) {
            this.preResult = preResult;
        }


        public String getAdPic() {
            return adPic;
        }

        public void setAdPic(String adPic) {
            this.adPic = adPic;
        }


        public String getAdGameType() {
            return adGameType;
        }

        public void setAdGameType(String adGameType) {
            this.adGameType = adGameType;
        }

        public List<ZodiacNumsBean> getZodiacNums() {
            return zodiacNums;
        }

        public void setZodiacNums(List<ZodiacNumsBean> zodiacNums) {
            this.zodiacNums = zodiacNums;
        }

        public List<FiveElementsBean> getFiveElements() {
            return fiveElements;
        }

        public void setFiveElements(List<FiveElementsBean> fiveElements) {
            this.fiveElements = fiveElements;
        }

        public static class ZodiacNumsBean {
            /**
             * key : pig
             * name : 猪
             * nums : [1,13,25,37,49]
             */

            private String key;
            private String name;
            private List<Integer> nums;

            public String getKey() {
                return key;
            }

            public void setKey(String key) {
                this.key = key;
            }

            public String getName() {
                return name;
            }

            public void setName(String name) {
                this.name = name;
            }

            public List<Integer> getNums() {
                return nums;
            }

            public void setNums(List<Integer> nums) {
                this.nums = nums;
            }
        }

        public static class FiveElementsBean {
            /**
             * name : 金
             * key : metal
             * nums : [5,6,19,20,27,28,35,36,49]
             */

            private String name;
            private String key;
            private List<Integer> nums;

            public String getName() {
                return name;
            }

            public void setName(String name) {
                this.name = name;
            }

            public String getKey() {
                return key;
            }

            public void setKey(String key) {
                this.key = key;
            }

            public List<Integer> getNums() {
                return nums;
            }

            public void setNums(List<Integer> nums) {
                this.nums = nums;
            }
        }
    }

    public static class InfoBean {
        /**
         * sqlList : ["主库(5303)：SELECT * FROM `ssc_type` WHERE  `id` = :id   --Spent：0.46 ms","主库(5303)：SELECT time, number, data FROM `ssc_data` WHERE  `type` = :type  AND time <= 1566554333 ORDER BY  number DESC  --Spent：5.53 ms"]
         * sqlTotalNum : 2
         * sqlTotalTime : 5.99 ms
         * runtime : 28.66 ms
         */

        private int sqlTotalNum;
        private String sqlTotalTime;
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
    }
}
