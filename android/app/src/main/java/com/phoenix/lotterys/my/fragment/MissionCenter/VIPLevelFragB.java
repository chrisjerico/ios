package com.phoenix.lotterys.my.fragment.MissionCenter;

import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;
import android.view.View;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.phoenix.lotterys.R;import com.phoenix.lotterys.R2;
import com.phoenix.lotterys.application.BaseFragments;
import com.phoenix.lotterys.main.bean.ConfigBean;
import com.phoenix.lotterys.my.adapter.VIPLevelAdapter;
import com.phoenix.lotterys.my.bean.VIPLevelBean;
import com.phoenix.lotterys.util.Constants;
import com.phoenix.lotterys.util.GsonUtil;
import com.phoenix.lotterys.util.NetUtils;
import com.phoenix.lotterys.util.SPConstants;
import com.phoenix.lotterys.util.ShareUtils;
import com.phoenix.lotterys.util.SpacesItemDecoration;
import com.scwang.smartrefresh.layout.SmartRefreshLayout;
import com.wanxiangdai.commonlibrary.util.StringUtils;

import java.util.ArrayList;
import java.util.List;

import butterknife.BindView;

/**
 * 文件描述:  开心乐账变
 * 创建者: IAN
 * 创建时间: 2019/7/3 12:56
 */
public class VIPLevelFragB extends BaseFragments {

    @BindView(R2.id.name_tex)
    TextView nameTex;
    @BindView(R2.id.name_tex_lin)
    TextView nameTexLin;
    @BindView(R2.id.happiness_tex)
    TextView happinessTex;
    @BindView(R2.id.happiness_tex_lin)
    TextView happinessTexLin;
    @BindView(R2.id.happy_balance_tex)
    TextView happyBalanceTex;
    @BindView(R2.id.happy_balance_tex_lin)
    TextView happyBalanceTexLin;
    @BindView(R2.id.full_date_tex)
    TextView fullDateTex;
    @BindView(R2.id.accounting_rec)
    RecyclerView accountingRec;
    @BindView(R2.id.main_lin)
    LinearLayout mainLin;
    @BindView(R2.id.full_date_lin)
    LinearLayout fullDateLin;
    @BindView(R2.id.name_text1)
    TextView nameText1;
    @BindView(R2.id.happiness_tex0)
    TextView happinessTex0;
    @BindView(R2.id.mission_refresh)
    SmartRefreshLayout missionRefresh;

    public VIPLevelFragB() {
        super(R.layout.accounting_change_frag_b, true, true);
    }
    private ConfigBean configBean;
    private String name;
    @Override
    public void initView(View view) {

        configBean = (ConfigBean) ShareUtils.getObject(getContext(), SPConstants.CONFIGBEAN, ConfigBean.class);
        name = StringUtils.isEmpty(configBean.getData()
                .getMissionName())?"开心乐":configBean.getData()
                .getMissionName();

        missionRefresh.setEnableRefresh(false);//是否启用下拉刷新功能
        missionRefresh.setEnableLoadMore(false);//是否启用上拉加载功能

//        mainLin.setBackgroundColor(getContext().getResources().getColor(R.color.my_line));

        nameTexLin.setVisibility(View.GONE);
        happinessTexLin.setVisibility(View.GONE);
        happyBalanceTexLin.setVisibility(View.GONE);
        fullDateLin.setVisibility(View.GONE);

        nameTex.setText(R.string.level);
        happinessTex.setText(name+"头衔");
        happyBalanceTex.setText("成长"+name);

        LinearLayoutManager linearLayoutManager = new LinearLayoutManager(getContext());
        accountingRec.setLayoutManager(linearLayoutManager);
        accountingRec.addItemDecoration(new SpacesItemDecoration(getContext()));

         adapter = new VIPLevelAdapter(getContext(), list, R.layout.pubglidstye_b);
        accountingRec.setAdapter(adapter);
        
        getData();
    }
    private VIPLevelAdapter adapter;
    private List<VIPLevelBean.DataBean>  list =new ArrayList<>();
    private VIPLevelBean vipLevelBean;
    private void getData() {
        NetUtils.get(Constants.LEVELS,"", true, getContext(), new NetUtils.NetCallBack() {
            @Override
            public void onSuccess(String object) {
                vipLevelBean = GsonUtil.fromJson(object, VIPLevelBean.class);

                if (list.size()>0)
                    list.clear();

                if (null != vipLevelBean && null != vipLevelBean.getData() && vipLevelBean.getData().size() > 0) {
                    list.addAll(vipLevelBean.getData());
                }
                adapter.notifyDataSetChanged();
            }

            @Override
            public void onError() {

            }
        });

    }
}
