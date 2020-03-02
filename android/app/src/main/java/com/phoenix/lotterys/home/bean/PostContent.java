package com.phoenix.lotterys.home.bean;

import java.util.Arrays;

/**
 * Greated by Luke
 * on 2019/12/1
 */
public class PostContent {
    String token;
    String title;
    String content;
    String alias;
    String price;
    String sign;
    String []images;

    @Override
    public String toString() {
        return "PostContent{" +
                "token='" + token + '\'' +
                ", title='" + title + '\'' +
                ", content='" + content + '\'' +
                ", alias='" + alias + '\'' +
                ", price='" + price + '\'' +
                ", sign='" + sign + '\'' +
                ", images=" + Arrays.toString(images) +
                '}';
    }

    public String getToken() {
        return token;
    }

    public void setToken(String token) {
        this.token = token;
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

    public String getAlias() {
        return alias;
    }

    public void setAlias(String alias) {
        this.alias = alias;
    }

    public String getPrice() {
        return price;
    }

    public void setPrice(String price) {
        this.price = price;
    }

    public String getSign() {
        return sign;
    }

    public void setSign(String sign) {
        this.sign = sign;
    }

    public String[] getImages() {
        return images;
    }

    public void setImages(String[] images) {
        this.images = images;
    }
}
