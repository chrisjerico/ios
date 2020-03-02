package com.phoenix.lotterys.my.bean;

import java.io.Serializable;
import java.util.List;

/**
 * 文件描述:
 * 创建者: IAN
 * 创建时间: 2019/7/18 20:03
 */
public class LotteryRecordPopBean implements Serializable {


    /**
     * code : 0
     * msg : 获取游戏大厅数据成功
     * data : [{"gameType":"lhc","gameTypeName":"六合彩","list":[{"id":"11","isSeal":"0","enable":"1","name":"lhcmmc","title":"六合秒秒彩","fromType":"70","customise":"0","isInstant":"1","gameType":"lhc","pic":"https://fhptstatic02.com/upload/test/customise/images/lottery_lhcmmc.jpg?v=156345123743","serverTime":"2019-07-18 20:00:37","curIssue":null,"curOpenTime":null,"curCloseTime":null,"openCycle":"即买即开","preIsOpen":0,"preIssue":null,"preOpenTime":"1970-01-01 08:00:00","preNum":"","preResult":""},{"id":"70","isSeal":"0","enable":"1","name":"lhc","title":"香港六合彩","fromType":"0","customise":"0","isInstant":"0","gameType":"lhc","pic":"https://fhptstatic02.com/upload/test/customise/images/lottery_lhc.jpg?v=156345123758","serverTime":"2019-07-18 20:00:37","curIssue":null,"curOpenTime":null,"curCloseTime":null,"openCycle":"2/3天一期","preIsOpen":1,"preIssue":"2019017","preOpenTime":"2019-02-12 21:34:55","preNum":"40,09,26,17,32,31,27","preResult":{"sum":182,"sumBigOrSmall":"大","sumOddOrEven":"双","colorSeven":"绿波","tmOddOrEven":"单","tmBigOrSmall":"大","tmSumOddOrEven":"单","tmSumBigOrSmall":"大","tmSumUnits":"尾大","zodiacs":["猴","兔","狗","羊","龙","蛇","鸡"]}}]},{"gameType":"pk10","gameTypeName":"PK10","list":[{"id":"9","isSeal":"0","enable":"1","name":"pk10mmc","title":"赛车秒秒彩","fromType":"50","customise":"0","isInstant":"1","gameType":"pk10","pic":"https://fhptstatic02.com/upload/test/customise/images/lottery_pk10mmc.jpg?v=156345123718","serverTime":"2019-07-18 20:00:37","curIssue":736343,"curOpenTime":"2019-07-19 ","curCloseTime":"2019-07-18 23:59:30","openCycle":"即买即开","preIsOpen":0,"preIssue":null,"preOpenTime":"1970-01-01 08:00:00","preNum":"","preResult":""},{"id":"50","isSeal":"0","enable":"1","name":"pk10","title":"北京赛车(PK10)","fromType":"0","customise":"0","isInstant":"0","gameType":"pk10","pic":"https://fhptstatic02.com/upload/test/customise/images/lottery_pk10.jpg?v=156345123791","serverTime":"2019-07-18 20:00:37","curIssue":736332,"curOpenTime":"2019-07-18 20:10:00","curCloseTime":"2019-07-18 20:09:30","openCycle":"20分钟一期","preIsOpen":1,"preIssue":"729523","preOpenTime":"2019-02-13 23:50:31","preNum":"10,01,06,05,04,08,07,09,03,02","preResult":"11,小,单,龙,虎,虎,虎,虎"}]},{"gameType":"cqssc","gameTypeName":"时时彩","list":[{"id":"7","isSeal":"0","enable":"1","name":"ofclmmc","title":"秒秒彩","fromType":"1","customise":"0","isInstant":"1","gameType":"cqssc","pic":"https://fhptstatic02.com/upload/test/customise/images/lottery_ofclmmc.jpg?v=156345123743","serverTime":"2019-07-18 20:00:37","curIssue":"20190719000","curOpenTime":"2019-07-19 ","curCloseTime":"2019-07-18 23:59:30","openCycle":"即买即开","preIsOpen":0,"preIssue":null,"preOpenTime":"1970-01-01 08:00:00","preNum":"","preResult":""},{"id":"1","isSeal":"0","enable":"1","name":"cqssc","title":"重庆时时彩","fromType":"0","customise":"0","isInstant":"0","gameType":"cqssc","pic":"https://fhptstatic02.com/upload/test/customise/images/lottery_cqssc.jpg?v=156345123748","serverTime":"2019-07-18 20:00:37","curIssue":"20190718048","curOpenTime":"2019-07-18 20:10:00","curCloseTime":"2019-07-18 20:09:10","openCycle":"20分钟一期","preIsOpen":1,"preIssue":"20190214009","preOpenTime":"2019-02-14 03:10:55","preNum":"7,0,3,7,1","preResult":"18,小,双,龙,杂六,杂六,杂六,牛8,一对"}]},{"gameType":"bjkl8","gameTypeName":"北京快乐8","list":[{"id":"65","isSeal":"0","enable":"1","name":"bjkl8","title":"北京快乐8","fromType":"0","customise":"0","isInstant":"0","gameType":"bjkl8","pic":"https://fhptstatic02.com/upload/test/customise/images/lottery_bjkl8.jpg?v=156345123733","serverTime":"2019-07-18 20:00:37","curIssue":963604,"curOpenTime":"2019-07-18 20:05:00","curCloseTime":"2019-07-18 20:04:20","openCycle":"5分钟一期","preIsOpen":1,"preIssue":"935905","preOpenTime":"2019-02-13 23:55:46","preNum":"05,06,09,14,18,25,29,30,35,37,38,41,44,48,54,56,63,73,74,79","preResult":"778,小,双,水,前(多),单双(和)"}]},{"gameType":"fc3d","gameTypeName":"福彩3D","list":[{"id":"6","isSeal":"0","enable":"1","name":"fc3d","title":"福彩3D","fromType":"0","customise":"0","isInstant":"0","gameType":"fc3d","pic":"https://fhptstatic02.com/upload/test/customise/images/lottery_fc3d.jpg?v=15634512374","serverTime":"2019-07-18 20:00:37","curIssue":null,"curOpenTime":null,"curCloseTime":null,"openCycle":"1天一期","preIsOpen":1,"preIssue":"2019037","preOpenTime":"2019-02-13 21:24:26","preNum":"7,5,6","preResult":"2,顺子,18,大,双,龙"}]},{"gameType":"qxc","gameTypeName":"七星彩","list":[{"id":"2","isSeal":"0","enable":"1","name":"qxc","title":"七星彩","fromType":"0","customise":"0","isInstant":"0","gameType":"qxc","pic":"https://fhptstatic02.com/upload/test/customise/images/lottery_qxc.jpg?v=15634512378","serverTime":"2019-07-18 20:00:37","curIssue":null,"curOpenTime":null,"curCloseTime":null,"openCycle":"2/3天一期","preIsOpen":1,"preIssue":"2019016","preOpenTime":"2019-02-12 20:33:58","preNum":"0,2,0,7,0,6,0","preResult":"15,小,单,和"}]},{"gameType":"pk10nn","gameTypeName":"牛牛","list":[{"id":"3","isSeal":"0","enable":"1","name":"pk10nn","title":"PK10牛牛","fromType":"0","customise":"0","isInstant":"0","gameType":"pk10nn","pic":"https://fhptstatic02.com/upload/test/customise/images/lottery_pk10nn.jpg?v=156345123760","serverTime":"2019-07-18 20:00:37","curIssue":736332,"curOpenTime":"2019-07-18 20:10:00","curCloseTime":"2019-07-18 20:09:10","openCycle":"20分钟一期","preIsOpen":1,"preIssue":"729523","preOpenTime":"2019-02-13 23:50:31","preNum":"10,01,06,05,04,08,07,09,03,02","preResult":"牛6,牛4,牛牛,牛3,牛1,牛9"}]},{"gameType":"xyft","gameTypeName":"幸运飞艇","list":[{"id":"55","isSeal":"0","enable":"1","name":"xyft","title":"幸运飞艇","fromType":"0","customise":"0","isInstant":"0","gameType":"xyft","pic":"https://fhptstatic02.com/upload/test/customise/images/lottery_xyft.jpg?v=156345123767","serverTime":"2019-07-18 20:00:37","curIssue":"20190718084","curOpenTime":"2019-07-18 20:04:00","curCloseTime":"2019-07-18 20:03:00","openCycle":"5分钟一期","preIsOpen":1,"preIssue":"20190213180","preOpenTime":"2019-02-14 04:04:35","preNum":"02,07,06,01,10,04,05,08,03,09","preResult":"9,小,单,虎,龙,虎,虎,龙"}]},{"gameType":"pcdd","gameTypeName":"PC蛋蛋","list":[{"id":"66","isSeal":"0","enable":"1","name":"pcdd","title":"PC蛋蛋","fromType":"0","customise":"0","isInstant":"0","gameType":"pcdd","pic":"https://fhptstatic02.com/upload/test/customise/images/lottery_pcdd.jpg?v=156345123799","serverTime":"2019-07-18 20:00:37","curIssue":963604,"curOpenTime":"2019-07-18 20:05:00","curCloseTime":"2019-07-18 20:04:20","openCycle":"5分钟一期","preIsOpen":1,"preIssue":"935905","preOpenTime":"2019-02-13 23:55:46","preNum":"7,0,8","preResult":"15,大,单,--,红波"}]},{"gameType":"gdkl10","gameTypeName":"快乐10分","list":[{"id":"60","isSeal":"0","enable":"1","name":"gdkl10","title":"广东快乐十分","fromType":"0","customise":"0","isInstant":"0","gameType":"gdkl10","pic":"https://fhptstatic02.com/upload/test/customise/images/lottery_gdkl10.jpg?v=156345123752","serverTime":"2019-07-18 20:00:37","curIssue":"20190718034","curOpenTime":"2019-07-18 20:20:00","curCloseTime":"2019-07-18 20:18:30","openCycle":"20分钟一期","preIsOpen":1,"preIssue":"20190213042","preOpenTime":"2019-02-13 23:02:33","preNum":"04,18,06,07,03,17,20,02","preResult":"77,小,单,尾大,龙,虎,虎,龙"}]},{"gameType":"jsk3","gameTypeName":"快三","list":[{"id":"10","isSeal":"0","enable":"1","name":"jsk3","title":"江苏骰宝(快3)","fromType":"0","customise":"0","isInstant":"0","gameType":"jsk3","pic":"https://fhptstatic02.com/upload/test/customise/images/lottery_jsk3.jpg?v=156345123746","serverTime":"2019-07-18 20:00:37","curIssue":"20190718035","curOpenTime":"2019-07-18 20:10:00","curCloseTime":"2019-07-18 20:08:00","openCycle":"20分钟一期","preIsOpen":1,"preIssue":"20190213041","preOpenTime":"2019-02-13 22:11:22","preNum":"1,1,4","preResult":"6,小,双"}]},{"gameType":"gd11x5","gameTypeName":"11选5","list":[{"id":"21","isSeal":"0","enable":"1","name":"gd11x5","title":"广东11选5","fromType":"0","customise":"0","isInstant":"0","gameType":"gd11x5","pic":"https://fhptstatic02.com/upload/test/customise/images/lottery_gd11x5.jpg?v=156345123749","serverTime":"2019-07-18 20:00:37","curIssue":"2019071833","curOpenTime":"2019-07-18 20:10:00","curCloseTime":"2019-07-18 20:08:00","openCycle":"20分钟一期","preIsOpen":1,"preIssue":"2019021342","preOpenTime":"2019-02-13 23:11:26","preNum":"06,07,04,01,11","preResult":"29,小,单,尾大,虎,大,大,小,小,和"}]}]
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
         * gameType : lhc
         * gameTypeName : 六合彩
         * list : [{"id":"11","isSeal":"0","enable":"1","name":"lhcmmc","title":"六合秒秒彩","fromType":"70","customise":"0","isInstant":"1","gameType":"lhc","pic":"https://fhptstatic02.com/upload/test/customise/images/lottery_lhcmmc.jpg?v=156345123743","serverTime":"2019-07-18 20:00:37","curIssue":null,"curOpenTime":null,"curCloseTime":null,"openCycle":"即买即开","preIsOpen":0,"preIssue":null,"preOpenTime":"1970-01-01 08:00:00","preNum":"","preResult":""},{"id":"70","isSeal":"0","enable":"1","name":"lhc","title":"香港六合彩","fromType":"0","customise":"0","isInstant":"0","gameType":"lhc","pic":"https://fhptstatic02.com/upload/test/customise/images/lottery_lhc.jpg?v=156345123758","serverTime":"2019-07-18 20:00:37","curIssue":null,"curOpenTime":null,"curCloseTime":null,"openCycle":"2/3天一期","preIsOpen":1,"preIssue":"2019017","preOpenTime":"2019-02-12 21:34:55","preNum":"40,09,26,17,32,31,27","preResult":{"sum":182,"sumBigOrSmall":"大","sumOddOrEven":"双","colorSeven":"绿波","tmOddOrEven":"单","tmBigOrSmall":"大","tmSumOddOrEven":"单","tmSumBigOrSmall":"大","tmSumUnits":"尾大","zodiacs":["猴","兔","狗","羊","龙","蛇","鸡"]}}]
         */

        private String gameType;    //彩种类型 六合彩系列
        private String gameTypeName;    //彩种名字 六合彩系列
        private List<ListBean> list;

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

        public List<ListBean> getList() {
            return list;
        }

        public void setList(List<ListBean> list) {
            this.list = list;
        }
    }
    public static class ListBean {

        /**
         * id : 70
         * isSeal : 0
         * isClose : 1
         * enable : 1
         * name : lhc
         * title : 香港六合彩
         * customise : 0
         * isInstant : 0
         * gameType : lhc
         * pic : https://cdn01.kspass.cn/upload/c190/customise/images/kjw_logo_70.jpg?v=1558120389
         * openCycle : 2/3天一期
         * curIssue : 2020009
         * curOpenTime : 2020-02-25 21:35:00
         * curCloseTime : 2020-02-25 21:30:00
         * serverTime : 2020-02-23 22:28:03
         * serverTimestamp : 1582468083783
         */

        private String id;
        private String isSeal;
        private String isClose;
        private String enable;
        private String name;
        private String title; //香港六合彩
        private String customise;
        private String isInstant;
        private String gameType; //游戏类型 lhc
        private String pic;//图片
        private String lowFreq;//是否是低频彩
        private String openCycle; //2/3天一期
        private String curIssue; //2020009
        private String curOpenTime; //2020-02-25 21:35:00
        private String curCloseTime; //2020-02-25 21:35:00
        private String serverTime; //2020-02-23 22:28:03
        private String serverTimestamp; //1582468083783

        public String getLowFreq() {
            return lowFreq;
        }

        public void setLowFreq(String lowFreq) {
            this.lowFreq = lowFreq;
        }

        public String getId() {
            return id;
        }

        public void setId(String id) {
            this.id = id;
        }

        public String getIsSeal() {
            return isSeal;
        }

        public void setIsSeal(String isSeal) {
            this.isSeal = isSeal;
        }

        public String getIsClose() {
            return isClose;
        }

        public void setIsClose(String isClose) {
            this.isClose = isClose;
        }

        public String getEnable() {
            return enable;
        }

        public void setEnable(String enable) {
            this.enable = enable;
        }

        public String getName() {
            return name;
        }

        public void setName(String name) {
            this.name = name;
        }

        public String getTitle() {
            return title;
        }

        public void setTitle(String title) {
            this.title = title;
        }

        public String getCustomise() {
            return customise;
        }

        public void setCustomise(String customise) {
            this.customise = customise;
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

        public String getPic() {
            return pic;
        }

        public void setPic(String pic) {
            this.pic = pic;
        }

        public String getOpenCycle() {
            return openCycle;
        }

        public void setOpenCycle(String openCycle) {
            this.openCycle = openCycle;
        }

        public String getCurIssue() {
            return curIssue;
        }

        public void setCurIssue(String curIssue) {
            this.curIssue = curIssue;
        }

        public String getCurOpenTime() {
            return curOpenTime;
        }

        public void setCurOpenTime(String curOpenTime) {
            this.curOpenTime = curOpenTime;
        }

        public String getCurCloseTime() {
            return curCloseTime;
        }

        public void setCurCloseTime(String curCloseTime) {
            this.curCloseTime = curCloseTime;
        }

        public String getServerTime() {
            return serverTime;
        }

        public void setServerTime(String serverTime) {
            this.serverTime = serverTime;
        }

        public String getServerTimestamp() {
            return serverTimestamp;
        }

        public void setServerTimestamp(String serverTimestamp) {
            this.serverTimestamp = serverTimestamp;
        }
    }
}
