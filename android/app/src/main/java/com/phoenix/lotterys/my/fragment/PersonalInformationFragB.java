package com.phoenix.lotterys.my.fragment;

import android.text.TextUtils;
import android.util.Log;
import android.view.View;
import android.widget.FrameLayout;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.phoenix.lotterys.R;import com.phoenix.lotterys.R2;
import com.phoenix.lotterys.application.BaseFragments;
import com.phoenix.lotterys.my.bean.UserInfo;
import com.phoenix.lotterys.util.Constants;
import com.phoenix.lotterys.util.NetUtils;
import com.phoenix.lotterys.util.SPConstants;
import com.phoenix.lotterys.util.ShareUtils;
import com.phoenix.lotterys.util.StampToDate;
import com.phoenix.lotterys.util.Uiutils;
import com.phoenix.lotterys.view.CustomTitleBar;
import com.wanxiangdai.commonlibrary.util.ImageLoadUtil;
import com.wanxiangdai.commonlibrary.util.StringUtils;

import butterknife.BindView;

/**
 * 文件描述: 个人信息
 * 创建者: IAN
 * 创建时间: 2019/7/2 14:50
 */
public class PersonalInformationFragB extends BaseFragments {

    @BindView(R2.id.portrait_img)
    ImageView portraitImg;
    @BindView(R2.id.name_tex)
    TextView nameTex;
    @BindView(R2.id.time_tex)
    TextView timeTex;
    @BindView(R2.id.information_lin)
    LinearLayout informationLin;
    @BindView(R2.id.weather_tex)
    TextView weatherTex;
    @BindView(R2.id.weather_name_tex)
    TextView weatherNameTex;
    @BindView(R2.id.weather_fra)
    FrameLayout weatherFra;
    @BindView(R2.id.titlebar)
    CustomTitleBar titlebar;

    @BindView(R2.id.account_number_lin)
    View accountNumberLin;

    @BindView(R2.id.name_lin)
    View nameLin;

    @BindView(R2.id.qq_lin)
    View qqLin;

    @BindView(R2.id.mobile_phone_lin)
    View mobilePhoneLin;

    @BindView(R2.id.mailbox_lin)
    View mailboxLin;

    @BindView(R2.id.currency_lin)
    View currencyLin;

    private TextView accountNumberLeftTex;
    private TextView nameLeftTex;
    private TextView qqLeftTex;
    private TextView mobilePhoneLeftTex;
    private TextView mailboxLeftTex;
    private TextView currencyLeftTex;

    private UserInfo userInfo ;

    public PersonalInformationFragB() {
        super(R.layout.personal_information_act_b, true,
                true);
    }

    @Override
    public void initView(View view) {
        Uiutils.setBarStye(titlebar,getActivity());
        titlebar.setText(getContext().getResources().getString(R.string.my_information));

        setView();
        userInfo =(UserInfo) ShareUtils.getObject(getContext(),
                SPConstants.USERINFO, UserInfo.class);
       if (null==userInfo){
           getData();
       }else {
           setLeftTex();
       }
    }


    private void getData() {
        NetUtils.get(Constants.USERINFO , Uiutils.getToken(getContext()), true,
                getContext(), new NetUtils.NetCallBack() {
                    @Override
                    public void onSuccess(String object) {
                        userInfo= Uiutils.stringToObject(object,UserInfo.class);

                        if (null!=userInfo&&null!=userInfo.getData()){
                           boolean isok = ShareUtils.saveObject(getContext(),
                                    SPConstants.USERINFO,userInfo);
                            setLeftTex();
                        }
                    }

                    @Override
                    public void onError() {

                    }
                });
    }

    private void setView() {
        accountNumberLeftTex=accountNumberLin.findViewById(R.id.left_tex);
        nameLeftTex=nameLin.findViewById(R.id.left_tex);
        qqLeftTex=qqLin.findViewById(R.id.left_tex);
        mobilePhoneLeftTex=mobilePhoneLin.findViewById(R.id.left_tex);
        mailboxLeftTex=mailboxLin.findViewById(R.id.left_tex);
        currencyLeftTex=currencyLin.findViewById(R.id.left_tex);
    }

    private void setLeftTex() {
        if (!StringUtils.isEmpty(userInfo.getData().getAvatar())) {
            ImageLoadUtil.loadRoundImage(portraitImg, userInfo.getData().getAvatar(), 0);
        }else{
            ImageLoadUtil.ImageLoad(getContext(), R.drawable.head, portraitImg);
        }

        accountNumberLeftTex.setText(getContext().getResources()
                .getString(R.string.account_number)+userInfo.getData().getUsr());
        accountNumberLeftTex.setVisibility(View.VISIBLE);

        nameLeftTex.setText(getContext().getResources()
                .getString(R.string.real_name)+userInfo.getData().getFullName());
        nameLeftTex.setVisibility(View.VISIBLE);

        qqLeftTex.setText(getContext().getResources()
                .getString(R.string.qq)+userInfo.getData().getQq());
        qqLeftTex.setVisibility(View.VISIBLE);

//        mobilePhoneLeftTex.setText(getContext().getResources()
//                .getString(R.string.mobile_phone)+userInfo.getData().getPhone());
//        mobilePhoneLeftTex.setVisibility(View.VISIBLE);
//

        if(userInfo.getData().getPhone()!=null && !StringUtils.isEmpty(userInfo.getData().getPhone())){
            String phone = userInfo.getData().getPhone();
            Log.e("phone",phone+"///");
            if (userInfo.getData().getPhone().length()>=11) {
                phone = phone.substring(0, 3) + "****" + userInfo.getData().getPhone().substring(7, 11);
            }
                mobilePhoneLeftTex.setText(getContext().getResources()
                        .getString(R.string.mobile_phone) + phone);
            mobilePhoneLeftTex.setVisibility(View.VISIBLE);
        }else {
            mobilePhoneLeftTex.setText(getContext().getResources()
                    .getString(R.string.mobile_phone));
            mobilePhoneLeftTex.setVisibility(View.VISIBLE);
        }

        mailboxLeftTex.setText(getContext().getResources()
                .getString(R.string.mailbox)+userInfo.getData().getEmail());
        mailboxLeftTex.setVisibility(View.VISIBLE);

        currencyLeftTex.setText(getContext().getResources()
                .getString(R.string.currency)+" RMB");
        currencyLeftTex.setVisibility(View.VISIBLE);

        nameTex.setText(userInfo.getData().getUsr());
        timeTex.setText(StampToDate.stampToDates(System.currentTimeMillis(),2));

        String string = StampToDate.stampToDates(System.currentTimeMillis(),2).substring(11,13);

        String time = "";
        String context = "";
        if (!StringUtils.isEmpty(string)){
            if (Integer.parseInt(string)<=5){
                time="凌晨好,";
                context="凌晨，时间不早了记得休息";

                weatherFra.setBackground(getContext().getResources().getDrawable(R.drawable.bangwan));
            }else if (Integer.parseInt(string)<=11) {

                time="上午好,";
                context="上午，补充能量继续战斗";

                weatherFra.setBackground(getContext().getResources().getDrawable(R.drawable.sun));
            }else if (Integer.parseInt(string)<=17){
                time="下午好,";
                context="下午，补充能量继续战斗";

                weatherFra.setBackground(getContext().getResources().getDrawable(R.drawable.xiawu));
            }else{
                time="晚上好,";
                context="傍晚，安静的夜晚是不可多得的享受";
                weatherFra.setBackground(getContext().getResources().getDrawable(R.drawable.wuye));
            }
        }
        weatherTex.setText(context);
        weatherNameTex.setText(time+userInfo.getData().getUsr());
    }
}
