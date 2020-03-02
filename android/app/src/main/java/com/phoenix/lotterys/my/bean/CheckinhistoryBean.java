package com.phoenix.lotterys.my.bean;

import java.io.Serializable;
import java.util.List;

/**
 * 文件描述:用户签到历史
 * 创建者: IAN
 * 创建时间: 2019/9/5 13:04
 */
public class CheckinhistoryBean implements Serializable {


    /**
     * code : 0
     * msg : ok
     * data : [{"checkinDate":"2019-09-05","integral":"10.00","remark":"签到送积分"}]
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
         * checkinDate : 2019-09-05
         * integral : 10.00
         * remark : 签到送积分
         */

        private String checkinDate;
        private String integral;
        private String remark;

        public String getCheckinDate() {
            return checkinDate;
        }

        public void setCheckinDate(String checkinDate) {
            this.checkinDate = checkinDate;
        }

        public String getIntegral() {
            return integral;
        }

        public void setIntegral(String integral) {
            this.integral = integral;
        }

        public String getRemark() {
            return remark;
        }

        public void setRemark(String remark) {
            this.remark = remark;
        }
    }
}
