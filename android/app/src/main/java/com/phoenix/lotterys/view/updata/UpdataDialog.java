package com.phoenix.lotterys.view.updata;

import android.annotation.SuppressLint;
import android.app.Dialog;
import android.content.Context;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.phoenix.lotterys.R;import com.phoenix.lotterys.R2;

/**
 * Date:2018/9/22
 * TIME:14:16
 * author：Luke
 */
public class UpdataDialog extends Dialog {
    private View view;
    private Button yes;
    private Button no;
    private Button btupdata;
    private Button btCancel;
    private TextView titleTv;
    private TextView tv_dx;
    private TextView tv_versionCode;
    private NumberProgressBar tv_load;
    private RelativeLayout rl_verson;
    private LinearLayout ll_no;
    private LinearLayout ll_updata;
    private TextView messageTv;
    private String titleStr;
    private String messageStr;
    private String yesStr, noStr;
    private String versionCode, dx, forceUpdate;
    private int loadStr;
    private int isForce;

    /*  -------------------------------- 接口监听 -------------------------------------  */

    private onNoOnclickListener noOnclickListener;
    private onYesOnclickListener yesOnclickListener;
    private onUpdateOnclickListener UpdateOnclickListener;

    public interface onUpdateOnclickListener {
        void onUpdateClick();
    }

    public interface onYesOnclickListener {
        void onYesClick();
    }

    public interface onNoOnclickListener {
        void onNoClick();
    }

    public void setonUpdateOnclickListener(onUpdateOnclickListener onUpdateOnclickListener) {
        this.UpdateOnclickListener = onUpdateOnclickListener;
    }

    public void setNoOnclickListener(String str, onNoOnclickListener onNoOnclickListener) {
        if (str != null) {
            noStr = str;
        }
        this.noOnclickListener = onNoOnclickListener;
    }

    public void setYesOnclickListener(String str, onYesOnclickListener onYesOnclickListener) {
        if (str != null) {
            yesStr = str;
        }
        this.yesOnclickListener = onYesOnclickListener;
    }

    /*  ---------------------------------- 构造方法 -------------------------------------  */

    public UpdataDialog(Context context) {
        super(context, R.style.UpDialog);//风格主题
//        super(context);
    }


    /*  ---------------------------------- onCreate-------------------------------------  */

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.updata_dialog_layout);//自定义布局
        //按空白处不能取消动画
        setCanceledOnTouchOutside(false);
        setCancelable(false);

        //初始化界面控件
        initView();
        //初始化界面数据
        initData();
        //初始化界面控件的事件
        initEvent();

    }

    /**
     * 初始化界面的确定和取消监听器
     */
    private void initEvent() {
        //设置确定按钮被点击后，向外界提供监听
        yes.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (yesOnclickListener != null) {
                    yesOnclickListener.onYesClick();
                }
            }
        });
        //设置取消按钮被点击后，向外界提供监听
        no.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (noOnclickListener != null) {
                    noOnclickListener.onNoClick();
                }
            }
        });
        btupdata.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (UpdateOnclickListener != null) {
                    UpdateOnclickListener.onUpdateClick();
                }
            }
        });
        btCancel.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                noOnclickListener.onNoClick();
                dismiss();
            }
        });
    }

    /**
     * 初始化界面控件的显示数据
     */
    private void initData() {
        if (isForce==1) {
            btCancel.setVisibility(View.GONE);
        } else {
            btCancel.setVisibility(View.VISIBLE);
        }

        if (titleStr != null) {
            titleTv.setText(titleStr);
        }
        if (messageStr != null) {
            messageTv.setText(messageStr);
        }
        //如果设置按钮的文字
        if (yesStr != null) {
            yes.setText(yesStr);
        }
        if (noStr != null) {
            no.setText(noStr);
        }


        if (versionCode != null) {
            tv_versionCode.setText(versionCode);
        }
        if (dx != null) {
            tv_dx.setText(dx);
        }
        if (forceUpdate != null) {
            if (forceUpdate.equals("0")) {
                ll_updata.setVisibility(View.GONE);
                ll_no.setVisibility(View.VISIBLE);
            } else if (forceUpdate.equals("1")) {
                ll_updata.setVisibility(View.VISIBLE);
                ll_no.setVisibility(View.GONE);
            }
        }

    }

    /**
     * 初始化界面控件
     */
    private void initView() {
        yes = (Button) findViewById(R.id.yes);
        no = (Button) findViewById(R.id.no);
        btupdata = (Button) findViewById(R.id.bt_updata);
        btCancel = (Button) findViewById(R.id.bt_cancel);
        titleTv = (TextView) findViewById(R.id.title);
        tv_dx = (TextView) findViewById(R.id.tv_dx);
        tv_versionCode = (TextView) findViewById(R.id.tv_versionCode);

        messageTv = (TextView) findViewById(R.id.message);
        tv_load = (NumberProgressBar) findViewById(R.id.tv_load);
        rl_verson = (RelativeLayout) findViewById(R.id.rl_verson);
        ll_no = (LinearLayout) findViewById(R.id.ll_no);
        ll_updata = (LinearLayout) findViewById(R.id.ll_updata);
        view = (View) findViewById(R.id.view);

    }

    /*  ---------------------------------- set方法 传值-------------------------------------  */

    //为外界设置一些public 公开的方法，来向自定义的dialog传递值
    public void setTitle(String title) {
        titleStr = title;
    }

    public void setMessage(int isForce1, String message, String versionCode1, String dx1, String forceUpdate1) {
        messageStr = message;
        versionCode = versionCode1;
        dx = dx1;
        forceUpdate = forceUpdate1;
        isForce = isForce1;
    }


    public void setProgress(int mProgress) {
        tv_load.setProgress(mProgress);
    }

    @SuppressLint("ResourceAsColor")
    public void setMessage1(String message) {
        if (message.equals("1")) {
            messageTv.setVisibility(View.GONE);
            rl_verson.setVisibility(View.GONE);
            view.setVisibility(View.GONE);
            ll_no.setVisibility(View.GONE);
            ll_updata.setVisibility(View.GONE);
            tv_load.setVisibility(View.VISIBLE);
            yes.setClickable(false);
            yes.setTextColor(R.color.color_f4f4f4);
            no.setClickable(false);
            no.setTextColor(R.color.color_f4f4f4);
        } else if (message.equals("2")) {

        }

    }


}

