package com.phoenix.lotterys.event;

/**
 * @author : W
 * @e-mail :
 * @date : 2019/12/11 15:06
 * @description :
 */
public class ToastEvent {

    private String msg;

    public ToastEvent(String msg) {
        this.msg = msg;
    }

    public String getMsg() {
        return msg;
    }
}
