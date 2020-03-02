package com.phoenix.lotterys.view;

import android.app.Activity;
import android.app.Dialog;
import android.graphics.Color;
import android.os.Bundle;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.phoenix.lotterys.R;import com.phoenix.lotterys.R2;
import com.phoenix.lotterys.home.adapter.HomeDialogAdapter;
import com.phoenix.lotterys.home.bean.NoticeBean;
import com.phoenix.lotterys.util.ShareUtils;
import com.wanxiangdai.commonlibrary.util.DividerGridItemDecoration;
import com.wanxiangdai.commonlibrary.util.ScreenUtils;

import java.util.List;

public class HomeDialog extends Dialog {
    LinearLayout ll_notice;
    RelativeLayout rlMain;
    ImageView ivClose;
    TextView titleTex;
//    ImageView ivClose;
    RecyclerView rvHome;
    Activity context;
    TextView tvClose;
    HomeDialogAdapter homeDialogAdapter;
    List<NoticeBean.DataBean.PopupBean> list;
    private long mLastClickTime = 0;
    public static final long TIME_INTERVAL = 400L;

    public HomeDialog(Activity context, List<NoticeBean.DataBean.PopupBean> list) {
        super(context, R.style.MyDialog);
        this.context = context;
        this.list = list;
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        setContentView(R.layout.dialog_home);
        //点击屏幕空白消失
        setCanceledOnTouchOutside(false);
        //点击返回键消失
        setCancelable(false);
        //初始化界面控件
        initView();
        //点击事件
        initEvent();

        setv();

//        Window dialogWindow = getWindow();
//        WindowManager.LayoutParams lp = dialogWindow.getAttributes();
//        DisplayMetrics d = context.getResources().getDisplayMetrics(); // 获取屏幕宽、高用
//
//        lp.width = (int) (d.widthPixels * 0.8); // 宽度设置为屏幕的0.8
//        dialogWindow.setAttributes(lp);
    }

    public void setv(){
//        Log.e("setv..","//");
        if ( 0!= ShareUtils.getInt(context, "ba_top", 0)){
            titleTex.setBackgroundColor(context.getResources().getColor(
                    ShareUtils.getInt(context, "ba_top", 0)));
            tvClose.setTextColor(context.getResources().getColor(
                    ShareUtils.getInt(context, "ba_top", 0)));
        }
    }

    public void initView() {

        rlMain = findViewById(R.id.rl_main);
//        rlMain.getViewTreeObserver().addOnGlobalLayoutListener(mainTreeLis);

        tvClose = findViewById(R.id.tv_close);
        titleTex = findViewById(R.id.title_tex);
        ivClose = findViewById(R.id.iv_close);
        rvHome = findViewById(R.id.rv_home);

        int maxHeight = (ScreenUtils.getScreenHeight(context) * 7) / 10;
        ViewGroup.LayoutParams pms = rvHome.getLayoutParams();
        pms.height = maxHeight;
        rvHome.setLayoutParams(pms);

        rvHome.setLayoutManager(new LinearLayoutManager(context));
        homeDialogAdapter = new HomeDialogAdapter(list, context);
        rvHome.setAdapter(homeDialogAdapter);
        rvHome.addItemDecoration(new DividerGridItemDecoration(context,
                DividerGridItemDecoration.HORIZONTAL_LIST, 2, Color.rgb(243, 243, 243)));
        rvHome.getItemAnimator().setChangeDuration(300);
        rvHome.getItemAnimator().setMoveDuration(300);
        homeDialogAdapter.setListener(new HomeDialogAdapter.OnClickListener() {
            @Override
            public void onClickListener(View view, int position) {
                long nowTime = System.currentTimeMillis();
                if (nowTime - mLastClickTime > TIME_INTERVAL) {
                    mLastClickTime = nowTime;
                    if (list.get(position).isOpen()) {
                        list.get(position).setOpen(false);
                    } else {
                        list.get(position).setOpen(true);
                    }
                    homeDialogAdapter.notifyItemChanged(position);
                }
            }
        });

//        if(BuildConfig.FLAVOR.equals("c200")){
//        }else if(BuildConfig.FLAVOR.equals("c134")){
//        }else {
//            rlMain.setBackgroundColor(0);
//        }
    }

    private void initEvent() {
        tvClose.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if(homeDialogAdapter!=null)
                homeDialogAdapter.cancelAllWebview();
                dismiss();
            }
        });
        ivClose.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if(homeDialogAdapter!=null)
                homeDialogAdapter.cancelAllWebview();
                dismiss();
            }
        });
    }

    @Override
    public void dismiss() {
        super.dismiss();
//        rlMain.getViewTreeObserver().removeOnGlobalLayoutListener(mainTreeLis);
    }

//    private ViewTreeObserver.OnGlobalLayoutListener mainTreeLis = new ViewTreeObserver.OnGlobalLayoutListener() {
//        @Override
//        public void onGlobalLayout() {
//            int height = rlMain.getMeasuredHeight();
//            int maxHeight = (ScreenUtils.getScreenHeight(context) * 9) / 10;
//            if (height > maxHeight) {
//                rlMain.getViewTreeObserver().removeOnGlobalLayoutListener(this);
//                ViewGroup.LayoutParams pms = rlMain.getLayoutParams();
//                pms.height = maxHeight;
//                rlMain.setLayoutParams(pms);
//            }
//        }
//    };
}
