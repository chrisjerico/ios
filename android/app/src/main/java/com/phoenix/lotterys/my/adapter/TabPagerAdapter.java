package com.phoenix.lotterys.my.adapter;

import androidx.fragment.app.Fragment;
import androidx.fragment.app.FragmentManager;
import androidx.fragment.app.FragmentPagerAdapter;

import java.util.ArrayList;

/**
 * Date:2019/3/5
 * TIME:14:03
 * author：Luke
 */
public class TabPagerAdapter extends FragmentPagerAdapter {
    private ArrayList<Fragment> mFragments;
    private  String[] mTitles;
    public TabPagerAdapter(FragmentManager fm, ArrayList<Fragment> mFragments, String[] mTitles) {
        super(fm);
        this.mFragments =mFragments;
        this.mTitles =mTitles;
    }
    public TabPagerAdapter(FragmentManager fm, ArrayList<Fragment> mFragments) {
        super(fm);
        this.mFragments =mFragments;
    }
    @Override
    public int getCount() {
        return mFragments.size();
    }

    @Override
    public CharSequence getPageTitle(int position) {
        return mTitles[position];
    }

    @Override
    public Fragment getItem(int position) {
        return mFragments.get(position);
    }
}
