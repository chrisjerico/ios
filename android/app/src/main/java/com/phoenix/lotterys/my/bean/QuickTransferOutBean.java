package com.phoenix.lotterys.my.bean;

/**
 * Greated by Luke
 * on 2019/11/14
 */
public class QuickTransferOutBean {
    String id;
    String token;
    String sign;

    @Override
    public String toString() {
        return "QuickTransferOutBean{" +
                "id='" + id + '\'' +
                ", token='" + token + '\'' +
                ", sign='" + sign + '\'' +
                '}';
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

    public String getSign() {
        return sign;
    }

    public void setSign(String sign) {
        this.sign = sign;
    }
}
