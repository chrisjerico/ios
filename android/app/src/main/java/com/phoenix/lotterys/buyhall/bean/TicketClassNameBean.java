package com.phoenix.lotterys.buyhall.bean;

import java.util.List;

public class TicketClassNameBean {
    private String ticketClassName;
    private List<TicketNameBean> ticketNameBeanList;

    public String getTicketClassName() {
        return ticketClassName;
    }

    public void setTicketClassName(String ticketClassName) {
        this.ticketClassName = ticketClassName;
    }

    public List<TicketNameBean> getTicketNameBeanList() {
        return ticketNameBeanList;
    }

    public void setTicketNameBeanList(List<TicketNameBean> ticketNameBeanList) {
        this.ticketNameBeanList = ticketNameBeanList;
    }
}
