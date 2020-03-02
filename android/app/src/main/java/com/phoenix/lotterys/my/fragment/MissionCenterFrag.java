package com.phoenix.lotterys.my.fragment;

import android.animation.ObjectAnimator;
import android.annotation.SuppressLint;
import android.content.Context;
import android.content.SharedPreferences;
import androidx.fragment.app.Fragment;
import androidx.fragment.app.FragmentManager;
import androidx.fragment.app.FragmentTransaction;
import androidx.viewpager.widget.ViewPager;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;
import android.util.Log;
import android.view.View;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.ProgressBar;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.flyco.tablayout.SlidingTabLayout;
import com.phoenix.lotterys.BuildConfig;
import com.phoenix.lotterys.R;import com.phoenix.lotterys.R2;
import com.phoenix.lotterys.application.BaseFragments;
import com.phoenix.lotterys.home.bean.MessageEvent;
import com.phoenix.lotterys.main.FragmentUtilAct;
import com.phoenix.lotterys.main.bean.ConfigBean;
import com.phoenix.lotterys.my.adapter.MissionCenterAdapter;
import com.phoenix.lotterys.my.adapter.TabPagerAdapter;
import com.phoenix.lotterys.my.bean.My_item;
import com.phoenix.lotterys.my.bean.UserInfo;
import com.phoenix.lotterys.my.fragment.MissionCenter.AccountingChangeFrag;
import com.phoenix.lotterys.my.fragment.MissionCenter.HappyExchangeFrag;
import com.phoenix.lotterys.my.fragment.MissionCenter.MissionHallFrag;
import com.phoenix.lotterys.my.fragment.MissionCenter.MissionTabFrag;
import com.phoenix.lotterys.my.fragment.MissionCenter.VIPLevelFrag;
import com.phoenix.lotterys.util.Constants;
import com.phoenix.lotterys.util.FormatNum;
import com.phoenix.lotterys.util.NetUtils;
import com.phoenix.lotterys.util.SPConstants;
import com.phoenix.lotterys.util.ShareUtils;
import com.phoenix.lotterys.util.SpacesItemDecoration;
import com.phoenix.lotterys.util.Uiutils;
import com.phoenix.lotterys.util.recyclerUtil.BaseRecyclerAdapter;
import com.phoenix.lotterys.view.CustomTitleBar;
import com.phoenix.lotterys.view.DynamicWave;
import com.phoenix.lotterys.view.ViewPagerSlide;
import com.wanxiangdai.commonlibrary.util.EvenBusUtil.Even;
import com.wanxiangdai.commonlibrary.util.EvenBusUtil.EvenBusCode;
import com.wanxiangdai.commonlibrary.util.EvenBusUtil.EvenBusUtils;
import com.wanxiangdai.commonlibrary.util.ImageLoadUtil;
import com.wanxiangdai.commonlibrary.util.StringUtils;

import org.greenrobot.eventbus.EventBus;

import java.util.ArrayList;
import java.util.List;

import butterknife.BindView;
import butterknife.OnClick;

/**
 * 文件描述: 任务中心
 * 创建者: IAN
 * 创建时间: 2019/7/2 14:50
 */
@SuppressLint("ValidFragment")
public class MissionCenterFrag extends BaseFragments {


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
    //    @BindView(R2.id.framnent_lin)
//    FrameLayout framnentLin;
    @BindView(R2.id.vip_tex)
    TextView vipTex;
    @BindView(R2.id.vip_frot_img)
    TextView vipFrotImg;
    @BindView(R2.id.vip_queen_img)
    TextView vipQueenImg;
    @BindView(R2.id.tv_integral1)
    TextView tvIntegral1;
    @BindView(R2.id.my_lin)
    View myLin;
    boolean isHide = false;
    @BindView(R2.id.mian_rel)
    RelativeLayout mianRel;
    private MissionCenterAdapter adapter;

    private MissionHallFrag missionHallFrag;
    private HappyExchangeFrag happyExchangeFrag;
    private AccountingChangeFrag accountingChangeFrag;
    private VIPLevelFrag vipLevelFrag;


    @BindView(R2.id.tab_title)
    SlidingTabLayout tab_title;
    @BindView(R2.id.vp)
    ViewPagerSlide vp;
    private ArrayList<Fragment> mFragments = new ArrayList<>();
    private String[] mTitles;
    private TabPagerAdapter mAdapter;

    @SuppressLint("ValidFragment")
    public MissionCenterFrag(boolean isHide) {
        super(R.layout.mission_center_act, true,
                true);
        this.isHide = isHide;
    }

    private int selePostion;  //当前选中

    private UserInfo userInfo;
    private ConfigBean configBean;
    private String name;

    @Override
    public void initView(View view) {

        if (!StringUtils.isEmpty(ShareUtils.getString(getContext(), "themetyp", ""))
                && StringUtils.equals("4", ShareUtils.getString(getContext(), "themetyp", ""))) {
        } else {
            dWave.setVisibility(View.GONE);
            myLin.setVisibility(View.VISIBLE);
        }

        userInfo = (UserInfo) ShareUtils.getObject(getContext(), SPConstants.USERINFO, UserInfo.class);

        configBean = (ConfigBean) ShareUtils.getObject(getContext(), SPConstants.CONFIGBEAN, ConfigBean.class);

//        if (null != configBean && null != configBean.getData())
//            name = StringUtils.isEmpty(configBean.getData()
//                    .getMissionName()) ? "开心乐" : configBean.getData()
//                    .getMissionName();
//
//        tvIntegral.setText(name + ":");
//
//        if (null != configBean && null != configBean.getData())
//            if (!StringUtils.isEmpty(configBean.getData()
//                    .getCheckinSwitch()) && StringUtils.equals("1",
//                    configBean.getData()
//                            .getCheckinSwitch())) {
//                ivSign.setVisibility(View.VISIBLE);
//            }
        String taskName = "";    //c134 任务大厅名字动态变化 首页导航
        if (BuildConfig.FLAVOR.equals("c134")) {
            taskName = SPConstants.getValue(getContext(), SPConstants.SP_TASKHALL);
        }else {
            taskName = getResources().getString(R.string.mission_hall);
        }
        setViewData();

        setFrag(taskName);

        Uiutils.setBarStye(titlebar, getActivity());

        if (Uiutils.isSite("c200")){
            //设置布局管理器
            Uiutils.setRec(getContext(),horizontalRec,4,R.color.white);
        }else{
            //设置布局管理器
            LinearLayoutManager linearLayoutManager = new LinearLayoutManager(getContext());
            linearLayoutManager.setOrientation(LinearLayoutManager.HORIZONTAL);
            horizontalRec.setLayoutManager(linearLayoutManager);
            horizontalRec.addItemDecoration(new SpacesItemDecoration(getContext(), 1));
        }


        list1 = new ArrayList();
        list1.add(new My_item(R.mipmap.ck, taskName, true));
        list1.add(new My_item(R.mipmap.qk, name + "兑换", false));
        list1.add(new My_item(R.mipmap.zxkf, name + "账变", false));
        list1.add(new My_item(R.mipmap.yhkgl, getResources().getString(R.string.vip_level), false));

        titlebar.setText(list1.get(0).getTitle());
        adapter = new MissionCenterAdapter(getContext(), list1, R.layout.mission_center_adapter);
        horizontalRec.setAdapter(adapter);

        adapter.setOnItemClickListener(new BaseRecyclerAdapter.OnItemClickListener() {
            @Override
            public void onItemClick(RecyclerView parent, View view, int position) {

                if (position > 0 && position < list1.size() - 1 && selePostion < position) {
                    horizontalRec.scrollToPosition(position + 1);
                } else if (position > 0 && position < list1.size() - 1 && selePostion > position) {
                    horizontalRec.scrollToPosition(position - 1);
                }

                titlebar.setText(list1.get(position).getTitle());
                (list1.get(selePostion)).setSelected(false);
                (list1.get(position)).setSelected(true);
                adapter.notifyDataSetChanged();
                selePostion = position;


//                fm = getActivity().getSupportFragmentManager();
//                ft = fm.beginTransaction();
//                showPostion(position, listFra);
                vp.setCurrentItem(position);
                vp.setScroll(true);
                if (position == 2)
                    EvenBusUtils.setEvenBus(new Even(EvenBusCode.REFRESH_ACCOUNT_CHANGE));

            }
        });
        if (isHide) {
            titlebar.setIvBackHide(View.GONE);
//            ivTask.setVisibility(View.GONE);
        }

        setTheme();
        Uiutils.setBarStye0(mianRel,getActivity());
        String themetyp = ShareUtils.getString(getContext(),"themetyp","");
        String themid = ShareUtils.getString(getContext(),"themid","");
        if (!StringUtils.isEmpty(themetyp)&&StringUtils.equals("4",themetyp)&&
                !StringUtils.isEmpty(themetyp)&&StringUtils.equals("25",themid)) {
            dWave.setVisibility(View.INVISIBLE);
        }
    }

    private List<My_item> list1;

    private void setViewData() {
        if (null != configBean && null != configBean.getData())
            name = StringUtils.isEmpty(configBean.getData()
                    .getMissionName()) ? "开心乐" : configBean.getData()
                    .getMissionName();

        tvIntegral.setText(name + ":");

        if (null != configBean && null != configBean.getData())
            if (!StringUtils.isEmpty(configBean.getData()
                    .getCheckinSwitch()) && StringUtils.equals("1",
                    configBean.getData()
                            .getCheckinSwitch())) {
                ivSign.setVisibility(View.VISIBLE);
            }


        if (null != userInfo && null != userInfo.getData()) {
            Uiutils.setText(tvUserParentId, userInfo.getData().getUsr());
            Uiutils.setText(vipTex, userInfo.getData().getCurLevelGrade());
            String text = "0";
            if (StringUtils.isEmpty(userInfo.getData().getTaskRewardTotal())) {
            } else {
                text = userInfo.getData().getTaskRewardTotal();
                while (text.contains(".") && (text.endsWith("0") || text.endsWith("."))) {
                    text = text.substring(0, text.length() - 1);
                }
            }

            tvIntegral1.setText(userInfo.getData().getTaskReward());
            Uiutils.setText(tvGrow, "成长值(" + text + " - " +
                    userInfo.getData().getNextLevelInt() + ")");
            int progress = 0;
            if (!StringUtils.isEmpty(userInfo.getData().getTaskRewardTotal()) &&
                    !StringUtils.isEmpty(userInfo.getData().getNextLevelInt())) {
                progress = (int) (Double.parseDouble(userInfo.getData().getTaskRewardTotal())
                        / Double.parseDouble(userInfo.getData().getNextLevelInt()) * 100);
                Log.e("progress==", progress + "///");
                progress1.setProgress(progress);
                progress1.setMax(100);
            }
//            setImg(userInfo.getData().getCurLevelGrade(),vipFrotImg);
//            setImg(userInfo.getData().getNextLevelGrade(),vipQueenImg);
            vipFrotImg.setText(userInfo.getData().getCurLevelGrade());
            vipQueenImg.setText(userInfo.getData().getNextLevelGrade());
            vipTex.setText(userInfo.getData().getCurLevelGrade());

//            setImgBac(userInfo.getData().getCurLevelGrade(),vipTex);

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

        }
    }

    private void setImg(String name, ImageView imageView) {
        switch (name) {
            case "VIP0":
                ImageLoadUtil.ImageLoad(getContext(), R.mipmap.grade_0, imageView);
                break;
            case "VIP1":
                ImageLoadUtil.ImageLoad(getContext(), R.mipmap.grade_1, imageView);
                break;
            case "VIP2":
                ImageLoadUtil.ImageLoad(getContext(), R.mipmap.grade_2, imageView);
                break;
            case "VIP3":
                ImageLoadUtil.ImageLoad(getContext(), R.mipmap.grade_3, imageView);
                break;
            case "VIP4":
                ImageLoadUtil.ImageLoad(getContext(), R.mipmap.grade_4, imageView);
                break;
            case "VIP5":
                ImageLoadUtil.ImageLoad(getContext(), R.mipmap.grade_5, imageView);
                break;
            case "VIP6":
                ImageLoadUtil.ImageLoad(getContext(), R.mipmap.grade_6, imageView);
                break;
            case "VIP7":
                ImageLoadUtil.ImageLoad(getContext(), R.mipmap.grade_7, imageView);
                break;
            case "VIP8":
                ImageLoadUtil.ImageLoad(getContext(), R.mipmap.grade_8, imageView);
                break;
            case "VIP9":
                ImageLoadUtil.ImageLoad(getContext(), R.mipmap.grade_9, imageView);
                break;
            case "VIP10":
                ImageLoadUtil.ImageLoad(getContext(), R.mipmap.grade_10, imageView);
                break;
            default:
                ImageLoadUtil.ImageLoad(getContext(), R.mipmap.grade_11, imageView);
                break;
        }
    }

    private void setImgBac(String name, TextView textView) {
        switch (name) {
            case "VIP0":
                textView.setBackground(getResources().getDrawable(R.mipmap.vip0));
                break;
            case "VIP1":
                textView.setBackground(getResources().getDrawable(R.mipmap.vip1));
                break;
            case "VIP2":
                textView.setBackground(getResources().getDrawable(R.mipmap.vip2));
                break;
            case "VIP3":
                textView.setBackground(getResources().getDrawable(R.mipmap.vip3));
                break;
            case "VIP4":
                textView.setBackground(getResources().getDrawable(R.mipmap.vip4));
                break;
            case "VIP5":
                textView.setBackground(getResources().getDrawable(R.mipmap.vip5));
                break;
            case "VIP6":
                textView.setBackground(getResources().getDrawable(R.mipmap.vip6));
                break;
            case "VIP7":
                textView.setBackground(getResources().getDrawable(R.mipmap.vip7));
                break;
            case "VIP8":
                textView.setBackground(getResources().getDrawable(R.mipmap.vip8));
                break;
            case "VIP9":
                textView.setBackground(getResources().getDrawable(R.mipmap.vip9));
                break;
            case "VIP10":
                textView.setBackground(getResources().getDrawable(R.mipmap.vip10));
                break;
            case "VIP11":
                textView.setBackground(getResources().getDrawable(R.mipmap.vip11));
                break;
        }
    }


    private List<Fragment> listFra = new ArrayList<>();

    private FragmentManager fm;
    private FragmentTransaction ft;

    private void setFrag(String taskName) {
//        missionHallFrag = new MissionHallFrag();
//        listFra.add(missionHallFrag);
//        happyExchangeFrag = new HappyExchangeFrag();
//        listFra.add(happyExchangeFrag);
//        accountingChangeFrag = new AccountingChangeFrag();
//        listFra.add(accountingChangeFrag);
//        vipLevelFrag = new VIPLevelFrag();
//        listFra.add(vipLevelFrag);
//
//        fm = getActivity().getSupportFragmentManager();
////        AddFragmentUtil.initialization(fm,listFra,R.id.framnent_lin);
////
//        ft = fm.beginTransaction();
//
//        if (listFra.size() > 0) {
//            for (Fragment fragment : listFra) {
//                ft.add(R.id.framnent_lin, fragment);
//            }
//        }
////        AddFragmentUtil.showPostion(fm,0,listFra);
//        showPostion(0, listFra);


        mTitles = getResources().getStringArray(R.array.task_list);
        mTitles[0] = taskName ;

        //是否开启了任务中心
        if (configBean.getData() != null && "1".equals(configBean.getData().getHomeTypeSelect())) {
            mFragments.add(new MissionTabFrag());
        } else {
            mFragments.add(new MissionHallFrag());
        }

        mFragments.add(new HappyExchangeFrag());
        mFragments.add(new AccountingChangeFrag());
        mFragments.add(new VIPLevelFrag());

        mAdapter = new TabPagerAdapter(getChildFragmentManager(), mFragments, mTitles);
        vp.setAdapter(mAdapter);
        ((ViewPagerSlide) vp).setSlide(true);
        tab_title.setViewPager(vp, mTitles);
        vp.setCurrentItem(0);
        titlebar.setText(mTitles[0]);
        setmTitle();


    }

    private void showPostion(int index, List<Fragment> list) {

        if (list.size() > 0 && list.size() > index) {
            hideFragment(list);
            if (list.get(index) != null) {
                ft.show(list.get(index));
            }
            ft.commit();
        }
    }

    private void hideFragment(List<Fragment> list) {
        if (list.size() > 0) {
            for (Fragment fragment : list) {
                ft.hide(fragment);
            }
        }
    }

    @OnClick({R.id.iv_task, R.id.iv_sign, R.id.tv_money, R.id.iv_refresh})
    public void onClick(View view) {
        switch (view.getId()) {
            case R.id.iv_task:
//                getActivity().finish();
//                EventBus.getDefault().postSticky(new MessageEvent("login_my"));
//                startActivity(new Intent(getActivity(), MainActivity.class));
                if (getActivity() instanceof FragmentUtilAct) {
                    getActivity().finish();
                }else{
                    setMyf();
                }
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
        }
    }

    private boolean isok;
    private SharedPreferences sp;

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

                                sp = getContext().getSharedPreferences(SPConstants.SP_User, Context.MODE_PRIVATE);
                                SharedPreferences.Editor edit = sp.edit();
                                edit.putString(SPConstants.SP_BALANCE, FormatNum.amountFormat(userInfo.getData().getBalance(), 4));   //金额
                                edit.putString(SPConstants.SP_USR, userInfo.getData().getUsr());
                                edit.putString(SPConstants.SP_CURLEVELGRADE, userInfo.getData().getCurLevelGrade());
                                edit.putString(SPConstants.SP_NEXTLEVELGRADE, userInfo.getData().getNextLevelGrade());
                                edit.putString(SPConstants.SP_CURLEVELINT, userInfo.getData().getCurLevelInt());
                                edit.putString(SPConstants.SP_NEXTLEVELINT, userInfo.getData().getNextLevelInt());
                                edit.putString(SPConstants.SP_TASKREWARDTITLE, userInfo.getData().getTaskRewardTitle());
                                edit.putString(SPConstants.SP_TASKREWARDTOTAL, userInfo.getData().getTaskRewardTotal());
                                edit.putString(SPConstants.SP_TASKREWARD, userInfo.getData().getTaskReward());
                                edit.putString(SPConstants.SP_HASBANKCARD, userInfo.getData().isHasBankCard() + "");
                                edit.putString(SPConstants.SP_HASFUNDPWD, userInfo.getData().isHasFundPwd() + "");
                                edit.putString(SPConstants.SP_ISTEST, userInfo.getData().isIsTest() + "");
                                edit.putString(SPConstants.SP_UNREADMSG, userInfo.getData().getUnreadMsg() + "");
                                //头像
                                edit.putString(SPConstants.AVATAR, userInfo.getData().getAvatar());
                                edit.putString(SPConstants.SP_CURLEVELTITLE, userInfo.getData().getCurLevelTitle());
                                edit.putBoolean(SPConstants.SP_YUEBAOSHUTDOWN, userInfo.getData().isYuebaoSwitch());

                                edit.commit();


                                EventBus.getDefault().postSticky(new MessageEvent("userinfo"));
                            }
                        }
                    }

                    @Override
                    public void onError() {

                    }
                });
    }

    @Override
    public void getEvenMsg(Even even) {
        switch (even.getCode()) {
            case EvenBusCode.LONG_REFRESH_AMOUNT:
                isok = true;
                getInfo();
                break;
            case EvenBusCode.INTEGRAL_CHANGE:
                isok = true;
                getInfo();
                break;
            case EvenBusCode.CHANGE_THEME_STYLE_MYF:
                setTheme();
                break;
        }
    }

    private void setTheme() {
        Uiutils.setBaColor(getContext(), titlebar, false, null);
        Uiutils.setBaColor(getContext(), mianRel, false, null);
    }


    public void setmTitle() {
        vp.addOnPageChangeListener(new ViewPager.OnPageChangeListener() {
            @Override
            public void onPageScrolled(int i, float v, int i1) {

            }

            @Override
            public void onPageSelected(int position) {
                titlebar.setText(mTitles[position]);
                (list1.get(selePostion)).setSelected(false);
                (list1.get(position)).setSelected(true);
                adapter.notifyDataSetChanged();

                if (position > 0 && position < list1.size() - 1 && selePostion < position) {
                    horizontalRec.scrollToPosition(position + 1);
                } else if (position > 0 && position < list1.size() - 1 && selePostion > position) {
                    horizontalRec.scrollToPosition(position - 1);
                }


                selePostion = position;
            }

            @Override
            public void onPageScrollStateChanged(int i) {

            }
        });
    }

    protected void onTransformResume() {
        userInfo = (UserInfo) ShareUtils.getObject(getContext(), SPConstants.USERINFO, UserInfo.class);
        configBean = (ConfigBean) ShareUtils.getObject(getContext(), SPConstants.CONFIGBEAN, ConfigBean.class);
        setViewData();
    }

    private void setMyf() {
        if (!StringUtils.isEmpty(ShareUtils.getString(getContext(), "themetyp", ""))) {
            switch (ShareUtils.getString(getContext(), "themetyp", "")) {
                case "0":
                    FragmentUtilAct.startAct(getActivity(), new MyFragment1(false));
                    break;
                case "2":
                    FragmentUtilAct.startAct(getActivity(), new MyFragment1(false));
                    break;
                case "3":
                    FragmentUtilAct.startAct(getActivity(), new MyFragment1(false));
                    break;
                case "4":
                    FragmentUtilAct.startAct(getActivity(), new MyFragment2(false));
                    break;
                    default:
                        FragmentUtilAct.startAct(getActivity(), new MyFragment(false));
                        break;
            }
        } else {
            FragmentUtilAct.startAct(getActivity(), new MyFragment(false));
            return;
        }

    }
}
