package com.phoenix.lotterys.helper;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;

/**
 * Created by Ykai on 2018/3/15.
 */

public class OpenHelper {

    public static void startActivity(Context context, Class<?> cls){
        context.startActivity(new Intent(context,cls));
    }

    public static void startActivity(Context context, Intent intent){
        context.startActivity(intent);
    }

    public static void startActivity(Context context, Intent intent, int requestCode){
        ((Activity)context).startActivityForResult(intent,requestCode);
    }


}
