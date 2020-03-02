package com.phoenix.lotterys.my.bean;

import java.io.Serializable;
import java.util.List;

/**
 * 文件描述:  反馈记录
 * 创建者: IAN
 * 创建时间: 2019/7/6 13:20
 */
public class FeedbackRecordBean  {


    /**
     * code : 0
     * msg : 获取成功！
     * data : {"list":[{"id":"5","type":"0","content":"121212141414141","createTime":"1562327702","status":"0","userName":"a123456","pid":"0"}],"total":1}
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
         * list : [{"id":"5","type":"0","content":"121212141414141","createTime":"1562327702","status":"0","userName":"a123456","pid":"0"}]
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

        public static class ListBean  implements Serializable {
            /**
             * id : 5
             * type : 0
             * content : 121212141414141
             * createTime : 1562327702
             * status : 0
             * userName : a123456
             * pid : 0
             */

            private String id;
            private String type;
            private String content;
            private String createTime;
            private String status;
            private String userName;
            private String pid;
            private String isRead;


            public String getIsRead() {
                return isRead;
            }

            public void setIsRead(String isRead) {
                this.isRead = isRead;
            }

            public String getId() {
                return id;
            }

            public void setId(String id) {
                this.id = id;
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

            public String getCreateTime() {
                return createTime;
            }

            public void setCreateTime(String createTime) {
                this.createTime = createTime;
            }

            public String getStatus() {
                return status;
            }

            public void setStatus(String status) {
                this.status = status;
            }

            public String getUserName() {
                return userName;
            }

            public void setUserName(String userName) {
                this.userName = userName;
            }

            public String getPid() {
                return pid;
            }

            public void setPid(String pid) {
                this.pid = pid;
            }
        }
    }
}
