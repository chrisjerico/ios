package com.phoenix.lotterys.my.bean;

/**
 * Greated by Luke
 * on 2019/8/29
 */
public class OffLineBean {
    String token;
    String sign;
    String money;
    String payId;
    String gateway;

    String amount;
    String channel;
    String payee;
    String payer;
    String remark;
    String depositTime;

    @Override
    public String toString() {
        return "OffLineBean{" +
                "token='" + token + '\'' +
                ", sign='" + sign + '\'' +
                ", money='" + money + '\'' +
                ", payId='" + payId + '\'' +
                ", gateway='" + gateway + '\'' +
                ", channel='" + channel + '\'' +
                ", payee='" + payee + '\'' +
                ", payer='" + payer + '\'' +
                ", remark='" + remark + '\'' +
                ", amount='" + amount + '\'' +
                ", depositTime='" + depositTime + '\'' +
                '}';
    }

    public String getAmount() {
        return amount;
    }

    public void setAmount(String amount) {
        this.amount = amount;
    }

    public String getChannel() {
        return channel;
    }

    public void setChannel(String channel) {
        this.channel = channel;
    }

    public String getPayee() {
        return payee;
    }

    public void setPayee(String payee) {
        this.payee = payee;
    }

    public String getPayer() {
        return payer;
    }

    public void setPayer(String payer) {
        this.payer = payer;
    }

    public String getRemark() {
        return remark;
    }

    public void setRemark(String remark) {
        this.remark = remark;
    }

    public String getDepositTime() {
        return depositTime;
    }

    public void setDepositTime(String depositTime) {
        this.depositTime = depositTime;
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

    public String getMoney() {
        return money;
    }

    public void setMoney(String money) {
        this.money = money;
    }

    public String getPayId() {
        return payId;
    }

    public void setPayId(String payId) {
        this.payId = payId;
    }

    public String getGateway() {
        return gateway;
    }

    public void setGateway(String gateway) {
        this.gateway = gateway;
    }
}
