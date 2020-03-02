package com.phoenix.lotterys.buyhall.bean;

/**
 * Created by Ykai on 2019/6/3.
 */

public class TicketNameBean {
    private String name;
    private String odds;
    private String amount;
    private boolean isSelect;

    public TicketNameBean(String name, String odds,boolean isSelect) {
        this.name = name;
        this.odds = odds;
        this.isSelect = isSelect;
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
}
