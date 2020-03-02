package com.phoenix.lotterys.net;

import android.os.Handler;

import java.io.IOException;

import okhttp3.Call;
import okhttp3.Callback;
import okhttp3.Response;

public abstract class ObjectCallback implements Callback {
    private Handler handler = OkHttp3Utils.getInstance().getHandler();

    //主线程处理
    public abstract void onUi(boolean b ,String t);

    //主线程处理
    public abstract void onFailed(Call call, IOException e);

    //请求失败
    @Override
    public void onFailure(final Call call, final IOException e) {
        handler.post(new Runnable() {
            @Override
            public void run() {
                onFailed(call, e);
            }
        });
    }

    //请求json 并直接返回泛型的对象 主线程处理
    @Override
    public void onResponse(Call call, Response response) throws IOException {
        if(response.code()==200) {
            String json = response.body().string();
            handler.post(new Runnable() {
                @Override
                public void run() {
                    onUi(true,json);
                }
            });
        }else {
            handler.post(new Runnable() {
                @Override
                public void run() {
                    onUi(false,null);
                }
            });
        }
    }
}
