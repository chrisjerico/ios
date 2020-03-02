package com.phoenix.lotterys.main.bean;

/**
 * Greated by Luke
 * on 2019/8/14
 */
public class UpdataVersionBean {


    /**
     * code : 0
     * msg : 获取APP版本成功
     * data : {"versionCode":"1.0.0","versionName":"","switchUpdate":"1","updateContent":"11111","file":"http://test10.6yc.com/customise/app/android.apk"}
     * info : {"sqlList":["从库(5304)：SELECT id, name, title, value FROM `ssc_params`   --Spent：0.63 ms","从库(5304)：SELECT * FROM `ssc_blacklist` WHERE  `type` = :type   --Spent：0.28 ms","从库(5304)：SELECT * FROM `ssc_cache`  WHERE `name` = 'block_country'    --Spent：0.16 ms","主库(5303)：SELECT value FROM `ssc_params` WHERE  `name` = :name   --Spent：0.36 ms","主库(5303)：SELECT value FROM `ssc_params` WHERE  `name` = :name   --Spent：0.09 ms","主库(5303)：SELECT value FROM `ssc_params` WHERE  `name` = :name   --Spent：0.07 ms","主库(5303)：SELECT value FROM `ssc_params` WHERE  `name` = :name   --Spent：0.07 ms"],"sqlTotalNum":7,"sqlTotalTime":"1.66 ms","traceBack":{"loader":"2.19 ms","initDi":"10.24 ms","settings":"28.50 ms","access":"34.54 ms","dispatch":null},"runtime":"35.96 ms"}
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
         * versionCode : 1.0.0
         * versionName :
         * switchUpdate : 1
         * updateContent : 11111
         * file : http://test10.6yc.com/customise/app/android.apk
         */

        private String versionCode;
        private String versionName;
        private String switchUpdate;
        private String updateContent;
        private String file;

        public String getVersionCode() {
            return versionCode;
        }

        public void setVersionCode(String versionCode) {
            this.versionCode = versionCode;
        }

        public String getVersionName() {
            return versionName;
        }

        public void setVersionName(String versionName) {
            this.versionName = versionName;
        }

        public String getSwitchUpdate() {
            return switchUpdate;
        }

        public void setSwitchUpdate(String switchUpdate) {
            this.switchUpdate = switchUpdate;
        }

        public String getUpdateContent() {
            return updateContent;
        }

        public void setUpdateContent(String updateContent) {
            this.updateContent = updateContent;
        }

        public String getFile() {
            return file;
        }

        public void setFile(String file) {
            this.file = file;
        }
    }
}
