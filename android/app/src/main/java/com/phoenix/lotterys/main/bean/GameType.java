package com.phoenix.lotterys.main.bean;

import java.io.Serializable;
import java.util.List;

/**
 * Created by Luke
 * on 2019/6/14
 */
public class GameType implements Serializable{

    /**
     * code : 0
     * data : [{"category":"lottery","categoryName":"彩票","games":[{"gameType":"cqssc","gameTypeName":"时时彩","id":"1","name":"cqssc","pic":"https://cdn01.jnmffh.com/open_prize/images/icon/1.png","title":"重庆时时彩"},{"gameType":"pk10nn","gameTypeName":"牛牛","id":"3","name":"pk10nn","pic":"https://cdn01.jnmffh.com/open_prize/images/icon/3.png","title":"PK10牛牛"},{"gameType":"jsk3","gameTypeName":"快三","id":"10","name":"jsk3","pic":"https://cdn01.jnmffh.com/open_prize/images/icon/10.png","title":"江苏骰宝(快3)"}]},{"category":"real","categoryName":"真人","games":[{"category":"real","gameCat":"ag4","gameType":"ag4","id":"59","isHot":"0","isPopup":0,"pic":"https://cdn01.jnmffh.com/images/realLogo/59.jpg","title":"AG视讯"},{"category":"real","gameCat":"AGIN3","gameType":"ag3","id":"28","isHot":"0","isPopup":0,"pic":"https://cdn01.jnmffh.com/images/realLogo/28.jpg","title":"AG视讯(旧)"},{"category":"real","gameCat":"rghj","gameType":"rghj","id":"53","isHot":"1","isPopup":0,"pic":"https://cdn01.jnmffh.com/images/realLogo/53.jpg","title":"RG皇家视讯"},{"category":"real","gameCat":"mysx","gameType":"mysx","id":"56","isHot":"0","isPopup":0,"pic":"https://cdn01.jnmffh.com/images/realLogo/56.jpg","title":"玛雅视讯"},{"category":"real","gameCat":"BBIN2","gameType":"bbin2","id":"46","isHot":"0","isPopup":0,"pic":"https://cdn01.jnmffh.com/images/realLogo/46.jpg","title":"BBIN视讯"},{"category":"real","gameCat":"bg","gameType":"bg","id":"42","isHot":"0","isPopup":0,"pic":"https://cdn01.jnmffh.com/images/realLogo/42.jpg","title":"BG视讯"},{"category":"real","gameCat":"vr","gameType":"vr","id":"14","isHot":"0","isPopup":0,"pic":"https://cdn01.jnmffh.com/images/realLogo/14.jpg","title":"VR彩票"},{"category":"real","gameCat":"lv","gameType":"lv","id":"57","isHot":"0","isPopup":0,"pic":"https://cdn01.jnmffh.com/images/realLogo/57.jpg","title":"LV美女直播"},{"category":"real","gameCat":"OG3","gameType":"ag3","id":"34","isHot":"0","isPopup":0,"pic":"https://cdn01.jnmffh.com/images/realLogo/34.jpg","title":"OG视讯(旧)"},{"category":"real","gameCat":"dgsx","gameType":"dgsx","id":"60","isHot":"0","isPopup":0,"pic":"https://cdn01.jnmffh.com/images/realLogo/60.jpg","title":"DG视讯"},{"category":"real","gameCat":"og4","gameType":"og4","id":"70","isHot":"0","isPopup":0,"pic":"https://cdn01.jnmffh.com/images/realLogo/70.jpg","title":"OG视讯"},{"category":"real","gameCat":"HG3","gameType":"ag3","id":"33","isHot":"0","isPopup":0,"pic":"https://cdn01.jnmffh.com/images/realLogo/33.jpg","title":"HG视讯"}]},{"category":"game","categoryName":"电子","games":[{"category":"game","gameCat":"ag4","gameType":"ag4","id":"62","isHot":"0","isPopup":0,"pic":"https://cdn01.jnmffh.com/images/realLogo/62.jpg","title":"AG电子"},{"category":"game","gameCat":"AGGAME2","gameType":"ag2","id":"27","isHot":"0","isPopup":0,"pic":"https://cdn01.jnmffh.com/images/realLogo/27.jpg","title":"AG电子（免换）"},{"category":"game","gameCat":"AGIN3","gameType":"ag3","id":"29","isHot":"0","isPopup":0,"pic":"https://cdn01.jnmffh.com/images/realLogo/29.jpg","title":"AG电子(旧)"},{"category":"game","gameCat":"fg","gameType":"fg","id":"52","isHot":"0","isPopup":1,"pic":"https://cdn01.jnmffh.com/images/realLogo/52.jpg","title":"FG电子"},{"category":"game","gameCat":"BBIN2","gameType":"bbin2","id":"48","isHot":"0","isPopup":0,"pic":"https://cdn01.jnmffh.com/images/realLogo/48.jpg","title":"BBIN电子"},{"category":"game","gameCat":"MG3","gameType":"ag3","id":"36","isHot":"0","isPopup":1,"pic":"https://cdn01.jnmffh.com/images/realLogo/36.jpg","title":"MG电子"},{"category":"game","gameCat":"PT3","gameType":"ag3","id":"37","isHot":"0","isPopup":1,"pic":"https://cdn01.jnmffh.com/images/realLogo/37.jpg","title":"PT电子"},{"category":"game","gameCat":"jdb","gameType":"jdb","id":"39","isHot":"0","isPopup":0,"pic":"https://cdn01.jnmffh.com/images/realLogo/39.jpg","title":"JDB电子"},{"category":"game","gameCat":"cq9","gameType":"cq9","id":"41","isHot":"0","isPopup":0,"pic":"https://cdn01.jnmffh.com/images/realLogo/41.jpg","title":"CQ9电子"},{"category":"game","gameCat":"fydj","gameType":"fydj","id":"45","isHot":"0","isPopup":0,"pic":"https://cdn01.jnmffh.com/images/realLogo/45.jpg","title":"泛亚电竞"},{"category":"game","gameCat":"dt","gameType":"dt","id":"40","isHot":"0","isPopup":1,"pic":"https://cdn01.jnmffh.com/images/realLogo/40.jpg","title":"DT电子"},{"category":"game","gameCat":"gti","gameType":"gti","id":"74","isHot":"0","isPopup":0,"pic":"https://cdn01.jnmffh.com/images/realLogo/74.jpg","title":"Gti电子"}]},{"category":"fish","categoryName":"捕鱼","games":[{"category":"fish","gameCat":"ag4","gameType":"ag4","id":"63","isHot":"1","isPopup":0,"pic":"https://cdn01.jnmffh.com/images/realLogo/63.jpg","title":"AG捕鱼"},{"category":"fish","gameCat":"cq9","gameType":"cq9","id":"65","isHot":"0","isPopup":0,"pic":"https://cdn01.jnmffh.com/images/realLogo/65.jpg","title":"CQ9"},{"category":"fish","gameCat":"jdb","gameType":"jdb","id":"66","isHot":"0","isPopup":0,"pic":"https://cdn01.jnmffh.com/images/realLogo/66.jpg","title":"JDB"},{"category":"fish","gameCat":"kxqp2","gameType":"kxqp2","id":"67","isHot":"0","isPopup":0,"pic":"https://cdn01.jnmffh.com/images/realLogo/67.jpg","title":"开心捕鱼"},{"category":"fish","gameCat":"leyou","gameType":"leyou","id":"68","isHot":"1","isPopup":0,"pic":"https://cdn01.jnmffh.com/images/realLogo/68.jpg","title":"乐游捕鱼"},{"category":"fish","gameCat":"thqp2","gameType":"thqp2","id":"69","isHot":"0","isPopup":0,"pic":"https://cdn01.jnmffh.com/images/realLogo/69.jpg","title":"天豪捕鱼"},{"category":"fish","gameCat":"AGIN3","gameType":"ag3","id":"61","isHot":"0","isPopup":0,"pic":"https://cdn01.jnmffh.com/images/realLogo/61.jpg","title":"AG捕鱼(旧)"},{"category":"fish","gameCat":"bg","gameType":"bg","id":"43","isHot":"0","isPopup":0,"pic":"https://cdn01.jnmffh.com/images/realLogo/43.jpg","title":"BG捕鱼"},{"category":"fish","gameCat":"fg","gameType":"fg","id":"54","isHot":"0","isPopup":1,"pic":"https://cdn01.jnmffh.com/images/realLogo/54.jpg","title":"FG捕鱼"},{"category":"fish","gameCat":"BBIN2","gameType":"bbin2","id":"50","isHot":"0","isPopup":0,"pic":"https://cdn01.jnmffh.com/images/realLogo/50.jpg","title":"BB捕鱼"}]},{"category":"card","categoryName":"棋牌","games":[{"category":"card","gameCat":"kyqp2","gameType":"kyqp2","id":"23","isHot":"0","isPopup":1,"pic":"https://cdn01.jnmffh.com/images/realLogo/23.jpg","title":"开元棋牌"},{"category":"card","gameCat":"kxqp2","gameType":"kxqp2","id":"26","isHot":"0","isPopup":1,"pic":"https://cdn01.jnmffh.com/images/realLogo/26.jpg","title":"开心棋牌"},{"category":"card","gameCat":"fg","gameType":"fg","id":"55","isHot":"0","isPopup":1,"pic":"https://cdn01.jnmffh.com/images/realLogo/55.jpg","title":"FG棋牌"},{"category":"card","gameCat":"thqp2","gameType":"thqp2","id":"44","isHot":"0","isPopup":0,"pic":"https://cdn01.jnmffh.com/images/realLogo/44.jpg","title":"天豪棋牌"},{"category":"card","gameCat":"xyqp","gameType":"xyqp","id":"51","isHot":"0","isPopup":0,"pic":"https://cdn01.jnmffh.com/images/realLogo/51.jpg","title":"幸运棋牌"},{"category":"card","gameCat":"leyou","gameType":"leyou","id":"19","isHot":"0","isPopup":1,"pic":"https://cdn01.jnmffh.com/images/realLogo/19.jpg","title":"乐游棋牌"},{"category":"card","gameCat":"hlqp","gameType":"hlqp","id":"71","isHot":"0","isPopup":0,"pic":"https://cdn01.jnmffh.com/images/realLogo/71.jpg","title":"欢乐棋牌"}]},{"category":"sport","categoryName":"体育","games":[{"category":"sport","gameCat":"SHABA3","gameType":"ag3","id":"35","isHot":"0","isPopup":0,"pic":"https://cdn01.jnmffh.com/images/realLogo/35.jpg","title":"沙巴体育"},{"category":"sport","gameCat":"ag4","gameType":"ag4","id":"64","isHot":"0","isPopup":0,"pic":"https://cdn01.jnmffh.com/images/realLogo/64.jpg","title":"AG体育"},{"category":"sport","gameCat":"AGIN3","gameType":"ag3","id":"38","isHot":"0","isPopup":0,"pic":"https://cdn01.jnmffh.com/images/realLogo/38.jpg","title":"AG体育(旧)"},{"category":"sport","gameCat":"BBIN2","gameType":"bbin2","id":"47","isHot":"0","isPopup":0,"pic":"https://cdn01.jnmffh.com/images/realLogo/47.jpg","title":"BBIN体育"}]}]
     * info : {"runtime":"17.67 ms","sqlList":["主库(5303)：SELECT id, name, title, from_type FROM `ssc_type` WHERE  `isHot` = :isHot  AND enable=1 AND isDelete=0 AND isInstant=0 AND name != 'ugcs'  AND name != 'kxcs' ORDER BY sort ASC, id ASC LIMIT 15  --Spent：0.48 ms","主库(5303)：SELECT id, name FROM `ssc_type`  ORDER BY sort ASC  --Spent：0.18 ms","主库(5303)：SELECT id, category, name as title, game_type as gameType, game_cat as gameCat, is_hot as isHot FROM `ssc_real` WHERE enable=1 AND pc=1 ORDER BY sort ASC, id ASC  --Spent：0.33 ms"],"sqlTotalNum":3,"sqlTotalTime":"0.99 ms","traceBack":{"access":"14.22 ms","initDi":"7.43 ms","loader":"1.07 ms"}}
     * msg : 获取首页推荐游戏成功
     */
//    private static final long serialVersionUID = -7060210544600464481L;
    private int code;
    private InfoBean info;
    private String msg;
    private List<DataBean> data;

    @Override
    public String toString() {
        return "GameType{" +
                "code=" + code +
                ", info=" + info +
                ", msg='" + msg + '\'' +
                ", data=" + data +
                '}';
    }

    public int getCode() {
        return code;
    }

    public void setCode(int code) {
        this.code = code;
    }

    public InfoBean getInfo() {
        return info;
    }

    public void setInfo(InfoBean info) {
        this.info = info;
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

    public static class InfoBean {
        /**
         * runtime : 17.67 ms
         * sqlList : ["主库(5303)：SELECT id, name, title, from_type FROM `ssc_type` WHERE  `isHot` = :isHot  AND enable=1 AND isDelete=0 AND isInstant=0 AND name != 'ugcs'  AND name != 'kxcs' ORDER BY sort ASC, id ASC LIMIT 15  --Spent：0.48 ms","主库(5303)：SELECT id, name FROM `ssc_type`  ORDER BY sort ASC  --Spent：0.18 ms","主库(5303)：SELECT id, category, name as title, game_type as gameType, game_cat as gameCat, is_hot as isHot FROM `ssc_real` WHERE enable=1 AND pc=1 ORDER BY sort ASC, id ASC  --Spent：0.33 ms"]
         * sqlTotalNum : 3
         * sqlTotalTime : 0.99 ms
         * traceBack : {"access":"14.22 ms","initDi":"7.43 ms","loader":"1.07 ms"}
         */

        private String runtime;
        private int sqlTotalNum;
        private String sqlTotalTime;
        private TraceBackBean traceBack;
        private List<String> sqlList;

        public String getRuntime() {
            return runtime;
        }

        public void setRuntime(String runtime) {
            this.runtime = runtime;
        }

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

        public TraceBackBean getTraceBack() {
            return traceBack;
        }

        public void setTraceBack(TraceBackBean traceBack) {
            this.traceBack = traceBack;
        }

        public List<String> getSqlList() {
            return sqlList;
        }

        public void setSqlList(List<String> sqlList) {
            this.sqlList = sqlList;
        }

        public static class TraceBackBean {
            /**
             * access : 14.22 ms
             * initDi : 7.43 ms
             * loader : 1.07 ms
             */

            private String access;
            private String initDi;
            private String loader;

            public String getAccess() {
                return access;
            }

            public void setAccess(String access) {
                this.access = access;
            }

            public String getInitDi() {
                return initDi;
            }

            public void setInitDi(String initDi) {
                this.initDi = initDi;
            }

            public String getLoader() {
                return loader;
            }

            public void setLoader(String loader) {
                this.loader = loader;
            }
        }
    }

    public static class DataBean implements Serializable{
        /**
         * category : lottery
         * categoryName : 彩票
         * games : [{"gameType":"cqssc","gameTypeName":"时时彩","id":"1","name":"cqssc","pic":"https://cdn01.jnmffh.com/open_prize/images/icon/1.png","title":"重庆时时彩"},{"gameType":"pk10nn","gameTypeName":"牛牛","id":"3","name":"pk10nn","pic":"https://cdn01.jnmffh.com/open_prize/images/icon/3.png","title":"PK10牛牛"},{"gameType":"jsk3","gameTypeName":"快三","id":"10","name":"jsk3","pic":"https://cdn01.jnmffh.com/open_prize/images/icon/10.png","title":"江苏骰宝(快3)"}]
         */

        private String category;
        private String categoryName;
        private List<GamesBean> games;

        @Override
        public String toString() {
            return "DataBean{" +
                    "category='" + category + '\'' +
                    ", categoryName='" + categoryName + '\'' +
                    ", games=" + games +
                    '}';
        }

        public String getCategory() {
            return category;
        }

        public void setCategory(String category) {
            this.category = category;
        }

        public String getCategoryName() {
            return categoryName;
        }

        public void setCategoryName(String categoryName) {
            this.categoryName = categoryName;
        }

        public List<GamesBean> getGames() {
            return games;
        }

        public void setGames(List<GamesBean> games) {
            this.games = games;
        }

        public static class GamesBean implements Serializable{
            @Override
            public String toString() {
                return "GamesBean{" +
                        "gameType='" + gameType + '\'' +
                        ", gameTypeName='" + gameTypeName + '\'' +
                        ", id='" + id + '\'' +
                        ", name='" + name + '\'' +
                        ", pic='" + pic + '\'' +
                        ", title='" + title + '\'' +
                        ", isInstant='" + isInstant + '\'' +
                        ", category='" + category + '\'' +
                        ", gameCat='" + gameCat + '\'' +
                        ", isHot='" + isHot + '\'' +
                        ", supportTrial='" + supportTrial + '\'' +
                        ", isPopup=" + isPopup +
                        ", isSeal=" + isSeal +
                        '}';
            }

            /**
             * gameType : cqssc
             * gameTypeName : 时时彩
             * id : 1
             * name : cqssc
             * pic : https://cdn01.jnmffh.com/open_prize/images/icon/1.png
             * title : 重庆时时彩
             */

            private String gameType;
            private String gameTypeName;
            private String id;
            private String name;
            private String pic;
            private String title;
            private String isInstant;
            private String category;
            private String gameCat;
            private String isHot;
            private String supportTrial;
            private int isPopup;
            private int isSeal;

            public String getIsInstant() {
                return isInstant;
            }

            public void setIsInstant(String isInstant) {
                this.isInstant = isInstant;
            }

            public String getSupportTrial() {
                return supportTrial;
            }

            public void setSupportTrial(String supportTrial) {
                this.supportTrial = supportTrial;
            }

            public int getIsSeal() {
                return isSeal;
            }

            public void setIsSeal(int isSeal) {
                this.isSeal = isSeal;
            }

            public String getCategory() {
                return category;
            }

            public void setCategory(String category) {
                this.category = category;
            }

            public String getGameCat() {
                return gameCat;
            }

            public void setGameCat(String gameCat) {
                this.gameCat = gameCat;
            }

            public String getIsHot() {
                return isHot;
            }

            public void setIsHot(String isHot) {
                this.isHot = isHot;
            }

            public int getIsPopup() {
                return isPopup;
            }

            public void setIsPopup(int isPopup) {
                this.isPopup = isPopup;
            }

            public String getGameType() {
                return gameType;
            }

            public void setGameType(String gameType) {
                this.gameType = gameType;
            }

            public String getGameTypeName() {
                return gameTypeName;
            }

            public void setGameTypeName(String gameTypeName) {
                this.gameTypeName = gameTypeName;
            }

            public String getId() {
                return id;
            }

            public void setId(String id) {
                this.id = id;
            }

            public String getName() {
                return name;
            }

            public void setName(String name) {
                this.name = name;
            }

            public String getPic() {
                return pic;
            }

            public void setPic(String pic) {
                this.pic = pic;
            }

            public String getTitle() {
                return title;
            }

            public void setTitle(String title) {
                this.title = title;
            }
        }
    }
}
