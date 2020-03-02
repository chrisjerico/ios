package com.phoenix.lotterys.view;

import android.app.Dialog;
import android.content.Context;
import android.os.Bundle;
import android.text.TextUtils;
import android.view.View;
import android.widget.ImageView;
import android.widget.TextView;

import com.phoenix.lotterys.R;import com.phoenix.lotterys.R2;
import com.phoenix.lotterys.home.bean.RedBagDetailBean;
import com.phoenix.lotterys.util.SPConstants;
import com.phoenix.lotterys.util.Uiutils;

public class RedBagDetilDialog extends Dialog {
    ImageView ivClose;
    RedBagDetailBean.DataBean data;
    Context context;

    TextView tvUser;
    TextView tvRedbagBalance;
    TextView tvRedbagCount;
    TextView tvOnceRob;
    TextView tvContent;
    private onItemClickListener mItemClickListener;
    private String user;

    public interface onItemClickListener {
        void onItemClick(Object object);
    }
    public RedBagDetilDialog(Context context, RedBagDetailBean.DataBean data,onItemClickListener onItemClickListener) {
        super(context, R.style.MyDialog);
        this.context = context;
        mItemClickListener = onItemClickListener;
        this.data = data;
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        setContentView(R.layout.dialog_redbag);
        //点击屏幕空白消失
        setCanceledOnTouchOutside(false);
        //点击返回键消失
        setCancelable(false);
        //初始化界面控件
        initView();
        //点击事件
        initEvent();
    }

    private void initView() {
        user = SPConstants.getValue(getContext(), SPConstants.SP_USERTYPE);
        ivClose = findViewById(R.id.iv_close);
        tvUser = findViewById(R.id.tv_user);
        tvRedbagBalance = findViewById(R.id.tv_redbag_balance);
        tvRedbagCount = findViewById(R.id.tv_redbag_count);
        tvOnceRob = findViewById(R.id.tv_once_rob);
        tvContent = findViewById(R.id.tv_content);
        if(user.equals("guest")||data.isIsTest()||!data.isHasLogin()){
            tvUser.setText("游客");
            tvOnceRob.setText("登录抢红包");
        }else {
            tvUser.setText(TextUtils.isEmpty(data.getUsername())?"":data.getUsername());
            if(!TextUtils.isEmpty(data.getCanGet())&&data.getCanGet().equals("0")&&data.getAttendedTimes().equals("1")){
                tvOnceRob.setText("已参与活动");
            }else /*if(!TextUtils.isEmpty(data.getCanGet())&&data.getCanGet().equals("1"))*/{
                tvOnceRob.setText("立即开抢");
            }
        }
        tvRedbagBalance.setText(data.getLeftAmount()==null?"":data.getLeftAmount());
        tvRedbagCount.setText(data.getLeftCount()==null?"":data.getLeftCount());
        tvContent.setText(data.getIntro()==null?"":data.getIntro().replace("<br />",""));
    }

    private void initEvent() {
        ivClose.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                dismiss();
            }
        });
        tvOnceRob.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
//                if(!TextUtils.isEmpty(data.getCanGet())&&data.getCanGet().equals("0"))
//                    return;
                    if(TextUtils.isEmpty(user)||user.equals("guest")||data.isIsTest()||user.equals("Null")||!data.isHasLogin()){
//                        context.startActivity(new Intent(context, LoginActivity.class));
                        Uiutils.login(getContext());
                    }else {
                        if(mItemClickListener!=null)
                        mItemClickListener.onItemClick(RedBagDetilDialog.this);
                    }
                dismiss();
            }
        });
    }
}
