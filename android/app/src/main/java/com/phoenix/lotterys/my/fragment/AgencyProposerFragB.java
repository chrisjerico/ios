package com.phoenix.lotterys.my.fragment;

import android.annotation.SuppressLint;
import android.view.View;
import android.widget.EditText;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.phoenix.lotterys.R;import com.phoenix.lotterys.R2;
import com.phoenix.lotterys.main.FragmentUtilAct;
import com.phoenix.lotterys.my.bean.AgencyBean;
import com.phoenix.lotterys.util.Constants;
import com.phoenix.lotterys.util.NetUtils;
import com.phoenix.lotterys.util.Uiutils;
import com.phoenix.lotterys.view.CustomTitleBar;
import com.wanxiangdai.commonlibrary.base.BaseFragment;
import com.wanxiangdai.commonlibrary.util.EvenBusUtil.Even;
import com.wanxiangdai.commonlibrary.util.EvenBusUtil.EvenBusCode;
import com.wanxiangdai.commonlibrary.util.StringUtils;
import com.wanxiangdai.commonlibrary.util.ToastUtil;

import java.util.HashMap;
import java.util.Map;

import butterknife.BindView;

/**
 * 文件描述: 代理申请
 * 创建者: IAN
 * 创建时间: 2019/8/30 13:12
 */
@SuppressLint("ValidFragment")
public class AgencyProposerFragB extends BaseFragment implements View.OnClickListener {

    @BindView(R2.id.titlebar)
    CustomTitleBar titlebar;
    @BindView(R2.id.qq_tex)
    EditText qqTex;
    @BindView(R2.id.phone_tex)
    EditText phoneTex;
    @BindView(R2.id.context_tex)
    EditText contextTex;
    @BindView(R2.id.commit_tex)
    TextView commitTex;
    @BindView(R2.id.tis_tex)
    TextView tisTex;
    @BindView(R2.id.user_text)
    TextView userText;
    @BindView(R2.id.user_lin)
    LinearLayout userLin;
    @BindView(R2.id.stauts_tex)
    TextView stautsTex;
    @BindView(R2.id.stauts_lin)
    LinearLayout stautsLin;
    @BindView(R2.id.refuse_tex)
    TextView refuseTex;
    @BindView(R2.id.refuse_lin)
    LinearLayout refuseLin;
    @BindView(R2.id.context_tis_tex)
    TextView contextTisTex;
    @BindView(R2.id.context_lin)
    LinearLayout contextLin;

    private View lin;
    boolean isHide = false;
    @SuppressLint("ValidFragment")
    public AgencyProposerFragB(boolean isHide) {
        super(R.layout.agency_proposer_frag_b, true, true);
        this.isHide = isHide;
    }

    @Override
    public void initView(View view) {
        lin =view.findViewById(R.id.lin);

        Uiutils.setBarStye(titlebar, getActivity());

        titlebar.setText("代理申请");
        commitTex.setOnClickListener(this);
        getAgentapply1();
        Uiutils.setBaColor(getContext(),titlebar, false, null);
        if (isHide)
            titlebar.setIvBackHide(View.GONE);
    }

    /**
     * 申请
     */
    private void getAgentapply() {
        Map<String, Object> map = new HashMap<>();
        map.put("token", Uiutils.getToken(getContext()));
        map.put("action", "apply");
        map.put("qq", qqTex.getText().toString());
        map.put("phone", phoneTex.getText().toString());
        map.put("content", contextTex.getText().toString());

        NetUtils.post(Constants.AGENTAPPLY, map, true, getContext(), new NetUtils.NetCallBack() {
            @Override
            public void onSuccess(String object) {
                Uiutils.onSuccessTao(object, getContext());
                getActivity().finish();
            }

            @Override
            public void onError() {

            }
        });

    }

    private AgencyBean agencyBean;

    /**
     * 查
     */
    private void getAgentapply1() {
        Map<String,Object> map =new HashMap<>();
        map.put("token",Uiutils.getToken(getContext()));

        NetUtils.get(Constants.AGENTAPPLYINFO,map,
                true, getContext(), new NetUtils.NetCallBack() {
            @Override
            public void onSuccess(String object) {
                agencyBean = Uiutils.stringToObject(object, AgencyBean.class);
                tisTex.setVisibility(View.GONE);
                if (null != agencyBean && null != agencyBean.getData()) {
                        if (StringUtils.equals("1",agencyBean.getData().getReviewStatus())) {
                          setview(1);
                        }else if (StringUtils.equals("3",agencyBean.getData().getReviewStatus())){
                            setview(3);
                        }else if (StringUtils.equals("2",agencyBean.getData().getReviewStatus())){
                            FragmentUtilAct.startAct(getActivity(), new RecommendBenefitFrag(false));
                            getActivity().finish();
                            return;
                        }
                }
            }

            @Override
            public void onError() {

            }
        });

    }

    private void setview(int i) {
        switch (i){
            case 0:
                userLin.setVisibility(View.GONE);
                stautsLin.setVisibility(View.GONE);
                refuseLin.setVisibility(View.GONE);

                contextTisTex.setVisibility(View.VISIBLE);
                contextTex.setVisibility(View.VISIBLE);
                lin.setVisibility(View.VISIBLE);
                tisTex.setVisibility(View.GONE);

                qqTex.setEnabled(true);
                phoneTex.setEnabled(true);
                contextTex.setEnabled(true);

                qqTex.setText("");
                phoneTex.setText("");
                contextTex.setText("");
                commitTex.setText("申请");

                commitTex.setOnClickListener(this);

                break;
            case 1:
                Uiutils.setText(qqTex,agencyBean.getData().getQq());
                Uiutils.setText(phoneTex,agencyBean.getData().getMobile());
                Uiutils.setText(contextTex,agencyBean.getData().getApplyReason());

                qqTex.setEnabled(false);
                phoneTex.setEnabled(false);
                contextTex.setEnabled(false);
                commitTex.setBackgroundColor(getResources().getColor(R.color.fount2));
                commitTex.setOnClickListener(null);
                tisTex.setVisibility(View.VISIBLE);
                break;
            case 3:
                userLin.setVisibility(View.VISIBLE);
                stautsLin.setVisibility(View.VISIBLE);
                refuseLin.setVisibility(View.VISIBLE);

                contextTisTex.setVisibility(View.GONE);
                contextTex.setVisibility(View.GONE);
                lin.setVisibility(View.GONE);
                tisTex.setVisibility(View.GONE);

                Uiutils.setText(userText,agencyBean.getData().getUsername());
                Uiutils.setText(qqTex,agencyBean.getData().getQq());
                Uiutils.setText(phoneTex,agencyBean.getData().getMobile());
                Uiutils.setText(stautsTex,"代理审核拒绝");
                Uiutils.setText(refuseTex,agencyBean.getData().getReviewResult());

                qqTex.setEnabled(false);
                phoneTex.setEnabled(false);
                commitTex.setText("再次申请");
                commitTex.setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View v) {
                        setview(0);
                    }
                });
                break;
        }
    }

    @Override
    public void onClick(View v) {
        switch (v.getId()){
            case R.id.commit_tex:
                if (StringUtils.isEmpty(qqTex.getText().toString()) &&
                        StringUtils.isEmpty(phoneTex.getText().toString())) {
                    ToastUtil.toastShortShow(getContext(), "请输入qq号或者手机号");
                    return;
                }

                if (StringUtils.isEmpty(contextTex.getText().toString()) ||
                        contextTex.getText().toString().length() < 6) {
                    ToastUtil.toastShortShow(getContext(), "申请内容字数不能少于6");
                    return;
                }
                getAgentapply();
                break;
        }

    }

    @Override
    public void getEvenMsg(Even even) {
        switch (even.getCode()) {
            case EvenBusCode.CHANGE_THEME_STYLE_MYF:
                Uiutils.setBaColor(getContext(),titlebar, false, null);
                break;
        }
    }
}
