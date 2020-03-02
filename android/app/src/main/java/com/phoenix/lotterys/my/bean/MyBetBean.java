package com.phoenix.lotterys.my.bean;

import java.io.Serializable;
import java.util.List;

/**
 * 文件描述:
 * 创建者: IAN
 * 创建时间: 2019/8/26 21:44
 */
public class MyBetBean implements Serializable {


    /**
     * code : 0
     * msg : success
     * data : [{"id":2354193,"title":"秒秒彩","uid":4645,"usr":"test08","isTest":"0","gameId":7,"playId":7104040,"playCateId":3022,"issue":"2019080714261297","addTime":"2019-08-07 14:26:12","bonus":"199.60","odds":1.996,"rebate":0,"betInfo":"","multiple":0,"status":1,"rebateMoney":0,"resultMoney":99.6,"msg":"已中奖","isWin":1,"money":100,"play_name":"总和大","play_alias":"","group_name":"总和-龙虎和","orderNo":"2354193","lotteryNo":"9,8,2,0,5","openTime":"2019-08-07 14:26:12"},{"id":2354194,"title":"秒秒彩","uid":4645,"usr":"test08","isTest":"0","gameId":7,"playId":7104038,"playCateId":3022,"issue":"2019080714284063","addTime":"2019-08-07 14:28:40","bonus":"0.00","odds":1.996,"rebate":0.15,"betInfo":"","multiple":0,"status":1,"rebateMoney":15,"resultMoney":-85,"msg":"未中奖","isWin":0,"money":100,"play_name":"总和单","play_alias":"","group_name":"总和-龙虎和","orderNo":"2354194","lotteryNo":"4,4,3,1,8","openTime":"2019-08-07 14:28:40"},{"id":2356272,"title":"北京赛车(PK10)","uid":4645,"usr":"test08","isTest":"0","gameId":50,"playId":501101,"playCateId":11,"issue":"738015","addTime":"2019-08-25 23:32:21","bonus":"131.74","odds":1.996,"rebate":0,"betInfo":"","multiple":0,"status":1,"rebateMoney":0,"resultMoney":65.736,"msg":"已中奖","isWin":1,"money":66,"play_name":"大","play_alias":"","group_name":"冠军","orderNo":"2356272","lotteryNo":"08,05,10,01,02,07,09,03,06,04","openTime":"2019-08-25 23:32:21"},{"id":2356273,"title":"香港六合彩","uid":4645,"usr":"test08","isTest":"0","gameId":70,"playId":708624,"playCateId":86,"issue":"2019098","addTime":"2019-08-25 23:32:30","bonus":"0.00","odds":1.98,"rebate":0,"betInfo":"","multiple":0,"status":0,"rebateMoney":0,"resultMoney":64.68,"msg":"等待开奖","money":66,"play_name":"总和小","play_alias":"","group_name":"两面","orderNo":"2356273","lotteryNo":"","openTime":"2019-08-25 23:32:30"},{"id":2356279,"title":"极速11选5","uid":4645,"usr":"test08","isTest":"0","gameId":130,"playId":7108668,"playCateId":3191,"issue":"1908251132","addTime":"2019-08-25 23:33:28","bonus":"0.00","odds":1.9,"rebate":0,"betInfo":"","multiple":0,"status":1,"rebateMoney":0,"resultMoney":-33,"msg":"未中奖","isWin":0,"money":33,"play_name":"总和单","play_alias":"","group_name":"总和","orderNo":"2356279","lotteryNo":"03,08,07,02,10","openTime":"2019-08-25 23:33:28"}]
     */

    private int code;
    private String msg;
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

    public List<DataBean> getData() {
        return data;
    }

    public void setData(List<DataBean> data) {
        this.data = data;
    }

    public static class DataBean implements Serializable{
        /**
         * id : 2354193
         * title : 秒秒彩
         * uid : 4645
         * usr : test08
         * isTest : 0
         * gameId : 7
         * playId : 7104040
         * playCateId : 3022
         * issue : 2019080714261297
         * addTime : 2019-08-07 14:26:12
         * bonus : 199.60
         * odds : 1.996
         * rebate : 0
         * betInfo :
         * multiple : 0
         * status : 1
         * rebateMoney : 0
         * resultMoney : 99.6
         * msg : 已中奖
         * isWin : 1
         * money : 100
         * play_name : 总和大
         * play_alias :
         * group_name : 总和-龙虎和
         * orderNo : 2354193
         * lotteryNo : 9,8,2,0,5
         * openTime : 2019-08-07 14:26:12
         */

        private String id;
        private String title;
        private String uid;
        private String usr;
        private String isTest;
        private String gameId;
        private String playId;
        private String playCateId;
        private String issue;
        private String addTime;
        private String bonus;
        private String odds;
        private String rebate;
        private String betInfo;
        private String multiple;
        private String status;
        private String rebateMoney;
        private String resultMoney;
        private String msg;
        private String isWin;
        private String money;
        private String play_name;
        private String play_alias;
        private String group_name;
        private String orderNo;
        private String lotteryNo;
        private String openTime;
        private String logo;

        private boolean isAllowCancel;

        public boolean isAllowMemberCancelBet() {
            return isAllowCancel;
        }

        public void setAllowMemberCancelBet(boolean allowMemberCancelBet) {
            this.isAllowCancel = allowMemberCancelBet;
        }

        public String getLogo() {
            return logo;
        }

        public void setLogo(String logo) {
            this.logo = logo;
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

        public String getUid() {
            return uid;
        }

        public void setUid(String uid) {
            this.uid = uid;
        }

        public String getUsr() {
            return usr;
        }

        public void setUsr(String usr) {
            this.usr = usr;
        }

        public String getIsTest() {
            return isTest;
        }

        public void setIsTest(String isTest) {
            this.isTest = isTest;
        }

        public String getGameId() {
            return gameId;
        }

        public void setGameId(String gameId) {
            this.gameId = gameId;
        }

        public String getPlayId() {
            return playId;
        }

        public void setPlayId(String playId) {
            this.playId = playId;
        }

        public String getPlayCateId() {
            return playCateId;
        }

        public void setPlayCateId(String playCateId) {
            this.playCateId = playCateId;
        }

        public String getIssue() {
            return issue;
        }

        public void setIssue(String issue) {
            this.issue = issue;
        }

        public String getAddTime() {
            return addTime;
        }

        public void setAddTime(String addTime) {
            this.addTime = addTime;
        }

        public String getBonus() {
            return bonus;
        }

        public void setBonus(String bonus) {
            this.bonus = bonus;
        }

        public String getOdds() {
            return odds;
        }

        public void setOdds(String odds) {
            this.odds = odds;
        }

        public String getRebate() {
            return rebate;
        }

        public void setRebate(String rebate) {
            this.rebate = rebate;
        }

        public String getBetInfo() {
            return betInfo;
        }

        public void setBetInfo(String betInfo) {
            this.betInfo = betInfo;
        }

        public String getMultiple() {
            return multiple;
        }

        public void setMultiple(String multiple) {
            this.multiple = multiple;
        }

        public String getStatus() {
            return status;
        }

        public void setStatus(String status) {
            this.status = status;
        }

        public String getRebateMoney() {
            return rebateMoney;
        }

        public void setRebateMoney(String rebateMoney) {
            this.rebateMoney = rebateMoney;
        }

        public String getResultMoney() {
            return resultMoney;
        }

        public void setResultMoney(String resultMoney) {
            this.resultMoney = resultMoney;
        }

        public String getMsg() {
            return msg;
        }

        public void setMsg(String msg) {
            this.msg = msg;
        }

        public String getIsWin() {
            return isWin;
        }

        public void setIsWin(String isWin) {
            this.isWin = isWin;
        }

        public String getMoney() {
            return money;
        }

        public void setMoney(String money) {
            this.money = money;
        }

        public String getPlay_name() {
            return play_name;
        }

        public void setPlay_name(String play_name) {
            this.play_name = play_name;
        }

        public String getPlay_alias() {
            return play_alias;
        }

        public void setPlay_alias(String play_alias) {
            this.play_alias = play_alias;
        }

        public String getGroup_name() {
            return group_name;
        }

        public void setGroup_name(String group_name) {
            this.group_name = group_name;
        }

        public String getOrderNo() {
            return orderNo;
        }

        public void setOrderNo(String orderNo) {
            this.orderNo = orderNo;
        }

        public String getLotteryNo() {
            return lotteryNo;
        }

        public void setLotteryNo(String lotteryNo) {
            this.lotteryNo = lotteryNo;
        }

        public String getOpenTime() {
            return openTime;
        }

        public void setOpenTime(String openTime) {
            this.openTime = openTime;
        }
    }
}
