package com.phoenix.lotterys.home.bean;

/**
 * Greated by Luke
 * on 2019/12/3
 */
public class PreiseBean {


    /**
     * code : 0
     * msg : 获取成功
     * data : {"likeNum":3}
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
         * likeNum : 3
         */

        private int  likeNum;

        public int getLikeNum() {
            return likeNum;
        }

        public void setLikeNum(int likeNum) {
            this.likeNum = likeNum;
        }
    }
}
