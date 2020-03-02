package com.phoenix.lotterys.chat.bean;

import java.util.List;

/**
 * Greated by Luke
 * on 2019/7/11
 */
public class ChannelBean {
    String title;
    Boolean isOpen;
    private List<DataBean> data;
    public ChannelBean(String title,boolean isOpen,List<DataBean> data){
        this.title = title;
        this.isOpen = isOpen;
        this.data = data;
    }

    @Override
    public String toString() {
        return "ChannelBean{" +
                "title='" + title + '\'' +
                ", isOpen=" + isOpen +
                ", data=" + data +
                '}';
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public Boolean getOpen() {
        return isOpen;
    }

    public void setOpen(Boolean open) {
        isOpen = open;
    }

    public List<DataBean> getData() {
        return data;
    }

    public void setData(List<DataBean> data) {
        this.data = data;
    }

    public static class DataBean {
        String content;
        public DataBean(String content) {
            this .content = content;
        }

        public String getContent() {
            return content;
        }

        public void setContent(String content) {
            this.content = content;
        }
    }
}
