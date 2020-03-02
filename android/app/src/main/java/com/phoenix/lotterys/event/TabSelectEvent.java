package com.phoenix.lotterys.event;

/**
 * @author : W
 * @e-mail :
 * @date : 2019/11/11 11:19
 * @description :
 */
public class TabSelectEvent {
    private int index;

    public TabSelectEvent(int index) {
        this.index = index;
    }

    public int getIndex() {
        return index;
    }

    public void setIndex(int index) {
        this.index = index;
    }
}
