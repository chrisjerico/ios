package com.phoenix.lotterys.my.fragment;

import androidx.viewpager.widget.PagerAdapter;
import androidx.viewpager.widget.ViewPager;

import android.view.View;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;

//import com.bm.library.PhotoView;
import com.bumptech.glide.Glide;
import com.phoenix.lotterys.R;import com.phoenix.lotterys.R2;
import com.phoenix.lotterys.util.Uiutils;
import com.phoenix.lotterys.view.CustomTitleBar;
import com.wanxiangdai.commonlibrary.base.BaseFragment;
import com.wanxiangdai.commonlibrary.util.ImageLoadUtil;
import com.wanxiangdai.commonlibrary.util.StringUtils;

import java.util.ArrayList;
import java.util.List;

import butterknife.BindView;
import butterknife.OnClick;

/**
 * 文件描述:
 * 创建者: IAN
 * 创建时间: 2019/12/8 12:45
 */
public class LoadImgFrag extends BaseFragment {

    @BindView(R2.id.title)
    TextView title;
    @BindView(R2.id.view_pager)
    ViewPager viewPager;
    @BindView(R2.id.titlebar)
    CustomTitleBar titlebar;
    @BindView(R2.id.main_lin)
    LinearLayout mainLin;

    public LoadImgFrag() {
        super(R.layout.load_lmg_frag, true, true);
    }

    private List<ImageView> pageview = new ArrayList<ImageView>();

    private List<String> list =new ArrayList<>();
    private int position;
    @Override
    public void initView(View view) {
        list =getArguments().getStringArrayList("list");
        position =getArguments().getInt("position");

        titlebar.setVisibility(View.GONE);
        Uiutils.setBarStye(titlebar, getActivity());
        if (null!=list&&list.size()>0) {
            for (int i = 0; i < list.size(); i++) {
                View view1 = getLayoutInflater().inflate(R.layout.img, null);
                ImageView  imageView = view1.findViewById(R.id.img_lay);
//                imageView.enable();

                imageView.setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View v) {
                        getActivity().finish();
                    }
                });
                if (!StringUtils.isEmpty(list.get(i))){
//                        ImageLoadUtil.ImageLoad(getContext(), ((String) list.get(i)),imageView
//                                ,R.drawable.err,true);

                    Glide.with(getActivity()).load( list.get(i)).into(imageView);
                    }else {
                        ImageLoadUtil.ImageLoad(getContext(),R.drawable.err,imageView);
                    }

                pageview.add(imageView);
            }
            title.setText(position+1 + "/" + list.size());
        }

        viewPager.setAdapter(mPagerAdapter);

        viewPager.setOnPageChangeListener(new ViewPager.OnPageChangeListener() {
            @Override
            public void onPageScrolled(int i, float v, int i1) {

            }

            @Override
            public void onPageSelected(int i) {
                title.setText(i+1 + "/" + list.size());
            }

            @Override
            public void onPageScrollStateChanged(int i) {

            }
        });
    }

    private PagerAdapter mPagerAdapter = new PagerAdapter() {

        @Override
        public int getCount() {
            // TODO Auto-generated method stub
            return pageview.size();
        }

        @Override
        public boolean isViewFromObject(View arg0, Object arg1) {
            // TODO Auto-generated method stub
            return arg0 == arg1;
        }

        public void destroyItem(View arg0, int arg1, Object arg2) {
            ((ViewPager) arg0).removeView(pageview.get(arg1));
        }

        public Object instantiateItem(View arg0, int arg1) {
            ((ViewPager) arg0).addView(pageview.get(arg1));
            return pageview.get(arg1);
        }
    };

    @OnClick({R.id.main_lin})
    public void onClick(View view) {
                    getActivity().finish();

    }
}
