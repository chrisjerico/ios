package com.phoenix.lotterys.home.bean;

import java.util.List;

/**
 * Greated by Luke
 * on 2019/7/21
 */
public class GameList {

    /**
     * code : 0
     * msg : 获取真人游戏列表成功
     * data : [{"code":"NMGENMHF","name":"阿拉斯加冰钓","pic":"https://fhptstatic04.com/images/mg/NMGENMHF.png"},{"code":"NMGENMNY","name":"阿瓦隆","pic":"https://fhptstatic04.com/images/mg/NMGENMNY.png"},{"code":"NMGENMHE","name":"爱丽娜","pic":"https://fhptstatic04.com/images/mg/NMGENMHE.png"},{"code":"NMGENMFN","name":"暗恋","pic":"https://fhptstatic04.com/images/mg/NMGENMFN.png"},{"code":"NMGENMHT","name":"白金俱乐部","pic":"https://fhptstatic04.com/images/mg/NMGENMHT.png"},{"code":"NMGENMFT","name":"百万人鱼","pic":"https://fhptstatic04.com/images/mg/NMGENMFT.png"},{"code":"NMGENMGM","name":"板球明星","pic":"https://fhptstatic04.com/images/mg/NMGENMGM.png"},{"code":"NMGENMP5","name":"伴娘我最大","pic":"https://fhptstatic04.com/images/mg/NMGENMP5.png"},{"code":"NMGENM1O","name":"宝石转轴","pic":"https://fhptstatic04.com/images/mg/NMGENM1O.png"},{"code":"NMGENMNV","name":"比基尼派对","pic":"https://fhptstatic04.com/images/mg/NMGENMNV.png"},{"code":"NMGENMGX","name":"冰球突破","pic":"https://fhptstatic04.com/images/mg/NMGENMGX.png"},{"code":"NMGENMF3","name":"不朽情缘","pic":"https://fhptstatic04.com/images/mg/NMGENMF3.png"},{"code":"NMGENM3P","name":"丛林吉姆 黄金国","pic":"https://fhptstatic04.com/images/mg/NMGENM3P.png"},{"code":"NMGENMGS","name":"丛林快讯","pic":"https://fhptstatic04.com/images/mg/NMGENMGS.png"},{"code":"NMGENMHG","name":"大航海时代","pic":"https://fhptstatic04.com/images/mg/NMGENMHG.png"},{"code":"NMGENMEQ","name":"东方珍兽","pic":"https://fhptstatic04.com/images/mg/NMGENMEQ.png"},{"code":"NMGENMFV","name":"疯狂帽匠","pic":"https://fhptstatic04.com/images/mg/NMGENMFV.png"},{"code":"NMGENM1Z","name":"富裕人生","pic":"https://fhptstatic04.com/images/mg/NMGENM1Z.png"},{"code":"NMGENMFO","name":"橄榄球明星","pic":"https://fhptstatic04.com/images/mg/NMGENMFO.png"},{"code":"NMGENMEV","name":"古墓丽影","pic":"https://fhptstatic04.com/images/mg/NMGENMEV.png"},{"code":"NMGENM58","name":"怪物这么多","pic":"https://fhptstatic04.com/images/mg/NMGENM58.png"},{"code":"NMGENMGF","name":"哈维","pic":"https://fhptstatic04.com/images/mg/NMGENMGF.png"},{"code":"NMGENMGJ","name":"海底派对","pic":"https://fhptstatic04.com/images/mg/NMGENMGJ.png"},{"code":"NMGENMGL","name":"好牌大厅","pic":"https://fhptstatic04.com/images/mg/NMGENMGL.png"},{"code":"NMGENM1Q","name":"黑綿羊咩咩叫","pic":"https://fhptstatic04.com/images/mg/NMGENM1Q.png"},{"code":"NMGENMFA","name":"狐狸爵士","pic":"https://fhptstatic04.com/images/mg/NMGENMFA.png"},{"code":"NMGENM3B","name":"花粉之国","pic":"https://fhptstatic04.com/images/mg/NMGENM3B.png"},{"code":"NMGENMGI","name":"黄金时代","pic":"https://fhptstatic04.com/images/mg/NMGENMGI.png"},{"code":"NMGENMGD","name":"加德满都","pic":"https://fhptstatic04.com/images/mg/NMGENMGD.png"},{"code":"NMGENMGR","name":"嘉年华","pic":"https://fhptstatic04.com/images/mg/NMGENMGR.png"},{"code":"NMGENM3D","name":"金库甜心","pic":"https://fhptstatic04.com/images/mg/NMGENM3D.png"},{"code":"NMGENMHR","name":"金牌经典21点","pic":"https://fhptstatic04.com/images/mg/NMGENMHR.png"},{"code":"NMGENMGC","name":"现金之王","pic":"https://fhptstatic04.com/images/mg/NMGENMGC.png"},{"code":"NMGENMHO","name":"金牌拉斯维加斯21点","pic":"https://fhptstatic04.com/images/mg/NMGENMHO.png"},{"code":"NMGENM81","name":"经典老虎机","pic":"https://fhptstatic04.com/images/mg/NMGENM81.png"},{"code":"NMGENM3I","name":"巨额现金乘数","pic":"https://fhptstatic04.com/images/mg/NMGENM3I.png"},{"code":"NMGENMFB","name":"绝对胜利","pic":"https://fhptstatic04.com/images/mg/NMGENMFB.png"},{"code":"NMGENM4R","name":"开心点心","pic":"https://fhptstatic04.com/images/mg/NMGENM4R.png"},{"code":"NMGENMN4","name":"酷巴克","pic":"https://fhptstatic04.com/images/mg/NMGENMN4.png"},{"code":"NMGENMGO","name":"酷派狼人","pic":"https://fhptstatic04.com/images/mg/NMGENMGO.png"},{"code":"NMGENMGG","name":"快乐假日","pic":"https://fhptstatic04.com/images/mg/NMGENMGG.png"},{"code":"NMGENMHC","name":"篮球巨星","pic":"https://fhptstatic04.com/images/mg/NMGENMHC.png"},{"code":"NMGENMFP","name":"雷霆风暴","pic":"https://fhptstatic04.com/images/mg/NMGENMFP.png"},{"code":"NMGENMEX","name":"雷霆万钧","pic":"https://fhptstatic04.com/images/mg/NMGENMEX.png"},{"code":"NMGENM4U","name":"雷霆万钧 2","pic":"https://fhptstatic04.com/images/mg/NMGENM4U.png"},{"code":"NMGENMGZ","name":"马戏团","pic":"https://fhptstatic04.com/images/mg/NMGENMGZ.png"},{"code":"NMGENMER","name":"猫头鹰乐园","pic":"https://fhptstatic04.com/images/mg/NMGENMER.png"},{"code":"NMGENM4Q","name":"迷失拉斯维加斯","pic":"https://fhptstatic04.com/images/mg/NMGENM4Q.png"},{"code":"NMGENM1X","name":"秘密爱慕者","pic":"https://fhptstatic04.com/images/mg/NMGENM1X.png"},{"code":"NMGENMFQ","name":"漂亮猫咪","pic":"https://fhptstatic04.com/images/mg/NMGENMFQ.png"},{"code":"NMGENM3S","name":"千金小姐","pic":"https://fhptstatic04.com/images/mg/NMGENM3S.png"},{"code":"NMGENMPO","name":"青龙出海","pic":"https://fhptstatic04.com/images/mg/NMGENMPO.png"},{"code":"NMGENMGT","name":"燃烧欲望","pic":"https://fhptstatic04.com/images/mg/NMGENMGT.png"},{"code":"NMGENMHA","name":"森林之王","pic":"https://fhptstatic04.com/images/mg/NMGENMHA.png"},{"code":"NMGENMIR","name":"圣诞老人爪子","pic":"https://fhptstatic04.com/images/mg/NMGENMIR.png"},{"code":"NMGENM56","name":"寿司这么多","pic":"https://fhptstatic04.com/images/mg/NMGENM56.png"},{"code":"NMGENM1W","name":"水果糖果","pic":"https://fhptstatic04.com/images/mg/NMGENM1W.png"},{"code":"NMGENMFC","name":"苏佩起来","pic":"https://fhptstatic04.com/images/mg/NMGENMFC.png"},{"code":"NMGENMA1","name":"泰山","pic":"https://fhptstatic04.com/images/mg/NMGENMA1.png"},{"code":"NMGENMFG","name":"泰坦帝国","pic":"https://fhptstatic04.com/images/mg/NMGENMFG.png"},{"code":"NMGENM57","name":"糖果这么多","pic":"https://fhptstatic04.com/images/mg/NMGENM57.png"},{"code":"NMGENMHH","name":"特工珍尼","pic":"https://fhptstatic04.com/images/mg/NMGENMHH.png"},{"code":"NMGENMNT","name":"舞龙","pic":"https://fhptstatic04.com/images/mg/NMGENMNT.png"},{"code":"NMGENMHJ","name":"侠盗猎车手","pic":"https://fhptstatic04.com/images/mg/NMGENMHJ.png"},{"code":"NMGENMGQ","name":"现金虫虫","pic":"https://fhptstatic04.com/images/mg/NMGENMGQ.png"},{"code":"NMGENMGP","name":"现金威乐","pic":"https://fhptstatic04.com/images/mg/NMGENMGP.png"}]
     * info : {"sqlTotalNum":0,"sqlTotalTime":"0 ms","runtime":"238.41 ms"}
     */

    private int code;
    private String msg;
    private List<DataBean> data;

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
         * code : NMGENMHF
         * name : 阿拉斯加冰钓
         * pic : https://fhptstatic04.com/images/mg/NMGENMHF.png
         */

        private String code;
        private String name;
        private String pic;

        public String getCode() {
            return code;
        }

        public void setCode(String code) {
            this.code = code;
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
    }
}
