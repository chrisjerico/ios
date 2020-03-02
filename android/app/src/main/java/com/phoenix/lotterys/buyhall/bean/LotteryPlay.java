package com.phoenix.lotterys.buyhall.bean;

import java.util.List;

/**
 * Created by Luke
 * on 2019/6/15
 */
public class LotteryPlay {

    private String title;
    private List<ListBean> list;

    @Override
    public String toString() {
        return "LotteryPlay{" +
                "title='" + title + '\'' +
                ", list=" + list +
                '}';
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
                    "title='" + title + '\'' +
                    ", list=" + list +
                    ", mSelectList=" + selectList +
                    '}';
        }

        /**
         * title : 冠亚和
         * list : [501001,501002,501003,501004]
         */

        private String title;
        private List<Integer> list;
        private List<Integer> selectList;
        private String amount;

        public List<Integer> getmSelectList() {
            return selectList;
        }

        public void setmSelectList(List<Integer> mSelectList) {
            this.selectList = mSelectList;
        }

        public String getTitle() {
            return title;
        }

        public void setTitle(String title) {
            this.title = title;
        }

        public List<Integer> getList() {
            return list;
        }

        public void setList(List<Integer> list) {
            this.list = list;
        }


    }
}
