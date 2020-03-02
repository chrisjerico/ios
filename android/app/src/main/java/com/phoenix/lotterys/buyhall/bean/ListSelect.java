package com.phoenix.lotterys.buyhall.bean;

/**
 * Created by Luke
 * on 2019/6/15
 */
public class ListSelect {
    boolean select;
    public ListSelect(boolean b ){
        this.select = b;
    }

    @Override
    public String toString() {
        return "ListSelect{" +
                "select=" + select +
                '}';
    }

    public boolean isSelect() {
        return select;
    }

    public void setSelect(boolean select) {
        this.select = select;
    }
}
