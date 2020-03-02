package com.phoenix.lotterys.home.bean;

public class MessageEvent {
    private String message;
    private String tab;
    private String type;
    private String id;
    public MessageEvent(String message){
        this.message=message;
    }
    public MessageEvent(String message,String tab){
        this.message=message;
        this.tab=tab;
    }

    public MessageEvent(String message,String type,String id){
        this.message=message;
        this.type=type;
        this.id=id;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getTab() {
        return tab;
    }

    public void setTab(String tab) {
        this.tab = tab;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

}
