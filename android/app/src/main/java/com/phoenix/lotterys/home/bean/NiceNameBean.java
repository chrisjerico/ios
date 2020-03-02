package com.phoenix.lotterys.home.bean;

/**
 * Greated by Luke
 * on 2019/12/4
 */
public class NiceNameBean {
    String token;
    String sign;
    String nickname;

    @Override
    public String toString() {
        return "NiceNameBean{" +
                "token='" + token + '\'' +
                ", sign='" + sign + '\'' +
                ", nickname='" + nickname + '\'' +
                '}';
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

    public String getNickname() {
        return nickname;
    }

    public void setNickname(String nickname) {
        this.nickname = nickname;
    }
}
