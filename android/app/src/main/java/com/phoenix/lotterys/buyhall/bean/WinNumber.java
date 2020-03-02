package com.phoenix.lotterys.buyhall.bean;

/**
 * Created by Luke
 * on 2019/6/18
 */
public class WinNumber {
    String num;
    int color;
    String animal;
    boolean isHide;
    public WinNumber(String num,String animal){
        this.num = num;

        this.animal = animal;
    }
    public WinNumber(String num,String animal,boolean isHide){
        this.num = num;
        this.isHide = isHide;
        this.animal = animal;
    }
    @Override
    public String toString() {
        return "WinNumber{" +
                "num='" + num + '\'' +
                ", color=" + color +
                ", animal='" + animal + '\'' +
                '}';
    }

    public boolean isHide() {
        return isHide;
    }

    public void setHide(boolean hide) {
        isHide = hide;
    }

    public String getAnimal() {
        return animal;
    }

    public void setAnimal(String animal) {
        this.animal = animal;
    }

    public String getNum() {
        return num;
    }

    public void setNum(String num) {
        this.num = num;
    }

    public int getColor() {
        return color;
    }

    public void setColor(int color) {
        this.color = color;
    }
}
