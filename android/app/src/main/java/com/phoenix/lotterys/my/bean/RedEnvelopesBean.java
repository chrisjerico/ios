package com.phoenix.lotterys.my.bean;

import java.io.Serializable;
import java.util.List;

/**
 * 文件描述:
 * 创建者: IAN
 * 创建时间: 2019/7/11 12:24
 */
public class RedEnvelopesBean implements Serializable {

    /**
     * code : 0
     * msg : success
     * data : {"list":[{"id":"6772","uid":"4159","createTime":"1581313623","redBagId":"2159","genre":"2","operate":"3","amount":"53.30","genreText":"扫雷红包","operateText":"过期"},{"id":"6770","uid":"4159","createTime":"1581313510","redBagId":"2159","genre":"2","operate":"2","amount":"24.66","genreText":"扫雷红包","operateText":"抢红包"},{"id":"6768","uid":"4159","createTime":"1581313502","redBagId":"2159","genre":"2","operate":"1","amount":"100.00","genreText":"扫雷红包","operateText":"发送红包"},{"id":"6767","uid":"4159","createTime":"1581313413","redBagId":"2158","genre":"2","operate":"5","amount":"100.00","genreText":"扫雷红包","operateText":"获得赔付"},{"id":"6766","uid":"4159","createTime":"1581313413","redBagId":"2158","genre":"2","operate":"4","amount":"100.00","genreText":"扫雷红包","operateText":"踩雷赔付"},{"id":"6765","uid":"4159","createTime":"1581313413","redBagId":"2158","genre":"2","operate":"2","amount":"4.91","genreText":"扫雷红包","operateText":"抢红包"},{"id":"6762","uid":"4159","createTime":"1581313408","redBagId":"2158","genre":"2","operate":"1","amount":"50.00","genreText":"扫雷红包","operateText":"发送红包"},{"id":"6747","uid":"4159","createTime":"1581091220","redBagId":"2151","genre":"2","operate":"1","amount":"20.00","genreText":"扫雷红包","operateText":"发送红包"},{"id":"6745","uid":"4159","createTime":"1581087091","redBagId":"2149","genre":"2","operate":"1","amount":"20.00","genreText":"扫雷红包","operateText":"发送红包"},{"id":"6742","uid":"4159","createTime":"1581087023","redBagId":"2145","genre":"2","operate":"3","amount":"20.00","genreText":"扫雷红包","operateText":"过期"},{"id":"6741","uid":"4159","createTime":"1581087017","redBagId":"2147","genre":"2","operate":"1","amount":"20.00","genreText":"扫雷红包","operateText":"发送红包"},{"id":"6739","uid":"4159","createTime":"1581086952","redBagId":"2145","genre":"2","operate":"1","amount":"20.00","genreText":"扫雷红包","operateText":"发送红包"},{"id":"6737","uid":"4159","createTime":"1581084032","redBagId":"2143","genre":"2","operate":"5","amount":"39.60","genreText":"扫雷红包","operateText":"获得赔付"},{"id":"6736","uid":"4159","createTime":"1581084032","redBagId":"2143","genre":"2","operate":"4","amount":"39.60","genreText":"扫雷红包","operateText":"踩雷赔付"},{"id":"6735","uid":"4159","createTime":"1581084032","redBagId":"2143","genre":"2","operate":"2","amount":"3.21","genreText":"扫雷红包","operateText":"抢红包"},{"id":"6733","uid":"4159","createTime":"1581084030","redBagId":"2143","genre":"2","operate":"1","amount":"20.00","genreText":"扫雷红包","operateText":"发送红包"},{"id":"6715","uid":"4159","createTime":"1580818929","redBagId":"2135","genre":"2","operate":"3","amount":"6.71","genreText":"扫雷红包","operateText":"过期"},{"id":"6712","uid":"4159","createTime":"1580818929","redBagId":"2133","genre":"2","operate":"3","amount":"11.42","genreText":"扫雷红包","operateText":"过期"},{"id":"6707","uid":"4159","createTime":"1580818929","redBagId":"2130","genre":"2","operate":"3","amount":"9.31","genreText":"扫雷红包","operateText":"过期"},{"id":"6705","uid":"4159","createTime":"1580818929","redBagId":"2128","genre":"2","operate":"3","amount":"22.81","genreText":"扫雷红包","operateText":"过期"}],"total":147}
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
         * list : [{"id":"6772","uid":"4159","createTime":"1581313623","redBagId":"2159","genre":"2","operate":"3","amount":"53.30","genreText":"扫雷红包","operateText":"过期"},{"id":"6770","uid":"4159","createTime":"1581313510","redBagId":"2159","genre":"2","operate":"2","amount":"24.66","genreText":"扫雷红包","operateText":"抢红包"},{"id":"6768","uid":"4159","createTime":"1581313502","redBagId":"2159","genre":"2","operate":"1","amount":"100.00","genreText":"扫雷红包","operateText":"发送红包"},{"id":"6767","uid":"4159","createTime":"1581313413","redBagId":"2158","genre":"2","operate":"5","amount":"100.00","genreText":"扫雷红包","operateText":"获得赔付"},{"id":"6766","uid":"4159","createTime":"1581313413","redBagId":"2158","genre":"2","operate":"4","amount":"100.00","genreText":"扫雷红包","operateText":"踩雷赔付"},{"id":"6765","uid":"4159","createTime":"1581313413","redBagId":"2158","genre":"2","operate":"2","amount":"4.91","genreText":"扫雷红包","operateText":"抢红包"},{"id":"6762","uid":"4159","createTime":"1581313408","redBagId":"2158","genre":"2","operate":"1","amount":"50.00","genreText":"扫雷红包","operateText":"发送红包"},{"id":"6747","uid":"4159","createTime":"1581091220","redBagId":"2151","genre":"2","operate":"1","amount":"20.00","genreText":"扫雷红包","operateText":"发送红包"},{"id":"6745","uid":"4159","createTime":"1581087091","redBagId":"2149","genre":"2","operate":"1","amount":"20.00","genreText":"扫雷红包","operateText":"发送红包"},{"id":"6742","uid":"4159","createTime":"1581087023","redBagId":"2145","genre":"2","operate":"3","amount":"20.00","genreText":"扫雷红包","operateText":"过期"},{"id":"6741","uid":"4159","createTime":"1581087017","redBagId":"2147","genre":"2","operate":"1","amount":"20.00","genreText":"扫雷红包","operateText":"发送红包"},{"id":"6739","uid":"4159","createTime":"1581086952","redBagId":"2145","genre":"2","operate":"1","amount":"20.00","genreText":"扫雷红包","operateText":"发送红包"},{"id":"6737","uid":"4159","createTime":"1581084032","redBagId":"2143","genre":"2","operate":"5","amount":"39.60","genreText":"扫雷红包","operateText":"获得赔付"},{"id":"6736","uid":"4159","createTime":"1581084032","redBagId":"2143","genre":"2","operate":"4","amount":"39.60","genreText":"扫雷红包","operateText":"踩雷赔付"},{"id":"6735","uid":"4159","createTime":"1581084032","redBagId":"2143","genre":"2","operate":"2","amount":"3.21","genreText":"扫雷红包","operateText":"抢红包"},{"id":"6733","uid":"4159","createTime":"1581084030","redBagId":"2143","genre":"2","operate":"1","amount":"20.00","genreText":"扫雷红包","operateText":"发送红包"},{"id":"6715","uid":"4159","createTime":"1580818929","redBagId":"2135","genre":"2","operate":"3","amount":"6.71","genreText":"扫雷红包","operateText":"过期"},{"id":"6712","uid":"4159","createTime":"1580818929","redBagId":"2133","genre":"2","operate":"3","amount":"11.42","genreText":"扫雷红包","operateText":"过期"},{"id":"6707","uid":"4159","createTime":"1580818929","redBagId":"2130","genre":"2","operate":"3","amount":"9.31","genreText":"扫雷红包","operateText":"过期"},{"id":"6705","uid":"4159","createTime":"1580818929","redBagId":"2128","genre":"2","operate":"3","amount":"22.81","genreText":"扫雷红包","operateText":"过期"}]
         * total : 147
         */

        private int total;
        private List<ListBean> list;

        public int getTotal() {
            return total;
        }

        public void setTotal(int total) {
            this.total = total;
        }

        public List<ListBean> getList() {
            return list;
        }

        public void setList(List<ListBean> list) {
            this.list = list;
        }

        public static class ListBean {
            /**
             * id : 6772
             * uid : 4159
             * createTime : 1581313623
             * redBagId : 2159
             * genre : 2
             * operate : 3
             * amount : 53.30
             * genreText : 扫雷红包
             * operateText : 过期
             */

            private String id;
            private String uid;
            private Long createTime;
            private String redBagId;
            private String genre;
            private String operate;//1发红包，2抢红包，3过期退回，4踩雷，5赔付
            private String amount;
            private String genreText; //扫雷红包
            private String operateText; //过期

            public String getId() {
                return id;
            }

            public void setId(String id) {
                this.id = id;
            }

            public String getUid() {
                return uid;
            }

            public void setUid(String uid) {
                this.uid = uid;
            }

            public Long getCreateTime() {
                return createTime;
            }

            public void setCreateTime(Long createTime) {
                this.createTime = createTime;
            }

            public String getRedBagId() {
                return redBagId;
            }

            public void setRedBagId(String redBagId) {
                this.redBagId = redBagId;
            }

            public String getGenre() {
                return genre;
            }

            public void setGenre(String genre) {
                this.genre = genre;
            }

            public String getOperate() {
                return operate;
            }

            public void setOperate(String operate) {
                this.operate = operate;
            }

            public String getAmount() {
                return amount;
            }

            public void setAmount(String amount) {
                this.amount = amount;
            }

            public String getGenreText() {
                return genreText;
            }

            public void setGenreText(String genreText) {
                this.genreText = genreText;
            }

            public String getOperateText() {
                return operateText;
            }

            public void setOperateText(String operateText) {
                this.operateText = operateText;
            }
        }
    }
}
