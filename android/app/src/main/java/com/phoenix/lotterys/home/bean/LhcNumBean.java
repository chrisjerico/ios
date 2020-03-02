package com.phoenix.lotterys.home.bean;

/**
 * Greated by Luke
 * on 2019/11/26
 */
public class LhcNumBean {

    /**
     * code : 0
     * msg : 获取六合彩开奖信息成功
     * data : {"gameId":70,"serverTime":"2019-11-26 21:37:07","issue":"2019131","endtime":"2019-11-28 21:30:00","auto":true,"lotteryTime":"2019-11-28 21:35:00","nextIssueAnimal":{"animalsYear":"猪","lhcWxJin":"05,06,19,20,27,28,35,36,49","lhcWxMu":"01,02,09,10,17,18,31,32,39,40,47,48","lhcWxShui":"07,08,15,16,23,24,37,38,45,46","lhcWxHuo":"03,04,11,12,25,26,33,34,41,42","lhcWxTu":"13,14,21,22,29,30,43,44"},"preIssue":"2019130","preLotteryTime":"2019-11-26 21:34:28","preNum":"42,25,45,15,05,09,38","preNumColor":"blue,blue,red,blue,green,blue,green","preNumSx":"马,猪,兔,鸡,羊,兔,狗","preIsOpen":true}
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
        /**
         * gameId : 70
         * serverTime : 2019-11-26 21:37:07
         * issue : 2019131
         * endtime : 2019-11-28 21:30:00
         * auto : true
         * lotteryTime : 2019-11-28 21:35:00
         * nextIssueAnimal : {"animalsYear":"猪","lhcWxJin":"05,06,19,20,27,28,35,36,49","lhcWxMu":"01,02,09,10,17,18,31,32,39,40,47,48","lhcWxShui":"07,08,15,16,23,24,37,38,45,46","lhcWxHuo":"03,04,11,12,25,26,33,34,41,42","lhcWxTu":"13,14,21,22,29,30,43,44"}
         * preIssue : 2019130
         * preLotteryTime : 2019-11-26 21:34:28
         * preNum : 42,25,45,15,05,09,38
         * preNumColor : blue,blue,red,blue,green,blue,green
         * preNumSx : 马,猪,兔,鸡,羊,兔,狗
         * preIsOpen : true
         */

        private int gameId;
        private String serverTime;
        private String issue;
        private String endtime;
        private boolean auto;
        private String lotteryTime;
        private NextIssueAnimalBean nextIssueAnimal;
        private String preIssue;
        private String preLotteryTime;
        private String preNum;
        private String preNumColor;
        private String preNumSx;
        private String lotteryStr;
        private boolean preIsOpen;
        private String numbers;
        private String numSx;
        private String numColor;
        private int isFinish;

        private String lhcdocLotteryNo;

        public String getLhcdocLotteryNo() {
            return lhcdocLotteryNo;
        }

        public void setLhcdocLotteryNo(String lhcdocLotteryNo) {
            this.lhcdocLotteryNo = lhcdocLotteryNo;
        }

        public int getIsFinish() {
            return isFinish;
        }

        public void setIsFinish(int isFinish) {
            this.isFinish = isFinish;
        }

        public String getLotteryStr() {
            return lotteryStr;
        }

        public void setLotteryStr(String lotteryStr) {
            this.lotteryStr = lotteryStr;
        }

        public String getNumColor() {
            return numColor;
        }

        public void setNumColor(String numColor) {
            this.numColor = numColor;
        }

        public String getNumbers() {
            return numbers;
        }

        public void setNumbers(String numbers) {
            this.numbers = numbers;
        }

        public String getNumSx() {
            return numSx;
        }

        public void setNumSx(String numSx) {
            this.numSx = numSx;
        }

        public int getGameId() {
            return gameId;
        }

        public void setGameId(int gameId) {
            this.gameId = gameId;
        }

        public String getServerTime() {
            return serverTime;
        }

        public void setServerTime(String serverTime) {
            this.serverTime = serverTime;
        }

        public String getIssue() {
            return issue;
        }

        public void setIssue(String issue) {
            this.issue = issue;
        }

        public String getEndtime() {
            return endtime;
        }

        public void setEndtime(String endtime) {
            this.endtime = endtime;
        }

        public boolean isAuto() {
            return auto;
        }

        public void setAuto(boolean auto) {
            this.auto = auto;
        }

        public String getLotteryTime() {
            return lotteryTime;
        }

        public void setLotteryTime(String lotteryTime) {
            this.lotteryTime = lotteryTime;
        }

        public NextIssueAnimalBean getNextIssueAnimal() {
            return nextIssueAnimal;
        }

        public void setNextIssueAnimal(NextIssueAnimalBean nextIssueAnimal) {
            this.nextIssueAnimal = nextIssueAnimal;
        }

        public String getPreIssue() {
            return preIssue;
        }

        public void setPreIssue(String preIssue) {
            this.preIssue = preIssue;
        }

        public String getPreLotteryTime() {
            return preLotteryTime;
        }

        public void setPreLotteryTime(String preLotteryTime) {
            this.preLotteryTime = preLotteryTime;
        }

        public String getPreNum() {
            return preNum;
        }

        public void setPreNum(String preNum) {
            this.preNum = preNum;
        }

        public String getPreNumColor() {
            return preNumColor;
        }

        public void setPreNumColor(String preNumColor) {
            this.preNumColor = preNumColor;
        }

        public String getPreNumSx() {
            return preNumSx;
        }

        public void setPreNumSx(String preNumSx) {
            this.preNumSx = preNumSx;
        }

        public boolean isPreIsOpen() {
            return preIsOpen;
        }

        public void setPreIsOpen(boolean preIsOpen) {
            this.preIsOpen = preIsOpen;
        }

        public static class NextIssueAnimalBean {
            /**
             * animalsYear : 猪
             * lhcWxJin : 05,06,19,20,27,28,35,36,49
             * lhcWxMu : 01,02,09,10,17,18,31,32,39,40,47,48
             * lhcWxShui : 07,08,15,16,23,24,37,38,45,46
             * lhcWxHuo : 03,04,11,12,25,26,33,34,41,42
             * lhcWxTu : 13,14,21,22,29,30,43,44
             */

            private String animalsYear;
            private String lhcWxJin;
            private String lhcWxMu;
            private String lhcWxShui;
            private String lhcWxHuo;
            private String lhcWxTu;

            public String getAnimalsYear() {
                return animalsYear;
            }

            public void setAnimalsYear(String animalsYear) {
                this.animalsYear = animalsYear;
            }

            public String getLhcWxJin() {
                return lhcWxJin;
            }

            public void setLhcWxJin(String lhcWxJin) {
                this.lhcWxJin = lhcWxJin;
            }

            public String getLhcWxMu() {
                return lhcWxMu;
            }

            public void setLhcWxMu(String lhcWxMu) {
                this.lhcWxMu = lhcWxMu;
            }

            public String getLhcWxShui() {
                return lhcWxShui;
            }

            public void setLhcWxShui(String lhcWxShui) {
                this.lhcWxShui = lhcWxShui;
            }

            public String getLhcWxHuo() {
                return lhcWxHuo;
            }

            public void setLhcWxHuo(String lhcWxHuo) {
                this.lhcWxHuo = lhcWxHuo;
            }

            public String getLhcWxTu() {
                return lhcWxTu;
            }

            public void setLhcWxTu(String lhcWxTu) {
                this.lhcWxTu = lhcWxTu;
            }
        }
    }
}
