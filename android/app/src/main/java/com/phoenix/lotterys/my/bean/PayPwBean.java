package com.phoenix.lotterys.my.bean;

/**
 * Greated by Luke
 * on 2019/7/20
 */
public class PayPwBean {
    String token;
    String login_pwd;
    String fund_pwd;
    String sign;

    public PayPwBean(String token, String login_pwd, String fund_pwd, String sign) {
        this.token = token;
        this.login_pwd = login_pwd;
        this.fund_pwd = fund_pwd;
        this.sign = sign;
    }

    @Override
    public String toString() {
        return "PayPwBean{" +
                "token='" + token + '\'' +
                ", login_pwd='" + login_pwd + '\'' +
                ", fund_pwd='" + fund_pwd + '\'' +
                '}';
    }

    public String getSign() {
        return sign;
    }

    public void setSign(String sign) {
        this.sign = sign;
    }

    public String getToken() {
        return token;
    }

    public void setToken(String token) {
        this.token = token;
    }

    public String getLogin_pwd() {
        return login_pwd;
    }

    public void setLogin_pwd(String login_pwd) {
        this.login_pwd = login_pwd;
    }

    public String getFund_pwd() {
        return fund_pwd;
    }

    public void setFund_pwd(String fund_pwd) {
        this.fund_pwd = fund_pwd;
    }
}
