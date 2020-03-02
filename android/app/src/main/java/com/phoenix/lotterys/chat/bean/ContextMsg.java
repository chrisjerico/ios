package com.phoenix.lotterys.chat.bean;

public class ContextMsg {
    public static final int TYPE_RECEIVED = 1;
    public static final int TYPE_SENT = 2;

    public ContextMsg(String content, int type) {
        this.content = content;
        this.type = type;
    }

    public String getContent() {
        return content;
    }

    public void setMsg(String content) {
        this.content = content;
    }

    public int getType() {
        return type;
    }

    public void setType(int type) {
        this.type = type;
    }

    @Override
    public String toString() {
        return "ContextMsg{" +
                "content='" + content + '\'' +
                ", type=" + type +
                '}';
    }

    String content;
    int type;
}
