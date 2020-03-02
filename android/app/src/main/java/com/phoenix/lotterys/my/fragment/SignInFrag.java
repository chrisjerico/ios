package com.phoenix.lotterys.my.fragment;

import android.annotation.SuppressLint;
import android.graphics.Color;
import androidx.recyclerview.widget.GridLayoutManager;
import androidx.recyclerview.widget.RecyclerView;
import android.view.Gravity;
import android.view.KeyEvent;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.PopupWindow;
import android.widget.TextView;

import com.example.zhouwei.library.CustomPopWindow;
import com.phoenix.lotterys.R;import com.phoenix.lotterys.R2;
import com.phoenix.lotterys.application.BaseFragments;
import com.phoenix.lotterys.main.bean.ConfigBean;
import com.phoenix.lotterys.my.adapter.SignInAdapter;
import com.phoenix.lotterys.my.adapter.SignInPopAdapter;
import com.phoenix.lotterys.my.adapter.SignIntegralAdapter;
import com.phoenix.lotterys.my.bean.CheckinhistoryBean;
import com.phoenix.lotterys.my.bean.My_item;
import com.phoenix.lotterys.my.bean.SignInBean;
import com.phoenix.lotterys.util.Constants;
import com.phoenix.lotterys.util.GsonUtil;
import com.phoenix.lotterys.util.NetUtils;
import com.phoenix.lotterys.util.SPConstants;
import com.phoenix.lotterys.util.ShareUtils;
import com.phoenix.lotterys.util.SpacesItemDecoration;
import com.phoenix.lotterys.util.Uiutils;
import com.phoenix.lotterys.view.CustomTitleBar;
import com.wanxiangdai.commonlibrary.base.BaseActivity;
import com.wanxiangdai.commonlibrary.util.EvenBusUtil.Even;
import com.wanxiangdai.commonlibrary.util.EvenBusUtil.EvenBusCode;
import com.wanxiangdai.commonlibrary.util.EvenBusUtil.EvenBusUtils;
import com.wanxiangdai.commonlibrary.util.MeasureUtil;
import com.wanxiangdai.commonlibrary.util.StringUtils;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import butterknife.BindView;
import butterknife.OnClick;

/**
 * 文件描述: 签到
 * 创建者: IAN
 * 创建时间: 2019/7/13 12:37
 */
@SuppressLint("ValidFragment")
public class SignInFrag extends BaseFragments implements View.OnClickListener {


    @BindView(R2.id.titlebar)
    CustomTitleBar titlebar;
    @BindView(R2.id.sign_in_rec)
    RecyclerView signInRec;
    @BindView(R2.id.check_in_record_tex)
    TextView checkInRecordTex;
    @BindView(R2.id.gift_package_rec)
    RecyclerView giftPackageRec;
    @BindView(R2.id.days_tex)
    TextView daysTex;
    @BindView(R2.id.sign_immediately_tex)
    TextView signImmediatelyTex;
    @BindView(R2.id.check_bags_lin)
    LinearLayout checkBagsLin;

    private SignInAdapter adapter;
    private SignIntegralAdapter signIntegralAdapter;
    private SignInPopAdapter signInPopAdapter;
    private List<SignInBean.DataBean.CheckinListBean> list = new ArrayList<>();
    private List<SignInBean.DataBean.CheckinBonusBean> list1 = new ArrayList<>();
    private List<CheckinhistoryBean.DataBean> listPop = new ArrayList<>();

    private boolean isvariation;

    @SuppressLint("ValidFragment")
    public SignInFrag(boolean isHide) {
        super(R.layout.sign_in_frag, true, true);
        this.isHide = isHide;
    }

    private CustomPopWindow customPopWindow;
    private CustomPopWindow.PopupWindowBuilder popupWindowBuilder;
    private ConfigBean configBean;
    boolean isHide = false;

    @Override
    public void initView(View view) {
        ((BaseActivity) getActivity()).initImmersionBar2();
        configBean = (ConfigBean) ShareUtils.getObject(getContext(), SPConstants.CONFIGBEAN, ConfigBean.class);
        Uiutils.setBarStye(titlebar, getActivity());
        titlebar.setText("签到");
        titlebar.setBackgroundColor(Color.parseColor("#6987f5"));

        Uiutils.setRec(getContext(), giftPackageRec, 0);
        signIntegralAdapter = new SignIntegralAdapter(getContext(), list1, R.layout.
                sign_in_gift_package_adapter);
        giftPackageRec.setAdapter(signIntegralAdapter);

        signInRec.setLayoutManager(new GridLayoutManager(getActivity(), 4,
                GridLayoutManager.VERTICAL, false));
        signInRec.addItemDecoration(new SpacesItemDecoration(getContext(), 1));

        adapter = new SignInAdapter(getContext(), list, R.layout.sign_in_adapter);
        signInRec.setAdapter(adapter);

        setContentView();

        popupWindowBuilder = Uiutils.setPopSetting1(getContext(), contentView, MeasureUtil.dip2px(getContext()
                , 300), MeasureUtil.dip2px(getContext()
                , 400), true, false, 0.5f);





        repuestData();
//        signIn();
        if (isHide)
            titlebar.setIvBackHide(View.GONE);

//        Uiutils.setStateColor(getActivity());
    }


    private void signIn() {
//        用户签到（签到类型：0是签到，1是补签）
        Map<String, Object> map = new HashMap<>();
        map.put("token", Uiutils.getToken(getContext()));
        map.put("type", "1");
        map.put("date", "2019-7-16");

        NetUtils.post(Constants.CHECKIN, map, true, getContext(), new NetUtils.NetCallBack() {
            @Override
            public void onSuccess(String object) {

            }

            @Override
            public void onError() {

            }
        });
    }

    private SignInBean signInBean;

    private void repuestData() {
//        用户签到列表（签到类型：0是签到，1是补签）
        Map<String, Object> map = new HashMap<>();
        map.put("token", Uiutils.getToken(getContext()));

        NetUtils.get(Constants.CHECKINLIST, map, true,
                getContext(), new NetUtils.NetCallBack() {
                    @Override
                    public void onSuccess(String object) {
                        signInBean = GsonUtil.fromJson(object, SignInBean.class);

                        if (list.size() > 0)
                            list.clear();

                        if (null != signInBean && null != signInBean.getData() && null != signInBean.getData().
                                getCheckinList() && signInBean.getData().getCheckinList().size() > 0)
                            list.addAll(signInBean.getData().getCheckinList());
                        adapter.notifyDataSetChanged();

                        if (list1.size() > 0)
                            list1.clear();

//                        if (null!=configBean&&null!=configBean.getData()&&!StringUtils.isEmpty(configBean.getData().
//                                getCheckinSet5())){
//                            if (StringUtils.equals("0",configBean.getData().
//                                    getCheckinSet5())&&list1.size()>0){
//                                list1.remove(0);
//                            }
//                        }
//
//                        if (null!=configBean&&null!=configBean.getData()&&!StringUtils.isEmpty(configBean.getData().
//                                getCheckinSet7())){
//                            if (StringUtils.equals("0",configBean.getData().
//                                    getCheckinSet7())&&list1.size()>0){
//                                list1.remove(list1.size()-1);
//                            }
//                        }

                        if (null != signInBean && null != signInBean.getData() && null != signInBean.getData().
                                getCheckinBonus() && signInBean.getData().getCheckinBonus().size() > 0) {
                            for (int i = 0; i < signInBean.getData().getCheckinBonus().size(); i++) {
                                if (!StringUtils.isEmpty(signInBean.getData().getCheckinBonus().get(i).getSwitchX()) &&
                                        StringUtils.equals("1", signInBean.getData().getCheckinBonus().get(i).getSwitchX())) {
                                    SignInBean.DataBean.CheckinBonusBean checkinBonusBean = signInBean.getData().getCheckinBonus().get(i);
                                    checkinBonusBean.setPostinon(i);
                                    list1.add(checkinBonusBean);
                                }
                            }
                        }

                        if (list1.size() > 0) {
                            checkBagsLin.setVisibility(View.VISIBLE);
                        } else {
                            checkBagsLin.setVisibility(View.GONE);
                        }

                        signIntegralAdapter.notifyDataSetChanged();

                        if (null != signInBean && null != signInBean.getData())
                            daysTex.setText(signInBean.getData().getCheckinTimes() + "");


                        if (null != signInBean && null != signInBean.getData())
                            if (StringUtils.isEmpty(signInBean.getData().getCheckinMoney())) {
                                day_num_tex.setText("已经连续签到0" + "天");
                            } else {
                                day_num_tex.setText("已经连续签到" + signInBean.getData().getCheckinTimes() + "天");
                            }

                        if (null != signInBean && null != signInBean.getData()) {
                            if (StringUtils.isEmpty(signInBean.getData().getCheckinMoney())) {
                                integral_and_tex.setText("累计积分0" + "分");
                            } else {
                                integral_and_tex.setText("累计积分" + signInBean.getData().getCheckinMoney() + "分");
                            }
                        }


                        if (null != signInBean && null != signInBean.getData() && !signInBean.getData()
                                .isCheckinSwitch()) {
                            contentView = LayoutInflater.from(getContext()).inflate(R.layout.revoke_pop, null);
                            contentView.findViewById(R.id.clear_tex).setVisibility(View.GONE);
                            contentView.findViewById(R.id.commit_tex).setOnClickListener(new View.OnClickListener() {
                                @Override
                                public void onClick(View v) {
                                    if (!isHide)
                                        getActivity().finish();
                                }
                            });
                            ((TextView) contentView.findViewById(R.id.title_tex)).setText(R.string.message_content);
                            ((TextView) contentView.findViewById(R.id.context_tex)).setText("暂未开启此功能");

                            popupWindowBuilder = Uiutils.setPopSetting1(getContext(), contentView,
                                    MeasureUtil.dip2px(getContext(), 300),
                                    ViewGroup.LayoutParams.WRAP_CONTENT,
                                    true, true, 0.5f);

                            CustomPopWindow mCustomPopWindow = popupWindowBuilder.create();
                            mCustomPopWindow.getPopupWindow().setOnDismissListener(new PopupWindow.OnDismissListener() {
                                @Override
                                public void onDismiss() {
                                    if (!isHide)
                                    getActivity().finish();
                                }
                            });

                            mCustomPopWindow.showAtLocation(contentView, Gravity.CENTER, 0, 0);
                            ((BaseActivity) getActivity()).initImmersionBar2();
                        }
                    }

                    @Override
                    public void onError() {
                    }
                });

    }

    private RecyclerView signInFragPopRec;
    private View signPopLin;

    private TextView integral_and_tex;
    private TextView day_num_tex;

    private void setContentView() {
        contentView = LayoutInflater.from(getContext()).inflate(R.layout.sign_in_frag_pop, null);

        signInFragPopRec = contentView.findViewById(R.id.sign_in_frag_pop_rec);
        integral_and_tex = contentView.findViewById(R.id.integral_and_tex);
        day_num_tex = contentView.findViewById(R.id.day_num_tex);
        signPopLin = contentView.findViewById(R.id.sign_pop_lin);
        ((ImageView) contentView.findViewById(R.id.clean_img)).setOnClickListener(this);

        signPopLin.setLayoutParams(new LinearLayout.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT,
                MeasureUtil.dip2px(getContext(), 44)));

        Uiutils.setRec(getContext(), signInFragPopRec, 1);

        signInPopAdapter = new SignInPopAdapter(getContext(), listPop, R.layout.sign_pop_lay);
        signInFragPopRec.setAdapter(signInPopAdapter);

    }

    private View contentView;

    @OnClick(R.id.check_in_record_tex)
    public void onClick() {
        getCheckinhistory();

    }

    private CheckinhistoryBean checkinhistoryBean;

    private void getCheckinhistory() {
        setContentView();
        Map<String, Object> map = new HashMap<>();
        map.put("token", Uiutils.getToken(getContext()));

        NetUtils.get(Constants.CHECKINHISTORY, map, true, getContext(),
                new NetUtils.NetCallBack() {
                    @Override
                    public void onSuccess(String object) {
                        checkinhistoryBean = Uiutils.stringToObject(object, CheckinhistoryBean.class);

                        if (listPop.size() > 0)
                            listPop.clear();

                        if (null != checkinhistoryBean && null != checkinhistoryBean.getData() &&
                                checkinhistoryBean.getData().size() > 0)
                            listPop.addAll(checkinhistoryBean.getData());

                        adapter.notifyDataSetChanged();

                        popupWindowBuilder.enableBackgroundDark(true);
                        customPopWindow = popupWindowBuilder.create();
                        customPopWindow.showAtLocation(contentView, Gravity.CENTER, 0, 0);
                        ((BaseActivity) getActivity()).initImmersionBar2();

                    }

                    @Override
                    public void onError() {

                    }
                });


    }

    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.clean_img:
                if (null != customPopWindow) {
                    customPopWindow.dissmiss();
                    ((BaseActivity) getActivity()).initImmersionBar2();
//                    Uiutils.setStateColor(getActivity());
                }
                break;
            case R.id.sign_immediately_tex:

                if (!StringUtils.isEmpty(signImmediatelyTex.getText().toString()) && StringUtils.equals(
                        "今日已签", signImmediatelyTex.getText().toString()
                ))
                    return;


                if (null != configBean && null != configBean.getData() && StringUtils.isEmpty(
                        configBean.getData().getCheckinRechargeDay()) &&
                        null != signInBean && null != signInBean.getData() && StringUtils.isEmpty(
                        signInBean.getData().getCheckinMoney())) {

                    if (Integer.parseInt(signInBean.getData().getCheckinMoney()) <
                            Integer.parseInt(configBean.getData().getCheckinRechargeDay())) {

                        contentView = LayoutInflater.from(getContext()).inflate(R.layout.revoke_pop, null);
                        contentView.findViewById(R.id.clear_tex).setVisibility(View.GONE);
                        contentView.findViewById(R.id.commit_tex).setOnClickListener(this);
                        ((TextView) contentView.findViewById(R.id.title_tex)).setText(R.string.message_content);
                        TextView contextTex00 = ((TextView) contentView.findViewById(R.id.context_tex));
                        contextTex00.setText("您的日存款金额未满足签到条件，今日存款金额需达到" +
                                configBean.getData().getCheckinRechargeDay() + "元");

                        popupWindowBuilder = Uiutils.setPopSetting1(getContext(), contentView,
                                MeasureUtil.dip2px(getContext(), 300),
                                ViewGroup.LayoutParams.WRAP_CONTENT,
                                true, true, 0.5f);

                        popupWindowBuilder.enableBackgroundDark(true);
                        customPopWindow = popupWindowBuilder.create();
                        customPopWindow.showAtLocation(contentView, Gravity.CENTER, 0, 0);
                        ((BaseActivity) getActivity()).initImmersionBar2();
                        return;
                    }
                }
                isSignImmediately = true;
                goCheckin(0, dates);
                break;
            case R.id.commit_tex:
                customPopWindow.dissmiss();
                ((BaseActivity) getActivity()).initImmersionBar2();
//                Uiutils.setStateColor(getActivity());
                break;
        }
    }

    @Override
    public void onResume() {
        super.onResume();
        getFocus();
    }

    //主界面获取焦点
    private void getFocus() {
        getView().setFocusableInTouchMode(true);
        getView().requestFocus();
        getView().setOnKeyListener(new View.OnKeyListener() {
            @Override
            public boolean onKey(View v, int keyCode, KeyEvent event) {
                if (event.getAction() == KeyEvent.ACTION_UP && keyCode == KeyEvent.KEYCODE_BACK) {
                    // 监听到返回按钮点击事件
                    if (!isHide)
                        getActivity().finish();
                    return true;
                }
                return false;
            }
        });
    }

    private String dates;
    private boolean isSignImmediately;

    @Override
    public void getEvenMsg(Even even) {
        switch (even.getCode()) {
            case EvenBusCode.SIGN_IN:
                My_item my_item = (My_item) even.getData();
                if (null == my_item) return;
                goCheckin(my_item.getImg(), my_item.getTitle());
                break;
            case EvenBusCode.GO_SIGN:
                signImmediatelyTex.setText("马上签到");
                dates = (String) even.getData();
                signImmediatelyTex.setOnClickListener(this);
                break;
            case EvenBusCode.ATTENDANCE_BRUSH_DATA:
                repuestData();

                break;
        }
    }

    /**
     * 签到补签到
     *
     * @param type
     */
    private void goCheckin(int type, String date) {
        if (!Uiutils.isFastClick())
            return;

        Map<String, Object> map = new HashMap<>();
        map.put("type", type + "");
        map.put("date", date);
        map.put("token", Uiutils.getToken(getContext()));

        NetUtils.post(Constants.CHECKIN, map, true, getContext(), new NetUtils.NetCallBack() {
            @Override
            public void onSuccess(String object) {
                if (isSignImmediately) {
                    isSignImmediately = false;
                    dates = "";
                    signImmediatelyTex.setText("今日已签");
                }
                repuestData();
                if (null != adapter)
                    adapter.setMinDate("");

                isvariation = true;
            }

            @Override
            public void onError() {
            }
        });
    }

    @Override
    public void onDestroy() {
        if (isvariation)
            EvenBusUtils.setEvenBus(new Even(EvenBusCode.INTEGRAL_CHANGE));

        super.onDestroy();
    }


    protected void onTransformResume() {
        initView(null);
    }
}
