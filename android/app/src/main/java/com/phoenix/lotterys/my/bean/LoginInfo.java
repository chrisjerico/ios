package com.phoenix.lotterys.my.bean;

import com.google.gson.annotations.SerializedName;

/**
 * Created by Luke
 * on 2019/6/16
 */
public class LoginInfo {

//    /**
//     * code : 0
//     * msg : 登录成功！
//     * data : {"uid":"22","parentId":"0","admin":"0","username":"flb2019","type":"0","name":"丰富的","coin":"0.0000","email":"","qq":"","phone":"13512456322","testFlag":"0","level_id":"-1","rebate":"0.00","API-SID":"opeUb5p5pg3cdpg0G0e0oY8d","API-TOKEN":"2d65fa1d7641c65e50d70f05f5a09b3f"}
//     * info : {"mysql":["主库： SELECT id, name, title, value FROM `ssc_params`   --Spent：0.56 ms","主库： SELECT * FROM `ssc_blacklist` WHERE  `type` = :type   --Spent：0.25 ms","主库： SELECT uid, isDelete, enable, parentId, admin, username, password, type, name, coin, email, qq, phone, testFlag, level_id, rebate, is_trial, salt FROM `ssc_members` WHERE  `username` = :username AND `admin` = :admin   --Spent：0.34 ms","主库： INSERT INTO ssc_member_session set `uid`=\"22\",`username`=\"flb2019\",`loginTime`=\"1560685151\",`accessTime`=\"1560685151\",`isOnLine`=\"1\",`loginIP`=\"832373303\",`auth_key`=\"appnoauthkey\",`isMobileDevices`=\"1\",`browser`=\"app\",`os`=\"app\",`session_key`=\"opeUb5p5pg3cdpg0G0e0oY8d\";  --Spent：3.26 ms","主库： UPDATE ssc_members SET `updateTime`=\"2019-06-16 19:39:11\",`host`=\"test10.6yc.com\" WHERE username = 'flb2019' ;  --Spent：2.68 ms","主库： SELECT * FROM `ssc_member_append`  WHERE  `uid` = \"22\"      --Spent：0.29 ms","主库： UPDATE ssc_member_append SET `last_login`=\"1560685151\" WHERE uid=22 ;  --Spent：3.57 ms","主库： DELETE FROM `ssc_member_session` WHERE  `uid` = :uid AND `isOnLine` = :isOnLine AND `isMobileDevices` = :isMobileDevices  AND session_key != 'opeUb5p5pg3cdpg0G0e0oY8d'   --Spent：2.87 ms","主库： SELECT uid, parentId, admin, username,  type, name, coin, email, qq, phone, testFlag, level_id, rebate FROM `ssc_members` WHERE  `username` = :username AND `admin` = :admin   --Spent：0.27 ms"],"runtime":"29.84 ms"}
//     */

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
         * uid : 22
         * parentId : 0
         * admin : 0
         * username : flb2019
         * type : 0
         * name : 丰富的
         * coin : 0.0000
         * email :
         * qq :
         * phone : 13512456322
         * testFlag : 0
         * level_id : -1
         * rebate : 0.00
         * API-SID : opeUb5p5pg3cdpg0G0e0oY8d
         * API-TOKEN : 2d65fa1d7641c65e50d70f05f5a09b3f
         */

        private String uid;
        private String parentId;
        private String admin;
        private String username;
        private String type;
        private String name;
        private String coin;
        private String email;
        private String qq;
        private String phone;
        private String testFlag;
        private String level_id;
        private String rebate;
        @SerializedName("API-SID")
        private String APISID;
        @SerializedName("API-TOKEN")
        private String APITOKEN;

        public String getUid() {
            return uid;
        }

        public void setUid(String uid) {
            this.uid = uid;
        }

        public String getParentId() {
            return parentId;
        }

        public void setParentId(String parentId) {
            this.parentId = parentId;
        }

        public String getAdmin() {
            return admin;
        }

        public void setAdmin(String admin) {
            this.admin = admin;
        }

        public String getUsername() {
            return username;
        }

        public void setUsername(String username) {
            this.username = username;
        }

        public String getType() {
            return type;
        }

        public void setType(String type) {
            this.type = type;
        }

        public String getName() {
            return name;
        }

        public void setName(String name) {
            this.name = name;
        }

        public String getCoin() {
            return coin;
        }

        public void setCoin(String coin) {
            this.coin = coin;
        }

        public String getEmail() {
            return email;
        }

        public void setEmail(String email) {
            this.email = email;
        }

        public String getQq() {
            return qq;
        }

        public void setQq(String qq) {
            this.qq = qq;
        }

        public String getPhone() {
            return phone;
        }

        public void setPhone(String phone) {
            this.phone = phone;
        }

        public String getTestFlag() {
            return testFlag;
        }

        public void setTestFlag(String testFlag) {
            this.testFlag = testFlag;
        }

        public String getLevel_id() {
            return level_id;
        }

        public void setLevel_id(String level_id) {
            this.level_id = level_id;
        }

        public String getRebate() {
            return rebate;
        }

        public void setRebate(String rebate) {
            this.rebate = rebate;
        }

        public String getAPISID() {
            return APISID;
        }

        public void setAPISID(String APISID) {
            this.APISID = APISID;
        }

        public String getAPITOKEN() {
            return APITOKEN;
        }

        public void setAPITOKEN(String APITOKEN) {
            this.APITOKEN = APITOKEN;
        }
    }

}
