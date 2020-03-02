package com.phoenix.lotterys.net;

import android.os.Handler;

import com.google.gson.Gson;
import com.google.gson.JsonArray;
import com.google.gson.JsonElement;
import com.google.gson.JsonParser;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import org.json.JSONTokener;

import java.io.IOException;
import java.lang.reflect.ParameterizedType;
import java.lang.reflect.Type;
import java.util.ArrayList;
import java.util.List;

import okhttp3.Call;
import okhttp3.Callback;
import okhttp3.Response;

/**
 * 1. 类的用途 如果要将得到的json直接转化为集合 建议使用该类
 * 该类的onUi() onFailed()方法运行在主线程
 */

public abstract class GsonArrayCallback<T> implements Callback {
    private Handler handler = OkHttp3Utils.getInstance().getHandler();

    //主线程处理
    public abstract void onUi(List<T> list);

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

    //请求json 并直接返回集合 主线程处理
    @Override
    public void onResponse(Call call, Response response) throws IOException {
        if (response.code() == 200) {
            final List<T> mList = new ArrayList<T>();
            String j = response.body().string();
            //判断是否数组
            try {
                Object json = new JSONTokener(j).nextValue();
                if (json instanceof JSONObject) {
                } else if (json instanceof JSONArray) {
                    JsonArray array = new JsonParser().parse(j).getAsJsonArray();
                    Gson gson = new Gson();
                    Class<T> cls = null;
                    Class clz = this.getClass();
                    ParameterizedType type = (ParameterizedType) clz.getGenericSuperclass();
                    Type[] types = type.getActualTypeArguments();
                    cls = (Class<T>) types[0];
                    for (final JsonElement elem : array) {
                        //循环遍历把对象添加到集合
                        mList.add((T) gson.fromJson(elem, cls));
                    }
                    handler.post(new Runnable() {
                        @Override
                        public void run() {
                            onUi(mList);
                        }
                    });
                }
            } catch (JSONException e) {
                e.printStackTrace();
            }
        }
    }
}

