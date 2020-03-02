package com.phoenix.lotterys.home.bean;

public class DialogHomeBean {
    private String title;
    private String content;
    private boolean isOpen;

    public DialogHomeBean(String title, String content,boolean isOpen) {
        this.title = title;
        this.content = content;
        this.isOpen = isOpen;
    }

    @Override
    public String toString() {
        return "DialogHomeBean{" +
                "title='" + title + '\'' +
                ", content='" + content + '\'' +
                ", isOpen=" + isOpen +
                '}';
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public boolean isOpen() {
        return isOpen;
    }

    public void setOpen(boolean open) {
        isOpen = open;
    }


}
