package com.phoenix.lotterys.buyhall.bean;

/**
 * Greated by Luke
 * on 2019/9/23
 */
public class ShareBetList {
    String betMoney;
    String index;
    String name;
    String odds;

    @Override
    public String toString() {
        return "ShareBetList{" +
                "betMoney='" + betMoney + '\'' +
                ", index='" + index + '\'' +
                ", name='" + name + '\'' +
                ", odds='" + odds + '\'' +
                '}';
    }

    public ShareBetList(String index, String betMoney, String name, String odds ) {
        this.betMoney = betMoney;
        this.index = index;
        this.name = name;
        this.odds = odds;
    }
    public String getBetMoney() {
        return betMoney;
    }

    public void setBetMoney(String betMoney) {
        this.betMoney = betMoney;
    }

    public String getIndex() {
        return index;
    }

    public void setIndex(String index) {
        this.index = index;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getOdds() {
        return odds;
    }

    public void setOdds(String odds) {
        this.odds = odds;
    }
}
