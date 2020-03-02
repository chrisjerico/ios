package com.phoenix.lotterys.my.bean;

import java.util.List;

/**
 * Created by Luke
 * on 2019/6/29
 */
public class WalletBean {


    /**
     * code : 0
     * data : [{"category":"real","gameCat":"ag4","gameSymbol":"agsx4","gameType":"ag4","id":"59","isHot":"0","isPopup":0,"pic":"https://cdn01.jnmffh.com/images/realLogo/59.jpg","title":"AG视讯"},{"category":"real","gameCat":"rghj","gameSymbol":"rghj","gameType":"rghj","id":"53","isHot":"1","isPopup":0,"pic":"https://cdn01.jnmffh.com/images/realLogo/53.jpg","title":"RG皇家视讯"},{"category":"real","gameCat":"mysx","gameSymbol":"mysx","gameType":"mysx","id":"56","isHot":"0","isPopup":0,"pic":"https://cdn01.jnmffh.com/images/realLogo/56.jpg","title":"玛雅视讯"},{"category":"real","gameCat":"BBIN2","gameSymbol":"bbin2_real","gameType":"bbin2","id":"46","isHot":"0","isPopup":0,"pic":"https://cdn01.jnmffh.com/images/realLogo/46.jpg","title":"BBIN视讯"},{"category":"real","gameCat":"bg","gameSymbol":"bg","gameType":"bg","id":"42","isHot":"0","isPopup":0,"pic":"https://cdn01.jnmffh.com/images/realLogo/42.jpg","title":"BG视讯"},{"category":"real","gameCat":"ebet","gameSymbol":"ebet","gameType":"ebet","id":"75","isHot":"0","isPopup":0,"pic":"https://cdn01.jnmffh.com/images/realLogo/75.jpg","title":"eBET视讯"},{"category":"real","gameCat":"n2live","gameSymbol":"real_n2live","gameType":"n2live","id":"78","isHot":"0","isPopup":0,"pic":"https://cdn01.jnmffh.com/images/realLogo/78.jpg","title":"n2-live视讯"},{"category":"real","gameCat":"vr","gameSymbol":"VR","gameType":"vr","id":"14","isHot":"0","isPopup":0,"pic":"https://cdn01.jnmffh.com/images/realLogo/14.jpg","title":"VR彩票"},{"category":"real","gameCat":"OG3","gameSymbol":"OG3","gameType":"ag3","id":"34","isHot":"0","isPopup":0,"pic":"https://cdn01.jnmffh.com/images/realLogo/34.jpg","title":"OG视讯(旧)"},{"category":"real","gameCat":"dgsx","gameSymbol":"dgsx","gameType":"dgsx","id":"60","isHot":"0","isPopup":0,"pic":"https://cdn01.jnmffh.com/images/realLogo/60.jpg","title":"DG视讯"},{"category":"real","gameCat":"og4","gameSymbol":"og4","gameType":"og4","id":"70","isHot":"0","isPopup":0,"pic":"https://cdn01.jnmffh.com/images/realLogo/70.jpg","title":"OG视讯"},{"category":"real","gameCat":"hg4","gameSymbol":"hg4","gameType":"hg4","id":"72","isHot":"0","isPopup":0,"pic":"https://cdn01.jnmffh.com/images/realLogo/72.jpg","title":"HG视讯"},{"category":"real","gameCat":"HG3","gameSymbol":"HG3","gameType":"ag3","id":"33","isHot":"0","isPopup":0,"pic":"https://cdn01.jnmffh.com/images/realLogo/33.jpg","title":"HG视讯"}]
     * info : {"runtime":"57.81 ms","sqlList":["主库(5303)：SELECT id, name, title, value FROM `ssc_params`   --Spent：0.71 ms","主库(5303)：SELECT * FROM `ssc_blacklist` WHERE  `type` = :type   --Spent：0.30 ms","主库(5303)：SELECT * FROM `ssc_cache`  WHERE `name` = 'block_country'    --Spent：0.18 ms","主库(5303)：SELECT id, category, name as title, game_type as gameType, game_cat as gameCat, game_code as isPopup, is_hot as isHot, game_symbol as gameSymbol FROM `ssc_real` WHERE  `enable` = :enable AND `pc` = :pc  ORDER BY sort ASC, id ASC  --Spent：0.78 ms","主库(5303)：SELECT name FROM `ssc_upload` WHERE name LIKE '%real_mobile_%' AND last_update > 0 ORDER BY name ASC  --Spent：0.36 ms"],"sqlTotalNum":5,"sqlTotalTime":"2.33 ms","traceBack":{"access":"51.04 ms","initDi":"11.57 ms","loader":"1.52 ms","settings":"43.76 ms"}}
     * msg : 获取真人游戏列表成功
     */

    private int code;
    private String msg;
    private String title;
    private List<DataBean> data;

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

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
         * category : real
         * gameCat : ag4
         * gameSymbol : agsx4
         * gameType : ag4
         * id : 59
         * isHot : 0
         * isPopup : 0
         * pic : https://cdn01.jnmffh.com/images/realLogo/59.jpg
         * title : AG视讯
         */
        public  DataBean(String title,String id){
            this.title= title;
            this.id= id;
        }
        private String category;
        private String gameCat;
        private String gameSymbol;
        private String gameType;
        private String id;
        private String isHot;
        private int isPopup;
        private String pic;
        private String title;
        private String balance;

        public String getBalance() {
            return balance;
        }

        public void setBalance(String balance) {
            this.balance = balance;
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

        public String getGameSymbol() {
            return gameSymbol;
        }

        public void setGameSymbol(String gameSymbol) {
            this.gameSymbol = gameSymbol;
        }

        public String getGameType() {
            return gameType;
        }

        public void setGameType(String gameType) {
            this.gameType = gameType;
        }

        public String getId() {
            return id;
        }

        public void setId(String id) {
            this.id = id;
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
