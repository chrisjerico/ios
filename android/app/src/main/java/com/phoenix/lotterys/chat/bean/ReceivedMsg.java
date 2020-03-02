package com.phoenix.lotterys.chat.bean;

public class ReceivedMsg {
    private String type;
    private ContextMsg msg;

    public void setType(String type) {
        this.type = type;
    }

    public String getType() {
        return type;
    }

    public void setMsg(ContextMsg msg) {
        this.msg = msg;
    }

    public ContextMsg getMsg() {
        return msg;
    }


    public class Msg {

        private int to;
        private String content;
        private int from;
        private String headimg;
        public void setTo(int to) {
            this.to = to;
        }
        public int getTo() {
            return to;
        }

        public void setContent(String content) {
            this.content = content;
        }
        public String getContent() {
            return content;
        }

        public void setFrom(int from) {
            this.from = from;
        }
        public int getFrom() {
            return from;
        }

        public void setHeadimg(String headimg) {
            this.headimg = headimg;
        }
        public String getHeadimg() {
            return headimg;
        }

    }

}
