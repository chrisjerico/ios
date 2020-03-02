package com.phoenix.lotterys.my.fragment;

import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.graphics.Color;
import android.os.Handler;
import android.os.Message;
import androidx.recyclerview.widget.RecyclerView;
import android.text.Editable;
import android.text.SpannableString;
import android.text.Spanned;
import android.text.TextUtils;
import android.text.TextWatcher;
import android.text.style.ForegroundColorSpan;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.EditText;
import android.widget.TextView;

import com.example.zhouwei.library.CustomPopWindow;
import com.phoenix.lotterys.R;import com.phoenix.lotterys.R2;
import com.phoenix.lotterys.application.BaseFragments;
import com.phoenix.lotterys.buyhall.bean.ShareBetInfo;
import com.phoenix.lotterys.buyhall.bean.ShareBetList;
import com.phoenix.lotterys.coupons.activity.WebActivity;
import com.phoenix.lotterys.main.bean.ConfigBean;
import com.phoenix.lotterys.my.adapter.DragonAssistantAdapter;
import com.phoenix.lotterys.my.bean.BaseBean;
import com.phoenix.lotterys.my.bean.LatestLongDragonBean;
import com.phoenix.lotterys.util.Constants;
import com.phoenix.lotterys.util.GsonUtil;
import com.phoenix.lotterys.util.NetUtils;
import com.phoenix.lotterys.util.SPConstants;
import com.phoenix.lotterys.util.ShareUtils;
import com.phoenix.lotterys.util.StampToDate;
import com.phoenix.lotterys.util.Uiutils;
import com.wanxiangdai.commonlibrary.util.EvenBusUtil.Even;
import com.wanxiangdai.commonlibrary.util.EvenBusUtil.EvenBusCode;
import com.wanxiangdai.commonlibrary.util.EvenBusUtil.EvenBusUtils;
import com.wanxiangdai.commonlibrary.util.StringUtils;
import com.wanxiangdai.commonlibrary.util.ToastUtil;

import java.net.URLDecoder;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import butterknife.BindView;
import butterknife.OnClick;

/**
 * 文件描述:
 * 创建者: IAN
 * 创建时间: 2019/7/8 15:39
 */
public class LatestLongDragonFrag extends BaseFragments implements View.OnClickListener {

    @BindView(R2.id.dragon_assistant_rec)
    RecyclerView dragonAssistantRec;
    @BindView(R2.id.claern_tex)
    TextView claernTex;
    @BindView(R2.id.injection_number_tex)
    TextView injectionNumberTex;
    @BindView(R2.id.amount_of_money_tex)
    TextView amountOfMoneyTex;
    @BindView(R2.id.in_put_money_edit)
    EditText inPutMoneyEdit;
    @BindView(R2.id.bet_right_away_tex)
    TextView betRightAwayTex;

    private DragonAssistantAdapter adapter;
    private List<LatestLongDragonBean.DataBean> list =new ArrayList<>();

    public LatestLongDragonFrag() {
        super(R.layout.latest_long_dragon_frag,true,true);
    }
    public static LatestLongDragonFrag getInstance() {
        LatestLongDragonFrag sf = new LatestLongDragonFrag();
        return sf;
    }
    @Override
    public void initView(View view) {
        inPutMoneyEdit.addTextChangedListener(new TextWatcher() {
            @Override
            public void beforeTextChanged(CharSequence s, int start, int count, int after) {
            }
            @Override
            public void onTextChanged(CharSequence s, int start, int before, int count) {
            }
            @Override
            public void afterTextChanged(Editable s) {
                String temp = inPutMoneyEdit.getText().toString();
                if (temp.contains(".")) {
                    int posDot = temp.indexOf(".");
                    if (posDot > 0 && temp.length() - posDot - 1 > 2) {
                        inPutMoneyEdit.setText(temp.subSequence(0, posDot + 3));
                        inPutMoneyEdit.setSelection(inPutMoneyEdit.getText().toString().length());
                    }
                }


                if (StringUtils.isEmpty(inPutMoneyEdit.getText().toString())){
                    amountOfMoneyTex.setVisibility(View.GONE);
                }else {
                    setFoatStype("共 "
                                    +inPutMoneyEdit.getText().toString().trim()+
                                    "元",amountOfMoneyTex,"#FB594B",1,
                            inPutMoneyEdit.getText().toString().length()+2);
                }
            }
        });
        setFoatStype("共 "
                +"0"+
                "注",injectionNumberTex,"#FB594B",1,3);
        inPutMoneyEdit.setText("");

        Uiutils.setRec(getContext(),dragonAssistantRec,1);
        adapter=new DragonAssistantAdapter(getContext(),list,R.layout.dragon_assistant_adapter);
        dragonAssistantRec.setAdapter(adapter);

        setcontextView();

        getData(true);

        setTheme();
    }

    private void getData(boolean isShow) {
        NetUtils.get(Constants.CHANGLONG,"", isShow, getContext(), new NetUtils.NetCallBack() {
            @Override
            public void onSuccess(String object) {
                if (!StringUtils.isEmpty(object))
                    latestLongDragonBean = Uiutils.stringToObject(object,LatestLongDragonBean.class);

                if (list.size()>0)
                    list.clear();

                if (null!=latestLongDragonBean&&null!=latestLongDragonBean.getData()&&
                latestLongDragonBean.getData().size()>0)
                    list.addAll(latestLongDragonBean.getData());

                adapter.notifyDataSetChanged();
                handler.removeMessages(1);
                handler.sendEmptyMessageDelayed(1,10000);

            }

            @Override
            public void onError() {

            }
        });


    }
    private LatestLongDragonBean latestLongDragonBean;

    private void setFoatStype(String str,TextView textView,String color,int startPostion,
                              int endPostion) {
        SpannableString spannableString = new SpannableString(str);
        spannableString.setSpan(new ForegroundColorSpan(
                        Color.parseColor(color)), startPostion,
                endPostion, Spanned.SPAN_EXCLUSIVE_EXCLUSIVE);
        textView.setVisibility(View.VISIBLE);
        textView.setText(spannableString);
    }

    @OnClick({R.id.claern_tex, R.id.bet_right_away_tex})
    public void onClick(View view) {
        switch (view.getId()) {
            case R.id.claern_tex:
                cleanStye();
                break;
            case R.id.bet_right_away_tex:
                if (StringUtils.isEmpty(inPutMoneyEdit.getText().toString())||Double.parseDouble(
                        inPutMoneyEdit.getText().toString())<0.1) {
                    ToastUtil.toastShortShow(getContext(), "投注金额不能少于0.1元");
                    return;
                }

                if (null ==dataBean) {
                    ToastUtil.toastShortShow(getContext(), "请先选择您的注单!");
                    return;
                }
                goBottomPour();
                break;
            case R.id.commit_tex:
                if (null!=customPopWindow) {
                    customPopWindow.dissmiss();
                    Uiutils.setStateColor(getActivity());

                }
                    String roomName = TextUtils.isEmpty(configBean.getData().getChatRoomName()) ? "" : configBean.getData().getChatRoomName();
                    Intent intent2 = new Intent(getContext(), WebActivity.class);
                    intent2.putExtra("url", Constants.BaseUrl() + Constants.SHARECHATROOM + roomName );
                    intent2.putExtra("type", "chat");

                    List<ShareBetList> shareBetList = new ArrayList<>();
                ShareBetList shareBetList1 = null;
                    if (!StringUtils.isEmpty(id)&&StringUtils.equals(id,dataBean.getBetList().get(0).getPlayId())){
                        shareBetList1 =new ShareBetList("0",totalMoney,dataBean.getPlayCateName()+""+
                                dataBean.getBetList().get(0).getPlayName()
                                ,dataBean.getBetList().get(0).getOdds());
                    }else{
                        shareBetList1 =new ShareBetList("0",totalMoney,dataBean.getPlayCateName()+""+
                                dataBean.getBetList().get(1).getPlayName()
                               ,dataBean.getBetList().get(1).getOdds());
                    }
                    shareBetList.add(shareBetList1);



                    ShareBetInfo shareBetInfo =new ShareBetInfo();
                    List<ShareBetInfo.BetParamsBean> shareBetParams = new ArrayList<>();
//                    dataBean.getTitle(),、
                List<ShareBetInfo.PlayNameArrayBean> sharePlayName = new ArrayList<>();
                if (!StringUtils.isEmpty(id)&&StringUtils.equals(id,dataBean.getBetList().get(0).getPlayId())){
                    shareBetParams.add(new ShareBetInfo.BetParamsBean(dataBean.getBetList().get(0).getPlayId(),totalMoney,
                            dataBean.getPlayCateName()+""+
                                    dataBean.getBetList().get(0).getPlayName(),dataBean.getBetList().get(0).getOdds(),
                            ""));
                    sharePlayName.add(new ShareBetInfo.PlayNameArrayBean(dataBean.getPlayCateName()+""+dataBean.getBetList().get(0).getPlayName(),
                            ""));
                }else{
                    shareBetParams.add(new ShareBetInfo.BetParamsBean(dataBean.getBetList().get(1).getPlayId(),totalMoney,
                            dataBean.getPlayCateName()+""+
                                    dataBean.getBetList().get(1).getPlayName(),dataBean.getBetList().get(1).getOdds(),
                            ""));
                    sharePlayName.add(new ShareBetInfo.PlayNameArrayBean(dataBean.getPlayCateName()+""+dataBean.getBetList().get(1).getPlayName(),
                            ""));
                }
                    shareBetInfo.setBetParams(shareBetParams);

                    shareBetInfo.setPlayNameArray(sharePlayName);
                    shareBetInfo.setGameId(dataBean.getGameId());
                    shareBetInfo.setGameName(dataBean.getTitle());
                    shareBetInfo.setCode("");
                    shareBetInfo.setTurnNum(dataBean.getIssue());
                    shareBetInfo.setTotalNums("1");

                shareBetInfo.setTotalNums("1");

                try {
                    long time = StampToDate.dateToStamp(dataBean.getCloseTime());
                    shareBetInfo.setFtime( time / 1000 + "");
                }catch (Exception e){ }
//                map.put("endTime", time / 1000 + "");


                    shareBetInfo.setTotalMoney(totalMoney);

                    String shareBetInfoJson = GsonUtil.toJson(shareBetInfo);
                    String shareBetJson = GsonUtil.toJson(shareBetList);
                intent2.putExtra("shareBetJson", shareBetJson);
                intent2.putExtra("shareBetInfoJson", shareBetInfoJson);
                   getActivity().startActivity(intent2);
                break;
            case R.id.clear_tex:
                if (null!=customPopWindow) {
                    customPopWindow.dissmiss();
                    Uiutils.setStateColor(getActivity());
                }
                break;

        }
    }

    private void cleanStye() {
        amountOfMoneyTex.setVisibility(View.GONE);
        setFoatStype("共 "
                +"0"+
                "注",injectionNumberTex,"#FB594B",1,3);
        inPutMoneyEdit.setText("");
    }

    private String totalMoney;
    private void goBottomPour() {
        Map<String,Object> map =new HashMap<>();
        map.put("token",Uiutils.getToken(getContext()));
        map.put("gameId",dataBean.getGameId());
//        map.put("betIssue",dataBean.getBetList());
        long time =0;
        try {
             time = StampToDate.dateToStamp(dataBean.getCloseTime());
        }catch (Exception e){ }
        map.put("endTime", time / 1000 + "");
        map.put("totalNum",1+"");
        map.put("tag",1+"");
        map.put("betIssue",dataBean.getIssue());
        totalMoney =Uiutils.getTwo(inPutMoneyEdit.getText().toString());
        map.put("totalMoney",Uiutils.getTwo(inPutMoneyEdit.getText().toString()));

        Map<String,Object> betBean =new HashMap<>();
        List<Map<String,Object> >listmap =new ArrayList<>();

        LatestLongDragonBean.DataBean.BetListBean betListBean =null;
        if (StringUtils.equals(id,dataBean.getBetList().get(0).getPlayId())){
            betListBean =dataBean.getBetList().get(0);
        }else if (StringUtils.equals(id,dataBean.getBetList().get(1).getPlayId())){
            betListBean =dataBean.getBetList().get(1);
        }

        if (null==betListBean)
            return;

        betBean.put("playId",betListBean.getPlayId());
        betBean.put("playIds",dataBean.getGameId());
        betBean.put("odds",betListBean.getOdds());
        betBean.put("money",Uiutils.getTwo(inPutMoneyEdit.getText().toString()));

        listmap.add(betBean);

        map.put("betBean",listmap);

        String url =null;
        SharedPreferences sp =getContext().getSharedPreferences("User", Context.MODE_PRIVATE);
        String userType=sp.getString("userType", "Null");
        if (!StringUtils.isEmpty(userType)&&StringUtils.equals("guest",userType)){
            url =Constants.LOTTERYGUESTBET ;
        }else{
            url =Constants.LOTTERYBET ;
        }

        NetUtils.post(URLDecoder.decode(url), map, true, getContext(), new NetUtils.NetCallBack() {
            @Override
            public void onSuccess(String object) {
                if (!StringUtils.isEmpty(object)){
                    BaseBean baseBean =Uiutils.stringToObject(object,BaseBean.class);
                    if (null!=baseBean&&!StringUtils.isEmpty(baseBean.getMsg()))
                        ToastUtil.toastShortShow(getContext(),baseBean.getMsg());

                    EvenBusUtils.setEvenBus(new Even(EvenBusCode.LONG_REFRESH_AMOUNT));

                    if (null!=adapter){
                        adapter.setId("");
                        adapter.setDataBean(null);
                        adapter.notifyDataSetChanged();
                        cleanStye();
                    }

                    share();

                }
            }

            @Override
            public void onError() {

            }
        });

    }

    private CustomPopWindow.PopupWindowBuilder popupWindowBuilder;
    private CustomPopWindow customPopWindow;
    private View contentview;

    private TextView title_tex;
    private TextView context_tex;
    private TextView clear_tex;
    private TextView commit_tex;
    ConfigBean configBean;
    private void share() {
         configBean = (ConfigBean) ShareUtils.getObject(getContext(), SPConstants.CONFIGBEAN, ConfigBean.class);
        if (null!=configBean&&null!=configBean.getData()&&configBean.getData().isChatFollowSwitch()&&
        !Uiutils.isTourist1(getContext())) {
            String nomey ="";

            if (!StringUtils.isEmpty(configBean.getData().getChatMinFollowAmount()))
                nomey =configBean.getData().getChatMinFollowAmount();

//            String nomey1 = Uiutils.getTwo(inPutMoneyEdit.getText().toString());

            if (!StringUtils.isEmpty(nomey) &&!StringUtils.isEmpty(totalMoney) && Double.parseDouble(nomey)
                    > Double.parseDouble(totalMoney)){
            }else{
                popupWindowBuilder = Uiutils.setPopSetting(getContext(), contentview,
                        Uiutils.getWiht(getActivity(), 0.6),
                        ViewGroup.LayoutParams.WRAP_CONTENT,
                        true, true, 0.5f);
                customPopWindow = popupWindowBuilder.create();
                customPopWindow.showAtLocation(contentview, Gravity.CENTER, 0, 0);
                Uiutils.setStateColor(getActivity());
            }
        }
    }

    private void setcontextView() {
        contentview = LayoutInflater.from(getContext()).inflate(R.layout.revoke_pop,
                null);
        title_tex = contentview.findViewById(R.id.title_tex);
        context_tex = contentview.findViewById(R.id.context_tex);
        clear_tex = contentview.findViewById(R.id.clear_tex);
        commit_tex = contentview.findViewById(R.id.commit_tex);
        clear_tex.setOnClickListener(this);
        commit_tex.setOnClickListener(this);
        title_tex.setText("分享注单");
        context_tex.setText("是否分享到聊天室");
    }

    @Override
    public void onDestroy() {
        super.onDestroy();
        adapter.cancelAllTimers();
    }

    private LatestLongDragonBean.DataBean dataBean =null;
    private  String id ="";
    public void setSyte(){
        dataBean =adapter.getDataBean();
        id =adapter.getId();
        if (null!=dataBean){
            setFoatStype("共 "
                    +"1"+
                    "注",injectionNumberTex,"#FB594B",1,3);
        }else{
            setFoatStype("共 "
                    +"0"+
                    "注",injectionNumberTex,"#FB594B",1,3);
        }

    }

    @Override
    public void getEvenMsg(Even even) {
        switch (even.getCode()){
            case EvenBusCode.LONG_QUEUES_REPLACE:
                setSyte();
                break;
            case EvenBusCode.LONG_REFRESH_DATA:
                getData(false);
                break;
            case EvenBusCode.CHANGE_THEME_STYLE_MYF:
                setTheme();
                break;

        }
    }

    private void setTheme() {
        if (Uiutils.setBaColor(getContext(),null)){
            betRightAwayTex.setTextColor(getContext().getResources().getColor(R.color.color_white));
        }else {
            if (0 != ShareUtils.getInt(getContext(), "ba_top", 0))
                betRightAwayTex.setTextColor(getContext().getResources().getColor(ShareUtils.
                        getInt(getContext(), "ba_top", 0)));
        }
    }

    private Handler handler =new Handler(){
        @Override
        public void handleMessage(Message msg) {
            switch (msg.what){
                case 1:
                    getData(false);
                    break;
            }
        }
    };

    public void setHandler() {
        handler.removeMessages(1);
        handler =null;
    }
}
