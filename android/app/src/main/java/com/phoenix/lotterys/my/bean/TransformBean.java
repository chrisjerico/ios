package com.phoenix.lotterys.my.bean;

/**
 * Greated by Luke
 * on 2019/8/28
 */
public class TransformBean {
    String fromId;
    String toId;
    String money;
    String token;
    String sign;

    @Override
    public String toString() {
        return "TransformBean{" +
                "fromId='" + fromId + '\'' +
                ", toId='" + toId + '\'' +
                ", money='" + money + '\'' +
                ", token='" + token + '\'' +
                ", sign='" + sign + '\'' +
                '}';
    }

    public String getFromId() {
        return fromId;
    }

    public void setFromId(String fromId) {
        this.fromId = fromId;
    }

    public String getToId() {
        return toId;
    }

    public void setToId(String toId) {
        this.toId = toId;
    }

    public String getMoney() {
        return money;
    }

    public void setMoney(String money) {
        this.money = money;
    }

    public String getToken() {
        return token;
    }

    public void setToken(String token) {
        this.token = token;
    }

    public String getSign() {
        return sign;
    }

    public void setSign(String sign) {
        this.sign = sign;
    }
}
