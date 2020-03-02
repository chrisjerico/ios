package com.phoenix.lotterys.my.bean;

import java.io.Serializable;
import java.util.List;

/**
 * 文件描述:
 * 创建者: IAN
 * 创建时间: 2019/7/20 15:14
 */
public class HeandBean implements Serializable {


    /**
     * code : 0
     * msg : 获取成功!
     * data : [{"filename":"1","url":"http://test10.6yc.com/customise/images/memberFace1.jpg?v=36852910"},{"filename":"2","url":"http://test10.6yc.com/customise/images/memberFace2.jpg?v=252809509"},{"filename":"3","url":"http://test10.6yc.com/customise/images/memberFace3.jpg?v=241435441"},{"filename":"4","url":"http://test10.6yc.com/customise/images/memberFace4.jpg?v=1361099754"},{"filename":"5","url":"http://test10.6yc.com/customise/images/memberFace5.jpg?v=1388400498"},{"filename":"6","url":"http://test10.6yc.com/customise/images/memberFace6.jpg?v=1996232353"}]
     */

    private int code;
    private String msg;
    private List<DataBean> data;

    public int getCode() {
        return code;
    }

    public void setCode(int code) {
        this.code = code;
    }

    public String getMsg() {
        return msg;
    }

    public void setMsg(String msg) {
        this.msg = msg;
    }

    public List<DataBean> getData() {
        return data;
    }

    public void setData(List<DataBean> data) {
        this.data = data;
    }

    public static class DataBean {
        /**
         * filename : 1
         * url : http://test10.6yc.com/customise/images/memberFace1.jpg?v=36852910
         */

        private String filename;
        private String url;

        public String getFilename() {
            return filename;
        }

        public void setFilename(String filename) {
            this.filename = filename;
        }

        public String getUrl() {
            return url;
        }

        public void setUrl(String url) {
            this.url = url;
        }
    }
}
