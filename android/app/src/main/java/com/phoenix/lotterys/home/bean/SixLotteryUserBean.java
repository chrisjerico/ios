package com.phoenix.lotterys.home.bean;

/**
 * Greated by Luke
 * on 2019/12/4
 */
public class SixLotteryUserBean {


    /**
     * code : 0
     * msg : 获取用户信息成功
     * data : {"followNum":0,"favContentNum":0,"nickname":"管理员","face":"https://cdn01.nadekouqiang.com/images/icon_0.png","isLhcdocVip":0,"missionLevel":"铂金会员","levelName":"VIP4","contentNum":276,"fansNum":3,"isFollow":1,"likeNum":7}
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
         * followNum : 0
         * favContentNum : 0
         * nickname : 管理员
         * face : https://cdn01.nadekouqiang.com/images/icon_0.png
         * isLhcdocVip : 0
         * missionLevel : 铂金会员
         * levelName : VIP4
         * contentNum : 276
         * fansNum : 3
         * isFollow : 1
         * likeNum : 7
         */

        private int followNum;
        private int favContentNum;
        private String nickname;
        private String face;
        private int isLhcdocVip;
        private String missionLevel;
        private String levelName;
        private int contentNum;
        private int fansNum;
        private int isFollow;
        private int likeNum;

        public int getFollowNum() {
            return followNum;
        }

        public void setFollowNum(int followNum) {
            this.followNum = followNum;
        }

        public int getFavContentNum() {
            return favContentNum;
        }

        public void setFavContentNum(int favContentNum) {
            this.favContentNum = favContentNum;
        }

        public String getNickname() {
            return nickname;
        }

        public void setNickname(String nickname) {
            this.nickname = nickname;
        }

        public String getFace() {
            return face;
        }

        public void setFace(String face) {
            this.face = face;
        }

        public int getIsLhcdocVip() {
            return isLhcdocVip;
        }

        public void setIsLhcdocVip(int isLhcdocVip) {
            this.isLhcdocVip = isLhcdocVip;
        }

        public String getMissionLevel() {
            return missionLevel;
        }

        public void setMissionLevel(String missionLevel) {
            this.missionLevel = missionLevel;
        }

        public String getLevelName() {
            return levelName;
        }

        public void setLevelName(String levelName) {
            this.levelName = levelName;
        }

        public int getContentNum() {
            return contentNum;
        }

        public void setContentNum(int contentNum) {
            this.contentNum = contentNum;
        }

        public int getFansNum() {
            return fansNum;
        }

        public void setFansNum(int fansNum) {
            this.fansNum = fansNum;
        }

        public int getIsFollow() {
            return isFollow;
        }

        public void setIsFollow(int isFollow) {
            this.isFollow = isFollow;
        }

        public int getLikeNum() {
            return likeNum;
        }

        public void setLikeNum(int likeNum) {
            this.likeNum = likeNum;
        }
    }
}
