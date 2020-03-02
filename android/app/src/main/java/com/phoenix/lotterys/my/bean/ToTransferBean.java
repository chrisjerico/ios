package com.phoenix.lotterys.my.bean;

/**
 * Greated by Luke
 * on 2019/10/12
 */
public class ToTransferBean {

    /**
     * code : 0
     * msg : 检查额度转换状态成功
     * data : {"needToTransferOut":false}
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
         * needToTransferOut : false
         */

        private boolean needToTransferOut;

        public boolean isNeedToTransferOut() {
            return needToTransferOut;
        }

        public void setNeedToTransferOut(boolean needToTransferOut) {
            this.needToTransferOut = needToTransferOut;
        }
    }
}
