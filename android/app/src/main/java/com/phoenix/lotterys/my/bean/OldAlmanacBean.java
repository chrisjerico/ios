package com.phoenix.lotterys.my.bean;

import java.io.Serializable;

/**
 * 文件描述:
 * 创建者: IAN
 * 创建时间: 2019/11/29 15:31
 */
public class OldAlmanacBean implements Serializable {


    /**
     * code : 0
     * msg : 获取老黄历详情成功
     * data : {"id":"6606","info":{"ganZhi":"辛亥","jiShenYiQu":"天恩 月恩 阴德 王日 驿马 天后 时阳","yi":"订盟/订婚 纳采/文定/过订/完聘/大定 会亲友 祭祀 斋醮 沐浴 塑绘 出火 开光 竖柱 上梁 开市/开业/开张 交易 立券 作梁 开柱眼 伐木 架马 安门 安床 拆卸 牧养 造畜稠 掘井","xiongShaYiJi":"月厌 地火 重日","ji":"造庙 嫁娶/结婚/婚嫁 出行 动土 安葬 行丧","baiJi":"辛不合酱主人不尝 亥不嫁娶不利新郎","riWuXing":"钗川金 开执位","chongSha":"冲蛇(乙已)煞西","xiShen":"西南","fuShen":"西南","caiShen":"正东","jiShi":"凶 吉 凶 凶 吉 凶 吉 吉 凶 凶 吉 吉","yearCN":"戊戌","yearEN":2019,"monthEN":1,"monthCN":"十二月","dayEN":14,"dayCN":"初九","daysOfMonthCN":30,"weekEN":"Monday","weekCN":"星期一","luckyNumber":"48 29 45 07 23","luckyColor":""},"date":"20190114"}
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
         * id : 6606
         * info : {"ganZhi":"辛亥","jiShenYiQu":"天恩 月恩 阴德 王日 驿马 天后 时阳","yi":"订盟/订婚 纳采/文定/过订/完聘/大定 会亲友 祭祀 斋醮 沐浴 塑绘 出火 开光 竖柱 上梁 开市/开业/开张 交易 立券 作梁 开柱眼 伐木 架马 安门 安床 拆卸 牧养 造畜稠 掘井","xiongShaYiJi":"月厌 地火 重日","ji":"造庙 嫁娶/结婚/婚嫁 出行 动土 安葬 行丧","baiJi":"辛不合酱主人不尝 亥不嫁娶不利新郎","riWuXing":"钗川金 开执位","chongSha":"冲蛇(乙已)煞西","xiShen":"西南","fuShen":"西南","caiShen":"正东","jiShi":"凶 吉 凶 凶 吉 凶 吉 吉 凶 凶 吉 吉","yearCN":"戊戌","yearEN":2019,"monthEN":1,"monthCN":"十二月","dayEN":14,"dayCN":"初九","daysOfMonthCN":30,"weekEN":"Monday","weekCN":"星期一","luckyNumber":"48 29 45 07 23","luckyColor":""}
         * date : 20190114
         */

        private String id;
        private InfoBean info;
        private String date;

        public String getId() {
            return id;
        }

        public void setId(String id) {
            this.id = id;
        }

        public InfoBean getInfo() {
            return info;
        }

        public void setInfo(InfoBean info) {
            this.info = info;
        }

        public String getDate() {
            return date;
        }

        public void setDate(String date) {
            this.date = date;
        }

        public static class InfoBean {
            /**
             * ganZhi : 辛亥
             * jiShenYiQu : 天恩 月恩 阴德 王日 驿马 天后 时阳
             * yi : 订盟/订婚 纳采/文定/过订/完聘/大定 会亲友 祭祀 斋醮 沐浴 塑绘 出火 开光 竖柱 上梁 开市/开业/开张 交易 立券 作梁 开柱眼 伐木 架马 安门 安床 拆卸 牧养 造畜稠 掘井
             * xiongShaYiJi : 月厌 地火 重日
             * ji : 造庙 嫁娶/结婚/婚嫁 出行 动土 安葬 行丧
             * baiJi : 辛不合酱主人不尝 亥不嫁娶不利新郎
             * riWuXing : 钗川金 开执位
             * chongSha : 冲蛇(乙已)煞西
             * xiShen : 西南
             * fuShen : 西南
             * caiShen : 正东
             * jiShi : 凶 吉 凶 凶 吉 凶 吉 吉 凶 凶 吉 吉
             * yearCN : 戊戌
             * yearEN : 2019
             * monthEN : 1
             * monthCN : 十二月
             * dayEN : 14
             * dayCN : 初九
             * daysOfMonthCN : 30
             * weekEN : Monday
             * weekCN : 星期一
             * luckyNumber : 48 29 45 07 23
             * luckyColor :
             */

            private String ganZhi;
            private String jiShenYiQu;
            private String yi;
            private String xiongShaYiJi;
            private String ji;
            private String baiJi;
            private String riWuXing;
            private String chongSha;
            private String xiShen;
            private String fuShen;
            private String caiShen;
            private String jiShi;
            private String yearCN;
            private int yearEN;
            private int monthEN;
            private String monthCN;
            private int dayEN;
            private String dayCN;
            private int daysOfMonthCN;
            private String weekEN;
            private String weekCN;
            private String luckyNumber;
            private String luckyColor;

            public String getGanZhi() {
                return ganZhi;
            }

            public void setGanZhi(String ganZhi) {
                this.ganZhi = ganZhi;
            }

            public String getJiShenYiQu() {
                return jiShenYiQu;
            }

            public void setJiShenYiQu(String jiShenYiQu) {
                this.jiShenYiQu = jiShenYiQu;
            }

            public String getYi() {
                return yi;
            }

            public void setYi(String yi) {
                this.yi = yi;
            }

            public String getXiongShaYiJi() {
                return xiongShaYiJi;
            }

            public void setXiongShaYiJi(String xiongShaYiJi) {
                this.xiongShaYiJi = xiongShaYiJi;
            }

            public String getJi() {
                return ji;
            }

            public void setJi(String ji) {
                this.ji = ji;
            }

            public String getBaiJi() {
                return baiJi;
            }

            public void setBaiJi(String baiJi) {
                this.baiJi = baiJi;
            }

            public String getRiWuXing() {
                return riWuXing;
            }

            public void setRiWuXing(String riWuXing) {
                this.riWuXing = riWuXing;
            }

            public String getChongSha() {
                return chongSha;
            }

            public void setChongSha(String chongSha) {
                this.chongSha = chongSha;
            }

            public String getXiShen() {
                return xiShen;
            }

            public void setXiShen(String xiShen) {
                this.xiShen = xiShen;
            }

            public String getFuShen() {
                return fuShen;
            }

            public void setFuShen(String fuShen) {
                this.fuShen = fuShen;
            }

            public String getCaiShen() {
                return caiShen;
            }

            public void setCaiShen(String caiShen) {
                this.caiShen = caiShen;
            }

            public String getJiShi() {
                return jiShi;
            }

            public void setJiShi(String jiShi) {
                this.jiShi = jiShi;
            }

            public String getYearCN() {
                return yearCN;
            }

            public void setYearCN(String yearCN) {
                this.yearCN = yearCN;
            }

            public int getYearEN() {
                return yearEN;
            }

            public void setYearEN(int yearEN) {
                this.yearEN = yearEN;
            }

            public int getMonthEN() {
                return monthEN;
            }

            public void setMonthEN(int monthEN) {
                this.monthEN = monthEN;
            }

            public String getMonthCN() {
                return monthCN;
            }

            public void setMonthCN(String monthCN) {
                this.monthCN = monthCN;
            }

            public int getDayEN() {
                return dayEN;
            }

            public void setDayEN(int dayEN) {
                this.dayEN = dayEN;
            }

            public String getDayCN() {
                return dayCN;
            }

            public void setDayCN(String dayCN) {
                this.dayCN = dayCN;
            }

            public int getDaysOfMonthCN() {
                return daysOfMonthCN;
            }

            public void setDaysOfMonthCN(int daysOfMonthCN) {
                this.daysOfMonthCN = daysOfMonthCN;
            }

            public String getWeekEN() {
                return weekEN;
            }

            public void setWeekEN(String weekEN) {
                this.weekEN = weekEN;
            }

            public String getWeekCN() {
                return weekCN;
            }

            public void setWeekCN(String weekCN) {
                this.weekCN = weekCN;
            }

            public String getLuckyNumber() {
                return luckyNumber;
            }

            public void setLuckyNumber(String luckyNumber) {
                this.luckyNumber = luckyNumber;
            }

            public String getLuckyColor() {
                return luckyColor;
            }

            public void setLuckyColor(String luckyColor) {
                this.luckyColor = luckyColor;
            }
        }
    }
}
