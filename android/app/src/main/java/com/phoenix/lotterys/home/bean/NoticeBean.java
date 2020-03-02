package com.phoenix.lotterys.home.bean;

import java.util.List;

/**
 * Created by Luke
 * on 2019/6/23
 */
public class NoticeBean {
    /**
     * code : 0
     * msg : 获取公告成功
     * data : {"scroll":[],"popup":[{"id":"17","nodeId":"2","type":"1","content":"<p>16<\/p>","title":"16","addTime":"2019-07-08 22:41:55"},{"id":"16","nodeId":"2","type":"1","content":"<p>15<\/p>","title":"15","addTime":"2019-07-08 22:41:49"},{"id":"15","nodeId":"2","type":"1","content":"<p>14<\/p>","title":"14","addTime":"2019-07-08 22:41:43"},{"id":"14","nodeId":"2","type":"1","content":"<p>13<\/p>","title":"13","addTime":"2019-07-08 22:41:37"},{"id":"13","nodeId":"2","type":"1","content":"<p>12<\/p>","title":"12","addTime":"2019-07-08 22:41:31"},{"id":"12","nodeId":"2","type":"1","content":"<p>11<\/p>","title":"11","addTime":"2019-07-08 22:41:25"},{"id":"11","nodeId":"2","type":"1","content":"<p>10<\/p>","title":"10","addTime":"2019-07-08 22:41:19"},{"id":"10","nodeId":"2","type":"1","content":"<p>999999999<\/p>","title":"9999","addTime":"2019-07-08 22:41:09"},{"id":"9","nodeId":"2","type":"1","content":"<p>888888888<\/p>","title":"8888","addTime":"2019-07-08 22:41:02"},{"id":"8","nodeId":"2","type":"1","content":"<p>77777777777<\/p>","title":"7777","addTime":"2019-07-08 22:40:54"}]}
     * info : {"sqlList":["主库(5303)：SELECT id, name, title, value FROM `ssc_params`   --Spent：0.57 ms","主库(5303)：SELECT * FROM `ssc_blacklist` WHERE  `type` = :type   --Spent：0.19 ms","主库(5303)：SELECT * FROM `ssc_cache`  WHERE `name` = 'block_country'    --Spent：0.15 ms","主库(5303)：SELECT id, nodeId, type, content, title, addTime FROM `ssc_content` WHERE nodeId=1 AND enable=1 AND (exipredDay=0 OR exipredDay > 1562824443) AND (notice_type=0 OR notice_type =1) ORDER BY sorts DESC, addTime DESC LIMIT 5  --Spent：0.50 ms","主库(5303)：SELECT id, nodeId, type, content, title, addTime FROM `ssc_content` WHERE nodeId=2 AND enable=1 AND (exipredDay=0 OR exipredDay > 1562824443) AND (notice_type=0 OR notice_type =1) ORDER BY sorts DESC, addTime DESC LIMIT 10  --Spent：0.28 ms"],"sqlTotalNum":5,"sqlTotalTime":"1.69 ms","runtime":"54.55 ms"}
     */

    private int code;
    private String msg;
    private DataBean data;

    @Override
    public String toString() {
        return "NoticeBean{" +
                "code=" + code +
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
        private List<Scroll> scroll;
        private List<PopupBean> popup;

        @Override
        public String toString() {
            return "DataBean{" +
                    "scroll=" + scroll +
                    ", popup=" + popup +
                    '}';
        }

        public List<Scroll> getScroll() {
            return scroll;
        }

        public void setScroll(List<Scroll> scroll) {
            this.scroll = scroll;
        }

        public List<PopupBean> getPopup() {
            return popup;
        }

        public void setPopup(List<PopupBean> popup) {
            this.popup = popup;
        }

        public static class PopupBean {
            /**
             * id : 17
             * nodeId : 2
             * type : 1
             * content : <p>16</p>
             * title : 16
             * addTime : 2019-07-08 22:41:55
             */

            private String id;
            private String nodeId;
            private String type;
            private String content;
            private String title;
            private String addTime;
            private boolean isOpen;

            @Override
            public String toString() {
                return "PopupBean{" +
                        "id='" + id + '\'' +
                        ", nodeId='" + nodeId + '\'' +
                        ", type='" + type + '\'' +
                        ", content='" + content + '\'' +
                        ", title='" + title + '\'' +
                        ", addTime='" + addTime + '\'' +
                        ", isOpen=" + isOpen +
                        '}';
            }

            public boolean isOpen() {
                return isOpen;
            }

            public void setOpen(boolean open) {
                isOpen = open;
            }

            public String getId() {
                return id;
            }

            public void setId(String id) {
                this.id = id;
            }

            public String getNodeId() {
                return nodeId;
            }

            public void setNodeId(String nodeId) {
                this.nodeId = nodeId;
            }

            public String getType() {
                return type;
            }

            public void setType(String type) {
                this.type = type;
            }

            public String getContent() {
                return content;
            }

            public void setContent(String content) {
                this.content = content;
            }

            public String getTitle() {
                return title;
            }

            public void setTitle(String title) {
                this.title = title;
            }

            public String getAddTime() {
                return addTime;
            }

            public void setAddTime(String addTime) {
                this.addTime = addTime;
            }
        }
        public static class Scroll {
            /**
             * id : 17
             * nodeId : 2
             * type : 1
             * content : <p>16</p>
             * title : 16
             * addTime : 2019-07-08 22:41:55
             */

            private String id;
            private String nodeId;
            private String type;
            private String content;
            private String title;
            private String addTime;

            public String getId() {
                return id;
            }

            public void setId(String id) {
                this.id = id;
            }

            public String getNodeId() {
                return nodeId;
            }

            public void setNodeId(String nodeId) {
                this.nodeId = nodeId;
            }

            public String getType() {
                return type;
            }

            public void setType(String type) {
                this.type = type;
            }

            public String getContent() {
                return content;
            }

            public void setContent(String content) {
                this.content = content;
            }

            public String getTitle() {
                return title;
            }

            public void setTitle(String title) {
                this.title = title;
            }

            public String getAddTime() {
                return addTime;
            }

            public void setAddTime(String addTime) {
                this.addTime = addTime;
            }
        }
    }


//    /**
//     * code : 0
//     * msg : 获取首页公告成功！
//     * data : [{"id":"330","title":"入款推荐方式","nodeId":"1","userId":null,"type":1,"message":"<p><img src=\"https://cdn01.qdyoukang.cn/upload/c018/customise/ueditor/php/upload/20190622/15611965549989.png\"/><\/p>","channel":null,"addTime":"2019-06-22 17:42:42","updateTime":"2019-06-22 17:42:42"},{"id":"328","title":"618狂欢节 一起疯狂 一起嗨！","nodeId":"2","userId":null,"type":1,"message":"<p><img src=\"https://cdn01.fsjtzs.cn/upload/c018/customise/ueditor/php/upload/20190617/15607640182694.png\"/><\/p>","channel":null,"addTime":"2019-06-17 17:34:43","updateTime":"2019-06-17 17:34:43"},{"id":"325","title":"银行入款优惠1.5%","nodeId":"2","userId":null,"type":1,"message":"<p><img src=\"https://cdn01.qdyoukang.cn/upload/c018/customise/ueditor/php/upload/20190611/15602468335637.png\"/><\/p>","channel":null,"addTime":"2019-06-11 17:53:59","updateTime":"2019-06-11 17:53:59"},{"id":"318","title":"为回馈广大新老会员，香港六合彩特码\u201c20\u201d，\u201c44\u201d，两个特码调整为期期50倍，超高赔率现金回馈，优惠享不停！","nodeId":"1","userId":null,"type":1,"message":"<p>为回馈广大新老会员，香港六合彩特码\u201c20\u201d，\u201c44\u201d，两个特码调整为期期50倍，超高赔率现金回馈，优惠享不停！<\/p>","channel":null,"addTime":"2019-05-23 16:03:21","updateTime":"2019-05-23 16:03:21"},{"id":"317","title":"由于公司财务清算，原公司入款卡广州正信德企业管理有限公司，暂停使用，请广大会员不要私自转入，以免造成不必要的损失，感谢您的理解与支持！！","nodeId":"1","userId":null,"type":1,"message":"<p>由于公司财务清算，工商王建，暂停使用，请广大会员不要私自转入，以免造成不必要的损失，感谢您的理解与支持！！<\/p>","channel":null,"addTime":"2019-05-22 13:42:42","updateTime":"2019-05-22 13:42:42"},{"id":"315","title":"尊敬的会员您好：近期受国际网络波动影响，部分会员打不开APP或者网页，目前技术部门正在处理优化中，期间给您造成的不便我们深感抱歉，后续会推出优惠彩金活动回馈大家，谢谢~~","nodeId":"1","userId":null,"type":1,"message":"<p>尊敬的会员您好：近期受国际网络波动影响，部分会员打不开APP或者网页，目前技术部门正在处理优化中，期间给您造成的不便我们深感抱歉，后续会推出优惠彩金活动回馈大家，谢谢~~<\/p>","channel":null,"addTime":"2019-05-21 19:48:10","updateTime":"2019-05-21 19:48:10"},{"id":"289","title":"最新公告","nodeId":"1","userId":null,"type":1,"message":"<p><span style=\"white-space: nowrap;\">尊敬的2044彩票会员您好：<\/span><span style=\"white-space: nowrap;\">近期支付宝，微信风控严重，导致成功率下降，请广大彩民选择（公司入款\u2014银行转账），的入款方式！<\/span><span style=\"white-space: nowrap;\">重要通告：若出现访问2044彩票被非法篡改跳转到其他黑平台页面时,切勿相信，谨防上当受骗！<\/span><\/p><p><span style=\"white-space: nowrap;\"><br/><\/span><\/p><p><span style=\"white-space: nowrap;\">本司香港六合彩特码B盘赔率为50倍，特码A盘赔率为48.1倍由于B盘赔率较高所有会员B盘A盘总下注码数不允许超过24码；如您未下注B盘只下注A盘，那么便没有码数限制。违者视为无效投注!!<\/span><\/p><p style=\"white-space: normal;\"><br/><\/p>","channel":null,"addTime":"2019-04-13 13:38:29","updateTime":"2019-04-13 13:38:29"},{"id":"103","title":"★★★尊敬的会员，欢迎登入2044彩票网，我们恪守\u201c客户至上\u201d的宗旨，为了回馈您对2044彩票网的支持与厚爱，现推出各大优惠豪礼与您共享，详情请您点击优惠活动进行了解，我们有最具实力的品牌优势，最优质的客户服务，最快捷的存取款服务，最给力的优惠策划，最丰富的平台优势，2044彩票网真诚期待您的莅临！★★★","nodeId":"1","userId":null,"type":1,"message":"<p><span style=\"white-space: normal;\"><span style=\"white-space: normal;\">★★★<\/span>尊敬的会员，欢迎登入2044<\/span><span style=\"white-space: normal;\">彩票网<\/span><span style=\"white-space: normal;\">，我们恪守\u201c客户至上\u201d的宗旨，为了回馈您对<span style=\"white-space: normal;\">2044<\/span>彩票网的支持与厚爱，现推出各大优惠豪礼与您共享，详情请您点击优惠活动进行了解，我们有最具实力的品牌优势，最优质的客户服务，最快捷的存取款服务，最给力的优惠策划，最丰富的平台优势，<span style=\"white-space: normal;\">2044<\/span>彩票网真诚期待您的莅临！<span style=\"white-space: normal;\">★★★<\/span><\/span><\/p>","channel":null,"addTime":"2017-07-22 00:00:00","updateTime":"2017-07-22 00:00:00"},{"id":"308","title":"理财好帮手  利息宝独家推出","nodeId":"2","userId":null,"type":1,"message":"<p><img src=\"https://cdn01.qdyoukang.cn/upload/c018/customise/ueditor/php/upload/20190508/15573239049713.jpg\"/><\/p>","channel":null,"addTime":"2019-05-08 21:58:27","updateTime":"2019-05-08 21:58:27"},{"id":"239","title":"极速时时彩赛车9.996倍！特码50倍！","nodeId":"2","userId":null,"type":1,"message":"<p><img src=\"https://cdn01.qdyoukang.cn/upload/c018/customise/ueditor/php/upload/20181121/15427997145816.png\"/><\/p>","channel":null,"addTime":"2018-11-20 01:24:15","updateTime":"2018-11-20 01:24:15"}]
//     * info : {"mysql":["主库： SELECT id, name, title, value FROM `ssc_params`   --Spent：0.73 ms","主库： SELECT * FROM `ssc_blacklist` WHERE  `type` = :type   --Spent：0.32 ms"],"runtime":"22.11 ms"}
//     */
//
//    private int code;
//    private String msg;
//    private InfoBean info;
//    private List<DataBean> data;
//
//    public int getCode() {
//        return code;
//    }
//
//    public void setCode(int code) {
//        this.code = code;
//    }
//
//    public String getMsg() {
//        return msg;
//    }
//
//    public void setMsg(String msg) {
//        this.msg = msg;
//    }
//
//    public InfoBean getInfo() {
//        return info;
//    }
//
//    public void setInfo(InfoBean info) {
//        this.info = info;
//    }
//
//    public List<DataBean> getData() {
//        return data;
//    }
//
//    public void setData(List<DataBean> data) {
//        this.data = data;
//    }
//
//    public static class InfoBean {
//    }
//
//    public static class DataBean {
//        /**
//         * id : 330
//         * title : 入款推荐方式
//         * nodeId : 1
//         * userId : null
//         * type : 1
//         * message : <p><img src="https://cdn01.qdyoukang.cn/upload/c018/customise/ueditor/php/upload/20190622/15611965549989.png"/></p>
//         * channel : null
//         * addTime : 2019-06-22 17:42:42
//         * updateTime : 2019-06-22 17:42:42
//         */
//
//        private String id;
//        private String title;
//        private String nodeId;
//        private Object userId;
//        private int type;
//        private String message;
//        private Object channel;
//        private String addTime;
//        private String updateTime;
//
//        public String getId() {
//            return id;
//        }
//
//        public void setId(String id) {
//            this.id = id;
//        }
//
//        public String getTitle() {
//            return title;
//        }
//
//        public void setTitle(String title) {
//            this.title = title;
//        }
//
//        public String getNodeId() {
//            return nodeId;
//        }
//
//        public void setNodeId(String nodeId) {
//            this.nodeId = nodeId;
//        }
//
//        public Object getUserId() {
//            return userId;
//        }
//
//        public void setUserId(Object userId) {
//            this.userId = userId;
//        }
//
//        public int getType() {
//            return type;
//        }
//
//        public void setType(int type) {
//            this.type = type;
//        }
//
//        public String getMessage() {
//            return message;
//        }
//
//        public void setMessage(String message) {
//            this.message = message;
//        }
//
//        public Object getChannel() {
//            return channel;
//        }
//
//        public void setChannel(Object channel) {
//            this.channel = channel;
//        }
//
//        public String getAddTime() {
//            return addTime;
//        }
//
//        public void setAddTime(String addTime) {
//            this.addTime = addTime;
//        }
//
//        public String getUpdateTime() {
//            return updateTime;
//        }
//
//        public void setUpdateTime(String updateTime) {
//            this.updateTime = updateTime;
//        }
//    }





}
