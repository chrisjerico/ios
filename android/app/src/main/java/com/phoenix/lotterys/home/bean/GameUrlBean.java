package com.phoenix.lotterys.home.bean;

/**
 * Greated by Luke
 * on 2019/7/21
 */
public class GameUrlBean {

    /**
     * code : 0
     * msg : 获取游戏跳转URL成功
     * data : /mobile/real/goToGame/25/1/
     * info : {"sqlTotalNum":0,"sqlTotalTime":"0 ms","runtime":"321.61 ms"}
     */

    private int code;
    private String msg;
    private String data;

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

    public String getData() {
        return data;
    }

    public void setData(String data) {
        this.data = data;
    }

}
