package com.phoenix.lotterys.my.fragment;

import android.annotation.SuppressLint;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.graphics.Bitmap;
import android.net.Uri;
import android.os.Build;
import androidx.annotation.RequiresApi;
import android.text.TextUtils;
import android.text.method.HideReturnsTransformationMethod;
import android.text.method.PasswordTransformationMethod;
import android.util.Log;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.View;
import android.webkit.JavascriptInterface;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import android.widget.Button;
import android.widget.CheckBox;
import android.widget.CompoundButton;
import android.widget.EditText;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.google.gson.Gson;
import com.google.gson.JsonSyntaxException;
import com.lzy.okgo.OkGo;
import com.lzy.okgo.model.Response;
import com.phoenix.lotterys.R;import com.phoenix.lotterys.R2;
import com.phoenix.lotterys.application.Application;
import com.phoenix.lotterys.application.BaseFragments;
import com.phoenix.lotterys.home.bean.MessageEvent;
import com.phoenix.lotterys.main.FragmentUtilAct;
import com.phoenix.lotterys.main.MainActivity;
import com.phoenix.lotterys.main.bean.ConfigBean;
import com.phoenix.lotterys.main.bean.VerifyBean;
import com.phoenix.lotterys.my.activity.LoginActivity;
import com.phoenix.lotterys.my.activity.RegeditActivity;
import com.phoenix.lotterys.my.bean.BaseBean;
import com.phoenix.lotterys.my.bean.LoginInfo;
import com.phoenix.lotterys.my.bean.RegeditQuestBean;
import com.phoenix.lotterys.util.Constants;
import com.phoenix.lotterys.util.ConstantsData;
import com.phoenix.lotterys.util.Md5;
import com.phoenix.lotterys.util.NetDialogCallBack;
import com.phoenix.lotterys.util.NumUtil;
import com.phoenix.lotterys.util.SPConstants;
import com.phoenix.lotterys.util.SecretUtils;
import com.phoenix.lotterys.util.ShareUtils;
import com.phoenix.lotterys.util.ToastUtils;
import com.phoenix.lotterys.util.Uiutils;
import com.phoenix.lotterys.view.MyIntentService;
import com.phoenix.lotterys.view.tddialog.TDialog;
import org.greenrobot.eventbus.EventBus;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;

import butterknife.BindView;
import butterknife.OnClick;
import im.delight.android.webview.AdvancedWebView;
import okhttp3.RequestBody;

/**
 * Greated by Luke
 * on 2020/2/13
 */
public class SimpleLoginFrament extends BaseFragments implements AdvancedWebView.Listener{
    LoginActivity  logActivity;
    private SharedPreferences sp;
    @BindView(R2.id.et_user)
    EditText etUser;
    @BindView(R2.id.et_password)
    EditText etPassword;
    @BindView(R2.id.cb_show)
    CheckBox cbShow;
    @BindView(R2.id.cb_pw)
    CheckBox cbPw;
    @BindView(R2.id.bt_login)
    Button btLogin;
    @BindView(R2.id.web)
    AdvancedWebView gameWebView;
    @BindView(R2.id.tv_pc)
    TextView tvPc;
    Application mApp;
    private String loginTo;
    private String md5pwd;
    String nc_token = "";
    String nc_sig = "";
    String nc_sid = "";
    private String googleCode;
    private String checkname;
    private TDialog mTDialog;

    public SimpleLoginFrament() {
        super(R.layout.simple_login, true, true);
    }

    @RequiresApi(api = Build.VERSION_CODES.LOLLIPOP)
    @SuppressLint("SetTextI18n")
    @Override
    public void initView(View view) {
        mApp = (Application) Application.getContextObject();
        logActivity = (LoginActivity)getActivity();
        sp = getContext().getSharedPreferences(SPConstants.SP_User, Context.MODE_PRIVATE);
        initLogin();
    }

    private void initLogin() {
        cbPw.setChecked(true);
        initListener(cbShow, etPassword);
        setWebView();
    }

    private void initListener(CheckBox cb, EditText et) {
        cb.setOnCheckedChangeListener(new CompoundButton.OnCheckedChangeListener() {
            @Override
            public void onCheckedChanged(CompoundButton buttonView, boolean isChecked) {
                if (isChecked) {
                    et.setTransformationMethod(HideReturnsTransformationMethod.getInstance());
                } else {
                    et.setTransformationMethod(PasswordTransformationMethod.getInstance());
                }
            }
        });
    }

    @OnClick({R.id.bt_login, /*R.id.bt_regedit, R.id.bt_playgame,*/ /*R.id.bt_gotohome, R.id.bt_online_service,*/ R.id.tv_pc, R.id.tv_regedit, R.id.tv_playgame})
    public void onViewClicked(View view) {
        switch (view.getId()) {
            case R.id.bt_login:
                try {
                    questLogin();
                } catch (UnsupportedEncodingException e) {
                    e.printStackTrace();
                }
                break;
//            case R.id.bt_regedit:
//                startActivity(new Intent(getActivity(), RegeditActivity.class));
//                break;
//            case R.id.bt_playgame:
//                Intent intent = new Intent(mApp, MyIntentService.class);
//                intent.putExtra("type", "2000");
//                getActivity().startService(intent);
//                startActivity(new Intent(getActivity(), MainActivity.class));
//                getActivity().finish();
//                break;
//            case R.id.bt_gotohome:
//                startActivity(new Intent(getContext(), MainActivity.class));
//                getActivity().finish();
//                break;
//            case R.id.bt_online_service:
//                String  zxkfurl = SPConstants.getValue(getContext(), SPConstants.SP_ZXKFURL);
//                if (!TextUtils.isEmpty(zxkfurl)) {
//                    Uiutils.goWebView(getContext(), zxkfurl.startsWith("http") ? zxkfurl : "http://" + zxkfurl
//                            , "在线客服");
//                } else {
//                    ToastUtils.ToastUtils("客服地址未配置或获取失败", getContext());
//                }
//                break;
            case R.id.tv_pc:
                onclickBrain();
                break;
            case R.id.tv_regedit:
                startActivity(new Intent(getActivity(), RegeditActivity.class));
                break;
                case R.id.tv_playgame:
                    Intent intent = new Intent(mApp, MyIntentService.class);
                    intent.putExtra("type", "2000");
                    getActivity().startService(intent);
                    startActivity(new Intent(getActivity(), MainActivity.class));
                    getActivity().finish();
                break;
        }
    }

    int count = 0;
    private void slideCode() {
        count++;
        if (count > 2) {
            gameWebView.setVisibility(View.VISIBLE);
        } else {
            gameWebView.setVisibility(View.GONE);
        }
    }

    private boolean questLogin() throws UnsupportedEncodingException {
        md5pwd = null;
        String mEtUser = etUser.getText().toString().trim();
        String mEtPassword = etPassword.getText().toString().trim();
        if (mEtUser == null || mEtUser.length() == 0) {
            ToastUtils.ToastUtils(getResources().getString(R.string.inputuser), getContext());
            slideCode();
            return false;
        } else if (mEtUser.length() < 4) {
            ToastUtils.ToastUtils(getResources().getString(R.string.inputuser9), getContext());
            slideCode();
            return false;
        }
        if (mEtPassword == null || mEtPassword.length() == 0) {
            ToastUtils.ToastUtils(getResources().getString(R.string.inputpwd), getContext());
            slideCode();
            return false;
        } else if (mEtPassword.length() < 6) {
            ToastUtils.ToastUtils(getResources().getString(R.string.inputpwd8), getContext());
            slideCode();
            return false;
        }
        if (gameWebView.getVisibility() == View.VISIBLE) {
            if (nc_sid.equals("") || nc_token.equals("") || nc_sig.equals("")) {
                ToastUtils.ToastUtils(getResources().getString(R.string.verify_err), getContext());
                return false;
            }
        }
        if (!TextUtils.isEmpty(checkname) && checkname.equals(mEtUser)) {
            if (!mTDialog.isShowing()) {
                mdialog();
                return false;
            }
        }
        RegeditQuestBean qb = new RegeditQuestBean();
        qb.setUsr(SecretUtils.DESede(mEtUser));
        qb.setPwd(SecretUtils.DESedePassw(mEtPassword));
        qb.setSign(SecretUtils.RsaToken());
        if (!TextUtils.isEmpty(googleCode)) {
            qb.setGgCode(SecretUtils.DESede(googleCode));
        }
        if (!nc_token.equals("") && !nc_sig.equals("") && !nc_sid.equals("")) {
            RegeditQuestBean.SlideCode sc = new RegeditQuestBean.SlideCode();
            sc.setNc_token(SecretUtils.DESede(nc_token));
            sc.setNc_sig(SecretUtils.DESede(nc_sig));
            sc.setNc_sid(SecretUtils.DESede(nc_sid));
            qb.setSlideCode(sc);
        }
        Gson gson = new Gson();
        String json = gson.toJson(qb);
        RequestBody body = RequestBody.create(Constants.JSON, json);
        OkGo.<String>post(URLDecoder.decode(Constants.BaseUrl()+Constants.USERLOGIN + (Constants.ENCRYPT ? Constants.SIGN : "")))//
                .tag(this)//
                .upRequestBody(body)
                .execute(new NetDialogCallBack(getContext(), true, getContext(),
                        true, LoginInfo.class) {
                    @Override
                    public void onUi(Object o) throws IOException {
                        LoginInfo li = (LoginInfo) o;
                        if (li != null && li.getCode() == 0) {
                            SharedPreferences.Editor edit = sp.edit();
                            edit.putString(SPConstants.SP_PASSWORD, cbPw.isChecked() ? Md5.convertMD5(mEtPassword) : "");
                            edit.putString(SPConstants.SP_USERNAME, mEtUser);
                            edit.putString(SPConstants.SP_API_SID, li.getData().getAPISID());
                            edit.putString(SPConstants.SP_API_TOKEN, li.getData().getAPITOKEN());
                            edit.putString(SPConstants.SP_USR, li.getData().getName());//名字
                            edit.putString(SPConstants.SP_REBATE, li.getData().getRebate());
                            edit.putString(SPConstants.SP_USERTYPE, "user");   //是否guest
                            edit.commit();
                            Log.e("token", li.getData().getAPISID());
                            if (loginTo != null && loginTo.equals("0")) {
                                EventBus.getDefault().postSticky(new MessageEvent("login_my"));
                            } else {
                                EventBus.getDefault().postSticky(new MessageEvent("login"));
                            }

                            Intent intent = new Intent(mApp, MyIntentService.class);
                            intent.putExtra("type", "3000");
                            getContext().startService(intent);
                            if(ConstantsData.passwod(mEtPassword)) {
                                ToastUtils.ToastUtils("您的密码过于简单，可能存在风险，请修改为复杂的密码", getContext());
                                FragmentUtilAct.startAct(getContext(), new SafetyCenterFrag(false));
                            }else
                                startActivity(new Intent(getContext(), MainActivity.class));
                        } else if (li != null && li.getCode() != 0 && li.getMsg() != null) {
                            ToastUtils.ToastUtils(li.getMsg(), getContext());
                            slideCode();
                            if (gameWebView.getVisibility() == View.VISIBLE) {
                                nc_sid = "";
                                nc_token = "";
                                nc_sig = "";
                                gameWebView.reload();
                            }
                        }
                    }

                    @Override
                    public void onErr(BaseBean bb) throws IOException {
//                        if(!TextUtils.isEmpty(checkname)&&checkname.equals(mEtUser))
//                            mdialog();
                        if (NumUtil.isContain(String.valueOf(bb.getData()), "ggCheck=true")) {
                            checkname = mEtUser;
//                            count--;
                            mdialog();
                        } else {
                            slideCode();
                        }
                        if (gameWebView.getVisibility() == View.VISIBLE) {
                            nc_sid = "";
                            nc_token = "";
                            nc_sig = "";
                            gameWebView.reload();
                        }
                    }

                    @Override
                    public void onFailed(Response<String> response) {
                        if (gameWebView.getVisibility() == View.VISIBLE) {
                            nc_sid = "";
                            nc_token = "";
                            nc_sig = "";
                            gameWebView.reload();
                        }
                    }

                });
        return false;
    }

    private void mdialog() {
        String[] array = getResources().getStringArray(R.array.affirm_change);
        View inflate = LayoutInflater.from(getContext()).inflate(R.layout.alertext_from, null);
        final EditText et = (EditText) inflate.findViewById(R.id.from_et);
        et.setHint(getResources().getString(R.string.google_code));
        mTDialog = new TDialog(getActivity(), TDialog.Style.Center, array, getResources().getString(R.string.google_code),
                "", "", new TDialog.onItemClickListener() {
            @Override
            public void onItemClick(Object object, int pos) {

                googleCode = et.getText().toString().trim();
                if (pos == 1) {
                    if (TextUtils.isEmpty(googleCode)) {
                        ToastUtils.ToastUtils(getResources().getString(R.string.google_code), getContext());
                    } else {
                        try {
                            questLogin();
                        } catch (UnsupportedEncodingException e) {
                            e.printStackTrace();
                        }
                    }
                }
            }
        });
        mTDialog.setMsgGravity(Gravity.CENTER);
        mTDialog.setMsgPaddingLeft(10, 5, 10, 0);
        mTDialog.setItemTextColorAt(0, getResources().getColor(R.color.textColor_alert_button_cancel));
        mTDialog.addView(inflate);
        mTDialog.show();
    }


    //获取保存在sp的参数
    private void showUser() {
        String guest = sp.getString(SPConstants.SP_USERTYPE, SPConstants.SP_NULL);
        if (!guest.equals(SPConstants.SP_NULL) && guest.equals("guest")) {
            return;
        }
        String username = sp.getString(SPConstants.SP_USERNAME, SPConstants.SP_NULL);
        if (!username.equals(SPConstants.SP_NULL)) {
            etUser.setText(username);
        }
        String password = sp.getString(SPConstants.SP_PASSWORD, SPConstants.SP_NULL);
        if (!password.equals(SPConstants.SP_NULL)) {
            etPassword.setText(Md5.convertMD5(password));
        }
        loginTo = sp.getString(SPConstants.SP_LOGIN_TO, SPConstants.SP_NULL);
    }

    @Override
    public void onResume() {
        super.onResume();
        showUser();
        gameWebView.onResume();
    }

    @SuppressLint("JavascriptInterface")
    private void setWebView() {
        gameWebView.setWebViewClient(new WebViewClient() {
            @Override
            public boolean shouldOverrideUrlLoading(WebView view, String url) {
                view.loadUrl(url);
                return true;
            }

            @Override
            public void onPageFinished(WebView view, String url) {
                LinearLayout.LayoutParams params = (LinearLayout.LayoutParams) gameWebView.getLayoutParams();
//                params.width = Tools.getWidthInPx(getActivity());
                params.height = Uiutils.dipToPx(getContext(), 80);
                gameWebView.setLayoutParams(params);
            }

        });
        final JavaScriptInterface myJavaScriptInterface
                = new JavaScriptInterface(getContext());
        gameWebView.getSettings().setLightTouchEnabled(true);
        gameWebView.getSettings().setJavaScriptEnabled(true);
        gameWebView.addJavascriptInterface(myJavaScriptInterface, "postSwiperData");
        gameWebView.loadUrl(Constants.BaseUrl()+Constants.SLIDECODE);
    }

    public class JavaScriptInterface {
        Context mContext;

        JavaScriptInterface(Context c) {
            mContext = c;
        }

        @JavascriptInterface
        public void jsCallWebView(String webMessage) {
            Log.e("webMessage", "" + webMessage);
            try {
                if (webMessage != null || !webMessage.equals("undefined")) {
                    VerifyBean vb = new Gson().fromJson(webMessage, VerifyBean.class);
                    Log.e("webMessage", "" + webMessage);
                    if (vb.getNc_value() != null && vb.getNc_token() != null && vb.getNc_csessionid() != null && vb.getNc_sig() != null) {
//                        nc_value = vb.getNc_value();
                        nc_sig = vb.getNc_value();
                        nc_token = vb.getNc_token();
                        nc_sid = vb.getNc_csessionid();
                    }
                }
            } catch (JsonSyntaxException e) {
                e.printStackTrace();
            }
        }
    }

    @Override
    public void onPageStarted(String url, Bitmap favicon) {

    }

    @Override
    public void onPageFinished(String url) {

    }

    @Override
    public void onPageError(int errorCode, String description, String failingUrl) {

    }

    @Override
    public void onDownloadRequested(String url, String suggestedFilename, String mimeType, long contentLength, String contentDisposition, String userAgent) {

    }

    @Override
    public void onExternalPageRequest(String url) {

    }

    @SuppressLint("NewApi")
    @Override
    public void onPause() {
        gameWebView.onPause();
        super.onPause();
    }

    @Override
    public void onDestroy() {
        gameWebView.onDestroy();
        super.onDestroy();
    }

    @Override
    public void onActivityResult(int requestCode, int resultCode, Intent intent) {
        super.onActivityResult(requestCode, resultCode, intent);
        gameWebView.onActivityResult(requestCode, resultCode, intent);
    }

    private void onclickBrain() {
        ConfigBean config = (ConfigBean) ShareUtils.getObject(getContext(), SPConstants.CONFIGBEAN, ConfigBean.class);
        if (null != config && null != config.getData()) {
            if (config.getData() != null && config.getData().getHost() != null) {
//                SkipGameUtil.loadUrl(config.getData().getHost(), getActivity());
                Intent intent = new Intent();
                intent.setAction("android.intent.action.VIEW");
                Uri content_url = Uri.parse(config.getData().getHost().startsWith("http") ? config.getData().getHost() : "http://" + config.getData().getHost());
                intent.setData(content_url);
                startActivity(intent);
            }
        }
    }


}
