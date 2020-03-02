package com.phoenix.lotterys.my.bean;

import java.io.Serializable;
import java.util.List;

/**
 * 文件描述:
 * 创建者: IAN
 * 创建时间: 2019/9/5 15:18
 */
public class ApplyMosaicGoldBean implements Serializable {


    /**
     * code : 0
     * msg : 获取申请活动彩金活动信息成功
     * data : {"list":[{"id":"93","enable":"1","type":"win_apply_coin","name":"456456456465","start":"1567094400","end":"1572451199","show_time":"1567094400","param":{"joinType":"0","joinCount":0,"min_reg_coin":"","max_reg_coin":"","win_apply_image":"","win_apply_content":"&lt;p&gt;&lt;img src=&quot;https://cdn01.xqcpjy.com/upload/t010/customise/ueditor/php/upload/20190830/1567139729874.jpg&quot;/&gt;&lt;/p&gt;","timeInterval":"0","minWinAmount":"0","maxWinAmount":"0","winSort":"0","showWinAmount":"0","min_recharge":"0.00","min_recharge_day":"0.00","min_recharge_act":"0.00","recharge_banks":"","levels":"","min_coin":"","max_coin":"","virtual_amount":"0.00","virtual_count":"0","intro":"","rechargeMore":"0","recharge_coin_levels":""},"max_amount":"0.00","used_amount":"0.00","max_member":"0","used_member":"0","times_limit":"0","winSort":"0"}],"total":1}
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
         * list : [{"id":"93","enable":"1","type":"win_apply_coin","name":"456456456465","start":"1567094400","end":"1572451199","show_time":"1567094400","param":{"joinType":"0","joinCount":0,"min_reg_coin":"","max_reg_coin":"","win_apply_image":"","win_apply_content":"&lt;p&gt;&lt;img src=&quot;https://cdn01.xqcpjy.com/upload/t010/customise/ueditor/php/upload/20190830/1567139729874.jpg&quot;/&gt;&lt;/p&gt;","timeInterval":"0","minWinAmount":"0","maxWinAmount":"0","winSort":"0","showWinAmount":"0","min_recharge":"0.00","min_recharge_day":"0.00","min_recharge_act":"0.00","recharge_banks":"","levels":"","min_coin":"","max_coin":"","virtual_amount":"0.00","virtual_count":"0","intro":"","rechargeMore":"0","recharge_coin_levels":""},"max_amount":"0.00","used_amount":"0.00","max_member":"0","used_member":"0","times_limit":"0","winSort":"0"}]
         * total : 1
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
             * id : 93
             * enable : 1
             * type : win_apply_coin
             * name : 456456456465
             * start : 1567094400
             * end : 1572451199
             * show_time : 1567094400
             * param : {"joinType":"0","joinCount":0,"min_reg_coin":"","max_reg_coin":"","win_apply_image":"","win_apply_content":"&lt;p&gt;&lt;img src=&quot;https://cdn01.xqcpjy.com/upload/t010/customise/ueditor/php/upload/20190830/1567139729874.jpg&quot;/&gt;&lt;/p&gt;","timeInterval":"0","minWinAmount":"0","maxWinAmount":"0","winSort":"0","showWinAmount":"0","min_recharge":"0.00","min_recharge_day":"0.00","min_recharge_act":"0.00","recharge_banks":"","levels":"","min_coin":"","max_coin":"","virtual_amount":"0.00","virtual_count":"0","intro":"","rechargeMore":"0","recharge_coin_levels":""}
             * max_amount : 0.00
             * used_amount : 0.00
             * max_member : 0
             * used_member : 0
             * times_limit : 0
             * winSort : 0
             */

            private String adminComment;
            private String amount;
            private String state;
            private String updateTime;
            private String userComment;
            private String winId;
            private String winName;
//            adminComment: ""
//            amount: "10.00"
//            id: "47"
//            state: "审核中"
//            updateTime: "2019-09-05 13:41:08"
//            userComment: "fdsfdsfass"
//            winId: "26"
//            winName: "彩金送"


            private String id;
            private String enable;
            private String type;
            private String name;
            private String start;
            private String end;
            private String show_time;
            private ParamBean param;
            private String max_amount;
            private String used_amount;
            private String max_member;
            private String used_member;
            private String times_limit;
            private String winSort;

            public String getAdminComment() {
                return adminComment;
            }

            public void setAdminComment(String adminComment) {
                this.adminComment = adminComment;
            }

            public String getAmount() {
                return amount;
            }

            public void setAmount(String amount) {
                this.amount = amount;
            }

            public String getState() {
                return state;
            }

            public void setState(String state) {
                this.state = state;
            }

            public String getUpdateTime() {
                return updateTime;
            }

            public void setUpdateTime(String updateTime) {
                this.updateTime = updateTime;
            }

            public String getUserComment() {
                return userComment;
            }

            public void setUserComment(String userComment) {
                this.userComment = userComment;
            }

            public String getWinId() {
                return winId;
            }

            public void setWinId(String winId) {
                this.winId = winId;
            }

            public String getWinName() {
                return winName;
            }

            public void setWinName(String winName) {
                this.winName = winName;
            }

            public String getId() {
                return id;
            }

            public void setId(String id) {
                this.id = id;
            }

            public String getEnable() {
                return enable;
            }

            public void setEnable(String enable) {
                this.enable = enable;
            }

            public String getType() {
                return type;
            }

            public void setType(String type) {
                this.type = type;
            }

            public String getName() {
                return name;
            }

            public void setName(String name) {
                this.name = name;
            }

            public String getStart() {
                return start;
            }

            public void setStart(String start) {
                this.start = start;
            }

            public String getEnd() {
                return end;
            }

            public void setEnd(String end) {
                this.end = end;
            }

            public String getShow_time() {
                return show_time;
            }

            public void setShow_time(String show_time) {
                this.show_time = show_time;
            }

            public ParamBean getParam() {
                return param;
            }

            public void setParam(ParamBean param) {
                this.param = param;
            }

            public String getMax_amount() {
                return max_amount;
            }

            public void setMax_amount(String max_amount) {
                this.max_amount = max_amount;
            }

            public String getUsed_amount() {
                return used_amount;
            }

            public void setUsed_amount(String used_amount) {
                this.used_amount = used_amount;
            }

            public String getMax_member() {
                return max_member;
            }

            public void setMax_member(String max_member) {
                this.max_member = max_member;
            }

            public String getUsed_member() {
                return used_member;
            }

            public void setUsed_member(String used_member) {
                this.used_member = used_member;
            }

            public String getTimes_limit() {
                return times_limit;
            }

            public void setTimes_limit(String times_limit) {
                this.times_limit = times_limit;
            }

            public String getWinSort() {
                return winSort;
            }

            public void setWinSort(String winSort) {
                this.winSort = winSort;
            }

            public static class ParamBean {
                /**
                 * joinType : 0
                 * joinCount : 0
                 * min_reg_coin :
                 * max_reg_coin :
                 * win_apply_image :
                 * win_apply_content : &lt;p&gt;&lt;img src=&quot;https://cdn01.xqcpjy.com/upload/t010/customise/ueditor/php/upload/20190830/1567139729874.jpg&quot;/&gt;&lt;/p&gt;
                 * timeInterval : 0
                 * minWinAmount : 0
                 * maxWinAmount : 0
                 * winSort : 0
                 * showWinAmount : 0
                 * min_recharge : 0.00
                 * min_recharge_day : 0.00
                 * min_recharge_act : 0.00
                 * recharge_banks :
                 * levels :
                 * min_coin :
                 * max_coin :
                 * virtual_amount : 0.00
                 * virtual_count : 0
                 * intro :
                 * rechargeMore : 0
                 * recharge_coin_levels :
                 */


                private String quickAmount1;
                private String quickAmount2;
                private String quickAmount3;
                private String quickAmount4;
                private String quickAmount5;
                private String quickAmount6;
                private String quickAmount7;
                private String quickAmount8;
                private String quickAmount9;
                private String quickAmount10;
                private String quickAmount11;
                private String quickAmount12;


                private String joinType;
                private int joinCount;
                private String min_reg_coin;
                private String max_reg_coin;
                private String win_apply_image;
                private String win_apply_content;
                private String timeInterval;
                private String minWinAmount;
                private String maxWinAmount;
                private String winSort;
                private String showWinAmount;
                private String min_recharge;
                private String min_recharge_day;
                private String min_recharge_act;
                private String recharge_banks;
                private String levels;
                private String min_coin;
                private String max_coin;
                private String virtual_amount;
                private String virtual_count;
                private String intro;
                private String rechargeMore;
                private String recharge_coin_levels;

                public String getQuickAmount1() {
                    return quickAmount1;
                }

                public void setQuickAmount1(String quickAmount1) {
                    this.quickAmount1 = quickAmount1;
                }

                public String getQuickAmount2() {
                    return quickAmount2;
                }

                public void setQuickAmount2(String quickAmount2) {
                    this.quickAmount2 = quickAmount2;
                }

                public String getQuickAmount3() {
                    return quickAmount3;
                }

                public void setQuickAmount3(String quickAmount3) {
                    this.quickAmount3 = quickAmount3;
                }

                public String getQuickAmount4() {
                    return quickAmount4;
                }

                public void setQuickAmount4(String quickAmount4) {
                    this.quickAmount4 = quickAmount4;
                }

                public String getQuickAmount5() {
                    return quickAmount5;
                }

                public void setQuickAmount5(String quickAmount5) {
                    this.quickAmount5 = quickAmount5;
                }

                public String getQuickAmount6() {
                    return quickAmount6;
                }

                public void setQuickAmount6(String quickAmount6) {
                    this.quickAmount6 = quickAmount6;
                }

                public String getQuickAmount7() {
                    return quickAmount7;
                }

                public void setQuickAmount7(String quickAmount7) {
                    this.quickAmount7 = quickAmount7;
                }

                public String getQuickAmount8() {
                    return quickAmount8;
                }

                public void setQuickAmount8(String quickAmount8) {
                    this.quickAmount8 = quickAmount8;
                }

                public String getQuickAmount9() {
                    return quickAmount9;
                }

                public void setQuickAmount9(String quickAmount9) {
                    this.quickAmount9 = quickAmount9;
                }

                public String getQuickAmount10() {
                    return quickAmount10;
                }

                public void setQuickAmount10(String quickAmount10) {
                    this.quickAmount10 = quickAmount10;
                }

                public String getQuickAmount11() {
                    return quickAmount11;
                }

                public void setQuickAmount11(String quickAmount11) {
                    this.quickAmount11 = quickAmount11;
                }

                public String getQuickAmount12() {
                    return quickAmount12;
                }

                public void setQuickAmount12(String quickAmount12) {
                    this.quickAmount12 = quickAmount12;
                }

                public String getJoinType() {
                    return joinType;
                }

                public void setJoinType(String joinType) {
                    this.joinType = joinType;
                }

                public int getJoinCount() {
                    return joinCount;
                }

                public void setJoinCount(int joinCount) {
                    this.joinCount = joinCount;
                }

                public String getMin_reg_coin() {
                    return min_reg_coin;
                }

                public void setMin_reg_coin(String min_reg_coin) {
                    this.min_reg_coin = min_reg_coin;
                }

                public String getMax_reg_coin() {
                    return max_reg_coin;
                }

                public void setMax_reg_coin(String max_reg_coin) {
                    this.max_reg_coin = max_reg_coin;
                }

                public String getWin_apply_image() {
                    return win_apply_image;
                }

                public void setWin_apply_image(String win_apply_image) {
                    this.win_apply_image = win_apply_image;
                }

                public String getWin_apply_content() {
                    return win_apply_content;
                }

                public void setWin_apply_content(String win_apply_content) {
                    this.win_apply_content = win_apply_content;
                }

                public String getTimeInterval() {
                    return timeInterval;
                }

                public void setTimeInterval(String timeInterval) {
                    this.timeInterval = timeInterval;
                }

                public String getMinWinAmount() {
                    return minWinAmount;
                }

                public void setMinWinAmount(String minWinAmount) {
                    this.minWinAmount = minWinAmount;
                }

                public String getMaxWinAmount() {
                    return maxWinAmount;
                }

                public void setMaxWinAmount(String maxWinAmount) {
                    this.maxWinAmount = maxWinAmount;
                }

                public String getWinSort() {
                    return winSort;
                }

                public void setWinSort(String winSort) {
                    this.winSort = winSort;
                }

                public String getShowWinAmount() {
                    return showWinAmount;
                }

                public void setShowWinAmount(String showWinAmount) {
                    this.showWinAmount = showWinAmount;
                }

                public String getMin_recharge() {
                    return min_recharge;
                }

                public void setMin_recharge(String min_recharge) {
                    this.min_recharge = min_recharge;
                }

                public String getMin_recharge_day() {
                    return min_recharge_day;
                }

                public void setMin_recharge_day(String min_recharge_day) {
                    this.min_recharge_day = min_recharge_day;
                }

                public String getMin_recharge_act() {
                    return min_recharge_act;
                }

                public void setMin_recharge_act(String min_recharge_act) {
                    this.min_recharge_act = min_recharge_act;
                }

                public String getRecharge_banks() {
                    return recharge_banks;
                }

                public void setRecharge_banks(String recharge_banks) {
                    this.recharge_banks = recharge_banks;
                }

                public String getLevels() {
                    return levels;
                }

                public void setLevels(String levels) {
                    this.levels = levels;
                }

                public String getMin_coin() {
                    return min_coin;
                }

                public void setMin_coin(String min_coin) {
                    this.min_coin = min_coin;
                }

                public String getMax_coin() {
                    return max_coin;
                }

                public void setMax_coin(String max_coin) {
                    this.max_coin = max_coin;
                }

                public String getVirtual_amount() {
                    return virtual_amount;
                }

                public void setVirtual_amount(String virtual_amount) {
                    this.virtual_amount = virtual_amount;
                }

                public String getVirtual_count() {
                    return virtual_count;
                }

                public void setVirtual_count(String virtual_count) {
                    this.virtual_count = virtual_count;
                }

                public String getIntro() {
                    return intro;
                }

                public void setIntro(String intro) {
                    this.intro = intro;
                }

                public String getRechargeMore() {
                    return rechargeMore;
                }

                public void setRechargeMore(String rechargeMore) {
                    this.rechargeMore = rechargeMore;
                }

                public String getRecharge_coin_levels() {
                    return recharge_coin_levels;
                }

                public void setRecharge_coin_levels(String recharge_coin_levels) {
                    this.recharge_coin_levels = recharge_coin_levels;
                }
            }
        }
    }
}
