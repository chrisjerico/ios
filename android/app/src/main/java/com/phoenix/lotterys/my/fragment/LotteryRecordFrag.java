package com.phoenix.lotterys.my.fragment;

import android.annotation.SuppressLint;
import android.os.Bundle;
import androidx.recyclerview.widget.RecyclerView;
import android.text.TextUtils;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;
import com.example.zhouwei.library.CustomPopWindow;
import com.phoenix.lotterys.R;import com.phoenix.lotterys.R2;
import com.phoenix.lotterys.application.BaseFragments;
import com.phoenix.lotterys.my.adapter.LotteryRecordAdapter;
import com.phoenix.lotterys.my.adapter.LotteryRecordFragAdapter;
import com.phoenix.lotterys.my.bean.LotteryRecordBean;
import com.phoenix.lotterys.my.bean.LotteryRecordPopBean;
import com.phoenix.lotterys.my.bean.My_item;
import com.phoenix.lotterys.util.Constants;
import com.phoenix.lotterys.util.GsonUtil;
import com.phoenix.lotterys.util.NetUtils;
import com.phoenix.lotterys.util.Uiutils;
import com.phoenix.lotterys.util.recyclerUtil.BaseRecyclerAdapter;
import com.phoenix.lotterys.view.CustomTitleBar;
import com.phoenix.lotterys.view.MaxHeightRecyclerView;
import com.wanxiangdai.commonlibrary.util.EvenBusUtil.Even;
import com.wanxiangdai.commonlibrary.util.EvenBusUtil.EvenBusCode;
import com.wanxiangdai.commonlibrary.util.ImageLoadUtil;
import com.wanxiangdai.commonlibrary.util.MeasureUtil;
import com.wanxiangdai.commonlibrary.util.StringUtils;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import butterknife.BindView;
import butterknife.OnClick;

/**
 * 文件描述:  开奖记录
 * 创建者: IAN
 * 创建时间: 2019/7/10 15:51
 */
@SuppressLint("ValidFragment")
public class LotteryRecordFrag extends BaseFragments implements BaseRecyclerAdapter.
        OnItemClickListener, View.OnClickListener {


    @BindView(R2.id.titlebar)
    CustomTitleBar titlebar;
    @BindView(R2.id.time_hoice_tex)
    TextView timeHoiceTex;
    @BindView(R2.id.time_hoice_lin)
    LinearLayout timeHoiceLin;
    @BindView(R2.id.type_sele_tex)
    TextView typeSeleTex;
    @BindView(R2.id.lottery_record_rec)
    RecyclerView lotteryRecordRec;
    @BindView(R2.id.type_img)
    ImageView typeImg;
    @BindView(R2.id.no_more_records_tex)
    TextView noMoreRecordsTex;
    @BindView(R2.id.main_lin)
    LinearLayout mainLin;
    @BindView(R2.id.periods_tex)
    TextView periodsTex;
    @BindView(R2.id.training_tex)
    TextView trainingTex;

    private MaxHeightRecyclerView popRec;

    private CustomPopWindow.PopupWindowBuilder popupWindowBuilder;
    private CustomPopWindow popWindow;
    private View contentView;

    private String id;//当前的彩种ID
    private LotteryRecordPopBean.ListBean curLotteryBean;//当前的彩种
    private String gameType;
    //    private String popType;
    boolean isHide = false;

    @SuppressLint("ValidFragment")
    public LotteryRecordFrag(boolean isHide) {
        super(R.layout.lottery_record_frag, true, true);
        this.isHide = isHide;
    }

    private ImageView ivmore;
    private View timeHoiceLi;

    private List<String> listData;

    @Override
    public void initView(View view) {
        Bundle bundle = this.getArguments();

        try {
            if (!isHide) {
                id = bundle.getString("id");
                gameType = bundle.getString("gameType");
            } else {
                gameType = "";
                id = "";
            }
        } catch (Exception e) {
            e.printStackTrace();
            id = "1";
            gameType = "cqssc";
        }


        Log.e("gameType", gameType + "///");

        timeHoiceLi = view.findViewById(R.id.time_hoice_li);
        Uiutils.setBarStye(titlebar, getActivity());
        titlebar.setText("开奖记录");

        titlebar.setRIghtImg(R.drawable.calendar_white, View.VISIBLE);
        titlebar.setRightIconOnClickListener(this);
        ivmore = titlebar.getView().findViewById(R.id.iv_more);

        contentView = LayoutInflater.from(getContext()).inflate(R.layout.city_pop,
                null);
        LinearLayout main_lin = contentView.findViewById(R.id.main_lin);
        main_lin.setBackground(getResources().getDrawable(R.color.white));
        popRec = contentView.findViewById(R.id.pop_rec);

        listData = Uiutils.test(7);
        if (null != listData && listData.size() > 0) {
            for (int i = 0; i < listData.size(); i++) {
                if (i == 0) {
                    listPopTime.add(new My_item(listData.get(i).substring(5,
                            listData.get(i).length()), true));
                } else {
                    listPopTime.add(new My_item(listData.get(i).substring(5,
                            listData.get(i).length()), false));
                }
            }
        }

        if (listPopTime.size() > 0) {
            typeSeleTex.setText(listPopTime.get(0).getTitle() + "(今天)");
            date = listData.get(0);
            dates = listPopTime.get(0).getTitle();
        }

        if (!StringUtils.isEmpty(gameType) && StringUtils.equals("lhc", gameType)) {
            ivmore.setVisibility(View.GONE);
            typeSeleTex.setVisibility(View.GONE);
        } else {
            ivmore.setVisibility(View.VISIBLE);
            typeSeleTex.setVisibility(View.VISIBLE);
        }

        adapterPop = new LotteryRecordAdapter(getContext(), listPop, R.layout.city_pop_adapter);
        adapterPop.setOnItemClickListener(this);
        Uiutils.setRec(getContext(), popRec, 0);
        popRec.setAdapter(adapterPop);

        popupWindowBuilder = Uiutils.setPopSetting(getContext(), contentView,
                MeasureUtil.dip2px(getContext(), 120), ViewGroup.LayoutParams.WRAP_CONTENT,
                true, true, 0.5f);

//        popWindow = popupWindowBuilder.create();

        Uiutils.setRec(getContext(), lotteryRecordRec, 0);
        adapter = new LotteryRecordFragAdapter(getContext(), lists, R.layout.
                lottery_record_frag_adapter);

        lotteryRecordRec.setAdapter(adapter);

        getList();
        if (isHide)
            titlebar.setIvBackHide(View.GONE);

        Uiutils.setBaColor(getContext(), titlebar, false, null);


        if (Uiutils.setBaColor(getContext(), null)) {
            mainLin.setBackgroundColor(getContext().getResources().getColor(R.color.black));
            timeHoiceTex.setTextColor(getContext().getResources().getColor(R.color.color_white));
            typeSeleTex.setTextColor(getContext().getResources().getColor(R.color.color_white));
            periodsTex.setTextColor(getContext().getResources().getColor(R.color.color_white));
            trainingTex.setTextColor(getContext().getResources().getColor(R.color.color_white));

        }


    }

    private LotteryRecordPopBean lotteryRecordPopBean;

    /**
     * 彩票例表
     */
    private void getList() {
        NetUtils.get(Constants.LOTTERYGAMES, "", true, getContext(), new NetUtils.NetCallBack() {
            @Override
            public void onSuccess(String object) {

                if (!StringUtils.isEmpty(object)) {
                    lotteryRecordPopBean = GsonUtil.fromJson(object, LotteryRecordPopBean
                            .class);

                    if (null != lotteryRecordPopBean && null != lotteryRecordPopBean.getData() &&
                            null != lotteryRecordPopBean.getData() && lotteryRecordPopBean.getData().size() > 0) {

                        for (int i = 0; i < lotteryRecordPopBean.getData().size(); i++) {
                            LotteryRecordPopBean.DataBean dBean = lotteryRecordPopBean.getData().get(i);
                            if (null != dBean.getList() && dBean.getList().size() > 0) {
                                for (LotteryRecordPopBean.ListBean listBean : dBean.getList()) {
                                    if (!StringUtils.isEmpty(listBean.getIsInstant()) && StringUtils.equals(
                                            "1", listBean.getIsInstant())) {
                                    } else {
                                        listPopProject0.add(listBean);
                                    }

                                }
                            }
                        }

                        LotteryRecordPopBean.ListBean firstBean = listPopProject0.get(0);
                        if (listPopProject0.size() > 0) {
                            for (LotteryRecordPopBean.ListBean listBean : listPopProject0) {
                                listPopProject.add(new My_item(Integer.parseInt(listBean.getId()),
                                        listBean.getTitle()));
                            }

                            if (listPop.size() > 0)
                                listPop.clear();

                            if (null != listPopProject && null != listPop)
                                listPop.addAll(listPopProject);

                            if (listPopProject0.size() > 0) {
//                                timeHoiceTex.setText(listPopProject0.get(0).getTitle());
//                                ImageLoadUtil.ImageLoad(getContext(), listPopProject0.get(0).getPic()
//                                        , typeImg, R.drawable.alerter_ic_face);
//                                id = listPopProject0.get(0).getId();


                                for (LotteryRecordPopBean.ListBean listBean : listPopProject0) {
                                    if (listBean.getId().equals(id)) {
                                        timeHoiceTex.setText(listBean.getTitle());
                                        //找出当前的彩票对象
                                        curLotteryBean = listBean;
                                        ImageLoadUtil.ImageLoad(getContext(), listBean.getPic()
                                                , typeImg, R.drawable.alerter_ic_face);
                                    }
                                }


                                adapter.setType(firstBean.getGameType());
                            }
                            adapterPop.notifyDataSetChanged();
                        }

                        if (TextUtils.isEmpty(gameType)) {
                            gameType = firstBean.getGameType();
                            timeHoiceTex.setText(firstBean.getTitle());
                        }

                        //没有游戏类型，就把取第一个
                        if (TextUtils.isEmpty(id)) {
                            id = firstBean.getId();
                            curLotteryBean = firstBean;
                        }

                        getData();
                    }
                }
            }

            @Override
            public void onError() {
            }
        });
    }

    private String date;
    private String dates;
    private LotteryRecordBean lotteryRecordBean;


    /**
     * 是否为 低频彩种
     * @param bean
     * @return
     */
    private boolean lowLottery(LotteryRecordPopBean.ListBean bean) {
        return bean != null && (StringUtils.equals("70", bean.getId())
                || StringUtils.equals("2", bean.getId())
                || StringUtils.equals("6", bean.getId())
                || "1".equals(bean.getLowFreq())
        );
    }

    private void getData() {
        Map<String, Object> map = new HashMap<>();
        map.put("id", id);
//        map.put("date", date);
        if (lowLottery(curLotteryBean)) {
//            map.put("date", Uiutils.getPastDate(30));
//            map.put("date", date);
        } else {
            map.put("date", date);
        }

        NetUtils.get(Constants.LOTTERYHISTORY, map, true,
                getContext(), new NetUtils.NetCallBack() {
                    @Override
                    public void onSuccess(String object) {

                        if (lists.size() > 0)
                            lists.clear();

                        if (!StringUtils.isEmpty(object)) {
                            lotteryRecordBean = GsonUtil.fromJson(object, LotteryRecordBean
                                    .class);

                            if (null != lotteryRecordBean && null != lotteryRecordBean.getData()
                                    && null != lotteryRecordBean.getData().getList() && lotteryRecordBean.getData().getList().size() > 0) {
                                lists.addAll(lotteryRecordBean.getData().getList());
                            }
                        }
                        if (lists.size() == 0) {
                            noMoreRecordsTex.setVisibility(View.VISIBLE);
                        } else {
                            noMoreRecordsTex.setVisibility(View.GONE);
                        }
                        adapter.notifyDataSetChanged();
                    }

                    @Override
                    public void onError() {

                    }
                });
    }

    private List<My_item> listPopProject = new ArrayList<>();
    private List<LotteryRecordPopBean.ListBean> listPopProject0 = new ArrayList<>();
    private List<My_item> listPopTime = new ArrayList<>();

    private List<My_item> listPop = new ArrayList<>();
    private LotteryRecordAdapter adapterPop;
    private LotteryRecordFragAdapter adapter;

    private int index;

    @OnClick(R.id.time_hoice_lin)
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.time_hoice_lin:
                timeHoiceTex.setSelected(true);
                timeHoiceLi.setBackgroundColor(getContext().getResources().getColor(R.color.title_backgroup));
                index = 1;

                if (listPop.size() > 0)
                    listPop.clear();

                if (listPopProject.size() > 0)
                    listPop.addAll(listPopProject);

//                adapterPop = new LotteryRecordAdapter(getContext(), listPop, R.layout.city_pop_adapter
//                        , timeHoiceTex.getText().toString());
//                adapterPop.setOnItemClickListener(this);
//                Uiutils.setRec(getContext(), popRec, 1);

                adapterPop.setName(timeHoiceTex.getText().toString());
                popRec.setAdapter(adapterPop);

                if (listPop.size() > 0) {
                    popWindow = popupWindowBuilder.create();
                    popWindow.showAsDropDown(timeHoiceLin, 0, 0);
                    Uiutils.setStateColor(getActivity());
                }
                break;
            case R.id.iv_more:

                timeHoiceTex.setSelected(false);
                timeHoiceLi.setBackgroundColor(getContext().getResources().getColor(R.color.my_line));

                index = 2;

                if (listPop.size() > 0)
                    listPop.clear();

                if (listPopTime.size() > 0)
                    listPop.addAll(listPopTime);

//                adapterPop = new LotteryRecordAdapter(getContext(), listPop, R.layout.city_pop_adapter, dates);
//                adapterPop.setOnItemClickListener(this);
//                Uiutils.setRec(getContext(), popRec, 1);

                adapterPop.setName(dates);
                popRec.setAdapter(adapterPop);

                if (listPop.size() > 0) {
                    popWindow = popupWindowBuilder.create();
                    popWindow.showAsDropDown(ivmore, 0, 0);
                    Uiutils.setStateColor(getActivity());
                }
                break;
        }
    }

    private List<LotteryRecordBean.DataBean.ListBean> lists = new ArrayList<>();

    @Override
    public void onItemClick(RecyclerView parent, View view, int position) {
        popWindow.dissmiss();
        Uiutils.setStateColor(getActivity());
        Uiutils.setStateColor(getActivity());
        if (index == 1) {
            //当前选中了哪个彩种
            timeHoiceTex.setText(listPop.get(position).getTitle());
            LotteryRecordPopBean.ListBean listBean = listPopProject0.get(position);
            curLotteryBean = listBean;

            id = listBean.getId();
            gameType = listBean.getGameType();

            if (lowLottery(curLotteryBean)) {
                ivmore.setVisibility(View.GONE);
                typeSeleTex.setVisibility(View.GONE);
            } else {
                ivmore.setVisibility(View.VISIBLE);
                typeSeleTex.setVisibility(View.VISIBLE);
            }


            adapter.setType(listBean.getGameType());
            ImageLoadUtil.ImageLoad(getContext(), listBean.getPic(), typeImg);

        } else {
            date = listData.get(position);
            dates = listPopTime.get(position).getTitle();
            switch (position) {
                case 0:
                    typeSeleTex.setText(listPopTime.get(position).getTitle() + "(今天)");
                    break;
                case 1:
                    typeSeleTex.setText(listPopTime.get(position).getTitle() + "(昨天)");
                    break;
                case 2:
                    typeSeleTex.setText(listPopTime.get(position).getTitle() + "(前天)");
                    break;
                default:
                    typeSeleTex.setText(listPopTime.get(position).getTitle());
                    break;
            }
        }
        getData();
    }

    @Override
    public void getEvenMsg(Even even) {
        switch (even.getCode()) {
            case EvenBusCode.CHANGE_THEME_STYLE_MYF:
                Uiutils.setBaColor(getContext(), titlebar, false, null);
                break;
        }
    }
}
