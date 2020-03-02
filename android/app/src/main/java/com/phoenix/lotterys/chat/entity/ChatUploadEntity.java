package com.phoenix.lotterys.chat.entity;

/**
 * @author : W
 * @e-mail :
 * @date : 2019/12/11 14:13
 * @description :
 */
public class ChatUploadEntity {

    /**
     * code : 0
     * msg : 文件上传成功
     * data : {"name":"photo_2019-03-24_22-19-57.jpg","ext":"jpg","mime":"image/jpeg","size":32020,"savename":"DlngA4aWE3_1575964360.jpg","savepath":"/alidata/www/web/customise/picture/chat/chatlog/DlngA4aWE3_1575964360.jpg","url":"https://cdn01.junbaozhaishanghang.com/upload/t003/customise/picture/chat/chatlog/DlngA4aWE3_1575964360.jpg","uri":"/customise/picture/chat/chatlog/DlngA4aWE3_1575964360.jpg","md5":"e0855b42ee3a237668098ceffd89b11f"}
     */

    private int code;
    private String msg;
    private DataBean data;

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

    public DataBean getData() {
        return data;
    }

    public void setData(DataBean data) {
        this.data = data;
    }

    public static class DataBean {
        /**
         * name : photo_2019-03-24_22-19-57.jpg
         * ext : jpg
         * mime : image/jpeg
         * size : 32020
         * savename : DlngA4aWE3_1575964360.jpg
         * savepath : /alidata/www/web/customise/picture/chat/chatlog/DlngA4aWE3_1575964360.jpg
         * url : https://cdn01.junbaozhaishanghang.com/upload/t003/customise/picture/chat/chatlog/DlngA4aWE3_1575964360.jpg
         * uri : /customise/picture/chat/chatlog/DlngA4aWE3_1575964360.jpg
         * md5 : e0855b42ee3a237668098ceffd89b11f
         */

        private String name;
        private String ext;
        private String mime;
        private int size;
        private String savename;
        private String savepath;
        private String url;
        private String uri;
        private String md5;

        public String getName() {
            return name;
        }

        public void setName(String name) {
            this.name = name;
        }

        public String getExt() {
            return ext;
        }

        public void setExt(String ext) {
            this.ext = ext;
        }

        public String getMime() {
            return mime;
        }

        public void setMime(String mime) {
            this.mime = mime;
        }

        public int getSize() {
            return size;
        }

        public void setSize(int size) {
            this.size = size;
        }

        public String getSavename() {
            return savename;
        }

        public void setSavename(String savename) {
            this.savename = savename;
        }

        public String getSavepath() {
            return savepath;
        }

        public void setSavepath(String savepath) {
            this.savepath = savepath;
        }

        public String getUrl() {
            return url;
        }

        public void setUrl(String url) {
            this.url = url;
        }

        public String getUri() {
            return uri;
        }

        public void setUri(String uri) {
            this.uri = uri;
        }

        public String getMd5() {
            return md5;
        }

        public void setMd5(String md5) {
            this.md5 = md5;
        }
    }
}
