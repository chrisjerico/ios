package com.phoenix.lotterys.main.bean;

import java.util.List;

/**
 * Greated by Luke
 * on 2019/9/10
 */
public class GameTypeBean {

    /**
     * alias : navigation
     * list : [{"docType":0,"gameId":4,"icon":"https://cdn01.buygoode.net/upload/t010/customise/picture/system/mobileIcon/f6548972ad9d20f0161835c37a45bc7a.jpeg","id":"73","levelType":"1","logo":"https://cdn01.buygoode.net/upload/t010/customise/picture/system/mobileIcon/f6548972ad9d20f0161835c37a45bc7a.jpeg","name":"","openWay":"0","seriesId":"7","sort":"0","subId":4,"tipFlag":"0","title":"在线客服","url":""},{"docType":0,"gameId":"20000","icon":"https://cdn01.buygoode.net/upload/t010/customise/picture/system/mobileIcon/7117b8aae3562734e4dc816b6617d0dd.jpeg","id":"74","levelType":"1","logo":"https://cdn01.buygoode.net/upload/t010/customise/picture/system/mobileIcon/7117b8aae3562734e4dc816b6617d0dd.jpeg","name":"2222222222","openWay":"0","seriesId":"7","sort":"0","subId":"20000","tipFlag":"0","title":"2222222222","url":"www.baidu.com"},{"docType":0,"gameId":2,"icon":"https://cdn01.buygoode.net/upload/t010/customise/picture/system/mobileIcon/73175be27a200e79d553a94de049e56d.jpeg","id":"75","levelType":"1","logo":"https://cdn01.buygoode.net/upload/t010/customise/picture/system/mobileIcon/73175be27a200e79d553a94de049e56d.jpeg","name":"111111111111","openWay":"0","seriesId":"7","sort":"0","subId":2,"tipFlag":"0","title":"APP下载","url":""}]
     * title : 导航
     */

    private String alias;
    private String title;
    private List<ListBean> list;

    public String getAlias() {
        return alias;
    }

    public void setAlias(String alias) {
        this.alias = alias;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public List<ListBean> getList() {
        return list;
    }

    public void setList(List<ListBean> list) {
        this.list = list;
    }

    public static class ListBean {
        @Override
        public String toString() {
            return "ListBean{" +
                    "docType=" + docType +
                    ", gameId=" + gameId +
                    ", icon='" + icon + '\'' +
                    ", id='" + id + '\'' +
                    ", levelType='" + levelType + '\'' +
                    ", logo='" + logo + '\'' +
                    ", name='" + name + '\'' +
                    ", openWay='" + openWay + '\'' +
                    ", seriesId='" + seriesId + '\'' +
                    ", sort='" + sort + '\'' +
                    ", subId=" + subId +
                    ", tipFlag='" + tipFlag + '\'' +
                    ", title='" + title + '\'' +
                    ", url='" + url + '\'' +
                    ", subType=" + subType +
                    '}';
        }

        /**
         * docType : 0
         * gameId : 4
         * icon : https://cdn01.buygoode.net/upload/t010/customise/picture/system/mobileIcon/f6548972ad9d20f0161835c37a45bc7a.jpeg
         * id : 73
         * levelType : 1
         * logo : https://cdn01.buygoode.net/upload/t010/customise/picture/system/mobileIcon/f6548972ad9d20f0161835c37a45bc7a.jpeg
         * name :
         * openWay : 0
         * seriesId : 7
         * sort : 0
         * subId : 4
         * tipFlag : 0
         * title : 在线客服
         * url :
         */

        private String docType;
        private String gameId;
        private String icon;
        private String id;
        private String levelType;
        private String logo;
        private String name;
        private String openWay;
        private String seriesId;
        private String sort;
        private String subId;
        private String tipFlag;
        private String title;
        private String url;
        private String isInstant;
        private String gameType;
        private String type;
        private int isPopup;
        private int supportTrial;
        boolean isSelect;

        public String getType() {
            return type;
        }

        public void setType(String type) {
            this.type = type;
        }

        public int getSupportTrial() {
            return supportTrial;
        }

        public void setSupportTrial(int supportTrial) {
            this.supportTrial = supportTrial;
        }

        public int getIsPopup() {
            return isPopup;
        }

        public void setIsPopup(int isPopup) {
            this.isPopup = isPopup;
        }

        public String getDocType() {
            return docType;
        }

        public void setDocType(String docType) {
            this.docType = docType;
        }

        public String getGameId() {
            return gameId;
        }

        public void setGameId(String gameId) {
            this.gameId = gameId;
        }

        public String getSubId() {
            return subId;
        }

        public void setSubId(String subId) {
            this.subId = subId;
        }

        public boolean isSelect() {
            return isSelect;
        }

        public void setSelect(boolean select) {
            isSelect = select;
        }

        public String getIsInstant() {
            return isInstant;
        }

        public void setIsInstant(String isInstant) {
            this.isInstant = isInstant;
        }

        public String getGameType() {
            return gameType;
        }

        public void setGameType(String gameType) {
            this.gameType = gameType;
        }

        private List<subTypeBean> subType;

        public List<subTypeBean> getSubType() {
            return subType;
        }

        public void setSubType(List<subTypeBean> subType) {
            this.subType = subType;
        }

        public static class subTypeBean {
            @Override
            public String toString() {
                return "subTypeBean{" +
                        "docType=" + docType +
                        ", gameId=" + gameId +
                        ", icon='" + icon + '\'' +
                        ", id='" + id + '\'' +
                        ", levelType='" + levelType + '\'' +
                        ", logo='" + logo + '\'' +
                        ", name='" + name + '\'' +
                        ", openWay='" + openWay + '\'' +
                        ", seriesId='" + seriesId + '\'' +
                        ", sort='" + sort + '\'' +
                        ", subId=" + subId +
                        ", tipFlag='" + tipFlag + '\'' +
                        ", title='" + title + '\'' +
                        ", url='" + url + '\'' +
                        '}';
            }

            /**
             * docType : 0
             * gameId : 4
             * icon : https://cdn01.buygoode.net/upload/t010/customise/picture/system/mobileIcon/f6548972ad9d20f0161835c37a45bc7a.jpeg
             * id : 73
             * levelType : 1
             * logo : https://cdn01.buygoode.net/upload/t010/customise/picture/system/mobileIcon/f6548972ad9d20f0161835c37a45bc7a.jpeg
             * name :
             * openWay : 0
             * seriesId : 7
             * sort : 0
             * subId : 4
             * tipFlag : 0
             * title : 在线客服
             * url :
             */

            private String docType;
            private String gameId;
            private String icon;
            private String id;
            private String levelType;
            private String logo;
            private String name;
            private String openWay;
            private String seriesId;
            private String sort;
            private String subId;
            private String tipFlag;
            private String title;
            private String url;
            private int isPopup;
            private int supportTrial;
            private String isInstant;
            private String gameType;

            public String getIsInstant() {
                return isInstant;
            }

            public void setIsInstant(String isInstant) {
                this.isInstant = isInstant;
            }

            public String getGameType() {
                return gameType;
            }

            public void setGameType(String gameType) {
                this.gameType = gameType;
            }

            public int getSupportTrial() {
                return supportTrial;
            }

            public void setSupportTrial(int supportTrial) {
                this.supportTrial = supportTrial;
            }

            public int getIsPopup() {
                return isPopup;
            }

            public void setIsPopup(int isPopup) {
                this.isPopup = isPopup;
            }

            public String getDocType() {
                return docType;
            }

            public void setDocType(String docType) {
                this.docType = docType;
            }

            public String getGameId() {
                return gameId;
            }

            public void setGameId(String gameId) {
                this.gameId = gameId;
            }

            public String getSubId() {
                return subId;
            }

            public void setSubId(String subId) {
                this.subId = subId;
            }

            public String getIcon() {
                return icon;
            }

            public void setIcon(String icon) {
                this.icon = icon;
            }

            public String getId() {
                return id;
            }

            public void setId(String id) {
                this.id = id;
            }

            public String getLevelType() {
                return levelType;
            }

            public void setLevelType(String levelType) {
                this.levelType = levelType;
            }

            public String getLogo() {
                return logo;
            }

            public void setLogo(String logo) {
                this.logo = logo;
            }

            public String getName() {
                return name;
            }

            public void setName(String name) {
                this.name = name;
            }

            public String getOpenWay() {
                return openWay;
            }

            public void setOpenWay(String openWay) {
                this.openWay = openWay;
            }

            public String getSeriesId() {
                return seriesId;
            }

            public void setSeriesId(String seriesId) {
                this.seriesId = seriesId;
            }

            public String getSort() {
                return sort;
            }

            public void setSort(String sort) {
                this.sort = sort;
            }

            public String getTipFlag() {
                return tipFlag;
            }

            public void setTipFlag(String tipFlag) {
                this.tipFlag = tipFlag;
            }

            public String getTitle() {
                return title;
            }

            public void setTitle(String title) {
                this.title = title;
            }

            public String getUrl() {
                return url;
            }

            public void setUrl(String url) {
                this.url = url;
            }
        }

        public String getIcon() {
            return icon;
        }

        public void setIcon(String icon) {
            this.icon = icon;
        }

        public String getId() {
            return id;
        }

        public void setId(String id) {
            this.id = id;
        }

        public String getLevelType() {
            return levelType;
        }

        public void setLevelType(String levelType) {
            this.levelType = levelType;
        }

        public String getLogo() {
            return logo;
        }

        public void setLogo(String logo) {
            this.logo = logo;
        }

        public String getName() {
            return name;
        }

        public void setName(String name) {
            this.name = name;
        }

        public String getOpenWay() {
            return openWay;
        }

        public void setOpenWay(String openWay) {
            this.openWay = openWay;
        }

        public String getSeriesId() {
            return seriesId;
        }

        public void setSeriesId(String seriesId) {
            this.seriesId = seriesId;
        }

        public String getSort() {
            return sort;
        }

        public void setSort(String sort) {
            this.sort = sort;
        }

        public String getTipFlag() {
            return tipFlag;
        }

        public void setTipFlag(String tipFlag) {
            this.tipFlag = tipFlag;
        }

        public String getTitle() {
            return title;
        }

        public void setTitle(String title) {
            this.title = title;
        }

        public String getUrl() {
            return url;
        }

        public void setUrl(String url) {
            this.url = url;
        }
    }


}
