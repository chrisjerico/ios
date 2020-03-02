package com.phoenix.lotterys.my.fragment;

import android.view.View;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.phoenix.lotterys.R;import com.phoenix.lotterys.R2;
import com.phoenix.lotterys.my.bean.MailFragBean;
import com.phoenix.lotterys.util.Constants;
import com.phoenix.lotterys.util.NetUtils;
import com.phoenix.lotterys.util.Uiutils;
import com.wanxiangdai.commonlibrary.base.BaseActivity;
import com.wanxiangdai.commonlibrary.util.EvenBusUtil.Even;
import com.wanxiangdai.commonlibrary.util.EvenBusUtil.EvenBusCode;
import com.wanxiangdai.commonlibrary.util.StringUtils;

import java.util.HashMap;
import java.util.Map;

import butterknife.BindView;
import butterknife.OnClick;

/**
 * 文件描述:
 * 创建者: IAN
 * 创建时间: 2019/12/8 12:45
 */
public class MessagPopFrag extends BaseActivity {

    @BindView(R2.id.title_tex)
    TextView titleTex;
    @BindView(R2.id.context_tex)
    TextView contextTex;
    @BindView(R2.id.context_tex2)
    TextView contextTex2;
    @BindView(R2.id.context_tex3)
    TextView contextTex3;
    @BindView(R2.id.clear_tex)
    TextView clearTex;
    @BindView(R2.id.commit_tex)
    TextView commitTex;
    @BindView(R2.id.main_lin)
    LinearLayout mainLin;
    @BindView(R2.id.main_lin0)
    LinearLayout mainLin0;

    public MessagPopFrag() {
        super(false, R.layout.messag_pop_frag, true, true);
    }

    private String id;
    private String name;

    @Override
    public void initView() {
        id =getIntent().getStringExtra("id");
        name =getIntent().getStringExtra("name");

        if (!StringUtils.isEmpty(name))
            contextTex.setText(name);


        if (!StringUtils.isEmpty(id))
            setRead();
//        else
//            finish();
    }





    @Override
    protected void onDestroy() {
        Constants.isHowMag = false;
        super.onDestroy();
    }

    @OnClick({R.id.clear_tex, R.id.commit_tex, R.id.main_lin0})
    public void onClick(View view) {
//        switch (view.getId()) {
//            case R.id.clear_tex:
//                finish();
//                break;
//            case R.id.commit_tex:
//                if (!StringUtils.isEmpty(id))
//                setRead();
//                else
//                    finish();
//                break;
//            case R.id.main_lin0:
//                finish();
//                break;
//        }

//        if (!StringUtils.isEmpty(id))
//            setRead();
//        else
            finish();
    }

    private void setRead() {
        Map<String,Object> httpParams = new HashMap<>();
        httpParams.put("token", Uiutils.getToken(this));
        httpParams.put("id", id);

        NetUtils.post(Constants.READMSG, httpParams, false, this,
                new NetUtils.NetCallBack() {
                    @Override
                    public void onSuccess(String object) {
//                        finish();
                    }

                    @Override
                    public void onError() {
//                        finish();
                    }
                });
    }


    @Override
    public void getEvenMsg(Even even) {
        switch (even.getCode()){
            case EvenBusCode.message_update_popup:
                MailFragBean.DataBean.ListBean listBean =(MailFragBean.DataBean.ListBean)even.getData();
                if (null!=listBean){
                    id =listBean.getId();
                    name =listBean.getName();

                    if (!StringUtils.isEmpty(name))
                        contextTex.setText(name);

                    if (!StringUtils.isEmpty(id))
                        setRead();
                }
                break;
        }
    }
}
