package com.phoenix.lotterys.my.bean;

import java.io.Serializable;
import java.util.List;

/**
 * 文件描述:
 * 创建者: IAN
 * 创建时间: 2019/8/26 19:06
 */
public class MissionHallBean implements Serializable {


    /**
     * code : 0
     * msg : 获取任务大厅列表成功
     * data : {"list":[{"id":"10","sortId":"1","missionName":"每日存款送积分","missionDesc":"每日存款次数3次以上（金额不限），即可完成此任务。","integral":"100.0000","missionType":"1","status":"1","overTime":"1640880000","type":"1"},{"id":"13","sortId":"1","missionName":"极速赛车投注任务","missionDesc":"每日极速赛车的当日有效投注达到10000，即可完成此任务。","integral":"200.0000","missionType":"9","status":"1","overTime":"1639324799","type":"1"},{"id":"14","sortId":"1","missionName":"极速时时彩投注任务","missionDesc":"每日极速时时彩的当日有效投注达到10000，即可完成此任务。","integral":"200.0000","missionType":"9","status":"1","overTime":"1639324799","type":"1"},{"id":"16","sortId":"1","missionName":"极速六合彩投注任务","missionDesc":"每日极速六合彩的当日有效投注达到10000，即可完成此任务。","integral":"200.0000","missionType":"9","status":"1","overTime":"1640966399","type":"1"},{"id":"24","sortId":"1","missionName":"棋牌 真人 电子 投注金额20000","missionDesc":"棋牌 真人 电子 投注金额20000","integral":"500.0000","missionType":"10","status":"1","overTime":"1640880000","type":"1"},{"id":"25","sortId":"1","missionName":"棋牌 真人 电子 单笔投注金额1000","missionDesc":"棋牌 真人 电子 单笔投注金额1000","integral":"300.0000","missionType":"13","status":"1","overTime":"1640880000","type":"1"},{"id":"2","sortId":"2","missionName":"首次存款","missionDesc":"首次存款","integral":"100.0000","missionType":"26","status":"0","overTime":"0","type":"0"},{"id":"8","sortId":"7","missionName":"首次中奖","missionDesc":"首次中奖","integral":"100.0000","missionType":"31","status":"0","overTime":"0","type":"0"},{"id":"9","sortId":"7","missionName":"首次抢红包","missionDesc":"第一次点击主页上的红包，并成功抢红包一次！","integral":"100.0000","missionType":"32","status":"1","overTime":"0","type":"0"},{"id":"17","sortId":"2","missionName":"每日单笔存款1500元","missionDesc":"每日会员单笔存款1500元","integral":"200.0000","missionType":"3","status":"1","overTime":"1640880000","type":"1"},{"id":"18","sortId":"2","missionName":"每日单笔存款5000元","missionDesc":"每日单笔存款5000元","integral":"800.0000","missionType":"3","status":"1","overTime":"1640880000","type":"1"},{"id":"26","sortId":"2","missionName":"每日单笔存款15000元","missionDesc":"每日单笔存款15000元","integral":"1500.0000","missionType":"3","status":"1","overTime":"1640880000","type":"1"},{"id":"27","sortId":"2","missionName":"每日单笔存款30000元","missionDesc":"每日单笔存款30000元","integral":"2800.0000","missionType":"3","status":"1","overTime":"1640966399","type":"1"}],"total":13}
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
         * list : [{"id":"10","sortId":"1","missionName":"每日存款送积分","missionDesc":"每日存款次数3次以上（金额不限），即可完成此任务。","integral":"100.0000","missionType":"1","status":"1","overTime":"1640880000","type":"1"},{"id":"13","sortId":"1","missionName":"极速赛车投注任务","missionDesc":"每日极速赛车的当日有效投注达到10000，即可完成此任务。","integral":"200.0000","missionType":"9","status":"1","overTime":"1639324799","type":"1"},{"id":"14","sortId":"1","missionName":"极速时时彩投注任务","missionDesc":"每日极速时时彩的当日有效投注达到10000，即可完成此任务。","integral":"200.0000","missionType":"9","status":"1","overTime":"1639324799","type":"1"},{"id":"16","sortId":"1","missionName":"极速六合彩投注任务","missionDesc":"每日极速六合彩的当日有效投注达到10000，即可完成此任务。","integral":"200.0000","missionType":"9","status":"1","overTime":"1640966399","type":"1"},{"id":"24","sortId":"1","missionName":"棋牌 真人 电子 投注金额20000","missionDesc":"棋牌 真人 电子 投注金额20000","integral":"500.0000","missionType":"10","status":"1","overTime":"1640880000","type":"1"},{"id":"25","sortId":"1","missionName":"棋牌 真人 电子 单笔投注金额1000","missionDesc":"棋牌 真人 电子 单笔投注金额1000","integral":"300.0000","missionType":"13","status":"1","overTime":"1640880000","type":"1"},{"id":"2","sortId":"2","missionName":"首次存款","missionDesc":"首次存款","integral":"100.0000","missionType":"26","status":"0","overTime":"0","type":"0"},{"id":"8","sortId":"7","missionName":"首次中奖","missionDesc":"首次中奖","integral":"100.0000","missionType":"31","status":"0","overTime":"0","type":"0"},{"id":"9","sortId":"7","missionName":"首次抢红包","missionDesc":"第一次点击主页上的红包，并成功抢红包一次！","integral":"100.0000","missionType":"32","status":"1","overTime":"0","type":"0"},{"id":"17","sortId":"2","missionName":"每日单笔存款1500元","missionDesc":"每日会员单笔存款1500元","integral":"200.0000","missionType":"3","status":"1","overTime":"1640880000","type":"1"},{"id":"18","sortId":"2","missionName":"每日单笔存款5000元","missionDesc":"每日单笔存款5000元","integral":"800.0000","missionType":"3","status":"1","overTime":"1640880000","type":"1"},{"id":"26","sortId":"2","missionName":"每日单笔存款15000元","missionDesc":"每日单笔存款15000元","integral":"1500.0000","missionType":"3","status":"1","overTime":"1640880000","type":"1"},{"id":"27","sortId":"2","missionName":"每日单笔存款30000元","missionDesc":"每日单笔存款30000元","integral":"2800.0000","missionType":"3","status":"1","overTime":"1640966399","type":"1"}]
         * total : 13
         */

        private int total;
        private List<ListBean> list;

        public int getTotal() {
            return total;
        }

        public void setTotal(int total) {
            this.total = total;
        }

        public List<ListBean> getList() {
            return list;
        }

        public void setList(List<ListBean> list) {
            this.list = list;
        }

        public static class ListBean {
            /**
             * id : 10
             * sortId : 1
             * missionName : 每日存款送积分
             * missionDesc : 每日存款次数3次以上（金额不限），即可完成此任务。
             * integral : 100.0000
             * missionType : 1
             * status : 1
             * overTime : 1640880000
             * type : 1
             */

            private String id;
            private String sortId;
            private String missionName;
            private String missionDesc;
            private String integral;
            private String missionType;
            private String status;
            private String overTime;
            private String type;

            public String getId() {
                return id;
            }

            public void setId(String id) {
                this.id = id;
            }

            public String getSortId() {
                return sortId;
            }

            public void setSortId(String sortId) {
                this.sortId = sortId;
            }

            public String getMissionName() {
                return missionName;
            }

            public void setMissionName(String missionName) {
                this.missionName = missionName;
            }

            public String getMissionDesc() {
                return missionDesc;
            }

            public void setMissionDesc(String missionDesc) {
                this.missionDesc = missionDesc;
            }

            public String getIntegral() {
                return integral;
            }

            public void setIntegral(String integral) {
                this.integral = integral;
            }

            public String getMissionType() {
                return missionType;
            }

            public void setMissionType(String missionType) {
                this.missionType = missionType;
            }

            public String getStatus() {
                return status;
            }

            public void setStatus(String status) {
                this.status = status;
            }

            public String getOverTime() {
                return overTime;
            }

            public void setOverTime(String overTime) {
                this.overTime = overTime;
            }

            public String getType() {
                return type;
            }

            public void setType(String type) {
                this.type = type;
            }
        }
    }
}
