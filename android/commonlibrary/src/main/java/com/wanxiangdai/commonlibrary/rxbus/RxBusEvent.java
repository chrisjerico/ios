package com.wanxiangdai.commonlibrary.rxbus;

/**
 * Created by Ykai on 2018/3/20.
 */

public class RxBusEvent {
    int id;
    String name;
    Object object;
    int value;
    boolean isCkeck;

    public RxBusEvent(int id, String name) {
        this.id = id;
        this.name = name;
    }

    public RxBusEvent(String name, boolean isCkeck) {
        this.name = name;
        this.isCkeck = isCkeck;
    }

    public RxBusEvent(int id, String name, Object object) {
        this.id = id;
        this.name = name;
        this.object = object;
    }

    public RxBusEvent(int id, String name, int value) {
        this.id = id;
        this.name = name;
        this.value = value;
    }

    public int getId() {
        return id;
    }

    public String getName() {
        return name;
    }

    public Object getObject() {
        return object;
    }

    public int getValue() {
        return value;
    }

    public boolean isCkeck() {
        return isCkeck;
    }
}
