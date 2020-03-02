package com.phoenix.lotterys.view;

import android.app.Dialog;
import android.content.Context;
import android.text.TextUtils;
import android.view.View;
import android.widget.TextView;

import com.phoenix.lotterys.R;import com.phoenix.lotterys.R2;


/**
 * Created by Luke
 * on 2019/6/16
 */
public  class LoadingDialog extends Dialog {

    private static LoadingDialog mLoadingProgress;

    public LoadingDialog(Context context) {
        super(context);
    }

    public LoadingDialog(Context context, int theme) {
        super(context, theme);
    }//这个消息文字，根据自己需要加吧
    public static LoadingDialog showprogress(Context context, CharSequence message, boolean iscanCancel){
        mLoadingProgress=new LoadingDialog(context, R.style.loading_dialog);//自定义style主要让背景变成透明并去掉标题部分

        //触摸外部无法取消,必须（根据自己需要吧）
        mLoadingProgress.setCanceledOnTouchOutside(false);

        mLoadingProgress.setTitle("");
        mLoadingProgress.setContentView(R.layout.loading_layout);
        mLoadingProgress.getWindow().setBackgroundDrawableResource(android.R.color.transparent);
        if(message==null|| TextUtils.isEmpty(message)){
            mLoadingProgress.findViewById(R.id.loading_tv).setVisibility(View.GONE);
        }else {
            TextView tv = (TextView) mLoadingProgress.findViewById(R.id.loading_tv);
            tv.setText(message);
        }
        //按返回键响应是否取消等待框的显示
        mLoadingProgress.setCancelable(iscanCancel);

        mLoadingProgress.show();

        return mLoadingProgress;
    }

    public static LoadingDialog showprogress(Context context, boolean iscanCancel){
        try {
            mLoadingProgress = new LoadingDialog(context, R.style.loading_dialog);//自定义style主要让背景变成透明并去掉标题部分

            mLoadingProgress.setCanceledOnTouchOutside(false);

            mLoadingProgress.setTitle("");
            mLoadingProgress.setContentView(R.layout.loading_layout);
            mLoadingProgress.getWindow().setBackgroundDrawableResource(android.R.color.transparent);

            mLoadingProgress.findViewById(R.id.loading_tv).setVisibility(View.GONE);

            mLoadingProgress.setCancelable(iscanCancel);

            if (null != mLoadingProgress && !mLoadingProgress.isShowing())
                mLoadingProgress.show();
        }catch (Exception e){

        }

        return mLoadingProgress;
    }

    public static LoadingDialog showprogress(Context context){
        mLoadingProgress=new LoadingDialog(context, R.style.loading_dialog);

        mLoadingProgress.setCanceledOnTouchOutside(false);

        mLoadingProgress.setTitle("");
        mLoadingProgress.setContentView(R.layout.loading_layout);
        mLoadingProgress.getWindow().setBackgroundDrawableResource(android.R.color.transparent);

        mLoadingProgress.findViewById(R.id.loading_tv).setVisibility(View.GONE);

        mLoadingProgress.setCancelable(true);

        mLoadingProgress.show();

        return mLoadingProgress;
    }




    public static void dismissprogress(){
        if(mLoadingProgress!=null){
            mLoadingProgress.dismiss();
        }
    }
}

