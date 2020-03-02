package com.phoenix.lotterys.home.fragment;

import android.annotation.SuppressLint;
import androidx.recyclerview.widget.RecyclerView;
import android.view.View;
import com.phoenix.lotterys.R;import com.phoenix.lotterys.R2;
import com.phoenix.lotterys.home.adapter.SimpleLotteryAdapter;
import com.phoenix.lotterys.main.bean.HomeGame;
import com.phoenix.lotterys.util.Uiutils;
import com.wanxiangdai.commonlibrary.base.BaseFragment;
import butterknife.BindView;

/**
 * Greated by Luke
 * on 2020/2/15
 */
@SuppressLint("ValidFragment")
public class SimpleLotteryFrament extends BaseFragment {
    HomeGame.DataBean.IconsBean.ListBean icons;
    @BindView(R2.id.rv_ticket)
    RecyclerView rvTicket;

    public SimpleLotteryFrament(HomeGame.DataBean.IconsBean.ListBean icons) {
        super(R.layout.simple_fragment_lottery, true, true);
        this.icons = icons;
    }
    public static SimpleLotteryFrament getInstance(HomeGame.DataBean.IconsBean.ListBean icons) {
        SimpleLotteryFrament sf = new SimpleLotteryFrament(icons);
        return sf;
    }

    @Override
    public void initView(View view) {
        SimpleLotteryAdapter Onelevel = new SimpleLotteryAdapter(icons,  getContext());
        rvTicket.setAdapter(Onelevel);
        if (rvTicket.getItemDecorationCount() == 0){
                Uiutils.setRec(getContext(), rvTicket, 4, R.color.my_line1);
        }
    }
}
