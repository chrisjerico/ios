package com.phoenix.lotterys.view;

import android.app.Activity;
import android.content.Context;
import android.graphics.drawable.BitmapDrawable;

import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.PopupWindow;

import com.phoenix.lotterys.R;import com.phoenix.lotterys.R2;
import com.phoenix.lotterys.buyhall.adapter.MoneyAdapter;
import com.phoenix.lotterys.util.Uiutils;

import java.util.ArrayList;
import java.util.List;

public class MoneyPopupWindow extends PopupWindow {

    private Context context;
    private View view;
    private RecyclerView rvMoney;
    public List<String> list;
    public MoneyAdapter moneyAdapter;

    public MoneyPopupWindow(Context context) {
        this(context, ViewGroup.LayoutParams.WRAP_CONTENT, ViewGroup.LayoutParams.WRAP_CONTENT);
    }

    public MoneyPopupWindow(Context context, int with, int height) {
        this.context = context;
        setWidth(with);
        setHeight(height);
        //设置可以获得焦点
        setFocusable(true);
        //设置弹窗内可点击
        setTouchable(true);
        //设置弹窗外可点击
        setOutsideTouchable(true);
        setBackgroundDrawable(new BitmapDrawable());
        view = LayoutInflater.from(context).inflate(R.layout.popupwindow_money, null);
        setContentView(view);
        initData();
    }

    private void initData() {
        rvMoney = view.findViewById(R.id.rv_money);
        list = new ArrayList<>();
        list.add("10");
        list.add("100");
        list.add("1000");
        list.add("10000");
        list.add("清除");
        moneyAdapter = new MoneyAdapter(list, context);
        rvMoney.setAdapter(moneyAdapter);
        rvMoney.setLayoutManager(new LinearLayoutManager(context));
    }

    public void showLocation(View v) {
        view.measure(View.MeasureSpec.UNSPECIFIED, View.MeasureSpec.UNSPECIFIED);
        int measuredHeight = view.getMeasuredHeight();
        int[] location = new int[2];
        v.getLocationOnScreen(location);
        showAtLocation(v, Gravity.NO_GRAVITY, 300, location[1] - measuredHeight);
        if (context instanceof Activity)
        Uiutils.setStateColor((Activity) context);
    }
}
