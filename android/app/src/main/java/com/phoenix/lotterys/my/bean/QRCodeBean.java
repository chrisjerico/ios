package com.phoenix.lotterys.my.bean;

import java.io.Serializable;

/**
 * 文件描述: 二维码url
 * 创建者: IAN
 * 创建时间: 2019/8/22 14:53
 */
public class QRCodeBean implements Serializable {


    /**
     * code : 0
     * msg : 生成成功
     * data : {"secret":"M2GFW2COZ3GLYMQ4","qrcode":"https://chart.googleapis.com/chart?chs=200x200&chld=M|0&cht=qr&chl=otpauth%3A%2F%2Ftotp%2F0187688.com-a111111%3Fsecret%3DM2GFW2COZ3GLYMQ4","status":"gen"}
     */

    private int code;
    private String msg;
    private DataBean data;

    public int getCode() {
        return code;
    }

    public void setCode(int code) {
        this.code = code;
    }

    public String getMsg() {
        return msg;
    }

    public void setMsg(String msg) {
        this.msg = msg;
    }

    public DataBean getData() {
        return data;
    }

    public void setData(DataBean data) {
        this.data = data;
    }

    public static class DataBean {
        /**
         * secret : M2GFW2COZ3GLYMQ4
         * qrcode : https://chart.googleapis.com/chart?chs=200x200&chld=M|0&cht=qr&chl=otpauth%3A%2F%2Ftotp%2F0187688.com-a111111%3Fsecret%3DM2GFW2COZ3GLYMQ4
         * status : gen
         */

        private String secret;
        private String qrcode;
        private String status;

        public String getSecret() {
            return secret;
        }

        public void setSecret(String secret) {
            this.secret = secret;
        }

        public String getQrcode() {
            return qrcode;
        }

        public void setQrcode(String qrcode) {
            this.qrcode = qrcode;
        }

        public String getStatus() {
            return status;
        }

        public void setStatus(String status) {
            this.status = status;
        }
    }
}
