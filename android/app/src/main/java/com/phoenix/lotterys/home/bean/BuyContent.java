package com.phoenix.lotterys.home.bean;

import java.util.Arrays;

/**
 * Greated by Luke
 * on 2019/12/1
 */
public class BuyContent {
    String token;
    String sign;
    String cid;
    String amount;

    @Override
    public String toString() {
        return "BuyContent{" +
                "token='" + token + '\'' +
                ", sign='" + sign + '\'' +
                ", cid='" + cid + '\'' +
                '}';
    }

    public String getAmount() {
        return amount;
    }

    public void setAmount(String amount) {
        this.amount = amount;
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

    public String getCid() {
        return cid;
    }

    public void setCid(String cid) {
        this.cid = cid;
    }
}
