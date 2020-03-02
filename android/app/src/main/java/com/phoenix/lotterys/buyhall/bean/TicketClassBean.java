package com.phoenix.lotterys.buyhall.bean;

/**
 * Created by Ykai on 2019/6/3.
 */

public class TicketClassBean {
    private String name;
    private boolean isSelect;
    private boolean isHave;

    public TicketClassBean(String name, boolean isSelect, boolean isHave) {
        this.name = name;
        this.isSelect = isSelect;
        this.isHave = isHave;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public boolean isSelect() {
        return isSelect;
    }

    public void setSelect(boolean select) {
        isSelect = select;
    }

    public boolean isHave() {
        return isHave;
    }

    public void setHave(boolean have) {
        isHave = have;
    }
}
