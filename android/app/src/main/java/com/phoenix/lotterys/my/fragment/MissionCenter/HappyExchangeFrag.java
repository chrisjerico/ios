package com.phoenix.lotterys.my.fragment.MissionCenter;

import android.text.Editable;
import android.text.TextWatcher;
import android.view.View;
import android.widget.EditText;
import android.widget.TextView;

import com.phoenix.lotterys.R;import com.phoenix.lotterys.R2;
import com.phoenix.lotterys.application.BaseFragments;
import com.phoenix.lotterys.main.bean.ConfigBean;
import com.phoenix.lotterys.my.bean.UserInfo;
import com.phoenix.lotterys.util.Constants;
import com.phoenix.lotterys.util.NetUtils;
import com.phoenix.lotterys.util.SPConstants;
import com.phoenix.lotterys.util.ShareUtils;
import com.phoenix.lotterys.util.Uiutils;
import com.wanxiangdai.commonlibrary.util.EvenBusUtil.Even;
import com.wanxiangdai.commonlibrary.util.EvenBusUtil.EvenBusCode;
import com.wanxiangdai.commonlibrary.util.EvenBusUtil.EvenBusUtils;
import com.wanxiangdai.commonlibrary.util.StringUtils;
import com.wanxiangdai.commonlibrary.util.ToastUtil;

import java.util.HashMap;
import java.util.Map;

import butterknife.BindView;
import butterknife.OnClick;

/**
 * 文件描述:  开心乐兑换
 * 创建者: IAN
 * 创建时间: 2019/7/3 12:56
 */
public class HappyExchangeFrag extends BaseFragments {

    @BindView(R2.id.tex1)
    TextView tex1;
    @BindView(R2.id.tex2)
    TextView tex2;
    @BindView(R2.id.tex3)
    TextView tex3;
    @BindView(R2.id.tex4)
    TextView tex4;
    @BindView(R2.id.tex5)
    TextView tex5;
    @BindView(R2.id.edit)
    EditText edit;
    @BindView(R2.id.money_tex)
    TextView moneyTex;
    @BindView(R2.id.commit_tex)
    TextView commitTex;
    @BindView(R2.id.explain_tex)
    TextView explainTex;

    public HappyExchangeFrag() {
        super(R.layout.happy_exchange_frag, true, true);
    }

    private ConfigBean configBean;
    private  String name;
    @Override
    public void initView(View view) {

         configBean = (ConfigBean) ShareUtils.getObject(getContext(), SPConstants.CONFIGBEAN, ConfigBean.class);
        if (null != configBean && null != configBean.getData() && !StringUtils.isEmpty(configBean.getData()
                .getIsIntToMoney()) && StringUtils.equals("1", configBean.getData()
                .getIsIntToMoney())) {
        } else {
            commitTex.setBackgroundColor(getContext().getResources().getColor(R.color.my_backgroup));
            commitTex.setTextColor(getContext().getResources().getColor(R.color.textColor_downSheet_title));
            commitTex.setText("暂未开启");
        }


        if (null != configBean && null != configBean.getData() && !StringUtils.isEmpty(configBean.getData()
                .getMissionBili()) ) {
             name =StringUtils.isEmpty(configBean.getData()
                    .getMissionName())?"开心乐":configBean.getData()
                    .getMissionName();
            edit.setHint("请输入"+name);
            explainTex.setText(configBean.getData()
                    .getMissionBili()+" "+name+"：1 元人民币");
        }


        edit.addTextChangedListener(new TextWatcher() {
            @Override
            public void beforeTextChanged(CharSequence s, int start, int count, int after) {

            }

            @Override
            public void onTextChanged(CharSequence s, int start, int before, int count) {

            }

            @Override
            public void afterTextChanged(Editable s) {
                if (StringUtils.isEmpty(edit.getText().toString())||StringUtils.equals(".",
                        edit.getText().toString())){
                    moneyTex.setText("");
                    return;
                }


                if (null != configBean && null != configBean.getData() && !StringUtils.isEmpty(configBean.getData()
                        .getMissionBili())){
                    moneyTex.setText((double) Double.parseDouble(edit.getText().toString()) / Double.parseDouble(
                            configBean.getData()
                                    .getMissionBili()
                    ) + "");
                }else if (!StringUtils.isEmpty(edit.getText().toString())) {
                    moneyTex.setText((double) Double.parseDouble(edit.getText().toString()) / 10 + "");
                }
            }
        });
    }

    private UserInfo userInfo;

    @OnClick({R.id.tex1, R.id.tex2, R.id.tex3, R.id.tex4, R.id.tex5, R.id.commit_tex})
    public void onClick(View view) {

        switch (view.getId()) {
            case R.id.tex1:
                edit.setText(tex1.getText().toString());
                break;
            case R.id.tex2:
                edit.setText(tex2.getText().toString());
                break;
            case R.id.tex3:
                edit.setText(tex3.getText().toString());
                break;
            case R.id.tex4:
                edit.setText(tex4.getText().toString());
                break;
            case R.id.tex5:
                if (null == userInfo)
                    userInfo = (UserInfo) ShareUtils.getObject(getContext(), SPConstants.USERINFO, UserInfo.class);

                if (null != userInfo && null != userInfo.getData())
                    edit.setText(userInfo.getData().getTaskReward());
                break;

            case R.id.commit_tex:
                if (StringUtils.equals("暂未开启", commitTex.getText().toString()))
                    return;

                if (StringUtils.isEmpty(edit.getText().toString())) {
                    ToastUtil.toastShortShow(getContext(), "请输入"+name);
                } else {
                    getData();
                }
                break;
        }
    }

    /**
     * 兑换
     */
    private void getData() {
        Map<String, Object> map = new HashMap<>();
        map.put("money", edit.getText().toString());
        map.put("token", Uiutils.getToken(getContext()));

        NetUtils.post(Constants.CREDITSEXCHANGE, map, true, getContext(), new NetUtils.NetCallBack() {
            @Override
            public void onSuccess(String object) {
                if (!StringUtils.isEmpty(object)) {
                    Uiutils.onSuccessTao(object, getContext());
                    EvenBusUtils.setEvenBus(new Even(EvenBusCode.LONG_REFRESH_AMOUNT));
//
                    moneyTex.setText("");
                    edit.setText("");
                }
            }

            @Override
            public void onError() {

            }
        });

    }

}
