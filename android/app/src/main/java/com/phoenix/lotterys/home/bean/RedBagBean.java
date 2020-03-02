package com.phoenix.lotterys.home.bean;

/**
 * Greated by Luke
 * on 2019/9/5
 */
public class RedBagBean {
    String sign;
    String id;
    String token;

    @Override
    public String toString() {
        return "RedBagBean{" +
                "sign='" + sign + '\'' +
                ", id='" + id + '\'' +
                ", token='" + token + '\'' +
                '}';
    }

    public String getSign() {
        return sign;
    }

    public void setSign(String sign) {
        this.sign = sign;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getToken() {
        return token;
    }

    public void setToken(String token) {
        this.token = token;
    }
}
