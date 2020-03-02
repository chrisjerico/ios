package com.phoenix.lotterys.home.fragment;

import android.annotation.SuppressLint;

import androidx.fragment.app.Fragment;
import androidx.viewpager.widget.ViewPager;

import android.view.View;
import android.widget.TextView;

import com.flyco.tablayout.SlidingTabLayout;
import com.lzy.okgo.OkGo;
import com.lzy.okgo.model.Response;
import com.phoenix.lotterys.R;import com.phoenix.lotterys.R2;
import com.phoenix.lotterys.application.BaseFragments;
import com.phoenix.lotterys.home.bean.MessageEvent;
import com.phoenix.lotterys.my.adapter.TabPagerAdapter;
import com.phoenix.lotterys.my.bean.BaseBean;
import com.phoenix.lotterys.my.bean.UserInfo;
import com.phoenix.lotterys.my.bean.WalletBean;
import com.phoenix.lotterys.util.Constants;
import com.phoenix.lotterys.util.FormatNum;
import com.phoenix.lotterys.util.NetDialogCallBack;
import com.phoenix.lotterys.util.SPConstants;
import com.phoenix.lotterys.util.SecretUtils;
import com.phoenix.lotterys.util.ShareUtils;
import com.phoenix.lotterys.util.Uiutils;
import com.phoenix.lotterys.view.CustomTitleBar;

import org.greenrobot.eventbus.EventBus;

import java.io.IOException;
import java.net.URLDecoder;
import java.util.ArrayList;
import java.util.List;

import butterknife.BindView;
import butterknife.OnClick;

/**
 * Greated by Luke
 * on 2019/10/4
 */

/*额度转换 新界面*/
@SuppressLint("ValidFragment")
public class TransferNewFrament extends BaseFragments {

    @BindView(R2.id.titlebar)
    CustomTitleBar titlebar;
    @BindView(R2.id.tab_title)
    SlidingTabLayout tab_title;
    @BindView(R2.id.vp1)
    ViewPager vp;
    @BindView(R2.id.tv_name)
    TextView tvName;
    @BindView(R2.id.tv_money)
    TextView tvMoney;
    @BindView(R2.id.tv_realname)
    TextView tvRealname;
    private ArrayList<Fragment> mFragments = new ArrayList<>();
    private TabPagerAdapter mAdapter;
    boolean isHide = false;
    private final String[] mTitles = {"额度转换", "转换记录"};
    List<WalletBean.DataBean> data = new ArrayList<>();

    @SuppressLint("ValidFragment")
    public TransferNewFrament(boolean isHide) {
        super(R.layout.frament_new_transfer, true, true);
        this.isHide = isHide;
    }

    @Override
    public void initView(View view) {
        titlebar.setRightMove("", true);
        titlebar.setLeftIconOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                getActivity().finish();
            }
        });

        if (isHide)
            titlebar.setIvBackHide(View.GONE);

        mFragments.add(new TabTransferNewFrament(TransferNewFrament.this));
        mFragments.add(new LimitTransformNewFrament());
        mAdapter = new TabPagerAdapter(getChildFragmentManager(), mFragments, mTitles);
        vp.setAdapter(mAdapter);
        tab_title.setViewPager(vp, mTitles);
        Uiutils.setBarStye0(titlebar, getContext());
//        getUserInfo();

    }

    //获取登录信息
    public void getUserInfo() {
        String token = SPConstants.checkLoginInfo(getContext());
        OkGo.<String>get(URLDecoder.decode(Constants.BaseUrl() + Constants.USERINFO + SecretUtils.DESede(token) + "&sign=" + SecretUtils.RsaToken())).tag(getActivity()).execute(new NetDialogCallBack(getActivity(), true, getActivity(), true, UserInfo.class) {
            @Override
            public void onUi(Object o) throws IOException {
                UserInfo li = (UserInfo) o;
                if (li != null && li.getCode() == 0) {
                    ShareUtils.saveObject(getActivity(), SPConstants.USERINFO, li);
                    tvMoney.setText(FormatNum.amountFormat(li.getData().getBalance(), 4));
                    tvName.setText(li.getData().getUsr());
                    tvRealname.setText(li.getData().getFullName()!=null?li.getData().getFullName():"");
                }
            }

            @Override
            public void onErr(BaseBean bb) throws IOException {
            }

            @Override
            public void onFailed(Response<String> response) {
            }
        });
    }

    public void upData(boolean b) {
        UserInfo li = (UserInfo) ShareUtils.getObject(getContext(), SPConstants.USERINFO, UserInfo.class);
        tvMoney.setText(FormatNum.amountFormat(li.getData().getBalance(), 4));
        tvName.setText(li.getData().getUsr());
        tvRealname.setText(li.getData().getFullName()!=null?li.getData().getFullName():"");
        if(b)
            EventBus.getDefault().postSticky(new MessageEvent("userinfo"));
    }

    @OnClick({R.id.iv_refresh})
    public void onViewClicked(View view) {
        switch (view.getId()) {
            case R.id.iv_refresh:
                getUserInfo();
                break;
        }
    }

}
