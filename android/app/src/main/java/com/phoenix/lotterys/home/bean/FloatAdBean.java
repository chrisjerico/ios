package com.phoenix.lotterys.home.bean;

import java.util.List;

public class FloatAdBean {

    /**
     * code : 0
     * msg : 获取浮动广告成功
     * data : [{"position":1,"linkCategory":"1","linkPosition":"1","image":"https://cdn01.smxoo.cn/upload/test/customise/images/m_float_ad_1.jpg?v=1580393285","lotteryGameType":"cqssc","realIsPopup":0,"realSupportTrial":0},{"position":2,"linkCategory":"2","linkPosition":"53","image":"https://cdn01.smxoo.cn/upload/test/customise/images/m_float_ad_2.jpg?v=1580394535","lotteryGameType":"","realIsPopup":0,"realSupportTrial":0}]
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
         * position : 1
         * linkCategory : 1
         * linkPosition : 1
         * image : https://cdn01.smxoo.cn/upload/test/customise/images/m_float_ad_1.jpg?v=1580393285
         * lotteryGameType : cqssc
         * realIsPopup : 0
         * realSupportTrial : 0
         */

        private int position;
        private String linkCategory;
        private String linkPosition;
        private String image;
        private String lotteryGameType;
        private String realIsPopup;
        private String realSupportTrial;

        public int getPosition() {
            return position;
        }

        public void setPosition(int position) {
            this.position = position;
        }

        public String getLinkCategory() {
            return linkCategory;
        }

        public void setLinkCategory(String linkCategory) {
            this.linkCategory = linkCategory;
        }

        public String getLinkPosition() {
            return linkPosition;
        }

        public void setLinkPosition(String linkPosition) {
            this.linkPosition = linkPosition;
        }

        public String getImage() {
            return image;
        }

        public void setImage(String image) {
            this.image = image;
        }

        public String getLotteryGameType() {
            return lotteryGameType;
        }

        public void setLotteryGameType(String lotteryGameType) {
            this.lotteryGameType = lotteryGameType;
        }

        public String getRealIsPopup() {
            return realIsPopup;
        }

        public void setRealIsPopup(String realIsPopup) {
            this.realIsPopup = realIsPopup;
        }

        public String getRealSupportTrial() {
            return realSupportTrial;
        }

        public void setRealSupportTrial(String realSupportTrial) {
            this.realSupportTrial = realSupportTrial;
        }
    }
}
