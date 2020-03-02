package com.phoenix.lotterys.my.bean;

/**
 * Created by Luke
 * on 2019/6/17
 */
public class BaseBean {
    /**
     * code : 1
     * msg : 您是试玩玩家，访问该资源被拒绝！
     * data : []
     * info : {"mysql":["主库： SELECT id, name, title, value FROM `ssc_params`   --Spent：0.61 ms","主库： SELECT * FROM `ssc_blacklist` WHERE  `type` = :type   --Spent：0.22 ms"],"debug":{"file":"/alidata/www/web/wjapp/Core/Permission.php","line":238,"code":403},"runtime":"27.95 ms"}
     */

    private int code;
    private String msg;
    Object data;
    private ExtraBean extra;

    public ExtraBean getExtra() {
        return extra;
    }

    public void setExtra(ExtraBean extra) {
        this.extra = extra;
    }

    public static class ExtraBean {
        /**
         * hasNickname : false
         */

        private boolean hasNickname;

        public boolean isHasNickname() {
            return hasNickname;
        }

        public void setHasNickname(boolean hasNickname) {
            this.hasNickname = hasNickname;
        }
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

    public Object getData() {
        return data;
    }

    public void setData(Object data) {
        this.data = data;
    }

    @Override
    public String toString() {
        return "BaseBean{" +
                "code=" + code +
                ", msg='" + msg + '\'' +
                ", data=" + data +
                '}';
    }
}
