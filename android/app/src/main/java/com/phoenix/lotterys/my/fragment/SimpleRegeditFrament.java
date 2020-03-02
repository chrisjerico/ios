package com.phoenix.lotterys.my.fragment;

import android.annotation.SuppressLint;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Color;
import android.os.Build;
import android.os.Handler;
import androidx.annotation.RequiresApi;

import android.text.Html;
import android.text.InputFilter;
import android.text.InputType;
import android.text.TextUtils;
import android.text.method.DigitsKeyListener;
import android.text.method.HideReturnsTransformationMethod;
import android.text.method.PasswordTransformationMethod;
import android.util.Base64;
import android.util.Log;
import android.view.MotionEvent;
import android.view.View;
import android.view.ViewGroup;
import android.webkit.JavascriptInterface;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import android.widget.Button;
import android.widget.CheckBox;
import android.widget.CompoundButton;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.ProgressBar;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.google.gson.Gson;
import com.google.gson.JsonSyntaxException;
import com.lzy.okgo.OkGo;
import com.lzy.okgo.callback.StringCallback;
import com.lzy.okgo.model.Response;
import com.phoenix.lotterys.BuildConfig;
import com.phoenix.lotterys.R;import com.phoenix.lotterys.R2;
import com.phoenix.lotterys.application.Application;
import com.phoenix.lotterys.application.BaseFragments;
import com.phoenix.lotterys.home.bean.MessageEvent;
import com.phoenix.lotterys.main.MainActivity;
import com.phoenix.lotterys.main.bean.ConfigBean;
import com.phoenix.lotterys.main.bean.VerifyBean;
import com.phoenix.lotterys.my.activity.RegeditActivity;
import com.phoenix.lotterys.my.bean.BaseBean;
import com.phoenix.lotterys.my.bean.LoginInfo;
import com.phoenix.lotterys.my.bean.RegeditBean;
import com.phoenix.lotterys.my.bean.RegeditQuestBean;
import com.phoenix.lotterys.util.Constants;
import com.phoenix.lotterys.util.EditTextUtil;
import com.phoenix.lotterys.util.Md5;
import com.phoenix.lotterys.util.NetDialogCallBack;
import com.phoenix.lotterys.util.RegexConstants;
import com.phoenix.lotterys.util.SPConstants;
import com.phoenix.lotterys.util.SecretUtils;
import com.phoenix.lotterys.util.ShareUtils;
import com.phoenix.lotterys.util.ShowItem;
import com.phoenix.lotterys.util.ToastUtils;
import com.phoenix.lotterys.util.Uiutils;
import com.phoenix.lotterys.view.MyIntentService;
import com.phoenix.lotterys.view.TimeCount;
import com.wanxiangdai.commonlibrary.util.StringUtils;

import org.greenrobot.eventbus.EventBus;

import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.security.NoSuchAlgorithmException;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import butterknife.BindView;
import butterknife.OnClick;
import im.delight.android.webview.AdvancedWebView;
import okhttp3.RequestBody;

/**
 * Greated by Luke
 * on 2020/2/12
 */
//简约模板
@SuppressLint("ValidFragment")
public class SimpleRegeditFrament extends BaseFragments {
    public static final String DEVICE = "2";  //设备类型
    @BindView(R2.id.et_agent)
    EditText etAgent;
    @BindView(R2.id.rl_agent)
    RelativeLayout rlAgent;

    @BindView(R2.id.et_user)
    EditText etUser;

    @BindView(R2.id.et_password)
    EditText etPassword;
    @BindView(R2.id.cb_show_passwoad)
    CheckBox cbShowPasswoad;

    @BindView(R2.id.et_password_once)
    EditText etPasswordOnce;
    @BindView(R2.id.cb_show_password_once)
    CheckBox cbShowPasswordOnce;

    @BindView(R2.id.et_name)
    EditText etName;
    @BindView(R2.id.rl_name)
    RelativeLayout rlName;

    @BindView(R2.id.et_pay_pwd)
    EditText etPayPwd;
    @BindView(R2.id.rl_pay_pwd)
    RelativeLayout rlPayPwd;

    @BindView(R2.id.et_qq)
    EditText etQq;
    @BindView(R2.id.rl_qq)
    RelativeLayout rlQq;

    @BindView(R2.id.et_wx)
    EditText etWx;
    @BindView(R2.id.rl_wx)
    RelativeLayout rlWx;


//    @BindView(R2.id.rl_phone)
//    RelativeLayout rlPhone;

    @BindView(R2.id.rl_code)
    RelativeLayout rlCode;
    @BindView(R2.id.et_code)   //图片验证码
            EditText etCode;

    @BindView(R2.id.et_email)
    EditText etEmail;
    @BindView(R2.id.rl_email)
    RelativeLayout rlEmail;

    @BindView(R2.id.bt_login)
    Button btLogin;
    @BindView(R2.id.bt_regedit)
    Button btRegedit;
    @BindView(R2.id.bt_gotohome)
    Button btGotohome;

    @BindView(R2.id.bt_online_service)
    Button btOnlineService;




    @BindView(R2.id.web)
    AdvancedWebView gameWebView;
    @BindView(R2.id.pbar_web)
    ProgressBar pbarWeb;

    //   手机验证码
    @BindView(R2.id.rl_phone_code)
    RelativeLayout rlPhoneCode;
    //    @BindView(R2.id.et_phone_code)
//    EditText etPhoneCode;
    @BindView(R2.id.et_phone)
    EditText etPhone;
    @BindView(R2.id.bt_phone_code)
    Button btPhoneCode;

    @BindView(R2.id.rl_p_code)
    RelativeLayout rlPcode;
    @BindView(R2.id.et_p_code)
    EditText etPcode;
    @BindView(R2.id.iv_img)
    ImageView ivImg;
//    @BindView(R2.id.tv_close)
//    TextView tv_close;

//    @BindView(R2.id.sv)
//    ScrollView sv;

    @BindView(R2.id.ll_regedit_type)  //普通用户
            LinearLayout llRegedit_type;
    @BindView(R2.id.tv_user)  //普通用户
            TextView tvUser;
    @BindView(R2.id.tv_agency)//代理注册
            TextView tvAgency;

    @BindView(R2.id.tv_copyright)//代理注册
            TextView tvCopyright;
    @BindView(R2.id.tv_login)//
        TextView tvLogin;
    @BindView(R2.id.ll_main)//
            LinearLayout llMain;

    private TimeCount time;
    RegeditActivity regActivity;
    private SharedPreferences sp;
    String reco, email, name, fundpwd, qq, wx, phone, allowreg, passMax, passMin, passLimit, memberAsParent;
    Application mApp;
    private String phoCode;
    private String vCode;
    private String loginTo;

    String nc_sid = "";
    String nc_token = "";
    String nc_sig = "";
    String ps1;
    boolean isAgency = false;  //代理或普通用户
    public SimpleRegeditFrament() {
        super(R.layout.simple_regedit, true, true);
    }


    @RequiresApi(api = Build.VERSION_CODES.LOLLIPOP)
    @SuppressLint("SetTextI18n")
    @Override
    public void initView(View view) {
        regActivity = (RegeditActivity)getActivity();
        sp = getContext().getSharedPreferences(SPConstants.SP_User, Context.MODE_PRIVATE);
        ConfigBean configBean = (ConfigBean) ShareUtils.getObject(getContext(), SPConstants.CONFIGBEAN, ConfigBean.class);
        initRegedit(configBean);
    }


    private void initRegedit(ConfigBean configBean) {
        initListener(cbShowPasswoad, etPassword);
        initListener(cbShowPasswordOnce, etPasswordOnce);
        time = new TimeCount(60000, 1000, btPhoneCode);

        EditTextUtil.mEditTextChinese(etName);
        getConfig();
        setWebView();
        if (Uiutils.isSite("c008")||Uiutils.isSite("c049")){
            btOnlineService.setVisibility(View.VISIBLE);
        }else{
            btOnlineService.setVisibility(View.GONE);
        }
        if (null!=configBean&&null!=configBean.getData()&& !StringUtils.isEmpty(configBean.getData().getDomainBindAgentId())&&
                !StringUtils.equals("0",configBean.getData().getDomainBindAgentId())){
            etAgent.setText(configBean.getData().getDomainBindAgentId());
            etAgent.setEnabled(false);
        }
        if (configBean.getData().getWebName() != null) {
            tvCopyright.setText("COPYRIGHT © " + configBean.getData().getWebName() + " RESERVED");
        }
        String curIssue = "已有账号？<font color='#387EF5'>" + "马上登录" + "</font>" ;
        tvLogin.setText(Html.fromHtml(curIssue));
    }

    private void showItem(ConfigBean config) {
        loginTo = (TextUtils.isEmpty(config.getData().getLogin_to()))?"-1":config.getData().getLogin_to();
        reco = (TextUtils.isEmpty(config.getData().getHide_reco()))?"-1":config.getData().getHide_reco();
        memberAsParent = (TextUtils.isEmpty(config.getData().getMemberAsParent()))?"-1":config.getData().getMemberAsParent();
        email = (TextUtils.isEmpty(config.getData().getReg_email()))?"-1":config.getData().getReg_email();
        name = (TextUtils.isEmpty(config.getData().getReg_name()))?"-1":config.getData().getReg_name();
        fundpwd = (TextUtils.isEmpty(config.getData().getReg_fundpwd()))?"-1":config.getData().getReg_fundpwd();
        qq = (TextUtils.isEmpty(config.getData().getReg_qq()))?"-1":config.getData().getReg_qq();
        wx = (TextUtils.isEmpty(config.getData().getReg_wx()))?"-1":config.getData().getReg_wx();
        phone = (TextUtils.isEmpty(config.getData().getReg_phone()))?"-1":config.getData().getReg_phone();
        phoCode = (TextUtils.isEmpty(config.getData().getSmsVerify()))?"-1":config.getData().getSmsVerify();
        vCode = (TextUtils.isEmpty(config.getData().getReg_vcode()))?"-1":config.getData().getReg_vcode();
        passMax = (TextUtils.isEmpty(config.getData().getPass_length_max()))?"-1":config.getData().getPass_length_max();
        passMin = (TextUtils.isEmpty(config.getData().getPass_length_min()))?"-1":config.getData().getPass_length_min();
        passLimit = (TextUtils.isEmpty(config.getData().getPass_limit()))?"-1":config.getData().getPass_limit();
        allowreg = (TextUtils.isEmpty(config.getData().getAllowreg()))?"-1":config.getData().getAllowreg();
        String agentRegbutton = (TextUtils.isEmpty(config.getData().getAgentRegbutton()))?"-1":config.getData().getAgentRegbutton();
        String closeregreason = (TextUtils.isEmpty(config.getData().getCloseregreason()))?"-1":config.getData().getCloseregreason();

        if (agentRegbutton.equals("0")) {
            llRegedit_type.setVisibility(View.GONE);
        } else if (agentRegbutton.equals("1")) {
            llRegedit_type.setVisibility(View.VISIBLE);
        }


        if (allowreg.equals("0")) {
            llMain.setVisibility(View.GONE);
//            tv_close.setVisibility(View.VISIBLE);
//            tv_close.setText(closeregreason.equals("Null") ? "注册已关闭" : closeregreason);
        } else if (allowreg.equals("1")) {
            llMain.setVisibility(View.VISIBLE);
//            tv_close.setVisibility(View.GONE);
        }
        configShow(rlAgent, reco, etAgent);
        configShow(rlEmail, email, etEmail);
        configShow(rlName, name, etName);
        configShow(rlPayPwd, fundpwd, etPayPwd);
        configShow(rlQq, qq, etQq);
        configShow(rlWx, wx, etWx);
        configShow(rlPhoneCode, phone, etPhone);
        btPhoneCode.setVisibility(phoCode.equals("1") ? View.VISIBLE : View.GONE);
//        configShow1(rlPhoneCode, phoCode, etPhoneCode);
        configShow1(rlPcode, phoCode, etPcode);

//注册验证
        if (vCode.equals("0")) {
            rlCode.setVisibility(View.GONE);
            gameWebView.setVisibility(View.GONE);
        } else if (vCode.equals("1")) {
            gameWebView.setVisibility(View.GONE);
            rlCode.setVisibility(View.VISIBLE);
            getImgCode();
        } else if (vCode.equals("2")) {
            rlCode.setVisibility(View.GONE);
            gameWebView.setVisibility(View.VISIBLE);
        } else if (vCode.equals("3")) {
            gameWebView.setVisibility(View.GONE);
            rlCode.setVisibility(View.VISIBLE);
        }

        if (ShowItem.isNumeric(passMax) && ShowItem.isNumeric(passMin)) {
            InputFilter[] filters = {new InputFilter.LengthFilter(Integer.parseInt(passMax))};
            etPassword.setFilters(filters);
            etPasswordOnce.setFilters(filters);
            ps1 = passMin + "-" + passMax + "位";
            etPassword.setHint("请填写密码(" + ps1 + ")");
            etPasswordOnce.setHint("请再次填写密码(" + ps1 + ")");
        }

        //注册密码强度
        if (passLimit.equals("0")) {   //无限制
            etPassword.setHint("请填写密码(" + ps1 + ")");
            etPasswordOnce.setHint("请再次填写密码(" + ps1 + ")");
        } else if (passLimit.equals("1")) {  //数字 字母
            String digits = "1234567890QWERTYUIOPLKJHGFDSAZXCVBNMqwertyuioplkjhgfdsazxcvbnm";
            etPassword.setKeyListener(DigitsKeyListener.getInstance(digits));
            etPasswordOnce.setKeyListener(DigitsKeyListener.getInstance(digits));
            etPassword.setInputType(InputType.TYPE_TEXT_VARIATION_PASSWORD);
            etPasswordOnce.setInputType(InputType.TYPE_TEXT_VARIATION_PASSWORD);
            etPassword.setHint("请填写密码(" + ps1 + "数字加字母组合)");
            etPasswordOnce.setHint("请再次填写密码(" + ps1 + "数字加字母组合)");
        } else if (passLimit.equals("2")) {   //数字字母符号
            EditTextUtil.mEditText(etPassword);
            EditTextUtil.mEditText(etPasswordOnce);
            etPassword.setHint("请填写密码(" + ps1 + "数字、字母、符号组合)");
            etPasswordOnce.setHint("请再次填写密码(" + ps1 + "数字、字母、符号组合)");
        }
    }


    private void configShow(RelativeLayout rl, String show, EditText et) {
        if (show.equals("0")) {
            rl.setVisibility(View.GONE);
        } else if (show.equals("1")) {
            if(BuildConfig.FLAVOR.equals("c085")){
                et.setHint(et.getHint() + "(如没有可不填写)");
            }else {
                et.setHint(et.getHint() + "(选填)");
            }
        } else if (show.equals("2")) {

        }
    }

    private void configShow1(RelativeLayout rl, String show, EditText et) {
        if (show.equals("0")) {
            rl.setVisibility(View.GONE);
        } else if (show.equals("1")) {
            et.setHint(et.getHint() + "");
        } else if (show.equals("2")) {

        }
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

    @OnClick({R.id.bt_login, R.id.bt_regedit, R.id.bt_gotohome,R.id.bt_online_service,
            R.id.bt_phone_code, R.id.rl_img, R.id.tv_agency, R.id.tv_user, R.id.tv_login})
    public void onViewClicked(View view) {
        switch (view.getId()) {
            case R.id.bt_login:
                try {
                    checkParamet();
                } catch (UnsupportedEncodingException e) {
                    e.printStackTrace();
                } catch (NoSuchAlgorithmException e) {
                    e.printStackTrace();
                }catch (Exception e) {
                    e.printStackTrace();
                }
                break;
            case R.id.bt_regedit:
//                startActivity(new Intent(this, LoginActivity.class));
//                Uiutils.login(getContext());
//                regActivity. finish();
                break;
            case R.id.bt_gotohome:
                startActivity(new Intent(getContext(), MainActivity.class));
                regActivity.finish();
                break;
            case R.id.bt_online_service:
                String  zxkfurl = SPConstants.getValue(getContext(), SPConstants.SP_ZXKFURL);
                if (!TextUtils.isEmpty(zxkfurl)) {
                    Uiutils.goWebView(getContext(), zxkfurl.startsWith("http") ? zxkfurl : "http://" + zxkfurl
                            , "在线客服");

                } else {
                    ToastUtils.ToastUtils("客服地址未配置或获取失败", getContext());
                }
                break;
            case R.id.bt_phone_code:
                getPhoneCode();
                break;
            case R.id.rl_img:
                getImgCode();
                break;
            case R.id.tv_agency:
                isAgency = true;
                tvAgency.setBackgroundResource(R.drawable.reg_backgroup_blue);
                tvUser.setBackgroundResource(R.drawable.reg_backgroup_gray);
                tvUser.setTextColor(getResources().getColor(R.color.colorAccent));
                tvAgency.setTextColor(getResources().getColor(R.color.white));
                break;
            case R.id.tv_user:
                isAgency = false;
                tvAgency.setBackgroundResource(R.drawable.reg_backgroup_gray1);
                tvUser.setBackgroundResource(R.drawable.reg_backgroup_blue1);

                tvAgency.setTextColor(getResources().getColor(R.color.colorAccent));
                tvUser.setTextColor(getResources().getColor(R.color.white));
                break;
            case R.id.tv_login:
                Uiutils.login(getContext());
                regActivity. finish();
                break;
        }
    }

    Handler handler = new Handler();
    Runnable runnable = new Runnable() {
        @Override
        public void run() {
            btPhoneCode.setEnabled(true);
            btPhoneCode.setBackgroundResource(R.drawable.bt_backgroup1);

        }
    };


    private void getPhoneCode() {
        String mPhone = etPhone.getText().toString().trim();
        if (mPhone == null || mPhone.length() == 0) {
            ToastUtils.ToastUtils(getResources().getString(R.string.input_phone), getContext());
            return;
        } else if (mPhone.length() < 11) {
            ToastUtils.ToastUtils(getResources().getString(R.string.input_phone), getContext());
            return;
        }
        if (!isMatcherFinded("^1([358][0-9]|4[579]|66|7[0135678]|9[89])[0-9]{8}$", mPhone)) {
            ToastUtils.ToastUtils(getResources().getString(R.string.errorphone), getContext());
            return;
        }

        OkGo.<String>post(URLDecoder.decode(Constants.BaseUrl()+Constants.PHONECODE))//
                .tag(getContext())//
                .params("phone", SecretUtils.DESede(mPhone))//
                .params("sign", SecretUtils.RsaToken())//
                .execute(new NetDialogCallBack(getContext(), true, getContext(),
                        true, BaseBean.class) {
                    @Override
                    public void onUi(Object o) throws IOException {
                        BaseBean bb = (BaseBean) o;
                        if (bb != null && bb.getCode() == 0) {
                            time.start();
                            btPhoneCode.setEnabled(false);
//                        btPhoneCode.setBackgroundResource(R.drawable.backgroup_off);
                            btPhoneCode.setBackgroundColor(Color.parseColor("#f4f4f4"));
                            handler.postDelayed(runnable, 1000 * 60);
                            ToastUtils.ToastUtils("发送成功", getContext());
                        } else {
                            ToastUtils.ToastUtils("发送失败", getContext());
                        }

                    }

                    @Override
                    public void onErr(BaseBean bb) throws IOException {

                    }

                    @Override
                    public void onFailed(Response<String> response) {

                    }
                });
    }


    private void getImgCode() {
        OkGo.<String>get(Constants.BaseUrl()+Constants.IMGCODE+SecretUtils.DESede("523t2H6Jt1BT6ARh2y526JR6")+"&sign="+SecretUtils.RsaToken()).tag(this).execute(new StringCallback() {
            @Override
            public void onSuccess(Response<String> response) {
                if (response != null && response.body() != null) {
                    String base64DataStr = response.body() + "";
                    String base64Str = base64DataStr.substring(base64DataStr.indexOf(",") + 1, base64DataStr.length());
                    ivImg.setImageBitmap(base64ToBitmap(base64Str ));
                }
            }
        });
    }

    public static Bitmap base64ToBitmap(String base64Data) {
        byte[] bytes = new byte[0];
        try {
            bytes = Base64.decode(base64Data, Base64.DEFAULT);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return BitmapFactory.decodeByteArray(bytes, 0, bytes.length);
    }

    private boolean checkParamet() throws UnsupportedEncodingException, NoSuchAlgorithmException {

        int passLength;
        int passLengthSmaill;
        String md5pwd = null;
        String mEtAgent = etAgent.getText().toString().trim();
        String mEtUser = etUser.getText().toString().trim();
        String mEtPassword = etPassword.getText().toString().trim();
        String mEtPasswordOnce = etPasswordOnce.getText().toString().trim();
        String mEtName = etName.getText().toString().trim();
        String mEtPayPwd = etPayPwd.getText().toString().trim();
        String mEtQq = etQq.getText().toString().trim();
        String mEtWx = etWx.getText().toString().trim();
        String mEtPhone = etPhone.getText().toString().trim();
        String mEtCode = etCode.getText().toString().trim();   //图形验证码
        String mEmail = etEmail.getText().toString().trim();
        String phoneCode = etPcode.getText().toString().trim();//手机验证码

        //配置文件   0隐藏 1 选填  2 必填
        if (reco.equals("2") && (mEtAgent == null || mEtAgent.length() == 0)) {
            ToastUtils.ToastUtils(getResources().getString(R.string.agent_id3), getContext());
            return false;
        }

        if (mEtUser == null || mEtUser.length() == 0) {
            ToastUtils.ToastUtils(getResources().getString(R.string.inputuser9), getContext());
            return false;
        } else if (mEtUser.length() < 6) {
            ToastUtils.ToastUtils(getResources().getString(R.string.inputuser9), getContext());
            return false;
        }
//        else if (!isMatcherFinded(RegexConstants.ACCOUNT_REGEX, mEtUser)) {
//            ToastUtils.ToastUtils(getResources().getString(R.string.inputuser3), RegeditActivity.this);
//            return false;
//        }

        passLength = ShowItem.isNumeric(passMax) ? Integer.parseInt(passMax) : 16;
        passLengthSmaill = ShowItem.isNumeric(passMin) ? Integer.parseInt(passMin) : 6;

        if (mEtPassword == null || mEtPassword.length() == 0) {
            if (passLimit.equals("0")) {
                ToastUtils.ToastUtils(getResources().getString(R.string.inputpwdlength) + passLengthSmaill + "位-" + passLength + "位", getContext());
                return false;
            } else if (passLimit.equals("1")) {
                ToastUtils.ToastUtils(getResources().getString(R.string.inputpwdlength) + passLengthSmaill + "位-" + passLength + getResources().getString(R.string.inputpwdlength1), getContext());
                return false;
            } else if (passLimit.equals("2")) {
                ToastUtils.ToastUtils(getResources().getString(R.string.inputpwdlength) + passLengthSmaill + "位-" + passLength + getResources().getString(R.string.inputpwdlength1) + getResources().getString(R.string.inputpwdlength2), getContext());
                return false;
            }
        } else if (mEtPassword.length() < passLengthSmaill) {
            if (passLimit.equals("0")) {
                ToastUtils.ToastUtils(getResources().getString(R.string.inputpwdlength) + passLengthSmaill + "位-" + passLength + "位", getContext());
                return false;
            } else if (passLimit.equals("1")) {
                ToastUtils.ToastUtils(getResources().getString(R.string.inputpwdlength) + passLengthSmaill + "位-" + passLength + getResources().getString(R.string.inputpwdlength1), getContext());
                return false;
            } else if (passLimit.equals("2")) {
                ToastUtils.ToastUtils(getResources().getString(R.string.inputpwdlength) + passLengthSmaill + "位-" + passLength + getResources().getString(R.string.inputpwdlength1) + getResources().getString(R.string.inputpwdlength2), getContext());
                return false;
            }
        } else if (passLimit.equals("1") && !isMatcherFinded(RegexConstants.ACCOUNT_REGEX, mEtPassword)) {
            ToastUtils.ToastUtils(getResources().getString(R.string.inputpwdlength) + passLengthSmaill + "位-" + passLength + getResources().getString(R.string.inputpwdlength1), getContext());
            return false;
        } else if (passLimit.equals("2") && !isMatcherFinded(RegexConstants.REGEX, mEtPassword)) {
            ToastUtils.ToastUtils(getResources().getString(R.string.inputpwdlength) + passLengthSmaill + "位-" + passLength + getResources().getString(R.string.inputpwdlength4), getContext());
            return false;
//            }
        }

        if (mEtPasswordOnce == null || mEtPasswordOnce.length() == 0) {
            if (passLimit.equals("0")) {
                ToastUtils.ToastUtils(getResources().getString(R.string.inputpwdlength3) + getResources().getString(R.string.inputpwdlength) + passLengthSmaill + "位-" + passLength + "位", getContext());
                return false;
            } else if (passLimit.equals("1")) {
                ToastUtils.ToastUtils(getResources().getString(R.string.inputpwdlength3) + getResources().getString(R.string.inputpwdlength) + passLengthSmaill + "位-" + passLength + getResources().getString(R.string.inputpwdlength1), getContext());
                return false;
            } else if (passLimit.equals("2")) {
                ToastUtils.ToastUtils(getResources().getString(R.string.inputpwdlength3) + getResources().getString(R.string.inputpwdlength) + passLengthSmaill + "位-" + passLength + getResources().getString(R.string.inputpwdlength1) + getResources().getString(R.string.inputpwdlength2), getContext());
                return false;
            }
        } else if (mEtPasswordOnce.length() < passLengthSmaill) {
            if (passLimit.equals("0")) {
                ToastUtils.ToastUtils(getResources().getString(R.string.inputpwdlength3) + getResources().getString(R.string.inputpwdlength) + passLengthSmaill + "位-" + passLength + "位", getContext());
                return false;
            } else if (passLimit.equals("1")) {
                ToastUtils.ToastUtils(getResources().getString(R.string.inputpwdlength3) + getResources().getString(R.string.inputpwdlength) + passLengthSmaill + "位-" + passLength + getResources().getString(R.string.inputpwdlength1), getContext());
                return false;
            } else if (passLimit.equals("2")) {
                ToastUtils.ToastUtils(getResources().getString(R.string.inputpwdlength3) + getResources().getString(R.string.inputpwdlength) + passLengthSmaill + "位-" + passLength + getResources().getString(R.string.inputpwdlength1) + getResources().getString(R.string.inputpwdlength2), getContext());
                return false;
            }
        } else if (passLimit.equals("1") && !isMatcherFinded(RegexConstants.ACCOUNT_REGEX, mEtPasswordOnce)) {
            ToastUtils.ToastUtils(getResources().getString(R.string.inputpwdlength3) + getResources().getString(R.string.inputpwdlength) + passLengthSmaill + "位-" + passLength +
                    getResources().getString(R.string.inputpwdlength1), getContext());
            return false;
        } else if (passLimit.equals("2") && !isMatcherFinded(RegexConstants.REGEX, mEtPasswordOnce)) {
            ToastUtils.ToastUtils(getResources().getString(R.string.inputpwdlength3) + getResources().getString(R.string.inputpwdlength) + passLengthSmaill + "位-" + passLength +
                    getResources().getString(R.string.inputpwdlength1) + getResources().getString(R.string.inputpwdlength2), getContext());
            return false;
        }

        if (!mEtPassword.equals(mEtPasswordOnce)) {
            ToastUtils.ToastUtils(getResources().getString(R.string.inputpwd6), getContext());
            return false;
        }

        if (name.equals("2") && (mEtName == null || mEtName.length() == 0)) {
            ToastUtils.ToastUtils(getResources().getString(R.string.input_name), getContext());
            return false;
        } else if ((name.equals("2") || (name.equals("1") && mEtName.length() != 0)) && mEtName.length() < 2) {
            ToastUtils.ToastUtils(getResources().getString(R.string.input_name_lenght), getContext());
            return false;
        }

        if (fundpwd.equals("2") && (mEtPayPwd == null || mEtPayPwd.length() == 0)) {
            ToastUtils.ToastUtils(getResources().getString(R.string.input_pay_pwd), getContext());
            return false;
        } else if ((fundpwd.equals("2") || (fundpwd.equals("1") && mEtPayPwd.length() != 0)) && mEtPayPwd.length() < 4) {
            ToastUtils.ToastUtils(getResources().getString(R.string.input_pay_pwd), getContext());
            return false;
        }

        if (qq.equals("2") && (mEtQq == null || mEtQq.length() == 0)) {
            ToastUtils.ToastUtils(getResources().getString(R.string.input_QQ), getContext());
            return false;
        }

        if (wx.equals("2") && (mEtWx == null || mEtWx.length() == 0)) {
            ToastUtils.ToastUtils(getResources().getString(R.string.input_wx), getContext());
            return false;
        }

        if (phone.equals("2") && (mEtPhone == null || mEtPhone.length() == 0)) {
            ToastUtils.ToastUtils(getResources().getString(R.string.input_phone), getContext());
            return false;
        } else if ((phone.equals("2") || (phone.equals("1")) && mEtPhone.length() != 0) && mEtPhone.length() < 11) {
            ToastUtils.ToastUtils(getResources().getString(R.string.input_phone), getContext());
            return false;
        } else if ((phone.equals("2") || (phone.equals("1")) && mEtPhone.length() != 0) && (!isMatcherFinded("^1([358][0-9]|4[579]|66|7[0135678]|9[89])[0-9]{8}$", mEtPhone))) {
            ToastUtils.ToastUtils(getResources().getString(R.string.errorphone), getContext());
            return false;
        }

        if (email.equals("2") && (mEmail == null || mEmail.length() == 0)) {
            ToastUtils.ToastUtils(getResources().getString(R.string.input_email), getContext());
            return false;
        } else if ((email.equals("2") || (email.equals("1") && mEmail.length() != 0)) && !isEmail(mEmail)) {
            ToastUtils.ToastUtils(getResources().getString(R.string.security_emailerr), getContext());
            return false;
        }


        if (phoCode.equals("1") && (phoneCode == null || phoneCode.length() == 0)) {
            ToastUtils.ToastUtils(getResources().getString(R.string.input_phone_code), getContext());
            return false;
        } else if (phoCode.equals("1") && phoneCode.length() < 6) {
            ToastUtils.ToastUtils(getResources().getString(R.string.input_phone_code_lenght), getContext());
            return false;
        }


        if ((vCode.equals("1") || vCode.equals("3")) && (mEtCode == null || mEtCode.length() == 0)) {
            ToastUtils.ToastUtils(getResources().getString(R.string.input_code), getContext());
            return false;
        } else if ((vCode.equals("1") || vCode.equals("3")) && mEtCode.length() < 4) {
            ToastUtils.ToastUtils(getResources().getString(R.string.input_code), getContext());
            return false;
        }

        if (gameWebView.getVisibility() == View.VISIBLE) {
            if (nc_sid.equals("") || nc_token.equals("") || nc_sig.equals("")) {
                ToastUtils.ToastUtils(getResources().getString(R.string.verify_err), getContext());
                return false;
            }
        }

        RegeditQuestBean qb = new RegeditQuestBean();
        qb.setDevice(SecretUtils.DESede(DEVICE));

        if (!TextUtils.isEmpty(mEtAgent))
            qb.setInviter(SecretUtils.DESede(mEtAgent));

        if (!TextUtils.isEmpty(mEtUser))
            qb.setUsr(SecretUtils.DESede(mEtUser));

        if (!TextUtils.isEmpty(mEtPassword))
            qb.setPwd(SecretUtils.DESedePassw(mEtPassword));

        if (!TextUtils.isEmpty(mEtName))
            qb.setFullName(SecretUtils.DESede(mEtName));

        if (!TextUtils.isEmpty(mEtPayPwd))
            qb.setFundPwd(SecretUtils.DESedePassw(mEtPayPwd));

        if (!TextUtils.isEmpty(mEtWx))
            qb.setWx(SecretUtils.DESede(mEtWx));

        if (!TextUtils.isEmpty(mEtQq))
            qb.setQq(SecretUtils.DESede(mEtQq));

        if (!TextUtils.isEmpty(mEtPhone))
            qb.setPhone(SecretUtils.DESede(mEtPhone));

        if (!TextUtils.isEmpty(mEmail))
            qb.setEmail(SecretUtils.DESede(mEmail));

        if (!TextUtils.isEmpty(mEtCode))
            qb.setImgCode(SecretUtils.DESede(mEtCode));

        if (!TextUtils.isEmpty(phoneCode))
            qb.setSmsCode(SecretUtils.DESede(phoneCode));

        if (!TextUtils.isEmpty(mEtCode))
            qb.setAccessToken(SecretUtils.DESede(RegexConstants.IMGCODE));
        if (!nc_token.equals("") && !nc_sig.equals("") && !nc_sid.equals("")) {
            RegeditQuestBean.SlideCode sc = new RegeditQuestBean.SlideCode();
            sc.setNc_token(SecretUtils.DESede(nc_token));
            sc.setNc_sig(SecretUtils.DESede(nc_sig));
            sc.setNc_sid(SecretUtils.DESede(nc_sid));
            qb.setSlideCode(sc);
        }

        if (Constants.ENCRYPT)
            qb.setSign(SecretUtils.RsaToken());
        qb.setRegType(SecretUtils.DESede(isAgency ? "agent" : "user"));
        Gson gson = new Gson();
        String json = gson.toJson(qb);
        RequestBody body = RequestBody.create(Constants.JSON, json);
        OkGo.<String>post(URLDecoder.decode(Constants.BaseUrl()+Constants.USERREGEDIT + (Constants.ENCRYPT ? Constants.SIGN : "")))//
                .tag(this)//
                .upRequestBody(body)
                .execute(new NetDialogCallBack(getContext(), true, getContext(),
                        true, RegeditBean.class) {
                    @Override
                    public void onUi(Object o) throws IOException {
                        RegeditBean rb = (RegeditBean) o;
                        if (rb != null && rb.getCode() == 0) {
                            SharedPreferences.Editor edit = sp.edit();
                            edit.putString("password", Md5.convertMD5(mEtPassword));
                            edit.putString("username", mEtUser);
                            edit.putString(SPConstants.SP_USERTYPE, "user");   //是否guest
                            edit.commit();
                            if (rb.getData().isAutoLogin()) {
                                questLogin(mEtUser, mEtPassword);
                            } else {
                                ToastUtils.ToastUtils("注册成功", getContext());
//                                startActivity(new Intent(RegeditActivity.this, LoginActivity.class));
                                Uiutils.login(getContext());
                            }
                        } else if (rb != null && rb.getCode() != 0 && rb.getMsg() != null) {
                            ToastUtils.ToastUtils(rb.getMsg(), getContext());
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
                        if (bb != null && bb.getCode() == 1 && bb.getMsg() != null) {
                            if (bb.getMsg().equals("验证码不正确!")) {
                                getImgCode();
                            }
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


    //    注册来源：0:未知, 1:PC, 2:原生安卓, 3:原生IOS, 4:安卓H5, 5:IOSH5, 6:豪华版安卓, 7:豪华版IOS
    private void questLogin(String mEtUser, String pw) throws UnsupportedEncodingException {
        OkGo.<String>post(URLDecoder.decode(Constants.BaseUrl()+Constants.USERLOGIN + (Constants.ENCRYPT ? Constants.SIGN : "")))//
                .tag(this)//
                .params("usr", SecretUtils.DESede(mEtUser))//
                .params("pwd", SecretUtils.DESedePassw(pw))//
                .params("sign", SecretUtils.RsaToken())//
                .execute(new NetDialogCallBack(getContext(), true, this,
                        true, LoginInfo.class) {
                    @Override
                    public void onUi(Object o) throws IOException {
                        LoginInfo li = (LoginInfo) o;
                        if (li != null && li.getCode() == 0) {
                            SharedPreferences.Editor edit = sp.edit();
                            edit.putString(SPConstants.SP_PASSWORD, Md5.convertMD5(pw));
                            edit.putString(SPConstants.SP_USERNAME, mEtUser);
                            edit.putString(SPConstants.SP_API_SID, li.getData().getAPISID());
                            edit.putString(SPConstants.SP_API_TOKEN, li.getData().getAPITOKEN());
                            edit.putString(SPConstants.SP_USR, li.getData().getName());//名字
                            edit.putString(SPConstants.SP_REBATE, li.getData().getRebate());
                            edit.putString(SPConstants.SP_USERTYPE, "user");   //是否guest
                            edit.commit();
                            if (loginTo != null && loginTo.equals("0")) {
                                EventBus.getDefault().postSticky(new MessageEvent("login_my"));
                            } else {
                                EventBus.getDefault().postSticky(new MessageEvent("login"));
                            }
                            Intent intent = new Intent(mApp, MyIntentService.class);
                            intent.putExtra("type", "3000");
                            getActivity().startService(intent);

                            startActivity(new Intent(getContext(), MainActivity.class));
                        } else if (li != null && li.getCode() != 0 && li.getMsg() != null) {
                            ToastUtils.ToastUtils(li.getMsg(), getContext());
                        }
                    }

                    @Override
                    public void onErr(BaseBean bb) throws IOException {

                    }

                    @Override
                    public void onFailed(Response<String> response) {

                    }
                });

    }


    public static boolean isMatcherFinded(String patternStr, CharSequence input) {
        Pattern pattern = Pattern.compile(patternStr);
        Matcher matcher = pattern.matcher(input);
        if (matcher.find()) {
            return true;
        }
        return false;
    }

    public static boolean isEmail(String email) {
        if (null == email || "".equals(email)) return false;
        //Pattern p = Pattern.compile("\\w+@(\\w+.)+[a-z]{2,3}"); //简单匹配
        Pattern p = Pattern.compile("\\w+([-+.]\\w+)*@\\w+([-.]\\w+)*\\.\\w+([-.]\\w+)*");//复杂匹配
        Matcher m = p.matcher(email);
        return m.matches();
    }


    //配置文件   0隐藏 1 选填  2必填
    private void getConfig() {
        OkGo.<String>get(URLDecoder.decode(Constants.BaseUrl()+Constants.CONFIG)).tag(this).execute(new NetDialogCallBack(getContext(), true, this,
                true, ConfigBean.class) {
            @Override
            public void onUi(Object o) throws IOException {
                ConfigBean config = (ConfigBean) o;
                if (config != null && config.getCode() == 0 && config.getData() != null) {
                    ShareUtils.saveObject(getContext(), SPConstants.CONFIGBEAN, config);
                    SharedPreferences.Editor edit = sp.edit();
                    edit.putString("zxkfUrl", config.getData().getZxkfUrl());   //在线客服
                    edit.commit();
                    EventBus.getDefault().postSticky(new MessageEvent("config"));
                    SPConstants.setListValue(config.getData().getApiHosts());
                    try {
                        showItem(config);
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                }
            }

            @Override
            public void onErr(BaseBean bb) throws IOException {

            }

            @Override
            public void onFailed(Response<String> response) {

            }
        });

    }

    @Override
    public void onResume() {
        super.onResume();
        gameWebView.onResume();
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
        handler.removeCallbacks(runnable);
        super.onDestroy();
    }

    @Override
    public void onActivityResult(int requestCode, int resultCode, Intent intent) {
        super.onActivityResult(requestCode, resultCode, intent);
        gameWebView.onActivityResult(requestCode, resultCode, intent);
    }

    @SuppressLint({"JavascriptInterface", "ClickableViewAccessibility"})
    private void setWebView() {
//        gameWebView.setWebChromeClient(new WebChromeClient(){
//            @Override
//            public void onReceivedTitle(WebView view, String title) {
//                super.onReceivedTitle(view, title);
//                // android 6.0 以下通过title获取判断
//                if (Build.VERSION.SDK_INT < Build.VERSION_CODES.M) {
//                    if (title.contains("404") || title.contains("500")
//                            || title.contains("Error") || title.contains("找不到网页")
//                            || title.contains("网页无法打开")) {
//                        view.loadUrl("about:blank");// 避免出现默认的错误界面
//                        view.reload();
//                    }
//                }
//            }
//        });
        gameWebView.setWebViewClient(new WebViewClient() {
            @Override
            public boolean shouldOverrideUrlLoading(WebView view, String url) {
                view.loadUrl(url);
                return true;
            }

            @Override
            public void onPageStarted(WebView view, String url, Bitmap favicon) {
                super.onPageStarted(view, url, favicon);
                pbarWeb.setVisibility(View.VISIBLE);
            }

//            @Override
//            public void onReceivedHttpError(WebView view, WebResourceRequest request, WebResourceResponse errorResponse) {
//                super.onReceivedHttpError(view, request, errorResponse);
//                if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.LOLLIPOP) {
//                    int statusCode = errorResponse.getStatusCode();
//                    if (404 == statusCode || 500 == statusCode) {
//                        view.loadUrl("about:blank");// 避免出现默认的错误界面
//                        view.reload();
//                    }
//                }
//            }
//
//            @Override
//            public void onReceivedError(WebView view, WebResourceRequest request, WebResourceError error) {
//                super.onReceivedError(view, request, error);
//                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
//                    if (request.isForMainFrame()) {//是否是为 main frame创建
//                        view.loadUrl("about:blank");// 避免出现默认的错误界面
//                        view.reload();
//                    }
//                }
//            }

            @Override
            public void onPageFinished(WebView view, String url) {
                ViewGroup.LayoutParams params = gameWebView.getLayoutParams();
//                params.width = Tools.getWidthInPx(getActivity());
                params.height = Uiutils.dipToPx(getContext(), 80);
                gameWebView.setLayoutParams(params);
                pbarWeb.setVisibility(View.GONE);
            }

        });
        final SimpleRegeditFrament.JavaScriptInterface myJavaScriptInterface
                = new SimpleRegeditFrament.JavaScriptInterface(getActivity());
        gameWebView.getSettings().setLightTouchEnabled(true);
        gameWebView.getSettings().setJavaScriptEnabled(true);
        gameWebView.getSettings().setUseWideViewPort(true);
        gameWebView.addJavascriptInterface(myJavaScriptInterface, "postSwiperData");
        gameWebView.loadUrl(Constants.BaseUrl()+Constants.SLIDECODE);
        Log.e("urlxx",""+Constants.BaseUrl()+Constants.SLIDECODE);
        gameWebView.setOnTouchListener(new View.OnTouchListener() {
            @Override
            public boolean onTouch(View v, MotionEvent ev) {
                ((WebView) v).requestDisallowInterceptTouchEvent(true);
                return false;
            }
        });
    }

    public class JavaScriptInterface {
        Context mContext;

        JavaScriptInterface(Context c) {
            mContext = c;
        }

        @JavascriptInterface
        public void jsCallWebView(String webMessage) {
            try {
                if (webMessage != null || !webMessage.equals("undefined")) {
                    VerifyBean vb = new Gson().fromJson(webMessage, VerifyBean.class);
                    if (vb.getNc_value() != null && vb.getNc_token() != null && vb.getNc_csessionid() != null && vb.getNc_sig() != null) {
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
}
