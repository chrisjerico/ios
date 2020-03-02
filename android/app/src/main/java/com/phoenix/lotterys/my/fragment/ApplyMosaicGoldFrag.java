package com.phoenix.lotterys.my.fragment;

import android.graphics.Typeface;
import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;
import android.util.Log;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.example.zhouwei.library.CustomPopWindow;
import com.lzy.okgo.OkGo;
import com.lzy.okgo.callback.StringCallback;
import com.lzy.okgo.model.HttpParams;
import com.lzy.okgo.model.Response;
import com.phoenix.lotterys.R;import com.phoenix.lotterys.R2;
import com.phoenix.lotterys.my.adapter.ApplyMosaicGoledapter;
import com.phoenix.lotterys.my.adapter.TextAdapter;
import com.phoenix.lotterys.my.bean.ApplyMosaicGoldBean;
import com.phoenix.lotterys.my.bean.ApplyParticularsBean;
import com.phoenix.lotterys.util.Constants;
import com.phoenix.lotterys.util.GsonUtil;
import com.phoenix.lotterys.util.NetUtils;
import com.phoenix.lotterys.util.ReplaceUtil;
import com.phoenix.lotterys.util.SecretUtils;
import com.phoenix.lotterys.util.Uiutils;
import com.phoenix.lotterys.util.recyclerUtil.BaseRecyclerAdapter;
import com.phoenix.lotterys.view.CustomTitleBar;
import com.scwang.smartrefresh.layout.SmartRefreshLayout;
import com.scwang.smartrefresh.layout.api.RefreshLayout;
import com.scwang.smartrefresh.layout.listener.OnLoadMoreListener;
import com.scwang.smartrefresh.layout.listener.OnRefreshListener;
import com.wanxiangdai.commonlibrary.base.BaseFragment;
import com.wanxiangdai.commonlibrary.util.EvenBusUtil.Even;
import com.wanxiangdai.commonlibrary.util.EvenBusUtil.EvenBusCode;
import com.wanxiangdai.commonlibrary.util.ImageLoadUtil;
import com.wanxiangdai.commonlibrary.util.MeasureUtil;
import com.wanxiangdai.commonlibrary.util.StringUtils;
import com.wanxiangdai.commonlibrary.util.ToastUtil;

import java.net.URLDecoder;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import butterknife.BindView;
import im.delight.android.webview.AdvancedWebView;

/**
 * 文件描述:申请彩金
 * 创建者: IAN
 * 创建时间: 2019/9/5 14:06
 */
public class ApplyMosaicGoldFrag extends BaseFragment implements OnRefreshListener,
        OnLoadMoreListener, BaseRecyclerAdapter.OnItemClickListener, View.OnClickListener {

    @BindView(R2.id.titlebar)
    CustomTitleBar titlebar;
    @BindView(R2.id.mail_rec)
    RecyclerView mailRec;
    @BindView(R2.id.smart_refresh_layout)
    SmartRefreshLayout smartRefreshLayout;
    @BindView(R2.id.text1)
    TextView text1;
    @BindView(R2.id.text2)
    TextView text2;
    @BindView(R2.id.text3)
    TextView text3;
    @BindView(R2.id.apply_lin)
    LinearLayout applyLin;

    public ApplyMosaicGoldFrag() {
        super(R.layout.mail_act, true, true);
    }

    private CustomPopWindow customPopWindow;
    private CustomPopWindow.PopupWindowBuilder popupWindowBuilder;
    private View contentView;
    private View contentView1;
    private int type;

    @Override
    public void initView(View view) {

        type = getArguments().getInt("type");

        titlebar.setVisibility(View.GONE);
        smartRefreshLayout.setOnRefreshListener(this);
        smartRefreshLayout.setOnLoadMoreListener(this);

        smartRefreshLayout.setEnableLoadMore(false);
        smartRefreshLayout.setEnableRefresh(true);

        Uiutils.setRec(getContext(), mailRec, 1);
        if (2==type){
            applyLin.setVisibility(View.VISIBLE);
            text1.setText("申请时间");
            text2.setText("申请金额");
            text3.setText("状态");
            text1.setTypeface(Typeface.defaultFromStyle(Typeface.BOLD));
            text2.setTypeface(Typeface.defaultFromStyle(Typeface.BOLD));
            text3.setTypeface(Typeface.defaultFromStyle(Typeface.BOLD));
            adapter = new ApplyMosaicGoledapter(getContext(), list, R.layout.apply_mosaic_gole_adapter,2);
        }else{
            adapter = new ApplyMosaicGoledapter(getContext(), list, R.layout.apply_mosaic_gole_adapter,1);
        }

        adapter.setOnItemClickListener(this);
        mailRec.setAdapter(adapter);

        getData(true);


        setContextView();



    }

    /**
     * 广告pop
     */
    private void setAdvertisementPop() {
        contentView = LayoutInflater.from(getContext()).inflate(R.layout.apply_gold_pop_lay, null);
        contentView.findViewById(R.id.bet_pop_close_tex).setTag(contentView);
        contentView.findViewById(R.id.bet_pop_goto_tex).setTag(contentView);
        contentView.findViewById(R.id.bet_pop_close_tex).setOnClickListener(this);
        contentView.findViewById(R.id.bet_pop_goto_tex).setOnClickListener(this);

//        ImageLoadUtil.ImageLoad(lotteryNum.getData().getAdPic(),getContext(),
//                contentView.findViewById(R.id.bet_pop_img),"");
//        popupWindowBuilder = Uiutils.setPopSetting(getContext(), contentView,
//                MeasureUtil.dip2px(getContext(), 300),
//                ViewGroup.LayoutParams.WRAP_CONTENT,
//                true, true, 0.5f);

//        if (customPopWindow == null) {
//            customPopWindow = popupWindowBuilder.create();
//            customPopWindow.showAtLocation(contentView, Gravity.CENTER, 0, 0);
//        }
    }

    private void getImgCode() {

        String url ="";
        if (Constants.ENCRYPT){
            url =Constants.BaseUrl()+Constants.IMGCODE+SecretUtils.DESede(Uiutils.
                    getToken(getContext()))+Constants.SIGN+"&sign="+SecretUtils.RsaToken();
        }else{
            url=Constants.BaseUrl()+Constants.IMGCODE+Uiutils.getToken(getContext());
        }
        try {
            url = URLDecoder.decode(url, "utf-8");
        }catch (Exception e){

        }

        OkGo.getInstance().cancelTag(getActivity());
        OkGo.<String>get(url).tag(getActivity()).execute(new StringCallback() {
            @Override
            public void onSuccess(Response<String> response) {
                Log.e("aaa","bb");
                if (response != null && response.body() != null) {
                    String base64DataStr = response.body() + "";
                    if (!StringUtils.isEmpty(base64DataStr)) {
                        String base64Str = base64DataStr.substring(base64DataStr.indexOf(",") + 1, base64DataStr.length());
                        ivImg.setImageBitmap(Uiutils.base64ToBitmap(base64Str + ""));
                    }
                }
            }
        });
    }

    private ImageView ivImg;
    private AdvancedWebView activity_description_tex;
    private EditText in_put_money_edit;
    private EditText apply_instructions_edit;
    private EditText money_edit;

    private List<String> apply_list =new ArrayList<>();
    private TextAdapter textAdapter ;
    private RecyclerView apply_rec;
    /**
     * 广告pop
     */
    private void setAdvertisementPop1() {
        contentView1 = LayoutInflater.from(getContext()).inflate(R.layout.apply_gold_pop_lay1, null);

        activity_description_tex = contentView1.findViewById(R.id.activity_description_tex);
        apply_rec = contentView1.findViewById(R.id.apply_rec);

        Uiutils.setRec(getContext(),apply_rec,1,true);
        textAdapter =new TextAdapter(getContext(),apply_list,R.layout.text);
        apply_rec.setAdapter(textAdapter);

        textAdapter.setOnItemClickListener(new BaseRecyclerAdapter.OnItemClickListener() {
            @Override
            public void onItemClick(RecyclerView parent, View view, int position) {
                in_put_money_edit.setText(apply_list.get(position));
            }
        });

        ivImg = contentView1.findViewById(R.id.iv_img);
        in_put_money_edit = contentView1.findViewById(R.id.in_put_money_edit);
        apply_instructions_edit = contentView1.findViewById(R.id.apply_instructions_edit);
        money_edit = contentView1.findViewById(R.id.money_edit);
//        contentView1.findViewById(R.id.bet_pop_close_tex).setTag(contentView1);
//        contentView1.findViewById(R.id.bet_pop_goto_tex).setTag(contentView1);
        contentView1.findViewById(R.id.bet_pop_close_tex1).setOnClickListener(this);
        contentView1.findViewById(R.id.bet_pop_goto_tex1).setOnClickListener(this);
        contentView1.findViewById(R.id.iv_img).setOnClickListener(this);
        getImgCode();
//        getImgCode();
    }

    private void setContextView() {
        setAdvertisementPop();

//        contentView = LayoutInf
//        later.from(getContext()).inflate(R.layout.dragon_assistant_pop,
//                null);
//        contentView1 = LayoutInflater.from(getContext()).inflate(R.layout.dragon_assistant_pop,
//                null);

    }

    private ApplyMosaicGoldBean mailFragBean;
    private int page = 1;
    private int rows = 20;

    private void getData(boolean b) {
        Map<String, Object> map = new HashMap<>();
        map.put("page", page + "");
        map.put("rows", rows + "");
        map.put("token", Uiutils.getToken(getContext()));

        String url = "";

        if (type == 1) {
            url = Constants.WINAPPLYLIST;
        } else {

            url = Constants.APPLYWINLOG;
        }

        NetUtils.get(url ,map, true, getContext(),
                new NetUtils.NetCallBack() {
                    @Override
                    public void onSuccess(String object) {
                        smartRefreshLayout.finishRefresh();
                        smartRefreshLayout.finishLoadMore();

                        mailFragBean = GsonUtil.fromJson(object, ApplyMosaicGoldBean.class);
                        if (page == 1) {
                            if (list.size() > 0)
                                list.clear();
                        }

                        if (null != mailFragBean && null != mailFragBean.getData() && null != mailFragBean.
                                getData().getList() && mailFragBean.getData().getList().size() > 0) {
                            list.addAll(mailFragBean.getData().getList());
                        }

                        if (null != mailFragBean && null != mailFragBean.getData()&& list.size() != mailFragBean.getData().getTotal()) {
                            smartRefreshLayout.setEnableLoadMore(true);
                        } else {
                            smartRefreshLayout.setEnableLoadMore(false);
                        }

                        if (type==1)
                            smartRefreshLayout.setEnableLoadMore(false);

                        adapter.notifyDataSetChanged();
                    }

                    @Override
                    public void onError() {
                        if (null!=smartRefreshLayout) {
                            smartRefreshLayout.finishRefresh();
                            smartRefreshLayout.finishLoadMore();
                        }
                    }
                });
    }

    private ApplyMosaicGoledapter adapter;
    private List<ApplyMosaicGoldBean.DataBean.ListBean> list = new ArrayList<>();

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

    @Override
    public void onItemClick(RecyclerView parent, View view, int position) {
        switch (type){
            case 1:
                if (!StringUtils.isEmpty(list.get(position).getParam().getWin_apply_image())) {
                    ImageLoadUtil.ImageLoad(getContext(), list.get(position).getParam().getWin_apply_image(),
                            contentView.findViewById(R.id.bet_pop_img));
                } else {
                    ImageLoadUtil.ImageLoad(getContext(), R.drawable.winapply_default,
                            contentView.findViewById(R.id.bet_pop_img));
                }
                Log.e("aaa===","//");
                show(contentView);
                break;
            case 2:
                getParticulars(list.get(position).getId());
                break;
        }

    }

    private ApplyParticularsBean applyParticularsBean;
    /**
     * 详情
     * @param id
     */
    private void getParticulars(String id) {
        Map<String,Object> map =new HashMap<>();
        map.put("id",id);
        map.put("token",Uiutils.getToken(getContext()));

        NetUtils.get(Constants.APPLYWINLOGDETAIL ,map, true,
                getContext(), new NetUtils.NetCallBack() {
                    @Override
                    public void onSuccess(String object) {
                        applyParticularsBean =Uiutils.stringToObject(object,ApplyParticularsBean.class);

                        if (null!=applyParticularsBean&&null!=applyParticularsBean.getData()){
                                if (null!=contentView2){
                                    setV();
                                }else{
                                    setAdvertisementPop2();
                                }
                        }
                    }

                    @Override
                    public void onError() {

                    }
                });

    }

    private View contentView2;
    private void setAdvertisementPop2() {
        contentView2 = LayoutInflater.from(getContext()).inflate(R.layout.apply_gold_pop_lay2, null);
        getPop2view();
        setV();


    }

    private void setV() {
        Uiutils.setText(apply_lin1text2,applyParticularsBean.getData().getWinName());
        Uiutils.setText(apply_lin2text2,applyParticularsBean.getData().getUpdateTime());
        Uiutils.setText(apply_lin3text2,applyParticularsBean.getData().getAmount());
        Uiutils.setText(apply_lin4text2,applyParticularsBean.getData().getUserComment());
        Uiutils.setText(apply_lin5text2,applyParticularsBean.getData().getState());
        Uiutils.setText(apply_lin6text2,applyParticularsBean.getData().getAdminComment());
        Log.e("aaa===","///");
//        show(contentView2);


        popupWindowBuilder = Uiutils.setPopSetting(getContext(), contentView2,Uiutils.getWith(getContext()
                ,50), MeasureUtil.dip2px(getContext(),450),
                true, true, 0.5f);

//        popupWindowBuilder.enableBackgroundDark(true);
        customPopWindow = popupWindowBuilder.create();
        customPopWindow.showAtLocation(contentView2, Gravity.CENTER, 0, 0);
        Uiutils.setStateColor(getActivity());

    }

    private View apply_lin1;
    private View apply_lin2;
    private View apply_lin3;
    private View apply_lin4;
    private View apply_lin5;
    private View apply_lin6;
    private TextView apply_lin1text1;
    private TextView apply_lin1text2;

    private TextView apply_lin2text1;
    private TextView apply_lin2text2;

    private TextView apply_lin3text1;
    private TextView apply_lin3text2;

    private TextView apply_lin4text1;
    private TextView apply_lin4text2;

    private TextView apply_lin5text1;
    private TextView apply_lin5text2;

    private TextView apply_lin6text1;
    private TextView apply_lin6text2;

    private void getPop2view() {
        contentView2.findViewById(R.id.pop_lay2_close_tex).setOnClickListener(this);
        apply_lin1 = contentView2.findViewById(R.id.apply_lin1);
        apply_lin2 = contentView2.findViewById(R.id.apply_lin2);
        apply_lin3 = contentView2.findViewById(R.id.apply_lin3);
        apply_lin4 = contentView2.findViewById(R.id.apply_lin4);
        apply_lin5 = contentView2.findViewById(R.id.apply_lin5);
        apply_lin6 = contentView2.findViewById(R.id.apply_lin6);
        apply_lin1text1=apply_lin1.findViewById(R.id.text1);
        apply_lin1text2=apply_lin1.findViewById(R.id.text2);

        apply_lin2text1=apply_lin2.findViewById(R.id.text1);
        apply_lin2text2=apply_lin2.findViewById(R.id.text2);

        apply_lin3text1=apply_lin3.findViewById(R.id.text1);
        apply_lin3text2=apply_lin3.findViewById(R.id.text2);

        apply_lin4text1=apply_lin4.findViewById(R.id.text1);
        apply_lin4text2=apply_lin4.findViewById(R.id.text2);

        apply_lin5text1=apply_lin5.findViewById(R.id.text1);
        apply_lin5text2=apply_lin5.findViewById(R.id.text2);

        apply_lin6text1=apply_lin6.findViewById(R.id.text1);
        apply_lin6text2=apply_lin6.findViewById(R.id.text2);

        apply_lin1text1.setText("活动名称：");
        apply_lin2text1.setText("申请日期：");
        apply_lin3text1.setText("申请金额：");
        apply_lin4text1.setText("申请原因：");
        apply_lin5text1.setText("审核结果：");
        apply_lin6text1.setText("审核说明：");
    }


    private void show(View view) {

//        if (!Uiutils.isFastClick())
//            return;

        popupWindowBuilder = Uiutils.setPopSetting(getContext(), view,Uiutils.getWith(getContext()
                ,50), ViewGroup.LayoutParams.WRAP_CONTENT,
                true, true, 0.5f);

//        popupWindowBuilder.enableBackgroundDark(true);
        customPopWindow = popupWindowBuilder.create();
        customPopWindow.showAtLocation(view, Gravity.CENTER, 0, 0);
        Uiutils.setStateColor(getActivity());
    }

    private ApplyMosaicGoldBean.DataBean.ListBean listBean;

    @Override
    public void getEvenMsg(Even even) {
        switch (even.getCode()) {
            case EvenBusCode.APPLY_MOSAIC_GOLD:
                if (!Uiutils.isFastClick())
                    return;

                listBean = list.get((Integer) even.getData());
                setAdvertisementPop1();

                if (null!=listBean&&null!=listBean.getParam()&&!StringUtils.isEmpty(listBean.getParam().
                        getShowWinAmount())&&
                        StringUtils.equals("1",listBean.getParam().getShowWinAmount())){
                    contentView1.findViewById(R.id.money_lin).setVisibility(View.VISIBLE);
                    in_put_money_edit.setVisibility(View.VISIBLE);
                }else{
                    contentView1.findViewById(R.id.money_lin).setVisibility(View.GONE);
                    in_put_money_edit.setVisibility(View.GONE);
                }

                if (apply_list.size()>0)
                    apply_list.clear();

                if (null!=listBean&&null!=listBean.getParam()) {

                    if (!StringUtils.isEmpty(listBean.getParam().getWin_apply_content())) {
                        activity_description_tex.loadDataWithBaseURL(null, ReplaceUtil.getHtmlData(listBean.getParam().getWin_apply_content()),
                                "text/html", "utf-8", null);
                    }

                    addList(listBean.getParam().getQuickAmount1());
                    addList(listBean.getParam().getQuickAmount2());
                    addList(listBean.getParam().getQuickAmount3());
                    addList(listBean.getParam().getQuickAmount4());
                    addList(listBean.getParam().getQuickAmount5());
                    addList(listBean.getParam().getQuickAmount6());
                    addList(listBean.getParam().getQuickAmount7());
                    addList(listBean.getParam().getQuickAmount8());
                    addList(listBean.getParam().getQuickAmount9());
                    addList(listBean.getParam().getQuickAmount10());
                    addList(listBean.getParam().getQuickAmount11());
                    addList(listBean.getParam().getQuickAmount12());
                }
                textAdapter.notifyDataSetChanged();
                show(contentView1);
                break;
                case  EvenBusCode.APPLY_MOSAIC_GOLD_RESHRE:
                    page = 1;
                    getData(false);
                    break;
        }
    }

    private void addList(String name) {
        if (!StringUtils.isEmpty(name)&&
        Double.parseDouble(name)>0)
            apply_list.add(name);
    }

    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.bet_pop_close_tex:
                    customPopWindow.dissmiss();
                Uiutils.setStateColor(getActivity());
                break;
            case R.id.bet_pop_goto_tex:
                customPopWindow.dissmiss();
                Uiutils.setStateColor(getActivity());
                break;
            case R.id.bet_pop_close_tex1:
                customPopWindow.dissmiss();
                Uiutils.setStateColor(getActivity());
                break;
            case R.id.bet_pop_goto_tex1:
                if (null!=listBean&&null!=listBean.getParam()&&!StringUtils.isEmpty(listBean.getParam().
                        getShowWinAmount())&&
                        StringUtils.equals("1",listBean.getParam().getShowWinAmount())) {
                    if (null != in_put_money_edit && StringUtils.isEmpty(in_put_money_edit.getText().toString())) {
                        ToastUtil.toastShortShow(getContext(), "申请金额不能为空");
                        return;
                    }
                }
                if (null != apply_instructions_edit && StringUtils.isEmpty(apply_instructions_edit.getText().toString())) {
                    ToastUtil.toastShortShow(getContext(), "申请说明不能为空");
                    return;
                }

                if (null != money_edit && StringUtils.isEmpty(money_edit.getText().toString())) {
                    ToastUtil.toastShortShow(getContext(), "验证码不能为空");
                    return;
                }
                customPopWindow.dissmiss();
                Uiutils.setStateColor(getActivity());
                getApply();
                break;
            case R.id.iv_img:
                getImgCode();
                break;
            case R.id.pop_lay2_close_tex:
                customPopWindow.dissmiss();
                Uiutils.setStateColor(getActivity());
                break;

        }
    }

    private void getApply() {

        HttpParams map = new HttpParams();

        String url =null;
        if (!Constants.ENCRYPT) {
            map.put("id", listBean.getId());
            if (StringUtils.isEmpty(in_put_money_edit.getText().toString())) {
                map.put("amount", 0 + "");
            } else {
                map.put("amount", in_put_money_edit.getText().toString());
            }
            map.put("userComment", apply_instructions_edit.getText().toString());
            map.put("imgCode", money_edit.getText().toString());
            map.put("token", Uiutils.getToken(getContext()));

            url=Constants.APPLYWIN;
        }else {
            map.put("id", SecretUtils.DESede(listBean.getId()));
            if (StringUtils.isEmpty(in_put_money_edit.getText().toString())) {
                map.put("amount", SecretUtils.DESede(0 + ""));
            } else {
                map.put("amount", SecretUtils.DESede(in_put_money_edit.getText().toString()));
            }
            map.put("userComment", SecretUtils.DESede(apply_instructions_edit.getText().toString()));
            map.put("imgCode", SecretUtils.DESede(money_edit.getText().toString()));
            map.put("token", SecretUtils.DESede(Uiutils.getToken(getContext())));
            map.put("sign", SecretUtils.RsaToken());

            url=Constants.APPLYWIN+Constants.SIGN;
        }


        NetUtils.post1(url, map, true, getContext(), new NetUtils.NetCallBack() {
            @Override
            public void onSuccess(String object) {
                    Uiutils.onSuccessTao(object,getContext());
            }

            @Override
            public void onError() {

            }
        });

    }


}
