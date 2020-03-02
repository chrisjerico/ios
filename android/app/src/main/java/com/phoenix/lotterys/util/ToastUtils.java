package com.phoenix.lotterys.util;

import android.annotation.SuppressLint;
import android.content.Context;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.View;
import android.view.WindowManager;
import android.widget.TextView;
import android.widget.Toast;

import com.phoenix.lotterys.R;import com.phoenix.lotterys.R2;

/**
 * Date:2018/9/11
 * TIME:11:45
 * author：Luke
 */
public class ToastUtils {
//    static Toast toast;
    private static TextView mTextView;
    protected static Toast toast1   = null;
    static Toast toastStart;
    private static String oldMsg;
    private static long oneTime=0;
    private static long twoTime=0;
    @SuppressLint("WrongConstant")
    public static void ToastUtils(String s, Context context) {
        //加载Toast布局
        View toastRoot = LayoutInflater.from(context).inflate(R.layout.toast, null);
        //初始化布局控件
        mTextView = (TextView) toastRoot.findViewById(R.id.message);
        //获取屏幕高度
        WindowManager wm = (WindowManager) context.getSystemService(Context.WINDOW_SERVICE);
        int height = wm.getDefaultDisplay().getHeight();
        //为控件设置属性
        mTextView.setText(s);
        if(toastStart==null){
        //Toast的初始化
        toastStart = new Toast(context);

        //Toast的Y坐标是屏幕高度的1/3，不会出现不适配的问题
        toastStart.setGravity(Gravity.TOP, 0, height / 3);
        toastStart.setDuration(Toast.LENGTH_SHORT);
        toastStart.setView(toastRoot);
        toastStart.show();
        oneTime=System.currentTimeMillis();
        }else {
            twoTime=System.currentTimeMillis();
            if(s.equals(oldMsg)){
                if(twoTime-oneTime>Toast.LENGTH_SHORT){
                    toastStart.show();
                }
            }else{
                oldMsg = s;
                toastStart.setGravity(Gravity.TOP, 0, height / 3);
                toastStart.setDuration(Toast.LENGTH_SHORT);
                toastStart.setView(toastRoot);
                mTextView.setText(s);
                toastStart.show();

            }

//        }
//        toastStart.show();
        oneTime=twoTime;
    }
}

}
