package com.phoenix.lotterys.application;

import android.graphics.Rect;
import android.text.Editable;
import android.text.TextWatcher;
import android.view.View;
import android.view.ViewTreeObserver;
import android.widget.EditText;

import com.lzy.okgo.OkGo;
import com.wanxiangdai.commonlibrary.base.BaseActivity;

/**
 * Greated by Luke
 * on 2019/8/27
 */
public class BaseActivitys extends BaseActivity {

    public BaseActivitys(int layoutResID) {
        super(layoutResID);
    }

    public BaseActivitys(boolean isGame,int layoutResID) {
        super(isGame,layoutResID);
    }

    public BaseActivitys(int layoutResID, boolean isButterKnife,boolean isOpenEvenBus) {
        super(layoutResID);
        super.isButterKnife = isButterKnife;
        super.isOpenEvenBus = isOpenEvenBus;
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        OkGo.getInstance().cancelTag(this);
    }

    public void setEdit(EditText etMoney, View llBt) {
        etMoney.addTextChangedListener(new TextWatcher() {
            @Override
            public void beforeTextChanged(CharSequence s, int start, int count, int after) {

            }

            @Override
            public void onTextChanged(CharSequence s, int start, int before, int count) {
                if (s.toString().startsWith(".")) {
                    etMoney.setText("");
                }
            }

            @Override
            public void afterTextChanged(Editable s) {

            }
        });
        etMoney.getViewTreeObserver().addOnGlobalLayoutListener(new ViewTreeObserver.OnGlobalLayoutListener() {
            @Override
            public void onGlobalLayout() {
                Rect r = new Rect();
                BaseActivitys.this.getWindow().getDecorView().getWindowVisibleDisplayFrame(r);
                int screenHeight = BaseActivitys.this.getWindow().getDecorView().getRootView().getHeight();
                int heightDifference = screenHeight - r.bottom;
                if (heightDifference < 500) {
                    llBt.setVisibility(View.VISIBLE);
                } else {
                    llBt.setVisibility(View.GONE);
                }
            }
        });
    }
}
