package com.phoenix.lotterys.my.bean;

import java.io.Serializable;
import java.util.List;

/**
 * 文件描述:
 * 创建者: IAN
 * 创建时间: 2019/8/26 15:25
 */
public class VIPLevelBean implements Serializable {


    /**
     * code : 0
     * msg : 获取任务头衔列表成功
     * data : [{"id":"1","levelName":"VIP1","levelTitle":"新手","levelDesc":"2333333222222","integral":"0","checkinCards":"0","params":"{\"checkinPerDay\":[\"\",\"\",\"\",\"\",\"\",\"\",\"\"],\"bonus\":[{\"int\":\"\",\"switch\":\"0\"},{\"int\":\"\",\"switch\":\"0\"}]}"},{"id":"2","levelName":"VIP2","levelTitle":"青铜","levelDesc":"","integral":"100","checkinCards":"0","params":""},{"id":"3","levelName":"VIP3","levelTitle":"白银","levelDesc":"","integral":"1000","checkinCards":"0","params":""},{"id":"4","levelName":"VIP4","levelTitle":"黄金","levelDesc":"","integral":"10000","checkinCards":"0","params":""},{"id":"5","levelName":"VIP5","levelTitle":"铂金","levelDesc":"","integral":"100000","checkinCards":"1","params":""},{"id":"6","levelName":"VIP6","levelTitle":"钻石","levelDesc":"","integral":"500000","checkinCards":"1","params":""},{"id":"7","levelName":"VIP7","levelTitle":"星耀","levelDesc":"","integral":"1000000","checkinCards":"2","params":""},{"id":"8","levelName":"VIP8","levelTitle":"王者","levelDesc":"","integral":"5000000","checkinCards":"2","params":""},{"id":"9","levelName":"VIP9","levelTitle":"彩神","levelDesc":"","integral":"10000000","checkinCards":"3","params":""},{"id":"10","levelName":"VIP10","levelTitle":"彩魔","levelDesc":"23333","integral":"20000000","checkinCards":"0","params":"{\"checkinPerDay\":[\"\",\"\",\"\",\"\",\"\",\"\",\"\"],\"bonus\":[{\"int\":\"\",\"switch\":\"1\"},{\"int\":\"\",\"switch\":\"1\"}]}"}]
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
         * id : 1
         * levelName : VIP1
         * levelTitle : 新手
         * levelDesc : 2333333222222
         * integral : 0
         * checkinCards : 0
         * params : {"checkinPerDay":["","","","","","",""],"bonus":[{"int":"","switch":"0"},{"int":"","switch":"0"}]}
         */

        private String id;
        private String levelName;
        private String levelTitle;
        private String levelDesc;
        private String integral;
        private String checkinCards;
        private String params;

        public String getId() {
            return id;
        }

        public void setId(String id) {
            this.id = id;
        }

        public String getLevelName() {
            return levelName;
        }

        public void setLevelName(String levelName) {
            this.levelName = levelName;
        }

        public String getLevelTitle() {
            return levelTitle;
        }

        public void setLevelTitle(String levelTitle) {
            this.levelTitle = levelTitle;
        }

        public String getLevelDesc() {
            return levelDesc;
        }

        public void setLevelDesc(String levelDesc) {
            this.levelDesc = levelDesc;
        }

        public String getIntegral() {
            return integral;
        }

        public void setIntegral(String integral) {
            this.integral = integral;
        }

        public String getCheckinCards() {
            return checkinCards;
        }

        public void setCheckinCards(String checkinCards) {
            this.checkinCards = checkinCards;
        }

        public String getParams() {
            return params;
        }

        public void setParams(String params) {
            this.params = params;
        }
    }
}
