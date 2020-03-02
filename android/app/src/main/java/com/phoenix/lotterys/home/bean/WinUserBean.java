package com.phoenix.lotterys.home.bean;

public class WinUserBean {
    private String name;
    private String money;
    private Integer icon;

    @Override
    public String toString() {
        return "WinUserBean{" +
                "name='" + name + '\'' +
                ", money='" + money + '\'' +
                ", icon=" + icon +
                '}';
    }

    public WinUserBean(String name, Integer icon, String money ) {
        this.name = name;
        this.icon = icon;
        this.money = money;
    }

    public String getMoney() {
        return money;
    }

    public void setMoney(String money) {
        this.money = money;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public Integer getIcon() {
        return icon;
    }

    public void setIcon(Integer icon) {
        this.icon = icon;
    }
}
