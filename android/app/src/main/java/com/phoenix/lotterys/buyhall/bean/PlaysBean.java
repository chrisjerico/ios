package com.phoenix.lotterys.buyhall.bean;

import java.util.List;

/**
 * Greated by Luke
 * on 2019/7/24
 */
public class PlaysBean extends LotteryNewDetails.DataBean.PlayOddsBean.PlayGroupsBean.PlaysBean {
    /**
     * id : 1101
     * name : 总和大
     * alias :
     * code : TOTAL_BIG
     * played_groupid : 1
     * odds : 1.9960
     * offlineOdds : 1.9960
     * minMoney : 1
     * maxMoney : 1000000
     * maxTurnMoney : 60000000
     * isBan : 0
     */

    private String id;
    private String name;
    private String alias;
    private String code;
    private String played_groupid;
    private String odds;
    private String offlineOdds;
    private String minMoney;
    private String maxMoney;
    private String maxTurnMoney;
    private String isBan;
    private String amount;
    private String selectOdds;
    private String selectName;
    boolean isSelect;
    int ball;
    private List<String> nums;
    public PlaysBean() {

    }
    public PlaysBean(String name,String odds,String id) {
        this.name = name;
        this.odds = odds;
        this.id = id;

    }
    public PlaysBean(String name,String odds,String id,String alias) {
        this.name = name;
        this.odds = odds;
        this.id = id;
        this.alias = alias;

    }
    public PlaysBean(String name,String odds,String id,String alias,List <String>nums,int ball) {
        this.name = name;
        this.odds = odds;
        this.id = id;
        this.alias = alias;
        this.nums = nums;
        this.ball = ball;

    }
    public PlaysBean(String name,String odds,String id,String selectOdds,String selectName,String alias) {
        this.name = name;
        this.odds = odds;
        this.selectOdds = selectOdds;
        this.selectName = selectName;
        this.id = id;
        this.alias = alias;
    }
    public PlaysBean(String name,String odds,String id,List<String> nums,String alias) {
        this.name = name;
        this.odds = odds;
        this.id = id;
        this.nums = nums;
        this.alias = alias;

    }

    @Override
    public int getBall() {
        return ball;
    }

    public void setBall(int ball) {
        this.ball = ball;
    }

    public String getSelectName() {
        return selectName;
    }

    public void setSelectName(String selectName) {
        this.selectName = selectName;
    }

    public String getSelectOdds() {
        return selectOdds;
    }

    public void setSelectOdds(String selectOdds) {
        this.selectOdds = selectOdds;
    }

    @Override
    public String toString() {
        return "PlaysBean{" +
                "id='" + id + '\'' +
                ", name='" + name + '\'' +
                ", alias='" + alias + '\'' +
                ", code='" + code + '\'' +
                ", played_groupid='" + played_groupid + '\'' +
                ", odds='" + odds + '\'' +
                ", offlineOdds='" + offlineOdds + '\'' +
                ", minMoney='" + minMoney + '\'' +
                ", maxMoney='" + maxMoney + '\'' +
                ", maxTurnMoney='" + maxTurnMoney + '\'' +
                ", isBan='" + isBan + '\'' +
                ", isSelect=" + isSelect +
                ", amount=" + amount +
                ", nums=" + nums +
                '}';
    }

    @Override
    public List<String> getNums() {
        return nums;
    }

    @Override
    public void setNums(List<String> nums) {
        this.nums = nums;
    }

    public String getAmount() {
        return amount;
    }

    public void setAmount(String amount) {
        this.amount = amount;
    }

    public boolean isSelect() {
        return isSelect;
    }

    public void setSelect(boolean select) {
        isSelect = select;
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

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public String getPlayed_groupid() {
        return played_groupid;
    }

    public void setPlayed_groupid(String played_groupid) {
        this.played_groupid = played_groupid;
    }

    public String getOdds() {
        return odds;
    }

    public void setOdds(String odds) {
        this.odds = odds;
    }

    public String getOfflineOdds() {
        return offlineOdds;
    }

    public void setOfflineOdds(String offlineOdds) {
        this.offlineOdds = offlineOdds;
    }

    public String getMinMoney() {
        return minMoney;
    }

    public void setMinMoney(String minMoney) {
        this.minMoney = minMoney;
    }

    public String getMaxMoney() {
        return maxMoney;
    }

    public void setMaxMoney(String maxMoney) {
        this.maxMoney = maxMoney;
    }

    public String getMaxTurnMoney() {
        return maxTurnMoney;
    }

    public void setMaxTurnMoney(String maxTurnMoney) {
        this.maxTurnMoney = maxTurnMoney;
    }

    public String getIsBan() {
        return isBan;
    }

    public void setIsBan(String isBan) {
        this.isBan = isBan;
    }
}
