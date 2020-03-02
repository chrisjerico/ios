package com.phoenix.lotterys.home.adapter;

import android.content.Context;
import android.graphics.Typeface;
import androidx.fragment.app.Fragment;
import androidx.fragment.app.FragmentManager;
import androidx.fragment.app.FragmentPagerAdapter;

import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.ImageView;
import android.widget.TextView;

import com.phoenix.lotterys.R;import com.phoenix.lotterys.R2;
import com.phoenix.lotterys.main.bean.HomeGame;
import com.phoenix.lotterys.view.SignViewPager;
import com.wanxiangdai.commonlibrary.util.ImageLoadUtil;

import java.util.List;

/**
 * Created by Ykai on 2018/11/23.
 */

public class MyViewpagerPagerAdapter extends FragmentPagerAdapter {
    private List<Fragment> fragmentList;
    private Context context;
    private SignViewPager signViewPager;
    HomeGame gametype;
    //    List<String> type;
    int i = 0;
    int isShowImg = 0;
    private FragmentManager fm;

    public MyViewpagerPagerAdapter(FragmentManager fm, List<Fragment> list, Context context, HomeGame gametype) {
        super(fm);
        this.fm = fm;
        fragmentList = list;
        this.context = context;
        this.gametype = gametype;

    }

    public MyViewpagerPagerAdapter(FragmentManager fm, List<Fragment> list, Context context, HomeGame gametype, int isShowImg) {
        super(fm);
        this.fm = fm;
        fragmentList = list;
        this.context = context;
        this.gametype = gametype;
        this.isShowImg = isShowImg;

    }

    public void setSignViewPager(SignViewPager signViewPager) {
        this.signViewPager = signViewPager;
    }

    @Override
    public Fragment getItem(int position) {
        return fragmentList.get(position);
    }

    @Override
    public int getCount() {
        return fragmentList.size();
    }


    public View getCustomView(int position) {
        View view = LayoutInflater.from(context).inflate(isShowImg ==1?R.layout.simple_tab_item:R.layout.tab_item, null);
        ImageView iv = view.findViewById(R.id.iv_icon);
        TextView tv = view.findViewById(R.id.tv_name);
        tv.setText(gametype.getData().getIcons().get(position).getName());
//        if (Uiutils.isSite("c200")){

        if (isShowImg == 1) {
            if (!TextUtils.isEmpty(gametype.getData().getIcons().get(position).getLogo())) {
                ImageLoadUtil.ImageLoad(gametype.getData().getIcons().get(position).getLogo(), context, iv, "");
            } else {
                ImageLoadUtil.ImageLoad(context, R.drawable.load_img, iv, R.drawable.load_img);
            }
        } else {
            tv.setTypeface(Typeface.defaultFromStyle(Typeface.BOLD));
        }

        return view;
    }

    @Override
    public int getItemPosition(Object object) {
        return POSITION_NONE;
    }

    @Override
    public long getItemId(int position) {
        return fragmentList.get(position).hashCode();
    }

}
