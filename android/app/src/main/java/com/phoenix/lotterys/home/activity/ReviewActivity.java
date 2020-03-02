package com.phoenix.lotterys.home.activity;

import android.annotation.SuppressLint;
import android.os.Bundle;
import android.text.TextUtils;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.EditText;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.google.gson.Gson;
import com.lzy.okgo.OkGo;
import com.lzy.okgo.model.Response;
import com.phoenix.lotterys.R;import com.phoenix.lotterys.R2;
import com.phoenix.lotterys.application.BaseActivitys;
import com.phoenix.lotterys.home.bean.NiceNameBean;
import com.phoenix.lotterys.home.bean.PostContent;
import com.phoenix.lotterys.home.bean.Review;
import com.phoenix.lotterys.home.fragment.SixThemeBetterFragment;
import com.phoenix.lotterys.main.FragmentUtilAct;
import com.phoenix.lotterys.my.bean.BaseBean;
import com.phoenix.lotterys.util.Constants;
import com.phoenix.lotterys.util.EditTextUtil;
import com.phoenix.lotterys.util.NetDialogCallBack;
import com.phoenix.lotterys.util.SPConstants;
import com.phoenix.lotterys.util.SecretUtils;
import com.phoenix.lotterys.util.ToastUtils;
import com.phoenix.lotterys.util.Uiutils;
import com.phoenix.lotterys.view.tddialog.TDialog;
import com.wanxiangdai.commonlibrary.util.ToastUtil;

import java.io.IOException;
import java.net.URLDecoder;

import butterknife.BindView;
import butterknife.ButterKnife;
import butterknife.OnClick;
import okhttp3.RequestBody;

/**
 * Greated by Luke
 * on 2019/12/1
 */
//评论
public class ReviewActivity extends BaseActivitys {


    String cid, rid;
    @BindView(R2.id.tv_back)
    TextView tvBack;
    @BindView(R2.id.et_content)
    EditText etContent;
    @BindView(R2.id.titlebar)
    RelativeLayout titlebar;


    public void getIntentData() {
        Bundle bundle = getIntent().getExtras();
        cid = bundle.getString("cid");
        rid = bundle.getString("rid");
    }

    @SuppressLint("ValidFragment")
    public ReviewActivity() {
        super(R.layout.activity_review, true, true);
    }

    @Override
    public void initView() {
        Uiutils.setBarStye0(titlebar,this);
    }

    @OnClick({R.id.tv_back, R.id.bt_issue})
    public void onViewClicked(View view) {
        switch (view.getId()) {
            case R.id.tv_back:
                finish();
                break;

            case R.id.bt_issue:
                postContent();
                break;
        }
    }


    private void postContent() {
        String token = SPConstants.checkLoginInfo(this);
        if (TextUtils.isEmpty(token)) {
            return;
        }
        String mContent = etContent.getText().toString().trim();
        if (mContent == null || mContent.length() == 0) {
            ToastUtils.ToastUtils(getResources().getString(R.string.lhc_inputcotent), ReviewActivity.this);
            return;
        }
        Review content = new Review();
        content.setContent(SecretUtils.DESede(mContent));
        if (Constants.ENCRYPT)
            content.setSign(SecretUtils.RsaToken());
        content.setToken(SecretUtils.DESede(token));
        content.setCid(SecretUtils.DESede(cid));
        if (!TextUtils.isEmpty(rid))
        content.setRid(SecretUtils.DESede(rid));
        Gson gson = new Gson();
        String json = gson.toJson(content);
        RequestBody body = RequestBody.create(Constants.JSON, json);
        OkGo.<String>post(URLDecoder.decode(Constants.BaseUrl() + Constants.CONTENTREPLY + (Constants.ENCRYPT ? Constants.SIGN : "")))//
                .tag(this)//
                .upRequestBody(body)
                .execute(new NetDialogCallBack(this, true, ReviewActivity.this,
                        true, BaseBean.class) {
                    @Override
                    public void onUi(Object o) throws IOException {
                        BaseBean li = (BaseBean) o;
                        if (li != null && li.getCode() == 0) {
                            ToastUtil.toastShortShow(ReviewActivity.this, li.getMsg() == null ? "" : li.getMsg());
                            finish();
                        }
                    }

                    @Override
                    public void onErr(BaseBean bb) throws IOException {
                        if (bb != null && bb.getExtra() != null && !bb.getExtra().isHasNickname()) {
                            bbsNameDialog();
                        }
                    }

                    @Override
                    public void onFailed(Response<String> response) {

                    }

                });

    }

    private void bbsNameDialog() {
        String[] array = getResources().getStringArray(R.array.affirm_change);
        View inflate;
        inflate = LayoutInflater.from(this).inflate(R.layout.alertext_setname, null);
        EditText etContent = (EditText) inflate.findViewById(R.id.et_title);
//        tvContent.setText("打赏" + "元");
        EditTextUtil.mEditTextChinese(etContent);
        TDialog mTDialog1 = new TDialog(this, TDialog.Style.Center, array, "",
                "", ""
                , new TDialog.onItemClickListener() {
            @Override
            public void onItemClick(Object object, int pos) {
                if (pos == 1) {
                    String name = etContent.getText().toString().trim();
                    if (name == null || name.length() == 0) {
                        ToastUtil.toastShortShow(ReviewActivity.this, "请输入昵称");
                        return;
                    }
                    changeName(name);
                }
            }
        });
        mTDialog1.setMsgGravity(Gravity.CENTER);
        mTDialog1.setMsgPaddingLeft(10, 5, 10, 0);
        mTDialog1.setItemTextColorAt(0, getResources().getColor(R.color.textColor_alert_button_cancel));
        mTDialog1.addView(inflate);
        mTDialog1.show();

    }

    private void changeName(String n) {
        String token = SPConstants.checkLoginInfo(this);
        if (TextUtils.isEmpty(token)) {
            return;
        }
        NiceNameBean name = new NiceNameBean();
        name.setNickname(SecretUtils.DESede(n));
        if (Constants.ENCRYPT)
            name.setSign(SecretUtils.RsaToken());
        name.setToken(SecretUtils.DESede(token));
        Gson gson = new Gson();
        String json = gson.toJson(name);
        RequestBody body = RequestBody.create(Constants.JSON, json);
        OkGo.<String>post(URLDecoder.decode(Constants.BaseUrl() + Constants.SETNICKNAME + (Constants.ENCRYPT ? Constants.SIGN : "")))//
                .tag(this)//
                .upRequestBody(body)
                .execute(new NetDialogCallBack(this, true, ReviewActivity.this,
                        true, BaseBean.class) {
                    @Override
                    public void onUi(Object o) throws IOException {
                        BaseBean li = (BaseBean) o;
                        if (li != null && li.getCode() == 0 && li.getMsg() != null) {
                            ToastUtil.toastShortShow(ReviewActivity.this, li.getMsg());
                        }
                    }

                    @Override
                    public void onErr(BaseBean bb) throws IOException {
                        if (bb != null && bb.getExtra() != null && !bb.getExtra().isHasNickname()) {
                            bbsNameDialog();
                        }
                    }

                    @Override
                    public void onFailed(Response<String> response) {

                    }

                });
    }

}
