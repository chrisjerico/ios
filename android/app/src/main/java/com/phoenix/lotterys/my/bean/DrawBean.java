package com.phoenix.lotterys.my.bean;

/**
 * Greated by Luke
 * on 2019/8/23
 */
public class DrawBean {
    String money;
    String pwd;
    String token;
    String sign;
    @Override
    public String toString() {
        return "DrawBean{" +
                "money='" + money + '\'' +
                ", pwd='" + pwd + '\'' +
                ", token='" + token + '\'' +
                '}';
    }

    public String getSign() {
        return sign;
    }

    public void setSign(String sign) {
        this.sign = sign;
    }

    public String getMoney() {
        return money;
    }

    public void setMoney(String money) {
        this.money = money;
    }

    public String getPwd() {
        return pwd;
    }

    public void setPwd(String pwd) {
        this.pwd = pwd;
    }

    public String getToken() {
        return token;
    }

    public void setToken(String token) {
        this.token = token;
    }
}
