package com.phoenix.lotterys.my.bean;

import java.util.List;

/**
 * Created by Luke
 * on 2019/6/16
 */
public class RegeditBean {


    /**
     * code : 0
     * msg : 注册成功！
     * data : {"uid":"13","usr":"retretreret545","autoLogin":false}
     * info : {"sqlList":["主库(5303)：SELECT id, name, title, value FROM `ssc_params`   --Spent：0.71 ms","主库(5303)：SELECT * FROM `ssc_blacklist` WHERE  `type` = :type   --Spent：0.24 ms","主库(5303)：SELECT * FROM `ssc_cache`  WHERE `name` = 'block_country'    --Spent：0.16 ms","主库(5303)：SELECT  count(1) as total FROM `ssc_members` WHERE  `regIP` = :regIP AND `auth_key` = :auth_key  AND regTime > 1563717702  --Spent：0.37 ms","主库(5303)：SELECT uid, parentId, admin, username, password, coinPassword, type, name, coin, email, qq, phone, testFlag, level_id, rebate FROM `ssc_members` WHERE  `username` = :username   --Spent：0.16 ms","主库(5303)：SELECT uid, parentId, admin, username, password, coinPassword, type, name, coin, email, qq, phone, testFlag, level_id, rebate FROM `ssc_members`  WHERE `phone` = '13513213212'    --Spent：0.16 ms","主库(5303)：SELECT * FROM `ssc_activity` WHERE  `type` = :type AND `isDelete` = :isDelete AND `enable` = :enable  AND start<='1563804102' AND end>='1563804102'  --Spent：0.21 ms","主库(5303)：SELECT uid, parentId, admin, username, password, coinPassword, type, name, coin, email, qq, phone, testFlag, level_id, rebate FROM `ssc_members` WHERE  `username` = :username   --Spent：0.12 ms","主库(5303)：INSERT INTO `ssc_members` SET `salt` = '604264', `fanDian` = '0', `coin` = '0', `type` = '0', `regIP` = '832373303', `regTime` = '1563804102', `from_mobile` = '1', `smsVerified` = '0', `updateTime` = '2019-07-22 22:01:42', `username` = 'retretreret545', `name` = '梵蒂冈', `password` = '4e9612c77fd02bf7fa9a1db52ee0b729', `phone` = '13513213212', `coinPassword` = '0'Password;  --Spent：0.29 ms","主库(5303)：SELECT * FROM `ssc_member_district`  WHERE `uid` = '13' AND `district` = '菲律宾 0 0'    --Spent：0.16 ms","主库(5303)：INSERT INTO `ssc_member_district` SET `uid` = '13', `district` = '菲律宾 0 0';  --Spent：0.13 ms","主库(5303)：SELECT * FROM `ssc_member_append`  WHERE `uid` = '13'    --Spent：0.16 ms","主库(5303)：UPDATE `ssc_member_append` SET `from_domain` = 'test100f.fhptcdn.com', `source_domain` = '', `last_login` = '1563804102', `fandian2` = '0', `fandian3` = '0', `wx` = 'rertgrtgre54' WHERE uid=13;  --Spent：0.21 ms","主库(5303)：SELECT * FROM `ssc_stat_domain`  WHERE `date` = '2019-07-22' AND `domain` = 'test100f.fhptcdn.com'    --Spent：0.13 ms","主库(5303)：UPDATE `ssc_stat_domain` SET `date` = '2019-07-22', `domain` = 'test100f.fhptcdn.com', `last_update` = '1563804102', `regmember` = '5' WHERE `id` = '7';  --Spent：0.16 ms","主库(5303)：SELECT * FROM `ssc_stat_referer`  WHERE `date` = '2019-07-22' AND `host` = 'test100f.fhptcdn.com'    --Spent：0.16 ms","主库(5303)：UPDATE `ssc_stat_referer` SET `date` = '2019-07-22', `host` = 'test100f.fhptcdn.com', `last_update` = '2019-07-22 22:01:42', `reg` = '5' WHERE `id` = '4';  --Spent：0.15 ms","主库(5303)：SELECT * FROM `ssc_member_append1`  WHERE `uid` = '13'    --Spent：0.11 ms","主库(5303)：INSERT INTO `ssc_member_append1` SET `uid` = '13', `username` = 'retretreret545';  --Spent：0.11 ms","主库(5303)：SELECT uid, parentId, admin, username, password, coinPassword, type, name, coin, email, qq, phone, testFlag, level_id, rebate FROM `ssc_members` WHERE  `username` = :username   --Spent：0.16 ms","主库(5303)：SELECT * FROM `ssc_member_bank`  WHERE `uid` = '13'    --Spent：0.12 ms"],"sqlTotalNum":21,"sqlTotalTime":"4.18 ms","runtime":"42.97 ms"}
     */

    private int code;
    private String msg;
    private DataBean data;
    private InfoBean info;

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

    public InfoBean getInfo() {
        return info;
    }

    public void setInfo(InfoBean info) {
        this.info = info;
    }

    public static class DataBean {
        /**
         * uid : 13
         * usr : retretreret545
         * autoLogin : false
         */

        private String uid;
        private String usr;
        private boolean autoLogin;

        public String getUid() {
            return uid;
        }

        public void setUid(String uid) {
            this.uid = uid;
        }

        public String getUsr() {
            return usr;
        }

        public void setUsr(String usr) {
            this.usr = usr;
        }

        public boolean isAutoLogin() {
            return autoLogin;
        }

        public void setAutoLogin(boolean autoLogin) {
            this.autoLogin = autoLogin;
        }
    }

    public static class InfoBean {
        /**
         * sqlList : ["主库(5303)：SELECT id, name, title, value FROM `ssc_params`   --Spent：0.71 ms","主库(5303)：SELECT * FROM `ssc_blacklist` WHERE  `type` = :type   --Spent：0.24 ms","主库(5303)：SELECT * FROM `ssc_cache`  WHERE `name` = 'block_country'    --Spent：0.16 ms","主库(5303)：SELECT  count(1) as total FROM `ssc_members` WHERE  `regIP` = :regIP AND `auth_key` = :auth_key  AND regTime > 1563717702  --Spent：0.37 ms","主库(5303)：SELECT uid, parentId, admin, username, password, coinPassword, type, name, coin, email, qq, phone, testFlag, level_id, rebate FROM `ssc_members` WHERE  `username` = :username   --Spent：0.16 ms","主库(5303)：SELECT uid, parentId, admin, username, password, coinPassword, type, name, coin, email, qq, phone, testFlag, level_id, rebate FROM `ssc_members`  WHERE `phone` = '13513213212'    --Spent：0.16 ms","主库(5303)：SELECT * FROM `ssc_activity` WHERE  `type` = :type AND `isDelete` = :isDelete AND `enable` = :enable  AND start<='1563804102' AND end>='1563804102'  --Spent：0.21 ms","主库(5303)：SELECT uid, parentId, admin, username, password, coinPassword, type, name, coin, email, qq, phone, testFlag, level_id, rebate FROM `ssc_members` WHERE  `username` = :username   --Spent：0.12 ms","主库(5303)：INSERT INTO `ssc_members` SET `salt` = '604264', `fanDian` = '0', `coin` = '0', `type` = '0', `regIP` = '832373303', `regTime` = '1563804102', `from_mobile` = '1', `smsVerified` = '0', `updateTime` = '2019-07-22 22:01:42', `username` = 'retretreret545', `name` = '梵蒂冈', `password` = '4e9612c77fd02bf7fa9a1db52ee0b729', `phone` = '13513213212', `coinPassword` = '0'Password;  --Spent：0.29 ms","主库(5303)：SELECT * FROM `ssc_member_district`  WHERE `uid` = '13' AND `district` = '菲律宾 0 0'    --Spent：0.16 ms","主库(5303)：INSERT INTO `ssc_member_district` SET `uid` = '13', `district` = '菲律宾 0 0';  --Spent：0.13 ms","主库(5303)：SELECT * FROM `ssc_member_append`  WHERE `uid` = '13'    --Spent：0.16 ms","主库(5303)：UPDATE `ssc_member_append` SET `from_domain` = 'test100f.fhptcdn.com', `source_domain` = '', `last_login` = '1563804102', `fandian2` = '0', `fandian3` = '0', `wx` = 'rertgrtgre54' WHERE uid=13;  --Spent：0.21 ms","主库(5303)：SELECT * FROM `ssc_stat_domain`  WHERE `date` = '2019-07-22' AND `domain` = 'test100f.fhptcdn.com'    --Spent：0.13 ms","主库(5303)：UPDATE `ssc_stat_domain` SET `date` = '2019-07-22', `domain` = 'test100f.fhptcdn.com', `last_update` = '1563804102', `regmember` = '5' WHERE `id` = '7';  --Spent：0.16 ms","主库(5303)：SELECT * FROM `ssc_stat_referer`  WHERE `date` = '2019-07-22' AND `host` = 'test100f.fhptcdn.com'    --Spent：0.16 ms","主库(5303)：UPDATE `ssc_stat_referer` SET `date` = '2019-07-22', `host` = 'test100f.fhptcdn.com', `last_update` = '2019-07-22 22:01:42', `reg` = '5' WHERE `id` = '4';  --Spent：0.15 ms","主库(5303)：SELECT * FROM `ssc_member_append1`  WHERE `uid` = '13'    --Spent：0.11 ms","主库(5303)：INSERT INTO `ssc_member_append1` SET `uid` = '13', `username` = 'retretreret545';  --Spent：0.11 ms","主库(5303)：SELECT uid, parentId, admin, username, password, coinPassword, type, name, coin, email, qq, phone, testFlag, level_id, rebate FROM `ssc_members` WHERE  `username` = :username   --Spent：0.16 ms","主库(5303)：SELECT * FROM `ssc_member_bank`  WHERE `uid` = '13'    --Spent：0.12 ms"]
         * sqlTotalNum : 21
         * sqlTotalTime : 4.18 ms
         * runtime : 42.97 ms
         */

        private int sqlTotalNum;
        private String sqlTotalTime;
        private String runtime;
        private List<String> sqlList;

        public int getSqlTotalNum() {
            return sqlTotalNum;
        }

        public void setSqlTotalNum(int sqlTotalNum) {
            this.sqlTotalNum = sqlTotalNum;
        }

        public String getSqlTotalTime() {
            return sqlTotalTime;
        }

        public void setSqlTotalTime(String sqlTotalTime) {
            this.sqlTotalTime = sqlTotalTime;
        }

        public String getRuntime() {
            return runtime;
        }

        public void setRuntime(String runtime) {
            this.runtime = runtime;
        }

        public List<String> getSqlList() {
            return sqlList;
        }

        public void setSqlList(List<String> sqlList) {
            this.sqlList = sqlList;
        }
    }
}
