package com.phoenix.lotterys.home.bean;

/**
 * Greated by Luke
 * on 2019/12/5
 */
public class Review {
    String token;
    String sign;
    String cid;
    String rid;
    String content;

    @Override
    public String toString() {
        return "Review{" +
                "token='" + token + '\'' +
                ", sign='" + sign + '\'' +
                ", cid='" + cid + '\'' +
                ", rid='" + rid + '\'' +
                ", content='" + content + '\'' +
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

    public String getCid() {
        return cid;
    }

    public void setCid(String cid) {
        this.cid = cid;
    }

    public String getRid() {
        return rid;
    }

    public void setRid(String rid) {
        this.rid = rid;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }
}
