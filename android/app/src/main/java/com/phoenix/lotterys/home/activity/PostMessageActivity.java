package com.phoenix.lotterys.home.activity;

import android.Manifest;
import android.annotation.SuppressLint;
import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import androidx.annotation.NonNull;
import androidx.recyclerview.widget.GridLayoutManager;
import androidx.recyclerview.widget.RecyclerView;
import android.text.TextUtils;
import android.util.Log;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.View;
import android.view.Window;
import android.view.WindowManager;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.TextView;
import android.widget.Toast;

import com.google.gson.Gson;
import com.lzy.okgo.OkGo;
import com.lzy.okgo.model.Response;
import com.phoenix.lotterys.R;import com.phoenix.lotterys.R2;
import com.phoenix.lotterys.application.BaseActivitys;
import com.phoenix.lotterys.home.adapter.ImgAdapter;
import com.phoenix.lotterys.home.bean.NiceNameBean;
import com.phoenix.lotterys.home.bean.PostContent;
import com.phoenix.lotterys.home.fragment.SixThemeBetterFragment;
import com.phoenix.lotterys.main.FragmentUtilAct;
import com.phoenix.lotterys.main.bean.ConfigBean;
import com.phoenix.lotterys.my.bean.BaseBean;
import com.phoenix.lotterys.util.Constants;
import com.phoenix.lotterys.util.EditTextUtil;
import com.phoenix.lotterys.util.ImageBase64Utils;
import com.phoenix.lotterys.util.LQRPhotoSelectUtils;
import com.phoenix.lotterys.util.NetDialogCallBack;
import com.phoenix.lotterys.util.SPConstants;
import com.phoenix.lotterys.util.SecretUtils;
import com.phoenix.lotterys.util.ShareUtils;
import com.phoenix.lotterys.util.ShowItem;
import com.phoenix.lotterys.util.ToastUtils;
import com.phoenix.lotterys.util.Uiutils;
import com.phoenix.lotterys.view.EmotionDialog;
import com.phoenix.lotterys.view.tddialog.TDialog;
import com.wanxiangdai.commonlibrary.util.EvenBusUtil.Even;
import com.wanxiangdai.commonlibrary.util.EvenBusUtil.EvenBusCode;
import com.wanxiangdai.commonlibrary.util.EvenBusUtil.EvenBusUtils;
import com.wanxiangdai.commonlibrary.util.ToastUtil;

import java.io.File;
import java.io.IOException;
import java.net.URLDecoder;
import java.util.ArrayList;
import java.util.List;

import butterknife.BindView;
import butterknife.OnClick;
import kr.co.namee.permissiongen.PermissionFail;
import kr.co.namee.permissiongen.PermissionGen;
import kr.co.namee.permissiongen.PermissionSuccess;
import okhttp3.RequestBody;

/**
 * Greated by Luke
 * on 2019/12/1
 */
//https://github.com/qiushi123/TakePhoto_android7.0
public class PostMessageActivity extends BaseActivitys {
    @BindView(R2.id.titlebar)
    RelativeLayout titlebar;
    @BindView(R2.id.tv_1)
    TextView tv_1;
    @BindView(R2.id.tv_back)
    TextView tvBack;
    @BindView(R2.id.tv_title)
    TextView tvTitle;
    @BindView(R2.id.tv_history)
    TextView tvHistory;
    @BindView(R2.id.iv_emotion)
    ImageView ivEmotion;
    boolean isHide = false;
    String title = "";
    @BindView(R2.id.et_title)
    EditText etTitle;
    @BindView(R2.id.et_content)
    EditText etContent;
    @BindView(R2.id.et_money)
    EditText etMoney;
    @BindView(R2.id.rc_img)
    RecyclerView rcImg;
    @BindView(R2.id.ll_money)
    LinearLayout llMoney;
    List<String> imgPath = new ArrayList<>();
    List<String> imgbase64 = new ArrayList<>();
    List<String> imgStoragePath = new ArrayList<>();
    @BindView(R2.id.iv_img)
    ImageView ivImg;
    @BindView(R2.id.bt_issue)
    Button btIssue;
    private LQRPhotoSelectUtils mLqrPhotoSelectUtils;
    private ImgAdapter imgAdapter;
    String alias;
    double max = 0;
    double min = 0;

    public void getIntentData() {
        Bundle bundle = getIntent().getExtras();
        alias = bundle.getString("alias");
    }

    @SuppressLint("ValidFragment")
    public PostMessageActivity() {
        super(R.layout.post_message_frament, true, true);
    }

    @Override
    public void initView() {
        ConfigBean configBean = (ConfigBean) ShareUtils.getObject(PostMessageActivity.this, SPConstants.CONFIGBEAN, ConfigBean.class);
        if (configBean != null && configBean.getData() != null && configBean.getData().getLhcPriceList() != null) {
            for (int i = 0; i < configBean.getData().getLhcPriceList().size(); i++) {
                if (configBean.getData().getLhcPriceList().get(i).getAlias().equals(alias)) {
                    String priceMax = configBean.getData().getLhcPriceList().get(i).getPriceMax() == null ? "" : configBean.getData().getLhcPriceList().get(i).getPriceMax();
                    String priceMin = configBean.getData().getLhcPriceList().get(i).getPriceMin() == null ? "" : configBean.getData().getLhcPriceList().get(i).getPriceMin();
                    if (ShowItem.isNumeric(priceMax)) {
                        max = Double.parseDouble(priceMax);
                    }
                    if (ShowItem.isNumeric(priceMin)) {
                        min = Double.parseDouble(priceMin);
                    }
                    Log.e("xxxmax", +max + "||" + min);
                    if (max > 0 && min >= 0) {
                        llMoney.setVisibility(View.VISIBLE);
                    } else {
                        llMoney.setVisibility(View.GONE);
                    }
                }
            }
        }

        for (int c = 0; c < 104; c++) {
            String img = "file:///android_asset/emoji/" + (c + 1) + ".gif";
            imgPath.add(img);
        }
        imgAdapter = new ImgAdapter(this, imgStoragePath);
        rcImg.setLayoutManager(new GridLayoutManager(this, 3));
        rcImg.setAdapter(imgAdapter);
        imgAdapter.setListener(new ImgAdapter.OnClickListener() {
            @Override
            public void onClickListener(View view, int position) {
                imgStoragePath.remove(position);
                imgAdapter.notifyDataSetChanged();
                imgbase64.remove(position);
            }
        });
        init();

        Uiutils.setBarStye0(titlebar,this);
    }

    private void init() {
        // 1、创建LQRPhotoSelectUtils（一个Activity对应一个LQRPhotoSelectUtils）
        //true裁剪，false不裁剪
        mLqrPhotoSelectUtils = new LQRPhotoSelectUtils(this, new LQRPhotoSelectUtils.PhotoSelectListener() {
            @Override
            public void onFinish(File outputFile, Uri outputUri) {
                // 4、当拍照或从图库选取图片成功后回调
//                mTvPath.setText(outputFile.getAbsolutePath());
//                Glide.with(MainActivity.this).load(outputUri).into(mIvPic);
                imgbase64.add("data:image/png;base64," + ImageBase64Utils.imageToBase64(outputFile.getAbsolutePath()));
                imgStoragePath.add(outputUri.toString());
                if (imgAdapter != null)
                    imgAdapter.notifyDataSetChanged();
            }
        }, false);
    }

    @OnClick({R.id.tv_back, R.id.tv_history, R.id.iv_emotion, R.id.iv_img, R.id.bt_issue})
    public void onViewClicked(View view) {
        switch (view.getId()) {
            case R.id.tv_back:
                finish();
                break;
            case R.id.tv_history:
                FragmentUtilAct.startAct(this, SixThemeBetterFragment.getInstance("历史帖子", alias));

                break;
            case R.id.iv_emotion:
                EmotionDialog emotionDialog = new EmotionDialog(this, imgPath);
                emotionDialog.show();
                Window window = emotionDialog.getWindow();
                WindowManager.LayoutParams lp = window.getAttributes();
                lp.gravity = Gravity.TOP;
                lp.width = WindowManager.LayoutParams.MATCH_PARENT;//宽高可设置具体大小
                lp.height = WindowManager.LayoutParams.WRAP_CONTENT;
                emotionDialog.getWindow().setAttributes(lp);
                emotionDialog.setClicklistener(new EmotionDialog.ClickListenerInterface() {
                    @Override
                    public void doConfirm(String emotion) {
                        String con = etContent.getText().toString().toString() + emotion;
                        etContent.setText(con);
                        etContent.setSelection(con.toString().length());
                    }
                });
                break;
            case R.id.iv_img:
                selectImg();
                break;
            case R.id.bt_issue:
                postContent();
                break;
        }
    }

    public void selectImg() {
        if (imgStoragePath.size() < 3) {
            PermissionGen.needPermission(PostMessageActivity.this,
                    LQRPhotoSelectUtils.REQ_SELECT_PHOTO,
                    new String[]{Manifest.permission.READ_EXTERNAL_STORAGE,
                            Manifest.permission.WRITE_EXTERNAL_STORAGE}
            );
        } else {
            ToastUtil.toastShortShow(PostMessageActivity.this, "最多只能添加3张");
        }
    }

    @PermissionSuccess(requestCode = LQRPhotoSelectUtils.REQ_TAKE_PHOTO)
    public void takePhoto() {
        mLqrPhotoSelectUtils.takePhoto();
    }

    @PermissionSuccess(requestCode = LQRPhotoSelectUtils.REQ_SELECT_PHOTO)
    public void selectPhoto() {
        mLqrPhotoSelectUtils.selectPhoto();
    }

    @PermissionFail(requestCode = LQRPhotoSelectUtils.REQ_TAKE_PHOTO)
    public void showTip1() {
        Toast.makeText(getApplicationContext(), "拒绝后如果想上传图片请到设置开启权限", Toast.LENGTH_SHORT).show();
//        showDialog();
    }

    @PermissionFail(requestCode = LQRPhotoSelectUtils.REQ_SELECT_PHOTO)
    public void showTip2() {
        Toast.makeText(getApplicationContext(), "拒绝后如果想上传图片请到设置开启权限", Toast.LENGTH_SHORT).show();
//        showDialog();
    }

    @Override
    public void onRequestPermissionsResult(int requestCode, @NonNull String[] permissions, @NonNull int[] grantResults) {
        PermissionGen.onRequestPermissionsResult(this, requestCode, permissions, grantResults);
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        // 2、在Activity中的onActivityResult()方法里与LQRPhotoSelectUtils关联
        mLqrPhotoSelectUtils.attachToActivityForResult(requestCode, resultCode, data);
    }


    private void postContent() {
        String token = SPConstants.checkLoginInfo(this);
        if (TextUtils.isEmpty(token)) {
            return;
        }
        String mTitle = etTitle.getText().toString().trim();
        String mContent = etContent.getText().toString().trim();
        String mMoney = etMoney.getText().toString().trim();
        if (mTitle == null || mTitle.length() == 0) {
            ToastUtils.ToastUtils(getResources().getString(R.string.lhc_inputtitle), PostMessageActivity.this);
            return;
        }

        if (mContent == null || mContent.length() == 0) {
            ToastUtils.ToastUtils(getResources().getString(R.string.lhc_inputcotent), PostMessageActivity.this);
            return;
        }
//        if (llMoney.getVisibility() == View.VISIBLE&&!TextUtils.isEmpty(mMoney)) {
//            double money = 0;
//            try {
//                money = Double.parseDouble(mMoney);
//            } catch (NumberFormatException e) {
//                e.printStackTrace();
//                ToastUtil.toastShortShow(this,"收费金额格式不对");
//                return;
//            }
//            if(money<min){
//                ToastUtil.toastShortShow(this,"收费下限"+min+"元");
//                return;
//            }
//            if(money>max){
//                ToastUtil.toastShortShow(this,"收费上限"+max+"元");
//                return;
//            }
//        }

        PostContent content = new PostContent();
        content.setAlias(SecretUtils.DESede(alias));
        content.setContent(SecretUtils.DESede(mContent));
        content.setTitle(SecretUtils.DESede(mTitle));
        if (Constants.ENCRYPT)
            content.setSign(SecretUtils.RsaToken());
        content.setToken(SecretUtils.DESede(token));
        if (imgbase64 != null && imgbase64.size() > 0) {
            String[] images = new String[imgbase64.size()];
            for (int i = 0; i < imgbase64.size(); i++) {
                images[i] = imgbase64.get(i);
            }
            content.setImages(images);
        }
        if (mMoney.length() != 0)
            content.setPrice(SecretUtils.DESede(mMoney));

        Gson gson = new Gson();
        String json = gson.toJson(content);
        RequestBody body = RequestBody.create(Constants.JSON, json);
        OkGo.<String>post(URLDecoder.decode(Constants.BaseUrl() + Constants.POSTCONTENT + (Constants.ENCRYPT ? Constants.SIGN : "")))//
                .tag(this)//
                .upRequestBody(body)
                .execute(new NetDialogCallBack(this, true, PostMessageActivity.this,
                        true, BaseBean.class) {
                    @Override
                    public void onUi(Object o) throws IOException {
                        BaseBean li = (BaseBean) o;
                        String[] array = new String[]{getResources().getString(R.string.affirm)};
                        if (li != null && li.getCode() == 0) {
                            etTitle.setText("");
                            etContent.setText("");
                            etMoney.setText("");
                            if (imgbase64 != null) {
                                imgbase64.clear();
                            }
                            if (imgStoragePath != null) {
                                imgStoragePath.clear();
                            }
                            if (imgAdapter != null)
                                imgAdapter.notifyDataSetChanged();

                            TDialog mTDialog = new TDialog(PostMessageActivity.this, TDialog.Style.Center, array, li.getMsg(), "", "", new TDialog.onItemClickListener() {
                                @Override
                                public void onItemClick(Object object, int position) {
                                    EvenBusUtils.setEvenBus(new Even(EvenBusCode.ITEMDATA));
                                    PostMessageActivity.this.finish();
                                }
                            });
                            mTDialog.setCancelable(false);
                            mTDialog.show();
                        } else if (li != null && li.getCode() != 0 && li.getMsg() != null) {
                            ToastUtils.ToastUtils(li.getMsg(), PostMessageActivity.this);

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
        EditTextUtil.mEditTextChinese(etContent);
        TDialog mTDialog1 = new TDialog(this, TDialog.Style.Center, array, title,
                "", ""
                , new TDialog.onItemClickListener() {
            @Override
            public void onItemClick(Object object, int pos) {
                if (pos == 1) {
                    String name = etContent.getText().toString().trim();
                    if (name == null || name.length() == 0) {
                        ToastUtil.toastShortShow(PostMessageActivity.this, "请输入昵称");
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
                .execute(new NetDialogCallBack(this, true, PostMessageActivity.this,
                        true, BaseBean.class) {
                    @Override
                    public void onUi(Object o) throws IOException {
                        BaseBean li = (BaseBean) o;
                        if (li != null && li.getCode() == 0 && li.getMsg() != null) {
                            ToastUtil.toastShortShow(PostMessageActivity.this, li.getMsg());
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
