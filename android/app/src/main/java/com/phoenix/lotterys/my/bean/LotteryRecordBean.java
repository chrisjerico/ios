package com.phoenix.lotterys.my.bean;


import java.io.Serializable;
import java.util.List;

/**
 * 文件描述:
 * 创建者: IAN
 * 创建时间: 2019/7/15 15:56
 */
public class LotteryRecordBean implements Serializable {


    /**
     * code : 0
     * msg : 获取彩票开奖历史成功
     * data : {"list":[{"issue":"2019100","openTime":"2019-08-31 21:34:35","num":"14,32,44,06,24,01,05","result":"狗,龙,龙,马,鼠,猪,羊","gameType":"lhc"},{"issue":"2019099","openTime":"2019-08-29 21:35:32","num":"38,26,24,44,08,37,18","result":"狗,狗,鼠,龙,龙,猪,马","gameType":"lhc"},{"issue":"2019098","openTime":"2019-08-27 21:35:06","num":"06,29,18,33,43,46,16","result":"马,羊,马,兔,蛇,虎,猴","gameType":"lhc"},{"issue":"2019097","openTime":"2019-08-24 21:36:58","num":"01,31,47,21,49,10,13","result":"猪,蛇,牛,兔,猪,虎,猪","gameType":"lhc"},{"issue":"2019096","openTime":"2019-08-22 21:37:12","num":"06,42,01,05,04,43,08","result":"马,马,猪,羊,猴,蛇,龙","gameType":"lhc"},{"issue":"2019095","openTime":"2019-08-20 21:37:12","num":"12,32,23,35,16,15,02","result":"鼠,龙,牛,牛,猴,鸡,狗","gameType":"lhc"},{"issue":"2019094","openTime":"2019-08-17 21:35:40","num":"32,44,04,09,26,20,11","result":"龙,龙,猴,兔,狗,龙,牛","gameType":"lhc"},{"issue":"2019093","openTime":"2019-08-15 21:34:36","num":"13,02,38,23,35,46,17","result":"猪,狗,狗,牛,牛,虎,羊","gameType":"lhc"},{"issue":"2019092","openTime":"2019-08-13 21:34:45","num":"29,14,30,16,10,43,11","result":"羊,狗,马,猴,虎,蛇,牛","gameType":"lhc"},{"issue":"2019091","openTime":"2019-08-10 21:35:57","num":"48,49,44,22,15,42,06","result":"鼠,猪,龙,虎,鸡,马,马","gameType":"lhc"},{"issue":"2019090","openTime":"2019-08-08 21:35:39","num":"19,30,08,44,25,09,37","result":"蛇,马,龙,龙,猪,兔,猪","gameType":"lhc"},{"issue":"2019089","openTime":"2019-08-06 21:34:42","num":"06,21,37,22,15,05,36","result":"马,兔,猪,虎,鸡,羊,鼠","gameType":"lhc"},{"issue":"2019088","openTime":"2019-08-03 21:35:04","num":"24,28,43,27,23,37,16","result":"鼠,猴,蛇,鸡,牛,猪,猴","gameType":"lhc"}],"redBalls":[1,2,7,8,12,13,18,19,23,24,29,30,34,35,40,45,46],"greenBalls":[5,6,11,16,17,21,22,27,28,32,33,38,39,43,44,49],"blueBalls":[3,4,9,10,14,15,20,25,26,31,36,37,41,42,47,48]}
     */

    private int code;
    private String msg;
    private DataBean data;

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

    public static class DataBean {
        private List<ListBean> list;
        private List<Integer> redBalls;
        private List<Integer> greenBalls;
        private List<Integer> blueBalls;

        public List<ListBean> getList() {
            return list;
        }

        public void setList(List<ListBean> list) {
            this.list = list;
        }

        public List<Integer> getRedBalls() {
            return redBalls;
        }

        public void setRedBalls(List<Integer> redBalls) {
            this.redBalls = redBalls;
        }

        public List<Integer> getGreenBalls() {
            return greenBalls;
        }

        public void setGreenBalls(List<Integer> greenBalls) {
            this.greenBalls = greenBalls;
        }

        public List<Integer> getBlueBalls() {
            return blueBalls;
        }

        public void setBlueBalls(List<Integer> blueBalls) {
            this.blueBalls = blueBalls;
        }

        public static class ListBean {
            /**
             * issue : 2019100
             * openTime : 2019-08-31 21:34:35
             * num : 14,32,44,06,24,01,05
             * result : 狗,龙,龙,马,鼠,猪,羊
             * gameType : lhc
             */

            private String issue;
            private String openTime;
            private String num;
            private String result;
            private String gameType;
            private List<Integer> winningPlayers;

            public List<Integer> getWinningPlayers() {
                return winningPlayers;
            }

            public void setWinningPlayers(List<Integer> winningPlayers) {
                this.winningPlayers = winningPlayers;
            }

            public String getIssue() {
                return issue;
            }

            public void setIssue(String issue) {
                this.issue = issue;
            }

            public String getOpenTime() {
                return openTime;
            }

            public void setOpenTime(String openTime) {
                this.openTime = openTime;
            }

            public String getNum() {
                return num;
            }

            public void setNum(String num) {
                this.num = num;
            }

            public String getResult() {
                return result;
            }

            public void setResult(String result) {
                this.result = result;
            }

            public String getGameType() {
                return gameType;
            }

            public void setGameType(String gameType) {
                this.gameType = gameType;
            }
        }
    }
}
