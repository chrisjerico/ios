package com.phoenix.lotterys.buyhall.bean;

/**
 * Greated by Luke
 * on 2019/8/9
 */
public class Zodiac {
    String zodiac;
    boolean isSelect;

    @Override
    public String toString() {
        return "Zodiac{" +
                "zodiac='" + zodiac + '\'' +
                ", isSelect=" + isSelect +
                '}';
    }

    public Zodiac(String zodiac,boolean isSelect) {
        this.zodiac = zodiac;
        this.isSelect = isSelect;
    }

    public String getZodiac() {
        return zodiac;
    }

    public void setZodiac(String zodiac) {
        this.zodiac = zodiac;
    }

    public boolean isSelect() {
        return isSelect;
    }

    public void setSelect(boolean select) {
        isSelect = select;
    }
}
