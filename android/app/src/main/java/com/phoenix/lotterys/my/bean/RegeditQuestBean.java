package com.phoenix.lotterys.my.bean;

/**
 * Greated by Luke
 * on 2019/8/6
 */
public class RegeditQuestBean {
    String inviter;
    String usr;
    String pwd;
    String fullName;
    String fundPwd;
    String wx;
    String qq;
    String phone;
    String email;
    String device;
    String imgCode;
    String smsCode;
    String accessToken;
    String ggCode;
    String sign;
    String regType;
    private SlideCode slideCode;

    public static class SlideCode {
        String nc_sid;
        String nc_token;
        String nc_sig;

        public String getNc_sid() {
            return nc_sid;
        }

        public void setNc_sid(String nc_sid) {
            this.nc_sid = nc_sid;
        }

        public String getNc_token() {
            return nc_token;
        }

        public void setNc_token(String nc_token) {
            this.nc_token = nc_token;
        }

        public String getNc_sig() {
            return nc_sig;
        }

        public void setNc_sig(String nc_sig) {
            this.nc_sig = nc_sig;
        }
    }

    public SlideCode getSlideCode() {
        return slideCode;
    }

    public void setSlideCode(SlideCode slideCode) {
        this.slideCode = slideCode;
    }

    @Override
    public String toString() {
        return "RegeditQuestBean{" +
                "inviter='" + inviter + '\'' +
                ", usr='" + usr + '\'' +
                ", pwd='" + pwd + '\'' +
                ", fullName='" + fullName + '\'' +
                ", fundPwd='" + fundPwd + '\'' +
                ", wx='" + wx + '\'' +
                ", qq='" + qq + '\'' +
                ", phone='" + phone + '\'' +
                ", email='" + email + '\'' +
                ", device='" + device + '\'' +
                ", imgCode='" + imgCode + '\'' +
                ", smsCode='" + smsCode + '\'' +
                ", accessToken='" + accessToken + '\'' +
                ", sign='" + sign + '\'' +
                '}';
    }

    public String getRegType() {
        return regType;
    }

    public void setRegType(String regType) {
        this.regType = regType;
    }

    public String getSign() {
        return sign;
    }

    public void setSign(String sign) {
        this.sign = sign;
    }

    public String getGgCode() {
        return ggCode;
    }

    public void setGgCode(String ggCode) {
        this.ggCode = ggCode;
    }
    public String getAccessToken() {
        return accessToken;
    }

    public void setAccessToken(String accessToken) {
        this.accessToken = accessToken;
    }

    public String getInviter() {
        return inviter;
    }

    public void setInviter(String inviter) {
        this.inviter = inviter;
    }

    public String getUsr() {
        return usr;
    }

    public void setUsr(String usr) {
        this.usr = usr;
    }

    public String getPwd() {
        return pwd;
    }

    public void setPwd(String pwd) {
        this.pwd = pwd;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getFundPwd() {
        return fundPwd;
    }

    public void setFundPwd(String fundPwd) {
        this.fundPwd = fundPwd;
    }

    public String getWx() {
        return wx;
    }

    public void setWx(String wx) {
        this.wx = wx;
    }

    public String getQq() {
        return qq;
    }

    public void setQq(String qq) {
        this.qq = qq;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getDevice() {
        return device;
    }

    public void setDevice(String device) {
        this.device = device;
    }

    public String getImgCode() {
        return imgCode;
    }

    public void setImgCode(String imgCode) {
        this.imgCode = imgCode;
    }

    public String getSmsCode() {
        return smsCode;
    }

    public void setSmsCode(String smsCode) {
        this.smsCode = smsCode;
    }


}
