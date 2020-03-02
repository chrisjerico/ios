package com.phoenix.lotterys.main.bean;

import java.util.List;

/**
 * Greated by Luke
 * on 2019/8/17
 */
public class LaunchBean {


    /**
     * code : 0
     * msg : 获取启动图成功
     * data : [{"pic":"https://cdn01.jnmffh.com/upload/t036/customise/images/launch_image1.jpg"},{"pic":"https://cdn01.jnmffh.com/upload/t036/customise/images/launch_image2.jpg"}]
     * info : {"sqlList":["主库(5303)：SELECT id, name, title, value FROM `ssc_params`   --Spent：0.76 ms","主库(5303)：SELECT * FROM `ssc_blacklist` WHERE  `type` = :type   --Spent：0.25 ms","主库(5303)：SELECT * FROM `ssc_cache`  WHERE `name` = 'block_country'    --Spent：0.18 ms","主库(5303)：SELECT name FROM `ssc_upload` WHERE name LIKE '%launch_image%' AND last_update > 0 ORDER BY name ASC  --Spent：3.19 ms"],"sqlTotalNum":4,"sqlTotalTime":"4.38 ms","runtime":"40.93 ms"}
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
         * pic : https://cdn01.jnmffh.com/upload/t036/customise/images/launch_image1.jpg
         */

        private String pic;

        public String getPic() {
            return pic;
        }

        public void setPic(String pic) {
            this.pic = pic;
        }
    }
}
