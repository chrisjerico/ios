package com.phoenix.lotterys.home.bean;

import java.io.Serializable;
import java.util.List;

/**
 * Created by Luke
 * on 2019/6/23
 */
public class BannerBean1 implements Serializable {


    /**
     * code : 0
     * msg : 获取首页广告成功
     * data : [{"linkCategory":"1","linkPosition":"125","image":"https://cdn01.nxyuntuo.net/upload/t111/customise/images/m_home_center_ad_4.jpg?v=1576825499","lotteryGameType":"lhc","realIsPopup":0,"realSupportTrial":0}]
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
         * linkCategory : 1
         * linkPosition : 125
         * image : https://cdn01.nxyuntuo.net/upload/t111/customise/images/m_home_center_ad_4.jpg?v=1576825499
         * lotteryGameType : lhc
         * realIsPopup : 0
         * realSupportTrial : 0
         */

        private String linkCategory;
        private String linkPosition;
        private String image;
        private String lotteryGameType;
        private String realIsPopup;
        private String realSupportTrial;

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
