package com.phoenix.lotterys.home.bean;

/**
 * Created by Luke
 * on 2019/6/14
 */
public class ElectGame {
    String code;
    String name;

    @Override
    public String toString() {
        return "ElectGame{" +
                "code='" + code + '\'' +
                ", name='" + name + '\'' +
                '}';
    }

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }
}
