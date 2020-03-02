package com.phoenix.lotterys.home.bean;

/**
 * Greated by Luke
 * on 2019/9/5
 */
public class RedBagDetailBean {

    /**
     * code : 0
     * msg : 获取红包详情成功
     * data : {"name":"红包活动","start":"1567593594","end":"1572079854","show_time":"1562947200","redBagLogo":"https://cdn01.hchejie.net/upload/t010/customise/images/m_bonus_logo.jpg","isHideAmount":true,"isHideCount":true,"leftAmount":"￥****","leftCount":"****个","id":"90","intro":"单日充值满200元以上，即可获得1次抢红包次数。<br />\n单日充值满1500元以上，即可获得2次抢红包次数。<br />\n单日充值满5000元以上，即可获得3次抢红包次数。<br />\n单日充值满15000元以上，即可获得4次抢红包次数。<br />\n单日充值满50000元以上，即可获得5次抢红包次数。","username":"flb2019","hasLogin":true,"isTest":false,"attendedTimes":1,"attendTimesLimit":1}
     * info : {"sqlList":["主库(5303)：SELECT * FROM `ssc_activity` WHERE end>=1567687834 AND isDelete=0 AND type='bonus_coin' AND enable=1  --Spent：0.49 ms","主库(5303)：SELECT  count(1) as total FROM `ssc_upload` WHERE name LIKE '%m_bonus_logo.jpg%' AND last_update>0  --Spent：0.27 ms","主库(5303)：SELECT attend_times FROM `ssc_member_activity`  WHERE `uid` = '2679' AND `activity_id` = '90'    --Spent：0.37 ms"],"sqlTotalNum":3,"sqlTotalTime":"1.13 ms","traceBack":{"loader":"1.50 ms","initDi":"7.83 ms","settings":null,"access":"15.47 ms","dispatch":null},"runtime":"21.79 ms"}
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
         * name : 红包活动
         * start : 1567593594
         * end : 1572079854
         * show_time : 1562947200
         * redBagLogo : https://cdn01.hchejie.net/upload/t010/customise/images/m_bonus_logo.jpg
         * isHideAmount : true
         * isHideCount : true
         * leftAmount : ￥****
         * leftCount : ****个
         * id : 90
         * intro : 单日充值满200元以上，即可获得1次抢红包次数。<br />
         单日充值满1500元以上，即可获得2次抢红包次数。<br />
         单日充值满5000元以上，即可获得3次抢红包次数。<br />
         单日充值满15000元以上，即可获得4次抢红包次数。<br />
         单日充值满50000元以上，即可获得5次抢红包次数。
         * username : flb2019
         * hasLogin : true
         * isTest : false
         * attendedTimes : 1
         * attendTimesLimit : 1
         */

        private String name;
        private String start;
        private String end;
        private String show_time;
        private String redBagLogo;
        private boolean isHideAmount;
        private boolean isHideCount;
        private String leftAmount;
        private String leftCount;
        private String id;
        private String intro;
        private String username;
        private String canGet;
        private boolean hasLogin;
        private boolean isTest;
        private String attendedTimes;
        private String attendTimesLimit;

        public String getCanGet() {
            return canGet;
        }

        public void setCanGet(String canGet) {
            this.canGet = canGet;
        }

        public String getName() {
            return name;
        }

        public void setName(String name) {
            this.name = name;
        }

        public String getStart() {
            return start;
        }

        public void setStart(String start) {
            this.start = start;
        }

        public String getEnd() {
            return end;
        }

        public void setEnd(String end) {
            this.end = end;
        }

        public String getShow_time() {
            return show_time;
        }

        public void setShow_time(String show_time) {
            this.show_time = show_time;
        }

        public String getRedBagLogo() {
            return redBagLogo;
        }

        public void setRedBagLogo(String redBagLogo) {
            this.redBagLogo = redBagLogo;
        }

        public boolean isIsHideAmount() {
            return isHideAmount;
        }

        public void setIsHideAmount(boolean isHideAmount) {
            this.isHideAmount = isHideAmount;
        }

        public boolean isIsHideCount() {
            return isHideCount;
        }

        public void setIsHideCount(boolean isHideCount) {
            this.isHideCount = isHideCount;
        }

        public String getLeftAmount() {
            return leftAmount;
        }

        public void setLeftAmount(String leftAmount) {
            this.leftAmount = leftAmount;
        }

        public String getLeftCount() {
            return leftCount;
        }

        public void setLeftCount(String leftCount) {
            this.leftCount = leftCount;
        }

        public String getId() {
            return id;
        }

        public void setId(String id) {
            this.id = id;
        }

        public String getIntro() {
            return intro;
        }

        public void setIntro(String intro) {
            this.intro = intro;
        }

        public String getUsername() {
            return username;
        }

        public void setUsername(String username) {
            this.username = username;
        }

        public boolean isHasLogin() {
            return hasLogin;
        }

        public void setHasLogin(boolean hasLogin) {
            this.hasLogin = hasLogin;
        }

        public boolean isIsTest() {
            return isTest;
        }

        public void setIsTest(boolean isTest) {
            this.isTest = isTest;
        }

        public String getAttendedTimes() {
            return attendedTimes;
        }

        public void setAttendedTimes(String attendedTimes) {
            this.attendedTimes = attendedTimes;
        }

        public String getAttendTimesLimit() {
            return attendTimesLimit;
        }

        public void setAttendTimesLimit(String attendTimesLimit) {
            this.attendTimesLimit = attendTimesLimit;
        }
    }

}
