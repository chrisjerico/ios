package com.phoenix.lotterys.my.fragment;

import android.animation.ObjectAnimator;
import android.annotation.SuppressLint;
import android.content.ClipboardManager;
import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.Color;
import androidx.annotation.NonNull;
import androidx.fragment.app.FragmentManager;
import androidx.fragment.app.FragmentTransaction;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;
import android.util.Log;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.CompoundButton;
import android.widget.EditText;
import android.widget.FrameLayout;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.ProgressBar;
import android.widget.RelativeLayout;
import android.widget.Switch;
import android.widget.TextView;

import com.example.zhouwei.library.CustomPopWindow;
import com.phoenix.lotterys.R;import com.phoenix.lotterys.R2;
import com.phoenix.lotterys.application.BaseFragments;
import com.phoenix.lotterys.main.FragmentUtilAct;
import com.phoenix.lotterys.main.bean.ConfigBean;
import com.phoenix.lotterys.my.adapter.CityPopAdapter;
import com.phoenix.lotterys.my.adapter.RecommenAdapter;
import com.phoenix.lotterys.my.adapter.RecommendInformationAdapter;
import com.phoenix.lotterys.my.bean.My_item;
import com.phoenix.lotterys.my.bean.RecommendBean;
import com.phoenix.lotterys.my.bean.RecommendBenefitBean;
import com.phoenix.lotterys.my.bean.UserInfo;
import com.phoenix.lotterys.my.fragment.recommend.RecommendInformationFrag;
import com.phoenix.lotterys.util.Constants;
import com.phoenix.lotterys.util.GsonUtil;
import com.phoenix.lotterys.util.NetUtils;
import com.phoenix.lotterys.util.SPConstants;
import com.phoenix.lotterys.util.ShareUtils;
import com.phoenix.lotterys.util.SpacesItemDecoration;
import com.phoenix.lotterys.util.Uiutils;
import com.phoenix.lotterys.util.ZXingUtils;
import com.phoenix.lotterys.util.recyclerUtil.BaseRecyclerAdapter;
import com.phoenix.lotterys.view.CustomTitleBar;
import com.phoenix.lotterys.view.DynamicWave;
import com.scwang.smartrefresh.layout.SmartRefreshLayout;
import com.scwang.smartrefresh.layout.api.RefreshLayout;
import com.scwang.smartrefresh.layout.listener.OnLoadMoreListener;
import com.scwang.smartrefresh.layout.listener.OnRefreshListener;
import com.wanxiangdai.commonlibrary.util.EvenBusUtil.Even;
import com.wanxiangdai.commonlibrary.util.EvenBusUtil.EvenBusCode;
import com.wanxiangdai.commonlibrary.util.ImageLoadUtil;
import com.wanxiangdai.commonlibrary.util.MeasureUtil;
import com.wanxiangdai.commonlibrary.util.StringUtils;
import com.wanxiangdai.commonlibrary.util.ToastUtil;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import butterknife.BindView;
import butterknife.OnClick;

import static com.phoenix.lotterys.util.ShowItem.subZeroAndDot;

/**
 * 文件描述:推荐受益
 * 创建者: IAN
 * 创建时间: 2019/8/22 20:20
 */
@SuppressLint("ValidFragment")
public class RecommendBenefitFrag extends BaseFragments implements BaseRecyclerAdapter.OnItemClickListener
        , OnRefreshListener, OnLoadMoreListener, View.OnClickListener , CompoundButton.OnCheckedChangeListener{

    @BindView(R2.id.titlebar)
    CustomTitleBar titlebar;
    @BindView(R2.id.d_wave)
    DynamicWave dWave;
    @BindView(R2.id.iv_img)
    ImageView ivImg;
    @BindView(R2.id.tv_name)
    TextView tvName;
    @BindView(R2.id.tv_userParentId)
    TextView tvUserParentId;
    @BindView(R2.id.tv_money)
    TextView tvMoney;
    @BindView(R2.id.iv_refresh)
    ImageView ivRefresh;
    @BindView(R2.id.ll_user)
    LinearLayout llUser;
    @BindView(R2.id.tv_integral)
    TextView tvIntegral;
    @BindView(R2.id.rl_userInfo)
    RelativeLayout rlUserInfo;
    @BindView(R2.id.tv_grow)
    TextView tvGrow;
    @BindView(R2.id.iv_task)
    ImageView ivTask;
    @BindView(R2.id.ll_level)
    LinearLayout llLevel;
    @BindView(R2.id.progress1)
    ProgressBar progress1;
    @BindView(R2.id.iv_sign)
    ImageView ivSign;
    @BindView(R2.id.horizontal_rec)
    RecyclerView horizontalRec;
    @BindView(R2.id.framnent_lin)
    FrameLayout framnentLin;
    @BindView(R2.id.vip_tex)
    TextView vipTex;
    @BindView(R2.id.name_text1)
    TextView nameText1;
    @BindView(R2.id.name_text2)
    TextView nameText2;
    @BindView(R2.id.name_text3)
    TextView nameText3;
    @BindView(R2.id.name_text4)
    TextView nameText4;
    @BindView(R2.id.name_text5)
    TextView nameText5;
    @BindView(R2.id.main_lin)
    LinearLayout mainLin;
    @BindView(R2.id.pub_project_rec)
    RecyclerView pubProjectRec;
    @BindView(R2.id.iv_refresh_layout)
    SmartRefreshLayout smartRefreshLayout;
    @BindView(R2.id.project_lin)
    LinearLayout projectLin;
    @BindView(R2.id.name_text1_lin)
    LinearLayout nameText1Lin;
    @BindView(R2.id.name_text6)
    TextView nameText6;
    @BindView(R2.id.name_text1_lin0)
    LinearLayout nameText1Lin0;
    @BindView(R2.id.not_data_tex)
    TextView notDataTex;
    @BindView(R2.id.main_rel)
    RelativeLayout mainRel;


//推荐信息
    @BindView(R2.id.my_name_tex)
    TextView myNameTex;
    @BindView(R2.id.my_id_tex)
    TextView myIdTex;
    @BindView(R2.id.recommend_img)
    ImageView recommendImg;
    @BindView(R2.id.commission_rate_tex)
    TextView commissionRateTex;
    @BindView(R2.id.money_tex)
    TextView moneyTex;
    @BindView(R2.id.recommended_members_tex)
    TextView recommendedMembersTex;
    @BindView(R2.id.recommended_members_tex1)
    TextView recommendedMembersTex1;
    @BindView(R2.id.main_lin0)
    LinearLayout main_lin0;
    @BindView(R2.id.tv_sample)
    TextView tvSample;
    View mainView ;
    private RecommenAdapter adapter;

    private RecommendInformationFrag recommendInformationFrag;
    boolean isHide = false;

    @SuppressLint("ValidFragment")
    public RecommendBenefitFrag(boolean isHide) {
        super(R.layout.recommend_benefit_frag, true,
                true);
        this.isHide = isHide;
    }

    public static RecommendBenefitFrag getInstance(boolean isHide) {
        return new RecommendBenefitFrag(isHide);
    }

    private int selePostion;  //当前选中

    private UserInfo userInfo;

    private String[] arrayString;
    private List<My_item> listProject = new ArrayList<>();
    private List<RecommendBenefitBean.DataBean.ListBean> list = new ArrayList<>();

    @Override
    public void initView(View view) {
        smartRefreshLayout.setOnRefreshListener(this);
        smartRefreshLayout.setOnLoadMoreListener(this);

        smartRefreshLayout.setEnableLoadMore(false);
        smartRefreshLayout.setEnableRefresh(true);

        Uiutils.setBarStye(titlebar, getActivity());
        userInfo = (UserInfo) ShareUtils.getObject(getContext(), SPConstants.USERINFO, UserInfo.class);

        setViewData();
        mainView = view;
        if (Uiutils.isTourist1(getActivity())){
            smartRefreshLayout.setVisibility(View.GONE);
            horizontalRec.setVisibility(View.GONE);
            main_lin0.setVisibility(View.GONE);
        }else{
            setFrag(view);
            smartRefreshLayout.setVisibility(View.VISIBLE);
            horizontalRec.setVisibility(View.VISIBLE);
            main_lin0.setVisibility(View.VISIBLE);
        }

        //设置布局管理器
        LinearLayoutManager linearLayoutManager = new LinearLayoutManager(getContext());
        linearLayoutManager.setOrientation(LinearLayoutManager.HORIZONTAL);
        horizontalRec.setLayoutManager(linearLayoutManager);
        horizontalRec.addItemDecoration(new SpacesItemDecoration(getContext(), 1));

        arrayString = getContext().getResources().getStringArray(R.array.recommend_benefig);
        if (null != arrayString && arrayString.length > 0) {
            for (int i = 0; i < arrayString.length; i++) {
                if (i == 0) {
                    listProject.add(new My_item(0, arrayString[i], true));
                } else {
                    listProject.add(new My_item(0, arrayString[i], false));
                }
            }
        }

        titlebar.setText("推荐收益");
        adapter = new RecommenAdapter(getContext(), listProject, R.layout.recommend_adapter);
        horizontalRec.setAdapter(adapter);
        adapter.setOnItemClickListener(this);


        dataAdapter = new RecommendInformationAdapter(getContext(), list, R.layout.pub_recommend_stye);
        dataAdapter.setId(selePostion);
        Uiutils.setRec(getContext(), pubProjectRec, 0);
        pubProjectRec.setAdapter(dataAdapter);
//        dataAdapter.setOnItemClickListener(this);
//        dataAdapter.setOnItemClickListener(this);

        contentView = LayoutInflater.from(getContext()).inflate(R.layout.recommend_top_pop, null);
        setPoview();

        contentView1 = LayoutInflater.from(getContext()).inflate(R.layout.city_pop, null);
        setPopView();


        if (!StringUtils.isEmpty(ShareUtils.getString(getContext(), "themetyp", ""))) {
            if (!StringUtils.isEmpty(ShareUtils.getString(getContext(), "themetyp", ""))) {
                dWave.setVisibility(View.GONE);
            }
            Log.e("xxxxisHide", "" + isHide);
            if (isHide)
                titlebar.setIvBackHide(View.GONE);
        }

        setTheme();

        if (Uiutils.isSite("c153"))
        ImageLoadUtil.ImageLoad(getContext(),R.drawable.myreco_mobile1,recommendImg);
        else
            ImageLoadUtil.ImageLoad(getContext(),R.drawable.myreco_mobile,recommendImg);
    }

    private RecommendInformationAdapter dataAdapter;
    private int page = 1;
    private int rows = 20;
    private String level = "0";

    private RecommendBenefitBean recommendBenefitBean;

    private void getData(boolean b) {
        Map<String, Object> map = new HashMap<>();
        map.put("page", page + "");
        map.put("rows", rows + "");
        map.put("token", Uiutils.getToken(getContext()));
        map.put("level", level + "");
        NetUtils.get(url, map, b, getContext(), new NetUtils.NetCallBack() {
            @Override
            public void onSuccess(String object) {
                smartRefreshLayout.finishRefresh();
                smartRefreshLayout.finishLoadMore();

                recommendBenefitBean = GsonUtil.fromJson(object, RecommendBenefitBean.class);

                if (page == 1) {
                    if (list.size() > 0)
                        list.clear();
                }

                if (null != recommendBenefitBean && null != recommendBenefitBean.getData() && null != recommendBenefitBean.
                        getData().getList() && recommendBenefitBean.getData().getList().size() > 0) {
                    list.addAll(recommendBenefitBean.getData().getList());
                }

                if (null != recommendBenefitBean && list.size() != recommendBenefitBean.getData().getTotal()) {
                    smartRefreshLayout.setEnableLoadMore(true);
                } else {
                    smartRefreshLayout.setEnableLoadMore(false);
                }


                dataAdapter.notifyDataSetChanged();
            }

            @Override
            public void onError() {
                if (null!=smartRefreshLayout) {
                    smartRefreshLayout.finishRefresh();
                    smartRefreshLayout.finishLoadMore();
                }

                if (page == 1) {
                    if (list.size() > 0)
                        list.clear();
                }
                dataAdapter.notifyDataSetChanged();

            }
        });
    }

    private TextView tvMore;
    private boolean isok;

    private void setViewData() {
        if (null != userInfo && null != userInfo.getData()) {
            Uiutils.setText(tvMoney, "￥" + userInfo.getData().getBalance());
            if (isok) {
                isok = false;
                return;
            }

            if (null != userInfo && null != userInfo.getData() && !StringUtils.isEmpty(userInfo.getData()
                    .getAvatar())) {
                ImageLoadUtil.loadRoundImage0(ivImg,
                        userInfo.getData()
                                .getAvatar(), 0);
            } else {
                ImageLoadUtil.ImageLoad(getContext(), R.drawable.head, ivImg);
            }

            Uiutils.setText(tvUserParentId, userInfo.getData().getUsr());
            Uiutils.setText(vipTex, userInfo.getData().getCurLevelGrade());

            Uiutils.setText(tvGrow, "成长值(" + userInfo.getData().getCurLevelInt() + " - " +
                    userInfo.getData().getNextLevelInt() + ")");


//            titlebar.setRIghtTvVisibility(View.VISIBLE);
//            tvMore=(TextView) titlebar.findViewById(R.id.tv_more);
//            Uiutils.setText(tvMore, userInfo.getData().getUsr());
//            tvMore.setTextColor(getContext().getResources().getColor(R.color.white));

            int progress = 0;

            progress = (int) (Double.parseDouble(userInfo.getData().getCurLevelInt())
                    / Double.parseDouble(userInfo.getData().getNextLevelInt()) * 100);

            Log.e("progress==", progress + "///");

            progress1.setProgress(progress);
            progress1.setMax(100);


        }
    }

    private FragmentManager fm;
    private FragmentTransaction ft;

//    private void setFrag() {
//        recommendInformationFrag = new RecommendInformationFrag();
//        if (!isHide) {
//            fm = getActivity().getSupportFragmentManager();
//        } else {
//            fm = getChildFragmentManager();
    private void setFrag(View view) {
//        recommendInformationFrag = new RecommendInformationFrag();
//        fm = getActivity().getSupportFragmentManager();
//        ft = fm.beginTransaction();
//        ft.add(R.id.framnent_lin, recommendInformationFrag);
//        ft.show(recommendInformationFrag);
//        ft.commit();
        if (null != userInfo && null != userInfo.getData()) {
            myNameTex.setText(userInfo.getData().getUsr());
            myIdTex.setText(userInfo.getData().getUid());
        }
        setView(view);

        ConfigBean configBean = (ConfigBean) ShareUtils.getObject(getContext(), SPConstants.CONFIGBEAN, ConfigBean.class);
        if (null!=configBean&&null!=configBean.getData()&& !StringUtils.isEmpty(configBean.getData()
                .getMyreco_img())&&StringUtils.equals("1",configBean.getData()
                .getMyreco_img()))
            recommendImg.setVisibility(View.GONE);

        getData();

    }

    @OnClick({R.id.iv_task, R.id.iv_sign, R.id.tv_money, R.id.iv_refresh, R.id.name_text1_lin})
    public void onClick(View view) {
        switch (view.getId()) {
            case R.id.iv_task:
                if (!isHide)
                getActivity().finish();
                break;
            case R.id.iv_sign:
                FragmentUtilAct.startAct(getActivity(), new SignInFrag(false));
                break;
            case R.id.tv_money:
                if (tvMoney.getText().toString().contains("*")) {
                    Uiutils.setText(tvMoney, "￥" + userInfo.getData().getBalance());
                    ivRefresh.setVisibility(View.VISIBLE);
                } else {
                    tvMoney.setText("¥****");
                    ivRefresh.setVisibility(View.GONE);
                }
                break;
            case R.id.iv_refresh:
                ObjectAnimator objectAnimator = ObjectAnimator.ofFloat(ivRefresh, "rotation", 0f, 360f);
                objectAnimator.setDuration(1500);
                objectAnimator.start();

                isok = true;
                getInfo();
                break;
            case R.id.name_text1_lin:

                popupWindowBuilder = Uiutils.setPopSetting(getContext(), contentView1,
                        MeasureUtil.dip2px(getContext(), 80), ViewGroup.LayoutParams.WRAP_CONTENT,
                        true, false, 0.5f);
                customPopWindow = popupWindowBuilder.create();
                customPopWindow.showAsDropDown(nameText1Lin, 0, 0);
                Uiutils.setStateColor(getActivity());
                break;
            case R.id.clear_tex:
                customPopWindow.dissmiss();
                Uiutils.setStateColor(getActivity());
                break;
            case R.id.commit_tex:
                if (selePostion == 3) {
                    customPopWindow.dissmiss();
                    Uiutils.setStateColor(getActivity());
                } else {
                    if (StringUtils.equals("正常", item.getEnable()) && !StringUtils.equals("0", item.getIs_setting())) {
                        if (!StringUtils.isEmpty(editContext.getText().toString())) {
                            goRecharge();
                            customPopWindow.dissmiss();
                            Uiutils.setStateColor(getActivity());
                        } else {
                            ToastUtil.toastShortShow(getContext(), "请输入充值金额");
                        }
                    } else {
                        customPopWindow.dissmiss();
                        Uiutils.setStateColor(getActivity());
                    }
                }
                break;
            case R.id.copylink_tex:
                ClipboardManager cmb = (ClipboardManager) getContext().getSystemService(Context.CLIPBOARD_SERVICE);
                if (view.getTag()==recommendAdaView1){
                    cmb.setText(recommendAdaView1Url.getText());
                }else
                if (view.getTag()==recommendAdaView2){
                    cmb.setText(recommendAdaView2Url.getText());
                }
                ToastUtil.toastShortShow(getContext(), "复制成功");
                break;
        }
    }

    /**
     * 充值
     */
    private void goRecharge() {
        Map<String, Object> map = new HashMap<>();
        map.put("token", Uiutils.getToken(getContext()));
        map.put("uid", item.getUid());
        map.put("coin", editContext.getText().toString());

        NetUtils.post(Constants.RECOMMEND_TRANSFER, map, true, getContext(), new NetUtils.NetCallBack() {
            @Override
            public void onSuccess(String object) {

            }

            @Override
            public void onError() {

            }
        });
    }

    private CustomPopWindow.PopupWindowBuilder popupWindowBuilder;
    private CustomPopWindow customPopWindow;
    private View contentView;
    private View contentView1;


    private RecyclerView popRec;
    private CityPopAdapter adapterCity;
    private List<My_item> listPop = new ArrayList<>();

    private void setPopView() {
        if (listPop.size() > 0) listPop.clear();

        listPop.add(new My_item(0, "全部下线"));
        listPop.add(new My_item(1, "一级下线"));
        listPop.add(new My_item(2, "二级下线"));
        listPop.add(new My_item(3, "三级下线"));
        listPop.add(new My_item(4, "四级下线"));
        listPop.add(new My_item(5, "五级下线"));
        listPop.add(new My_item(6, "六级下线"));
        listPop.add(new My_item(7, "七级下线"));
        listPop.add(new My_item(8, "八级下线"));
        listPop.add(new My_item(9, "九级下线"));
        listPop.add(new My_item(10, "十级下线"));


        if (null == contentView1)
            return;

        popRec = contentView1.findViewById(R.id.pop_rec);
        LinearLayoutManager linearLayoutManager = new LinearLayoutManager(getContext());
        popRec.setLayoutManager(linearLayoutManager);
        popRec.addItemDecoration(new SpacesItemDecoration(getContext(), 1));

        adapterCity = new CityPopAdapter(getContext(), listPop, R.layout.city_pop_adapter);
        popRec.setAdapter(adapterCity);
        adapterCity.setOnItemClickListener(new BaseRecyclerAdapter.OnItemClickListener() {
            @Override
            public void onItemClick(RecyclerView parent, View view, int position) {
                customPopWindow.dissmiss();
                Uiutils.setStateColor(getActivity());
                level = listPop.get(position).getImg() + "";
                page = 1;
                getData(true);
            }
        });
    }


    private void getInfo() {
        NetUtils.get(Constants.USERINFO, Uiutils.getToken(getContext()), true, getContext(),
                new NetUtils.NetCallBack() {
                    @Override
                    public void onSuccess(String object) {
                        if (!StringUtils.isEmpty(object)) {
                            userInfo = Uiutils.stringToObject(object, UserInfo.class);
                            if (null != userInfo && null != userInfo.getData()) {
                                ShareUtils.saveObject(getContext(), SPConstants.USERINFO, userInfo);
                                setViewData();
                            }
                        }
                    }

                    @Override
                    public void onError() {

                    }
                });
    }

    @Override
    public void onItemClick(RecyclerView parent, View view, int position) {
        if (parent == horizontalRec) {
            (listProject.get(selePostion)).setSelected(false);
            (listProject.get(position)).setSelected(true);
            adapter.notifyDataSetChanged();

            if (position > 0 && position < listProject.size() - 2 && selePostion < position) {
                horizontalRec.scrollToPosition(position + 2);
            } else if (position > 0 && position < listProject.size() - 2 && selePostion > position) {
                horizontalRec.scrollToPosition(position - 2);
            }

            selePostion = position;
            level = "0";
            if (position == 0) {
                framnentLin.setVisibility(View.VISIBLE);
                projectLin.setVisibility(View.GONE);
            } else {
                projectLin.setVisibility(View.VISIBLE);
                framnentLin.setVisibility(View.GONE);
                dataAdapter.setId(selePostion);
                setSype();
                getData(true);
            }

            if (selePostion == 3 || selePostion == 1) {
                dataAdapter.setOnItemClickListener(this);
            } else {
                dataAdapter.setOnItemClickListener(null);
            }
        } else {
            if (selePostion == 3) {
                listBean = list.get(position);
                setpopData1();
                popupWindowBuilder = Uiutils.setPopSetting(getContext(), contentView,
                        MeasureUtil.dip2px(getContext(), 300), ViewGroup.LayoutParams.WRAP_CONTENT,
                        true, true, 0.5f);
                customPopWindow = popupWindowBuilder.create();
                customPopWindow.showAtLocation(contentView, Gravity.CENTER, 0, 0);
                Uiutils.setStateColor(getActivity());
            } else if (selePostion == 1) {
                item = listBean = list.get(position);
                setOnc();
            }
        }
    }

    private RecommendBenefitBean.DataBean.ListBean listBean;
    private String url;

    private void setSype() {
        switch (selePostion) {
            case 1:
                url = Constants.INVITELIST;
                setTex("分类", "用户名", "在线状态", "注册时间", "操作/状态", true);
                break;
            case 2:
                url = Constants.BETSTAT;
                setTex("分类", "日期", "投注金额", "佣金", "", true);
                break;
            case 3:
                url = Constants.BETLIST;
                setTex("分类", "用户", "日期", "金额", "", true);
                break;
            case 4:
                url = Constants.INVITEDOMAIN;
                setTex("", "首页推荐链接", "注册页推荐链接", "", "", false);
                break;
            case 5:
                url = Constants.DEPOSITSTAT;
                setTex("分类", "日期", "存款金额", "存款人数", "", true);
                break;
            case 6:
                url = Constants.DEPOSITLIST;
                setTex("分类", "用户", "日期", "存款金额", "", true);
                break;
            case 7:
                url = Constants.WITHDRAWSTAT;
                setTex("分类", "日期", "提款金额", "提款人数", "", true);
                break;
            case 8:
                url = Constants.WITHDRAWLIST;
                setTex("分类", "用户名", "日期", "提款金额", "", true);
                break;
            case 9:
                url = Constants.REALBETSTAT;
                setTex("分类", "日期", "投注金额", "会员输赢", "", true);
                break;
            case 10:
                url = Constants.REALBETLIST;
                setTex1("分类", "用户名", "游戏", "日期", "投注金额", "会员输赢", true);
                break;
        }
    }

    private void setTex(String name1, String name2, String name3, String name4, String name5, boolean isOK) {
        setTextV(name1, nameText1);
        setTextV(name2, nameText2);
        setTextV(name3, nameText3);
        setTextV(name4, nameText4);
        setTextV(name5, nameText5);

        nameText1Lin0.setVisibility(View.GONE);

        if (isOK) {
            nameText1.setCompoundDrawablesWithIntrinsicBounds(0, 0, R.drawable.gray_down, 0);
        } else {
            nameText1.setCompoundDrawablesWithIntrinsicBounds(0, 0, 0, 0);
        }
    }

    private void setTex1(String name1, String name2, String name3, String name4, String name5, String name6, boolean isOK) {
        setTextV(name1, nameText1);
        setTextV(name2, nameText2);
        setTextV(name3, nameText3);
        setTextV(name4, nameText4);
        setTextV(name5, nameText5);
        setTextV(name6, nameText6);
        nameText1Lin0.setVisibility(View.VISIBLE);

        if (isOK) {
            nameText1.setCompoundDrawablesWithIntrinsicBounds(0, 0, R.drawable.gray_down, 0);
        } else {
            nameText1.setCompoundDrawablesWithIntrinsicBounds(0, 0, 0, 0);
        }


    }

    private void setTextV(String name1, TextView textView) {
        if (!StringUtils.isEmpty(name1)) {
            if (textView == nameText1) {
                nameText1Lin.setVisibility(View.VISIBLE);
            } else {
                textView.setVisibility(View.VISIBLE);
            }
            textView.setText(name1);
        } else {
            if (textView == nameText1) {
                nameText1Lin.setVisibility(View.GONE);
            } else {
                textView.setVisibility(View.GONE);
            }
        }
    }

    @Override
    public void onLoadMore(@NonNull RefreshLayout refreshLayout) {
        page++;
        getData(false);
    }

    @Override
    public void onRefresh(@NonNull RefreshLayout refreshLayout) {
        page = 1;
        getData(false);
    }

    private RecommendBenefitBean.DataBean.ListBean item;


    private void setOnc() {

        if (null != item) {
            contentView = LayoutInflater.from(getContext()).inflate(R.layout.recommend_top_pop, null);
            setPoview();
            setpopData();
            popupWindowBuilder = Uiutils.setPopSetting(getContext(), contentView,
                    MeasureUtil.dip2px(getContext(), 300), ViewGroup.LayoutParams.WRAP_CONTENT,
                    true, true, 0.5f);
            customPopWindow = popupWindowBuilder.create();
            customPopWindow.showAtLocation(contentView, Gravity.CENTER, 0, 0);
            Uiutils.setStateColor(getActivity());

        }
    }

    private View accountStatusLin;
    private TextView accountStatusText1;
    private TextView accountStatusText2;

    private View userNameLin;
    private TextView userNameText1;
    private TextView userNameText2;

    private View registrationDateLin;
    private TextView registrationDateText1;
    private TextView registrationDateText2;

    private View relationshipSuperiorLin;
    private TextView relationshipSuperiorText1;
    private TextView relationshipSuperiorText2;

    private View balanceUserLin;
    private TextView balanceUserText1;
    private TextView balanceUserText2;

    private View myBalance;
    private TextView myBalanceText1;
    private TextView myBalanceText2;

    private View myBalance1;
    private TextView myBalance1Text1;
    private TextView myBalance1Text2;

    private View myBalance2;
    private TextView myBalance2Text1;
    private TextView myBalance2Text2;


    private TextView titleTex;
    private EditText editContext;
    private TextView clearTex;
    private TextView commitTex;

    private TextView rechargeAmountTex;
    private LinearLayout input_menye_lin;

    private void setPoview() {
        input_menye_lin = contentView.findViewById(R.id.input_menye_lin);
        titleTex = contentView.findViewById(R.id.title_tex);
        editContext = contentView.findViewById(R.id.edit_context);
        clearTex = contentView.findViewById(R.id.clear_tex);
        commitTex = contentView.findViewById(R.id.commit_tex);
        clearTex.setOnClickListener(this);
        commitTex.setOnClickListener(this);

        rechargeAmountTex = contentView.findViewById(R.id.recharge_amount_tex);

        accountStatusLin = contentView.findViewById(R.id.account_status_lin);
        accountStatusText1 = accountStatusLin.findViewById(R.id.text1);
        accountStatusText2 = accountStatusLin.findViewById(R.id.text2);

        userNameLin = contentView.findViewById(R.id.user_name_lin);
        userNameText1 = userNameLin.findViewById(R.id.text1);
        userNameText2 = userNameLin.findViewById(R.id.text2);

        registrationDateLin = contentView.findViewById(R.id.registration_date_lin);
        registrationDateText1 = registrationDateLin.findViewById(R.id.text1);
        registrationDateText2 = registrationDateLin.findViewById(R.id.text2);

        relationshipSuperiorLin = contentView.findViewById(R.id.relationship_superior_lin);
        relationshipSuperiorText1 = relationshipSuperiorLin.findViewById(R.id.text1);
        relationshipSuperiorText2 = relationshipSuperiorLin.findViewById(R.id.text2);

        balanceUserLin = contentView.findViewById(R.id.balance_user_lin);
        balanceUserText1 = balanceUserLin.findViewById(R.id.text1);
        balanceUserText2 = balanceUserLin.findViewById(R.id.text2);

        myBalance = contentView.findViewById(R.id.my_balance);
        myBalanceText1 = myBalance.findViewById(R.id.text1);
        myBalanceText2 = myBalance.findViewById(R.id.text2);

        myBalance1 = contentView.findViewById(R.id.my_balance1);
        myBalance1Text1 = myBalance1.findViewById(R.id.text1);
        myBalance1Text2 = myBalance1.findViewById(R.id.text2);

        myBalance2 = contentView.findViewById(R.id.my_balance2);
        myBalance2Text1 = myBalance2.findViewById(R.id.text1);
        myBalance2Text2 = myBalance2.findViewById(R.id.text2);



    }

    private void setpopData() {
        titleTex.setText("用户信息");
        myBalance1.setVisibility(View.GONE);
        myBalance2.setVisibility(View.GONE);
        accountStatusText1.setText("账户状态:");
        userNameText1.setText("用户姓名:");
        registrationDateText1.setText("注册时间:");
        relationshipSuperiorText1.setText("上级关系:");
        balanceUserText1.setText("用户余额:");
        myBalanceText1.setText("我的余额:");
        rechargeAmountTex.setText("充值金额:");

        if (Uiutils.isSite("c001")){
            registrationDateLin.setVisibility(View.GONE);
            balanceUserLin.setVisibility(View.GONE);
            relationshipSuperiorLin.setVisibility(View.GONE);
        }


        if (StringUtils.equals("正常", item.getEnable())) {
            if (!StringUtils.equals("0", item.getIs_setting())) {
                input_menye_lin.setVisibility(View.VISIBLE);

            }
            balanceUserText2.setTextColor(Color.parseColor("#4caf50"));
        } else {
            balanceUserText2.setTextColor(Color.parseColor("#f44336"));
        }
        accountStatusText2.setText(item.getEnable());
        userNameText2.setText(item.getName());
        registrationDateText2.setText(item.getRegtime());
        relationshipSuperiorText2.setText(userInfo.getData().getUsr() + " > " + item.getUsername());
        balanceUserText2.setText("￥" + item.getCoin());
        balanceUserText2.setTextColor(Color.parseColor("#f44336"));
        myBalanceText2.setText("￥" + userInfo.getData().getBalance());
        myBalanceText2.setTextColor(Color.parseColor("#f44336"));
    }


    private void setpopData1() {
        input_menye_lin.setVisibility(View.GONE);
        titleTex.setText("下注记录详情");
        myBalance1.setVisibility(View.VISIBLE);
        myBalance2.setVisibility(View.VISIBLE);
        accountStatusText1.setText("游戏名称:");
        userNameText1.setText("投注日期:");
        registrationDateText1.setText("投注期数:");
        relationshipSuperiorText1.setText("投注号码:");
        balanceUserText1.setText("玩法:");
        myBalanceText1.setText("开奖号码:");

        myBalance1Text1.setText("赔率:");
        myBalance2Text1.setText("中奖金额:");

//        accountStatusText2.setText(Uiutils.setText();listBean.getLottery_name());
        Uiutils.setText(accountStatusText2, listBean.getLottery_name());

//        userNameText2.setText(item.getDate());
        Uiutils.setText(userNameText2, listBean.getDate());

//        registrationDateText2.setText(item.getActionNo());
        Uiutils.setText(registrationDateText2, listBean.getActionNo());
//        relationshipSuperiorText2.setText(item.getActionData());
        Uiutils.setText(relationshipSuperiorText2, listBean.getActionData());
//        balanceUserText2.setText(item.getGroupname());
        Uiutils.setText(balanceUserText2, listBean.getGroupname());
        balanceUserText2.setTextColor(Color.parseColor("#f44336"));
//        myBalanceText2.setText(listBean.getLotteryNo());
        Uiutils.setText(myBalanceText2, listBean.getLotteryNo());
        myBalanceText2.setTextColor(Color.parseColor("#f44336"));

//        myBalance1Text2.setText(listBean.getOdds());
        Uiutils.setText(myBalance1Text2, listBean.getOdds());
//        myBalance2Text2.setText(listBean.getBonus());
        Uiutils.setText(myBalance2Text2, listBean.getBonus());
    }

    @Override
    public void getEvenMsg(Even even) {
        switch (even.getCode()) {
            case EvenBusCode.CHANGE_THEME_STYLE_MYF:
                setTheme();
                break;
            case EvenBusCode.LOGIN:

//                if(listProject!=null&&listProject.size()>0){
//                    (listProject.get(selePostion)).setSelected(false);
//                    (listProject.get(0)).setSelected(true);
//                }
//                if(adapter!=null)
//                adapter.notifyDataSetChanged();
//                if(framnentLin!=null)
//                framnentLin.setVisibility(View.VISIBLE);
//                if(projectLin!=null)
//                projectLin.setVisibility(View.GONE);
//                if(mainView!=null)
//                setFrag(mainView);
                break;
            case EvenBusCode.CHANGE_PICTURE:
                if (Uiutils.isTourist1(getActivity())){
                    smartRefreshLayout.setVisibility(View.GONE);
                    horizontalRec.setVisibility(View.GONE);
                    main_lin0.setVisibility(View.GONE);
                }else{
                    setFrag(mainView);
                    smartRefreshLayout.setVisibility(View.VISIBLE);
                    horizontalRec.setVisibility(View.VISIBLE);
                    main_lin0.setVisibility(View.VISIBLE);
                }
                break;
        }
    }

    private void setTheme() {
        Uiutils.setBaColor(getContext(), titlebar, false, null);
        Uiutils.setBaColor(getContext(), mainRel, false, null);
        if (Uiutils.isTheme(getContext()))
            Uiutils.setBarStye0(mainRel,getContext());

    }

//推荐收益
    private View recommendAdaView1;
    private TextView recommendAdaView1CopylinkTex;
    private TextView recommendAdaView1Url;
    private Switch recommendAdaView1SwitchV;
    private ImageView recommendAdaView1qrCodeImg;

    private View recommendAdaView2;
    private TextView recommendAdaView2CopylinkTex;
    private TextView recommendAdaView2Url;
    private Switch recommendAdaView2SwitchV;
    private ImageView recommendAdaView2qrCodeImg;

    private void setView (View view){
        recommendAdaView1 =view.findViewById(R.id.recommend_ada_view1);
        recommendAdaView1CopylinkTex =recommendAdaView1.findViewById(R.id.copylink_tex);
        recommendAdaView1CopylinkTex.setTag(recommendAdaView1);
        recommendAdaView1CopylinkTex.setOnClickListener(this);
        recommendAdaView1Url =recommendAdaView1.findViewById(R.id.url);
        recommendAdaView1SwitchV =recommendAdaView1.findViewById(R.id.switch_v);
        recommendAdaView1SwitchV.setTag(recommendAdaView1);
        recommendAdaView1SwitchV.setOnCheckedChangeListener(this);
        recommendAdaView1qrCodeImg =recommendAdaView1.findViewById(R.id.qr_code_img);

        recommendAdaView2 =view.findViewById(R.id.recommend_ada_view2);
        ((TextView)recommendAdaView2.findViewById(R.id.subpage_name_tex)).setText("注册推荐地址");
        recommendAdaView2CopylinkTex =recommendAdaView2.findViewById(R.id.copylink_tex);
        recommendAdaView2CopylinkTex.setTag(recommendAdaView2);
        recommendAdaView2CopylinkTex.setOnClickListener(this);
        recommendAdaView2Url =recommendAdaView2.findViewById(R.id.url);
        recommendAdaView2SwitchV =recommendAdaView2.findViewById(R.id.switch_v);
        recommendAdaView2SwitchV.setTag(recommendAdaView2);
        recommendAdaView2SwitchV.setOnCheckedChangeListener(this);
        recommendAdaView2qrCodeImg =recommendAdaView2.findViewById(R.id.qr_code_img);

    }

    private void getData() {
        Map<String, Object> map = new HashMap<>();
        map.put("token", Uiutils.getToken(getContext()));

        NetUtils.get(Constants.INVITEINFO , map, true, getContext(),
                new NetUtils.NetCallBack() {
                    @Override
                    public void onSuccess(String object) {

                        recommendBean = GsonUtil.fromJson(object, RecommendBean.class);

                        if (null!=recommendBean&&null!=recommendBean.getData()) {

                            setDa();
                        }
                    }

                    @Override
                    public void onError() {

                    }
                });
    }


    private void setDa() {
        recommendAdaView1Url.setText(recommendBean.getData().getLink_i());
        recommendAdaView2Url.setText(recommendBean.getData().getLink_r());
        String fd = subZeroAndDot(recommendBean.getData().getFanDian());
        String result = "="+(1000*Double.parseDouble(fd)/100)+"元";
        tvSample.setText("您推荐的会员在下注结算后,佣金会自动按照比例加到您的资金账户上。例如:您所推荐的会员下注1000元,您的收益=1000元*"+fd+"%"+result);
        Bitmap bitmap = ZXingUtils.createQRImage(recommendBean.getData().getLink_i(),
                MeasureUtil.dip2px(getContext(), 200),
                MeasureUtil.dip2px(getContext(), 200), null);
        recommendAdaView1qrCodeImg.setImageBitmap(bitmap);


        Bitmap bitmap1 = ZXingUtils.createQRImage(recommendBean.getData().getLink_r(),
                MeasureUtil.dip2px(getContext(), 200),
                MeasureUtil.dip2px(getContext(), 200), null);
        recommendAdaView2qrCodeImg.setImageBitmap(bitmap1);

        commissionRateTex.setText(recommendBean.getData().getFandian_intro());
        recommendedMembersTex.setText(recommendBean.getData().getMonth_member());
        recommendedMembersTex1.setText(recommendBean.getData().getTotal_member());
        moneyTex.setText(recommendBean.getData().getMonth_earn());
    }
    private RecommendBean recommendBean;


//    @Override
//    public void onClick(View v) {
//        switch (v.getId()){
//            case R.id.copylink_tex:
//                ClipboardManager cmb = (ClipboardManager) getContext().getSystemService(Context.CLIPBOARD_SERVICE);
//                if (v.getTag()==recommendAdaView1){
//                    cmb.setText(recommendAdaView1Url.getText());
//                }else
//                if (v.getTag()==recommendAdaView2){
//                    cmb.setText(recommendAdaView2Url.getText());
//                }
//                ToastUtil.toastShortShow(getContext(), "复制成功");
//                break;
//        }
//    }

    @Override
    public void onCheckedChanged(CompoundButton buttonView, boolean isChecked) {
        if (buttonView==recommendAdaView1SwitchV){
            if (isChecked) {
                recommendAdaView1qrCodeImg.setVisibility(View.VISIBLE);
            } else {
                recommendAdaView1qrCodeImg.setVisibility(View.GONE);
            }
        }else{
            if (isChecked) {
                recommendAdaView2qrCodeImg.setVisibility(View.VISIBLE);
            } else {
                recommendAdaView2qrCodeImg.setVisibility(View.GONE);
            }
        }
    }

    protected void onTransformResume() {
        userInfo = (UserInfo) ShareUtils.getObject(getContext(), SPConstants.USERINFO, UserInfo.class);
        setViewData();

        if(listProject!=null&&listProject.size()>0){
            (listProject.get(selePostion)).setSelected(false);
            (listProject.get(0)).setSelected(true);
        }
        if(adapter!=null)
            adapter.notifyDataSetChanged();
        if(framnentLin!=null)
            framnentLin.setVisibility(View.VISIBLE);
        if(projectLin!=null)
            projectLin.setVisibility(View.GONE);
        if(mainView!=null&&!Uiutils.isTourist1(getActivity()))
            setFrag(mainView);
    }
}
