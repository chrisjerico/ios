package com.phoenix.lotterys.util;

import android.app.Activity;

/**
 * Created by Luke
 * on 2019/6/24
 */
public class PlayJsonUtils {
    private Activity activity;
    private String paly;

    public PlayJsonUtils(Activity activity, String num) {
        this.activity = activity;
        getPlayJson(num);
    }

    private void getPlayJson(String num) {
        paly = AssetJson.getJson("play_"+num+".json", activity);

//        switch (num) {
//            case "1":  //重庆时时彩
//
//                break;
//            case "2":  //七星彩
//                break;
//
//            case "3":  //PK10牛牛
//
//                break;
//            case "6":  //福彩3D
//
//                break;
//            case "7":  //秒秒彩
//
//                break;
//            case "8":  //UG六合彩
//
//                break;
//            case "9":  //北京赛车秒秒彩系列
//
//                break;
//            case "10":  //江苏骰宝(快3)
//
//                break;
//            case "21":  //广东11选5
//
//                break;
//            case "50":  //北京赛车(PK10)
//
//                break;
//            case "55":  //幸运飞艇
//
//                break;
//            case "60":  //广东快乐十分
//
//                break;
//            case "61":  //重庆幸运农场
//
//                break;
//            case "65":  //北京快乐8
//
//                break;
//            case "66":  //PC蛋蛋
//
//                break;
//            case "70":  //香港六合彩
//
//                break;
//
//        }

    }

    public String PlayToJson() {
        return paly;
    }
}
