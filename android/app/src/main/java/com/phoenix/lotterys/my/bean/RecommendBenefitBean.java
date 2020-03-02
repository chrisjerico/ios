package com.phoenix.lotterys.my.bean;

import java.io.Serializable;
import java.util.List;

/**
 * 文件描述:
 * 创建者: IAN
 * 创建时间: 2019/8/28 14:24
 */
public class RecommendBenefitBean implements Serializable {


    /**
     * code : 0
     * msg : 获取代理下线投注报表成功
     * data : {"list":[{"date":"2019-08-28","level":0,"type":0,"bet_sum":"0.00","bet_count":0,"bet_member":0,"fandian_sum":"0.00","zj_sum":"0.00"},{"date":"2019-08-27","level":0,"type":0,"bet_sum":"0.00","bet_count":0,"bet_member":0,"fandian_sum":"0.00","zj_sum":"0.00"},{"date":"2019-08-26","level":0,"type":0,"bet_sum":"0.00","bet_count":0,"bet_member":0,"fandian_sum":"0.00","zj_sum":"0.00"},{"date":"2019-08-25","level":0,"type":0,"bet_sum":"0.00","bet_count":0,"bet_member":0,"fandian_sum":"0.00","zj_sum":"0.00"},{"date":"2019-08-24","level":0,"type":0,"bet_sum":"0.00","bet_count":0,"bet_member":0,"fandian_sum":"0.00","zj_sum":"0.00"},{"date":"2019-08-23","level":0,"type":0,"bet_sum":"0.00","bet_count":0,"bet_member":0,"fandian_sum":"0.00","zj_sum":"0.00"},{"date":"2019-08-22","level":0,"type":0,"bet_sum":"0.00","bet_count":0,"bet_member":0,"fandian_sum":"0.00","zj_sum":"0.00"},{"date":"2019-08-21","level":0,"type":0,"bet_sum":"0.00","bet_count":0,"bet_member":0,"fandian_sum":"0.00","zj_sum":"0.00"},{"date":"2019-08-20","level":0,"type":0,"bet_sum":"0.00","bet_count":0,"bet_member":0,"fandian_sum":"0.00","zj_sum":"0.00"},{"date":"2019-08-19","level":0,"type":0,"bet_sum":"0.00","bet_count":0,"bet_member":0,"fandian_sum":"0.00","zj_sum":"0.00"},{"date":"2019-08-18","level":0,"type":0,"bet_sum":"0.00","bet_count":0,"bet_member":0,"fandian_sum":"0.00","zj_sum":"0.00"},{"date":"2019-08-17","level":0,"type":0,"bet_sum":"0.00","bet_count":0,"bet_member":0,"fandian_sum":"0.00","zj_sum":"0.00"},{"date":"2019-08-16","level":0,"type":0,"bet_sum":"0.00","bet_count":0,"bet_member":0,"fandian_sum":"0.00","zj_sum":"0.00"},{"date":"2019-08-15","level":0,"type":0,"bet_sum":"0.00","bet_count":0,"bet_member":0,"fandian_sum":"0.00","zj_sum":"0.00"},{"date":"2019-08-14","level":0,"type":0,"bet_sum":"0.00","bet_count":0,"bet_member":0,"fandian_sum":"0.00","zj_sum":"0.00"},{"date":"2019-08-13","level":0,"type":0,"bet_sum":"0.00","bet_count":0,"bet_member":0,"fandian_sum":"0.00","zj_sum":"0.00"},{"date":"2019-08-12","level":0,"type":0,"bet_sum":"0.00","bet_count":0,"bet_member":0,"fandian_sum":"0.00","zj_sum":"0.00"},{"date":"2019-08-11","level":0,"type":0,"bet_sum":"0.00","bet_count":0,"bet_member":0,"fandian_sum":"0.00","zj_sum":"0.00"},{"date":"2019-08-10","level":0,"type":0,"bet_sum":"0.00","bet_count":0,"bet_member":0,"fandian_sum":"0.00","zj_sum":"0.00"},{"date":"2019-08-09","level":0,"type":0,"bet_sum":"0.00","bet_count":0,"bet_member":0,"fandian_sum":"0.00","zj_sum":"0.00"}],"total":20}
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

    public static class DataBean implements Serializable{
        /**
         * list : [{"date":"2019-08-28","level":0,"type":0,"bet_sum":"0.00","bet_count":0,"bet_member":0,"fandian_sum":"0.00","zj_sum":"0.00"},{"date":"2019-08-27","level":0,"type":0,"bet_sum":"0.00","bet_count":0,"bet_member":0,"fandian_sum":"0.00","zj_sum":"0.00"},{"date":"2019-08-26","level":0,"type":0,"bet_sum":"0.00","bet_count":0,"bet_member":0,"fandian_sum":"0.00","zj_sum":"0.00"},{"date":"2019-08-25","level":0,"type":0,"bet_sum":"0.00","bet_count":0,"bet_member":0,"fandian_sum":"0.00","zj_sum":"0.00"},{"date":"2019-08-24","level":0,"type":0,"bet_sum":"0.00","bet_count":0,"bet_member":0,"fandian_sum":"0.00","zj_sum":"0.00"},{"date":"2019-08-23","level":0,"type":0,"bet_sum":"0.00","bet_count":0,"bet_member":0,"fandian_sum":"0.00","zj_sum":"0.00"},{"date":"2019-08-22","level":0,"type":0,"bet_sum":"0.00","bet_count":0,"bet_member":0,"fandian_sum":"0.00","zj_sum":"0.00"},{"date":"2019-08-21","level":0,"type":0,"bet_sum":"0.00","bet_count":0,"bet_member":0,"fandian_sum":"0.00","zj_sum":"0.00"},{"date":"2019-08-20","level":0,"type":0,"bet_sum":"0.00","bet_count":0,"bet_member":0,"fandian_sum":"0.00","zj_sum":"0.00"},{"date":"2019-08-19","level":0,"type":0,"bet_sum":"0.00","bet_count":0,"bet_member":0,"fandian_sum":"0.00","zj_sum":"0.00"},{"date":"2019-08-18","level":0,"type":0,"bet_sum":"0.00","bet_count":0,"bet_member":0,"fandian_sum":"0.00","zj_sum":"0.00"},{"date":"2019-08-17","level":0,"type":0,"bet_sum":"0.00","bet_count":0,"bet_member":0,"fandian_sum":"0.00","zj_sum":"0.00"},{"date":"2019-08-16","level":0,"type":0,"bet_sum":"0.00","bet_count":0,"bet_member":0,"fandian_sum":"0.00","zj_sum":"0.00"},{"date":"2019-08-15","level":0,"type":0,"bet_sum":"0.00","bet_count":0,"bet_member":0,"fandian_sum":"0.00","zj_sum":"0.00"},{"date":"2019-08-14","level":0,"type":0,"bet_sum":"0.00","bet_count":0,"bet_member":0,"fandian_sum":"0.00","zj_sum":"0.00"},{"date":"2019-08-13","level":0,"type":0,"bet_sum":"0.00","bet_count":0,"bet_member":0,"fandian_sum":"0.00","zj_sum":"0.00"},{"date":"2019-08-12","level":0,"type":0,"bet_sum":"0.00","bet_count":0,"bet_member":0,"fandian_sum":"0.00","zj_sum":"0.00"},{"date":"2019-08-11","level":0,"type":0,"bet_sum":"0.00","bet_count":0,"bet_member":0,"fandian_sum":"0.00","zj_sum":"0.00"},{"date":"2019-08-10","level":0,"type":0,"bet_sum":"0.00","bet_count":0,"bet_member":0,"fandian_sum":"0.00","zj_sum":"0.00"},{"date":"2019-08-09","level":0,"type":0,"bet_sum":"0.00","bet_count":0,"bet_member":0,"fandian_sum":"0.00","zj_sum":"0.00"}]
         * total : 20
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

        public static class ListBean implements Serializable{
            private String level;
            private String username;
            private String logintime;
            private String regtime;
            private String caozuo;
            private String date;
            private String bet_sum;
            private String fandian_sum;
            private String money;
            private String domain;
            private String amount;
            private String member;
            private String validBetAmount;
            private String netAmount;

            private String name;
            private String coin;
            private String uid;

            private String is_setting;
            private String platform;
            private String comNetAmount;

            private String is_online;

            private String accessTime;
            private String lottery_name;
            private String actionNo;
            private String lotteryNo;
            private String odds;
            private String bonus;
            private String actionData;
            private String Groupname;

            public String getGroupname() {
                return Groupname;
            }

            public void setGroupname(String groupname) {
                Groupname = groupname;
            }

            public String getActionData() {
                return actionData;
            }

            public void setActionData(String actionData) {
                this.actionData = actionData;
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

            public String getLotteryNo() {
                return lotteryNo;
            }

            public void setLotteryNo(String lotteryNo) {
                this.lotteryNo = lotteryNo;
            }

            public String getActionNo() {
                return actionNo;
            }

            public void setActionNo(String actionNo) {
                this.actionNo = actionNo;
            }

            public String getLottery_name() {
                return lottery_name;
            }

            public void setLottery_name(String lottery_name) {
                this.lottery_name = lottery_name;
            }

            public String getIs_online() {
                return is_online;
            }

            public void setIs_online(String is_online) {
                this.is_online = is_online;
            }

            public String getAccessTime() {
                return accessTime;
            }

            public void setAccessTime(String accessTime) {
                this.accessTime = accessTime;
            }

            public String getComnetAmount() {
                return comNetAmount;
            }

            public void setComnetAmount(String comnetAmount) {
                this.comNetAmount = comnetAmount;
            }

            public String getPlatform() {
                return platform;
            }

            public void setPlatform(String platform) {
                this.platform = platform;
            }

            public String getIs_setting() {
                return is_setting;
            }

            public void setIs_setting(String is_setting) {
                this.is_setting = is_setting;
            }

            public String getUid() {
                return uid;
            }

            public void setUid(String uid) {
                this.uid = uid;
            }

            public String getCoin() {
                return coin;
            }

            public void setCoin(String coin) {
                this.coin = coin;
            }

            public String getName() {
                return name;
            }

            public void setName(String name) {
                this.name = name;
            }

            private String enable;

            public String getEnable() {
                return enable;
            }

            public void setEnable(String enable) {
                this.enable = enable;
            }

            public String getLevel() {
                return level;
            }

            public void setLevel(String level) {
                this.level = level;
            }

            public String getUsername() {
                return username;
            }

            public void setUsername(String username) {
                this.username = username;
            }

            public String getLogintime() {
                return logintime;
            }

            public void setLogintime(String logintime) {
                this.logintime = logintime;
            }

            public String getRegtime() {
                return regtime;
            }

            public void setRegtime(String regtime) {
                this.regtime = regtime;
            }

            public String getCaozuo() {
                return caozuo;
            }

            public void setCaozuo(String caozuo) {
                this.caozuo = caozuo;
            }

            public String getDate() {
                return date;
            }

            public void setDate(String date) {
                this.date = date;
            }

            public String getBet_sum() {
                return bet_sum;
            }

            public void setBet_sum(String bet_sum) {
                this.bet_sum = bet_sum;
            }

            public String getFandian_sum() {
                return fandian_sum;
            }

            public void setFandian_sum(String fandian_sum) {
                this.fandian_sum = fandian_sum;
            }

            public String getMoney() {
                return money;
            }

            public void setMoney(String money) {
                this.money = money;
            }

            public String getDomain() {
                return domain;
            }

            public void setDomain(String domain) {
                this.domain = domain;
            }

            public String getAmount() {
                return amount;
            }

            public void setAmount(String amount) {
                this.amount = amount;
            }

            public String getMember() {
                return member;
            }

            public void setMember(String member) {
                this.member = member;
            }

            public String getValidBetAmount() {
                return validBetAmount;
            }

            public void setValidBetAmount(String validBetAmount) {
                this.validBetAmount = validBetAmount;
            }

            public String getNetAmount() {
                return netAmount;
            }

            public void setNetAmount(String netAmount) {
                this.netAmount = netAmount;
            }
        }
    }
}
