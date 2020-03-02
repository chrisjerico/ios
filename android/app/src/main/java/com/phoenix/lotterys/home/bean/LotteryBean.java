package com.phoenix.lotterys.home.bean;

/**
 * Created by Luke
 * on 2019/6/14
 */
public class LotteryBean {
    String gamename;
    int img;

    public LotteryBean(String gamename, int img) {
        this.gamename = gamename;
        this.img = img;
    }

    @Override
    public String toString() {
        return "LotteryBean{" +
                "gamename='" + gamename + '\'' +
                ", img=" + img +
                '}';
    }

    public String getGamename() {
        return gamename;
    }

    public void setGamename(String gamename) {
        this.gamename = gamename;
    }

    public int getImg() {
        return img;
    }

    public void setImg(int img) {
        this.img = img;
    }
}
