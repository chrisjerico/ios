package com.phoenix.lotterys.my.bean;

import java.io.Serializable;

/**
 * Created by Luke
 * on 2019/6/8
 */
public class My_item implements Serializable {
    int img;
    String title;
    String mess;
    String alias;
    boolean isSelected;

    private String v;
    private String logo;

    public String getLogo() {
        return logo;
    }

    public void setLogo(String logo) {
        this.logo = logo;
    }

    public String getAlias() {
        return alias;
    }

    public void setAlias(String alias) {
        this.alias = alias;
    }

    public My_item(String v, String title) {
        this.v = v;
        this.title = title;
    }

    public String getV() {
        return v;
    }

    public void setV(String v) {
        this.v = v;
    }

    public My_item() {
    }

    public My_item(int img, String title) {
        this.img = img;
        this.title = title;
    }
    public My_item(int img, String title,String alias) {
        this.img = img;
        this.title = title;
        this.alias = alias;
    }

    public My_item(String title, boolean isSelected) {
        this.isSelected = isSelected;
        this.title = title;
    }

    public My_item(int img, String title, boolean isSelected) {
        this.img = img;
        this.title = title;
        this.isSelected = isSelected;
    }

    public String getMess() {
        return mess;
    }

    public void setMess(String mess) {
        this.mess = mess;
    }
    public int getImg() {
        return img;
    }

    public void setImg(int img) {
        this.img = img;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public boolean isSelected() {
        return isSelected;
    }

    public void setSelected(boolean selected) {
        isSelected = selected;
    }

    @Override
    public String toString() {
        return "My_item{" +
                "img=" + img +
                ", title='" + title + '\'' +
                ", mess='" + mess + '\'' +
                ", alias='" + alias + '\'' +
                ", isSelected=" + isSelected +
                ", v='" + v + '\'' +
                '}';
    }
}
