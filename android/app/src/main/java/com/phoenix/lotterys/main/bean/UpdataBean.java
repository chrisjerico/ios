package com.phoenix.lotterys.main.bean;

/**
 * Date:2018/9/30
 * TIME:15:35
 * author：Luke
 */
public class UpdataBean {

    /**
     * versionCode : 108
     * isForceUpdate : 0
     * versionName : 1.0.8
     * downUrl : https://www.11111.com/C3795847887F80C6/app-PL88-release.apk
     * updateLog : 1.代码优化
     * size : 78.8M
     */

    private int versionCode;
    private int isForceUpdate;
    private String versionName;
    private String downUrl;
    private String updateLog;
    private String size;


    public int getVersionCode() {
        return versionCode;
    }

    public void setVersionCode(int versionCode) {
        this.versionCode = versionCode;
    }

    public int getIsForceUpdate() {
        return isForceUpdate;
    }

    public void setIsForceUpdate(int isForceUpdate) {
        this.isForceUpdate = isForceUpdate;
    }

    public String getVersionName() {
        return versionName;
    }

    public void setVersionName(String versionName) {
        this.versionName = versionName;
    }

    public String getDownUrl() {
        return downUrl;
    }

    public void setDownUrl(String downUrl) {
        this.downUrl = downUrl;
    }

    public String getUpdateLog() {
        return updateLog;
    }

    public void setUpdateLog(String updateLog) {
        this.updateLog = updateLog;
    }

    public String getSize() {
        return size;
    }

    public void setSize(String size) {
        this.size = size;
    }

}
