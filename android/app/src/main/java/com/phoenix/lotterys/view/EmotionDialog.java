package com.phoenix.lotterys.view;

import android.app.Activity;
import android.app.Dialog;
import android.os.Bundle;
import androidx.recyclerview.widget.GridLayoutManager;
import androidx.recyclerview.widget.RecyclerView;
import android.view.View;

import com.phoenix.lotterys.R;import com.phoenix.lotterys.R2;
import com.phoenix.lotterys.home.adapter.EmotionAdapter;

import java.util.List;

public class EmotionDialog extends Dialog {
    Activity context;
    RecyclerView rvEmotion;
//    RelativeLayout rl_main;
    List<String> imgPath;
    private ClickListenerInterface clickListenerInterface;
    public interface ClickListenerInterface {
        void doConfirm(String emotion);
    }
    public void setClicklistener(ClickListenerInterface clickListenerInterface) {
        this.clickListenerInterface = clickListenerInterface;
    }
    public EmotionDialog(Activity context, List<String> imgPath) {
        super(context, R.style.MyDialog1);
        this.context = context;
        this.imgPath = imgPath;
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        setContentView(R.layout.dialog_emotion);
        //点击屏幕空白消失
        setCanceledOnTouchOutside(true);
        //点击返回键消失
        setCancelable(true);
        //初始化界面控件
        initView();
        //点击事件
    }


    private void initView() {

        rvEmotion = findViewById(R.id.rv_Emotion);  //
//        rl_main = findViewById(R.id.rl_main);  //

        EmotionAdapter emotion = new EmotionAdapter( getContext(),imgPath);
        rvEmotion.setLayoutManager(new GridLayoutManager(getContext(), 15));
        rvEmotion.setAdapter(emotion);
//        if (rvEmotion.getItemDecorationCount() == 0) {
//            rvEmotion.addItemDecoration(new DividerGridItemDecoration(getContext(),
//                    DividerGridItemDecoration.BOTH_SET, 5, 0));
//        }
        emotion.setListener(new EmotionAdapter.OnClickListener() {
            @Override
            public void onClickListener(View view, int position) {
                clickListenerInterface.doConfirm("[em_"+position+"]");
                dismiss();
            }
        });

//        rl_main.setOnClickListener(new View.OnClickListener() {
//            @Override
//            public void onClick(View v) {
//                dismiss();
//            }
//        });

    }


}
