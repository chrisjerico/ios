package com.phoenix.lotterys.util;


import android.util.Log;

import com.google.gson.Gson;
import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import com.google.gson.reflect.TypeToken;

import java.lang.reflect.Type;
import java.util.ArrayList;


/**
 * Gson的辅助类
 * Created by Hoyn on 16/12/14.
 */

public class GsonUtil {
    private static Gson gson = new Gson();

    public static String toJson(Object obj) {
        return gson.toJson(obj);
    }

    public static <T> T fromJson(String json, Class<T> cls) {
        try {
            T obj = gson.fromJson(json, cls);
            return obj;
        } catch (Exception e) {
//            L.e(e.getMessage() + "\n" + json);
            return null;
        }
    }

    public static <T> T fromJson(JsonElement json, Class<T> cls) {
        try {
            T obj = gson.fromJson(json, cls);
            return obj;
        } catch (Exception e) {
//            L.e(e.getMessage() + "\n" + json);
            return null;
        }
    }

    public static <T> ArrayList<T> jsonToArrayList(String json, Class<T> clazz) {
        try {
            Type type = new TypeToken<ArrayList<JsonObject>>() {}.getType();
            ArrayList<JsonObject> jsonObjects = new Gson().fromJson(json, type);
            ArrayList<T> arrayList = new ArrayList<>();
            for (JsonObject jsonObject : jsonObjects) {
                arrayList.add(new Gson().fromJson(jsonObject, clazz));
            }
            return arrayList;
        } catch (Exception e) {
            Log.e("GsonUtil", e.getMessage());
            return null;
        }


    }

    public static <T> T parseJSON(String json, Class<T> clazz) {

        Gson gson = new Gson();

        T info = gson.fromJson(json, clazz);

        return info;

    }



    public static <T> T parseJSON(String json, Type type) {

        Gson gson = new Gson();

        T info = gson.fromJson(json, type);

        return info;

    }



}
