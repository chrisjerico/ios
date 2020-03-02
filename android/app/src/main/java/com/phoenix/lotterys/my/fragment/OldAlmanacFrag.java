package com.phoenix.lotterys.my.fragment;

import android.text.Html;
import android.text.method.ScrollingMovementMethod;
import android.view.View;
import android.widget.ImageView;
import android.widget.TextView;

import com.phoenix.lotterys.R;import com.phoenix.lotterys.R2;
import com.phoenix.lotterys.application.BaseFragments;
import com.phoenix.lotterys.my.bean.OldAlmanacBean;
import com.phoenix.lotterys.util.Constants;
import com.phoenix.lotterys.util.NetUtils;
import com.phoenix.lotterys.util.Uiutils;
import com.wanxiangdai.commonlibrary.util.EvenBusUtil.Even;
import com.wanxiangdai.commonlibrary.util.EvenBusUtil.EvenBusCode;
import com.wanxiangdai.commonlibrary.util.StringUtils;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import butterknife.BindView;
import butterknife.OnClick;

/**
 * 文件描述:
 * 创建者: IAN
 * 创建时间: 2019/11/27 20:21
 */
public class OldAlmanacFrag extends BaseFragments {

    @BindView(R2.id.month_tex)
    TextView monthTex;
    @BindView(R2.id.month_en_tex)
    TextView monthEnTex;
    @BindView(R2.id.yuer_tex)
    TextView yuerTex;
    @BindView(R2.id.left_img)
    ImageView leftImg;
    @BindView(R2.id.day_num_tex)
    TextView dayNumTex;
    @BindView(R2.id.righr_imj)
    ImageView righrImj;
    @BindView(R2.id.title_left_tex)
    TextView titleLeftTex;
    @BindView(R2.id.week_tex)
    TextView weekTex;
    @BindView(R2.id.several_days_tex)
    TextView severalDaysTex;
    @BindView(R2.id.yi_tex)
    TextView yiTex;
    @BindView(R2.id.jishenyiqu_tex)
    TextView jishenyiquTex;
    @BindView(R2.id.lucky_number_tex)
    TextView luckyNumberTex;
    @BindView(R2.id.xiongshayiji_tex)
    TextView xiongshayijiTex;
    @BindView(R2.id.jishi_tex)
    TextView jishiTex;
    @BindView(R2.id.ji_tex)
    TextView jiTex;
    @BindView(R2.id.chongsha_tex)
    TextView chongshaTex;
    @BindView(R2.id.ganzhi_tex)
    TextView ganzhiTex;
    @BindView(R2.id.xishen_tex)
    TextView xishenTex;
    @BindView(R2.id.fushen_tex)
    TextView fushenTex;
    @BindView(R2.id.caishen_tex)
    TextView caishenTex;
    @BindView(R2.id.baiji_tex)
    TextView baijiTex;
    @BindView(R2.id.riwuxing_tex)
    TextView riwuxingTex;

    public OldAlmanacFrag() {
        super(R.layout.old_almanac_frag, true, true);
    }


    @Override
    public void initView(View view) {
        date = Uiutils.getFetureDate(0);
        if (date.contains("-"))
            date = date.replace("-","");
        getData(true);
    }

    private String date;
    private OldAlmanacBean oldAlmanacBean;
    private void getData(boolean b) {
        Map<String,Object> map =new HashMap<>();
        if (date.contains("-"))
            date = date.replace("-","");
        map.put("date",date);

        NetUtils.get(Constants.LHLDETAIL, map, b, getContext(), new NetUtils.NetCallBack() {
            @Override
            public void onSuccess(String object) {
                oldAlmanacBean = Uiutils.stringToObject(object,OldAlmanacBean.class);

                if (null!=oldAlmanacBean&&null!=oldAlmanacBean.getData()&&null!=oldAlmanacBean.
                        getData().getInfo()){


                    Uiutils.setText(monthTex,oldAlmanacBean.getData().getInfo().getMonthEN()+"月");
                    Uiutils.setText(monthEnTex,oldAlmanacBean.getData().getInfo().getWeekEN());
                    Uiutils.setText(yuerTex,oldAlmanacBean.getData().getInfo().getYearEN()+"年");
                    Uiutils.setText(dayNumTex,oldAlmanacBean.getData().getInfo().getDayEN()+"");

                    StringBuffer sb =new StringBuffer();
                    if (!StringUtils.isEmpty(oldAlmanacBean.getData().getInfo().getYearCN()))
                        sb.append(" "+oldAlmanacBean.getData().getInfo().getYearCN()+"年");
                    if (!StringUtils.isEmpty(oldAlmanacBean.getData().getInfo().getMonthCN()))
                        sb.append(" "+oldAlmanacBean.getData().getInfo().getMonthCN());
//                    if (StringUtils.isEmpty(oldAlmanacBean.getData().getInfo().getYearCN()))
//                        sb.append(" "+oldAlmanacBean.getData().getInfo().getYearCN()+"年");

                    Uiutils.setText(titleLeftTex,sb.toString()+"");

                    Uiutils.setText(weekTex,oldAlmanacBean.getData().getInfo().getWeekCN());
                    Uiutils.setText(severalDaysTex,oldAlmanacBean.getData().getInfo().getDayCN());

                    setText(yiTex,"宜","<br/>"+oldAlmanacBean.getData().getInfo().getYi(),1);
                    setText(jishenyiquTex,"吉神宜趋","<br/>"+oldAlmanacBean.getData().getInfo().getJiShenYiQu(),1);
                    setText(luckyNumberTex,"六合吉数","<br/>"+oldAlmanacBean.getData().getInfo().getLuckyNumber(),1);
                    setText(xiongshayijiTex,"凶煞宜忌","<br/>"+oldAlmanacBean.getData().getInfo().getXiongShaYiJi(),1);
                    setText(jiTex,"忌","<br/>"+oldAlmanacBean.getData().getInfo().getJi(),1);
                    setText(jishiTex,"时辰吉凶","<br/>"+oldAlmanacBean.getData().getInfo().getJiShi(),1);
                    setText(chongshaTex,"冲煞","<br/>"+oldAlmanacBean.getData().getInfo().getChongSha(),1);
                    setText(ganzhiTex,"天干地支","<br/>"+oldAlmanacBean.getData().getInfo().getGanZhi(),1);
                    setText(xishenTex,"喜神：",oldAlmanacBean.getData().getInfo().getXiShen(),1);
                    setText(fushenTex,"福神：",oldAlmanacBean.getData().getInfo().getFuShen(),1);
                    setText(caishenTex,"财神：",oldAlmanacBean.getData().getInfo().getCaiShen(),1);
                    setText(baijiTex,"白忌","<br/>"+oldAlmanacBean.getData().getInfo().getBaiJi(),1);
                    setText(riwuxingTex,"日五行","<br/>"+oldAlmanacBean.getData().getInfo().getRiWuXing(),1);
                }
            }

            @Override
            public void onError() {

            }
        });

    }

    private void setText(TextView view,String key ,String v,int type) {
        view.setMovementMethod(ScrollingMovementMethod.getInstance());
        if (!StringUtils.isEmpty(v)){
            String textSource =null;
            switch (type){
                case 1:
                    textSource = "<font ><big>"+key+"</big></font>"+v;
                    break;
                case 2:
                    textSource = "<font >"+key+"</font>"+v;
                    break;
                    default:
                        textSource = "<font ><big><big>"+key+"</big></big></font>"+v;
                        break;
            }
            view.setText(Html.fromHtml(textSource));
        }else{
            view.setText("<font ><big><big>"+key+"</big></big></font>");
        }
    }

    @OnClick({R.id.left_img, R.id.righr_imj})
    public void onClick(View view) {
        switch (view.getId()) {
            case R.id.left_img:
                setDate(1);
                break;
            case R.id.righr_imj:
                setDate(-1);
                break;
        }
    }

    private void setDate(int i) {
        try {
            SimpleDateFormat sdf=new SimpleDateFormat("yyyyMMdd");//小写的mm表示的是分钟
            date = Uiutils.getPastDate(i,sdf.parse(date));
            getData(true);
        }catch (Exception e){

        }
    }

    @Override
    public void getEvenMsg(Even even) {
        switch (even.getCode()){
            case EvenBusCode.OPTION_DATE:
                if (!StringUtils.isEmpty((String)even.getData())&&!StringUtils.equals((String)even.getData(),date)){
                    date =(String)even.getData();
                    if (date.contains("-"))
                        date = date.replace("-","");
                    getData(true);
                }
                break;
        }
    }
}
