package com.wanxiangdai.commonlibrary.util.EvenBusUtil;

/**
 * 文件描述: evenbus 公共实体
 * 创建者: IAN
 * 创建时间: 2019/7/2 12:40
 */
public class Even <T> {
    //响应码
    private int code ;

    //响应数据源
    private T data ;

    public Even(int code){
        this.code=code;
    }

    public Even(int code ,T data){
        this.code=code;
        this.data=data;
    }

    public int getCode() {
        return code;
    }

    public void setCode(int code) {
        this.code = code;
    }

    public T getData() {
        return data;
    }

    public void setData(T data) {
        this.data = data;
    }
}
