package com.phoenix.lotterys.home.fragment;

import android.content.ClipboardManager;
import android.content.Context;
import android.content.SharedPreferences;
import android.content.res.AssetManager;
import android.graphics.drawable.ColorDrawable;
import androidx.recyclerview.widget.GridLayoutManager;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;
import android.text.Editable;
import android.text.TextWatcher;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.PopupWindow;
import android.widget.RadioButton;
import android.widget.RadioGroup;
import android.widget.TextView;

import com.example.zhouwei.library.CustomPopWindow;
import com.phoenix.lotterys.R;import com.phoenix.lotterys.R2;
import com.phoenix.lotterys.application.BaseFragments;
import com.phoenix.lotterys.main.FragmentUtilAct;
import com.phoenix.lotterys.main.MainActivity;
import com.phoenix.lotterys.main.bean.ConfigBean;
import com.phoenix.lotterys.my.adapter.AddedCityAdapter;
import com.phoenix.lotterys.my.adapter.CityPopAdapter;
import com.phoenix.lotterys.my.bean.AddedCityBean;
import com.phoenix.lotterys.my.bean.CityBeans;
import com.phoenix.lotterys.my.bean.My_item;
import com.phoenix.lotterys.my.bean.QRCodeBean;
import com.phoenix.lotterys.util.Constants;
import com.phoenix.lotterys.util.GsonUtil;
import com.phoenix.lotterys.util.Md5;
import com.phoenix.lotterys.util.NetUtils;
import com.phoenix.lotterys.util.SPConstants;
import com.phoenix.lotterys.util.ShareUtils;
import com.phoenix.lotterys.util.SpacesItemDecoration;
import com.phoenix.lotterys.util.Uiutils;
import com.phoenix.lotterys.util.recyclerUtil.BaseRecyclerAdapter;
import com.phoenix.lotterys.view.CustomTitleBar;
import com.wanxiangdai.commonlibrary.util.EvenBusUtil.Even;
import com.wanxiangdai.commonlibrary.util.EvenBusUtil.EvenBusCode;
import com.wanxiangdai.commonlibrary.util.ImageLoadUtil;
import com.wanxiangdai.commonlibrary.util.MeasureUtil;
import com.wanxiangdai.commonlibrary.util.StringUtils;
import com.wanxiangdai.commonlibrary.util.ToastUtil;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.security.NoSuchAlgorithmException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import butterknife.BindView;
import butterknife.OnClick;

/**
 * 文件描述: 安全中心
 * 创建者: IAN
 * 创建时间: 2019/7/4 12:39
 */
public class SenseCentersFrag extends BaseFragments implements BaseRecyclerAdapter.
        OnItemClickListener, View.OnFocusChangeListener, View.OnClickListener {

    @BindView(R2.id.titlebar)
    CustomTitleBar titlebar;
    @BindView(R2.id.login_password_lin)
    LinearLayout loginPasswordLin;
    @BindView(R2.id.withdrawal_password_lin)
    LinearLayout withdrawalPasswordLin;
    @BindView(R2.id.login_password_radio)
    RadioButton loginPasswordRadio;
    @BindView(R2.id.withdrawal_password_radio)
    RadioButton withdrawalPasswordRadio;
    @BindView(R2.id.main_radio)
    RadioGroup mainRadio;
    @BindView(R2.id.common_login_sites_radio)
    RadioButton commonLoginSitesRadio;
    @BindView(R2.id.common_login_sites_lin)
    LinearLayout commonLoginSitesLin;
    @BindView(R2.id.country_tex)
    TextView countryTex;
    @BindView(R2.id.country_img)
    ImageView countryImg;
    @BindView(R2.id.country_lin)
    LinearLayout countryLin;
    @BindView(R2.id.province_tex)
    TextView provinceTex;
    @BindView(R2.id.province_img)
    ImageView provinceImg;
    @BindView(R2.id.province_lin)
    LinearLayout provinceLin;
    @BindView(R2.id.city_tex)
    TextView cityTex;
    @BindView(R2.id.city_img)
    ImageView cityImg;
    @BindView(R2.id.city_lin)
    LinearLayout cityLin;
    @BindView(R2.id.original_password_edit)
    EditText originalPasswordEdit;
    @BindView(R2.id.original_password_tex)
    TextView originalPasswordTex;
    @BindView(R2.id.new_password_edit)
    EditText newPasswordEdit;
    @BindView(R2.id.new_password_tex)
    TextView newPasswordTex;
    @BindView(R2.id.confirm_new_password_edit)
    EditText confirmNewPasswordEdit;
    @BindView(R2.id.confirm_new_password_tex)
    TextView confirmNewPasswordTex;
    @BindView(R2.id.new_password_but)
    Button newPasswordBut;
    @BindView(R2.id.old_withdrawal_password_edit)
    EditText oldWithdrawalPasswordEdit;
    @BindView(R2.id.old_withdrawal_password_tex)
    TextView oldWithdrawalPasswordTex;
    @BindView(R2.id.new_withdrawal_password_edit)
    EditText newWithdrawalPasswordEdit;
    @BindView(R2.id.new_withdrawal_password_tex)
    TextView newWithdrawalPasswordTex;
    @BindView(R2.id.new_withdrawal_password_num_tex)
    TextView newWithdrawalPasswordNumTex;
    @BindView(R2.id.confirm_withdrawal_password_edit)
    EditText confirmWithdrawalPasswordEdit;
    @BindView(R2.id.confirm_withdrawal_password_tex)
    TextView confirmWithdrawalPasswordTex;
    @BindView(R2.id.confirm_withdrawal_password_num_tex)
    TextView confirmWithdrawalPasswordNumTex;
    @BindView(R2.id.commit_withdrawal_password_but)
    Button commitWithdrawalPasswordBut;

    @BindView(R2.id.added_lin)
    LinearLayout addedLin;
    @BindView(R2.id.added_rec)
    RecyclerView addedRec;
    @BindView(R2.id.added_city_commit_but)
    Button addedCityCommitBut;
    @BindView(R2.id.secondary_validation_radio)
    RadioButton secondaryValidationRadio;
    @BindView(R2.id.download_app_tex)
    TextView downloadAppTex;
    @BindView(R2.id.next_tex)
    TextView nextTex;
    @BindView(R2.id.secondary_validation_lin)
    LinearLayout secondaryValidationLin;
    @BindView(R2.id.qr_code_img)
    ImageView qrCodeImg;
    @BindView(R2.id.secret_key_tex)
    TextView secretKeyTex;
    @BindView(R2.id.copy_tex)
    TextView copyTex;
    @BindView(R2.id.go_back_tex)
    TextView goBackTex;
    @BindView(R2.id.is_binding_tex)
    TextView isBindingTex;
    @BindView(R2.id.google_binding_lin)
    LinearLayout googleBindingLin;
    @BindView(R2.id.verification_edit)
    EditText verificationEdit;
    @BindView(R2.id.verification_lin)
    LinearLayout verificationLin;
    @BindView(R2.id.verification_go_back_tex)
    TextView verificationGoBackTex;
    @BindView(R2.id.verification_ok_tex)
    TextView verificationOkTex;
    @BindView(R2.id.unbundle_tex)
    TextView unbundleTex;
    @BindView(R2.id.unbundle_lin)
    LinearLayout unbundleLin;

    private CityBeans cityBeans;

    private PopupWindow tipsPop;

    private CustomPopWindow mCustomPopWindow;
    private View contentView;

    private int index;
    private RecyclerView popRec;
    private CityPopAdapter adapter;

    private AddedCityAdapter addedCityAdapter;
    private List<AddedCityBean.DataBean> addedList = new ArrayList<>();
    private AddedCityBean.DataBean addedCityBean = new AddedCityBean.DataBean();

    private List<My_item> list = new ArrayList<>();
    private List<My_item> list1 = new ArrayList<>();  //国
    private List<My_item> list2 = new ArrayList<>();   //省
    private List<My_item> list3 = new ArrayList<>();   //市

    private View countryView;
    private View provinceView;
    private View cityView;
    MainActivity activity;
    public SenseCentersFrag() {
        super(R.layout.safety_center_frag, true, true);
    }

    private View contentViewNnbundle;
    private ConfigBean configBean;
    @Override
    public void initView(View view) {
//        activity = (MainActivity)getActivity();
//        activity.isFramentType(true);
        getConfig();

        newPasswordTex.setText(Uiutils.getPassHin(getActivity()));
        confirmNewPasswordTex.setText(Uiutils.getPassHin(getActivity()));

        countryView = view.findViewById(R.id.country_view);
        provinceView = view.findViewById(R.id.province_view);
        cityView = view.findViewById(R.id.city_view);

        titlebar.setText(getContext().getResources().getString(R.string.safety_center));
        titlebar.setLeftIconOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
//                startActivity(new Intent(getContext(), MainActivity.class));
            }
        });
        titlebar.setRIghtTvVisibility(0x00000008);
//        Uiutils.setBarStye(titlebar, getActivity());
        initJsonData();
        setLosterner();
        mainRadio.setOnCheckedChangeListener(new RadioGroup.OnCheckedChangeListener() {
            @Override
            public void onCheckedChanged(RadioGroup group, int checkedId) {
                switch (checkedId) {
                    case R.id.login_password_radio:
                        loginPasswordLin.setVisibility(View.VISIBLE);
                        withdrawalPasswordLin.setVisibility(View.GONE);
                        commonLoginSitesLin.setVisibility(View.GONE);
                        secondaryValidationLin.setVisibility(View.GONE);

                        oldWithdrawalPasswordEdit.setText("");
                        newWithdrawalPasswordEdit.setText("");
                        confirmWithdrawalPasswordEdit.setText("");
                        if (list3 != null && list3.size() != 0 && list1 != null && list1.size() != 0 && list2 != null && list2.size() != 0) {
                            countryTex.setText(list3.get(0).getTitle());
                            addedCityBean.setCountry("0");
                            provinceTex.setText(list1.get(0).getTitle());
                            addedCityBean.setProvince(list1.get(0).getTitle());
                            cityTex.setText("北京");
                            addedCityBean.setCity("北京");
                        }
                        break;
                    case R.id.withdrawal_password_radio:
                        loginPasswordLin.setVisibility(View.GONE);
                        withdrawalPasswordLin.setVisibility(View.VISIBLE);
                        commonLoginSitesLin.setVisibility(View.GONE);
                        secondaryValidationLin.setVisibility(View.GONE);
                        originalPasswordEdit.setText("");
                        newPasswordEdit.setText("");
                        confirmNewPasswordEdit.setText("");
                        if (list3 != null && list3.size() != 0 && list1 != null && list1.size() != 0 && list2 != null && list2.size() != 0) {
                            countryTex.setText(list3.get(0).getTitle());
                            addedCityBean.setCountry("0");
                            provinceTex.setText(list1.get(0).getTitle());
                            addedCityBean.setProvince(list1.get(0).getTitle());
                            cityTex.setText("北京");
                            addedCityBean.setCity("北京");
                        }
                        break;
                    case R.id.common_login_sites_radio:
                        setTopsPop();
                        loginPasswordLin.setVisibility(View.GONE);
                        withdrawalPasswordLin.setVisibility(View.GONE);
                        secondaryValidationLin.setVisibility(View.GONE);
                        commonLoginSitesLin.setVisibility(View.VISIBLE);

                        originalPasswordEdit.setText("");
                        newPasswordEdit.setText("");
                        confirmNewPasswordEdit.setText("");

                        oldWithdrawalPasswordEdit.setText("");
                        newWithdrawalPasswordEdit.setText("");
                        confirmWithdrawalPasswordEdit.setText("");
                        break;
                    case R.id.secondary_validation_radio:
                        loginPasswordLin.setVisibility(View.GONE);
                        withdrawalPasswordLin.setVisibility(View.GONE);
                        commonLoginSitesLin.setVisibility(View.GONE);
                        if (isBind) {
                            unbundleLin.setVisibility(View.VISIBLE);

                        } else {
                            secondaryValidationLin.setVisibility(View.VISIBLE);
                        }
                        break;
                }
            }
        });

        addedRec.setLayoutManager(new GridLayoutManager(getActivity(), 2,
                GridLayoutManager.VERTICAL, false));

        addedCityAdapter = new AddedCityAdapter(getContext(), addedList, R.layout.added_city_adapter);
        addedRec.setAdapter(addedCityAdapter);
        repuestData();

        getQRCode(4, "");
        titlebar.setIvBackHide(View.GONE);


        setThemeColor();
    }

    private void getConfig() {
        NetUtils.get(Constants.CONFIG,"", false, getContext(), new NetUtils.NetCallBack() {
            @Override
            public void onSuccess(String object) {
                configBean =Uiutils.stringToObject(object,ConfigBean.class);

                if (null!=configBean){
                    ShareUtils.saveObject(getContext(), SPConstants.CONFIGBEAN, configBean);

                    if (null!=configBean&&null!=configBean.getData()&&!StringUtils.isEmpty(configBean.getData()
                            .getOftenLoginArea())&&StringUtils.equals("0",configBean.getData()
                            .getOftenLoginArea()))
                        commonLoginSitesRadio.setVisibility(View.VISIBLE);

                    if (null!=configBean&&null!=configBean.getData()&&configBean.getData()
                            .getGoogleVerifier())
                        secondaryValidationRadio.setVisibility(View.VISIBLE);
                }

            }

            @Override
            public void onError() {

            }
        });
    }

    private EditText qrCodeEdit;
    private void showPopMenuUnbundle() {
        contentViewNnbundle = LayoutInflater.from(getContext()).inflate(R.layout.unbundle_layout, null);

        contentViewNnbundle.findViewById(R.id.unbundle_close_tex).setOnClickListener(this);
        contentViewNnbundle.findViewById(R.id.unbundle_commit_tex).setOnClickListener(this);
        qrCodeEdit=(EditText)contentViewNnbundle.findViewById(R.id.qr_code_edit);

        popupWindowBuilder = Uiutils.setPopSetting(getContext(), contentViewNnbundle,
                MeasureUtil.dip2px(getContext(), 300), ViewGroup.LayoutParams.WRAP_CONTENT,
                true, true, 0.5f);

        mCustomPopWindow = popupWindowBuilder.create();
        mCustomPopWindow.showAtLocation(contentViewNnbundle,Gravity.CENTER, 0, 0);
        Uiutils.setStateColor(getActivity());
    }


    private void repuestData() {
        Map<String, Object> map = new HashMap<>();
        map.put("token", Uiutils.getToken(getContext()));
        NetUtils.get(Constants.ADDRESS , map, true, getContext(),
                new NetUtils.NetCallBack() {
                    @Override
                    public void onSuccess(String object) {
                        if (!StringUtils.isEmpty(object)) {
                            AddedCityBean addedCityBean = GsonUtil.fromJson(object, AddedCityBean.class);

                            if (addedList.size() > 0)
                                addedList.clear();

                            if (null != addedCityBean && null != addedCityBean.getData() && addedCityBean.
                                    getData().size() > 0) {
                                addedList.addAll(addedCityBean.getData());
                            }

                            if (addedList.size() > 0) {
                                addedLin.setVisibility(View.VISIBLE);
                            } else {
                                addedLin.setVisibility(View.GONE);
                            }

                            if (addedList.size() == 3) {
                                addedCityCommitBut.setVisibility(View.GONE);
                            } else {
                                addedCityCommitBut.setVisibility(View.VISIBLE);
                            }
                        }
                        addedCityAdapter.notifyDataSetChanged();
                    }

                    @Override
                    public void onError() {

                    }
                });
    }

    private void setLosterner() {
        originalPasswordEdit.setOnFocusChangeListener(this);
        newPasswordEdit.setOnFocusChangeListener(this);
        confirmNewPasswordEdit.setOnFocusChangeListener(this);

        oldWithdrawalPasswordEdit.setOnFocusChangeListener(this);
        newWithdrawalPasswordEdit.setOnFocusChangeListener(this);
        confirmWithdrawalPasswordEdit.setOnFocusChangeListener(this);

        newWithdrawalPasswordEdit.addTextChangedListener(textWatcher);
        confirmWithdrawalPasswordEdit.addTextChangedListener(textWatcher1);
    }

    private TextWatcher textWatcher = new TextWatcher() {
        @Override
        public void beforeTextChanged(CharSequence s, int start, int count, int after) {
        }

        @Override
        public void onTextChanged(CharSequence s, int start, int before, int count) {
        }

        @Override
        public void afterTextChanged(Editable s) {
            if (StringUtils.isEmpty(newWithdrawalPasswordEdit.getText().toString())) {
                newWithdrawalPasswordNumTex.setText("0/4");
            } else {
                newWithdrawalPasswordNumTex.setText(newWithdrawalPasswordEdit.getText().toString()
                        .length() + "/4");
            }
        }
    };

    private void setType(int type) {

        switch (type) {
            case 1:
                countryImg.setSelected(true);
                countryView.setBackgroundColor(getContext().getResources().getColor(R.color.title_backgroup));

                provinceImg.setSelected(false);
                provinceView.setBackgroundColor(getContext().getResources().getColor(R.color.my_line));

                cityImg.setSelected(false);
                cityView.setBackgroundColor(getContext().getResources().getColor(R.color.my_line));
                break;
            case 2:
                provinceImg.setSelected(true);
                provinceView.setBackgroundColor(getContext().getResources().getColor(R.color.title_backgroup));

                countryImg.setSelected(false);
                countryView.setBackgroundColor(getContext().getResources().getColor(R.color.my_line));

                cityImg.setSelected(false);
                cityView.setBackgroundColor(getContext().getResources().getColor(R.color.my_line));
                break;

            case 3:
                cityImg.setSelected(true);
                cityView.setBackgroundColor(getContext().getResources().getColor(R.color.title_backgroup));

                provinceImg.setSelected(false);
                provinceView.setBackgroundColor(getContext().getResources().getColor(R.color.my_line));

                countryImg.setSelected(false);
                countryView.setBackgroundColor(getContext().getResources().getColor(R.color.my_line));
                break;

        }
    }


    private TextWatcher textWatcher1 = new TextWatcher() {
        @Override
        public void beforeTextChanged(CharSequence s, int start, int count, int after) {
        }

        @Override
        public void onTextChanged(CharSequence s, int start, int before, int count) {
        }

        @Override
        public void afterTextChanged(Editable s) {
            if (StringUtils.isEmpty(confirmWithdrawalPasswordEdit.getText().toString())) {
                confirmWithdrawalPasswordNumTex.setText("0/4");
            } else {
                confirmWithdrawalPasswordNumTex.setText(confirmWithdrawalPasswordEdit.
                        getText().toString().length() + "/4");
            }
        }
    };

    private void setTopsPop() {
        View tipsView = LayoutInflater.from(getActivity()).inflate(R.layout.tips_pop,
                null);

        tipsView.findViewById(R.id.fdsfaaa).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (tipsPop.isShowing())
                    tipsPop.dismiss();
                Uiutils.setBgDarkAlpha(getActivity(), 1);
            }
        });

        tipsPop = new PopupWindow(tipsView, MeasureUtil.dip2px(getContext(), 300),
                ViewGroup.LayoutParams.WRAP_CONTENT);
        tipsPop.setBackgroundDrawable(new ColorDrawable());
        tipsPop.setFocusable(true);
        Uiutils.setBgDarkAlpha(getActivity(), 0.5f);
        tipsPop.setOnDismissListener(new PopupWindow.OnDismissListener() {
            @Override
            public void onDismiss() {
                if (tipsPop.isShowing())
                    tipsPop.dismiss();

                Uiutils.setBgDarkAlpha(getActivity(), 1);
            }
        });
        tipsPop.showAtLocation(tipsView, Gravity.CENTER, 0, 0);
        Uiutils.setStateColor(getActivity());
    }

    private void initJsonData() {
        //解析数据
        /**
         * 注意：assets 目录下的Json文件仅供参考，实际使用可自行替换文件
         * 关键逻辑在于循环体
         *
         * */
        String JsonData = getJson("city.json");//获取assets目录下的json文件数据

        if (!StringUtils.isEmpty(JsonData)) {
            cityBeans = GsonUtil.fromJson(JsonData, CityBeans.class);

            list3.add(new My_item(getContext().getResources()
                    .getString(R.string.china), true));
            list3.add(new My_item(getContext().getResources()
                    .getString(R.string.foreign_country), false));

            if (null != cityBeans && null != cityBeans.getData() && cityBeans.getData().size() > 0) {
                for (int i = 0; i < cityBeans.getData().size(); i++) {

                    if (i == 0) {
                        list1.add(new My_item(cityBeans.getData().get(i).getName(), true));

                        setCityData(i);

                    } else {
                        list1.add(new My_item(cityBeans.getData().get(i).getName(), false));
                    }
                }
            }

            if (list3.size() > 0)
                countryTex.setText(list3.get(0).getTitle());
            addedCityBean.setCountry("0");

            if (list1.size() > 0)
                provinceTex.setText(list1.get(0).getTitle());
            addedCityBean.setProvince(list1.get(0).getTitle());
        }
        showPopMenu();
    }

    /**
     * 从asset目录下读取fileName文件内容
     *
     * @param fileName 待读取asset下的文件名
     * @return 得到省市县的String
     */
    private String getJson(String fileName) {
        StringBuilder stringBuilder = new StringBuilder();
        try {
            AssetManager assetManager = getActivity().getAssets();
            BufferedReader bf = new BufferedReader(new InputStreamReader(
                    assetManager.open(fileName)));
            String line;
            while ((line = bf.readLine()) != null) {
                stringBuilder.append(line);
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
        return stringBuilder.toString();
    }

    private CustomPopWindow.PopupWindowBuilder popupWindowBuilder;

    private void showPopMenu() {
        contentView = LayoutInflater.from(getContext()).inflate(R.layout.city_pop, null);
        //处理popWindow c
        setPopView();
        //创建并显示popWindow
//        mCustomPopWindow = new CustomPopWindow.PopupWindowBuilder(getContext())
//                .setView(contentView)
//                .setBgDarkAlpha(0.7f) // 控制亮度
//                .create();

        popupWindowBuilder = Uiutils.setPopSetting(getContext(), contentView,
                MeasureUtil.dip2px(getContext(), 120), ViewGroup.LayoutParams.WRAP_CONTENT,
                true, false, 0.5f);


    }

    private void showPop(View view, List<My_item> currentList, int index) {
        popupWindowBuilder.enableBackgroundDark(true);
        mCustomPopWindow = popupWindowBuilder.create();
        this.index = index;
        if (null != mCustomPopWindow) {
            if (list.size() > 0)
                list.clear();

            if (null != currentList && currentList.size() > 0) {
                list.addAll(currentList);
            }
            adapter.notifyDataSetChanged();
        }

        mCustomPopWindow.showAsDropDown(view, 0, 0);
        Uiutils.setStateColor(getActivity());
    }

    private void setPopView() {
        if (null == contentView)
            return;

        popRec = contentView.findViewById(R.id.pop_rec);
        LinearLayoutManager linearLayoutManager = new LinearLayoutManager(getContext());
        popRec.setLayoutManager(linearLayoutManager);
        popRec.addItemDecoration(new SpacesItemDecoration(getContext(), 1));

        adapter = new CityPopAdapter(getContext(), list, R.layout.city_pop_adapter);
        popRec.setAdapter(adapter);
        adapter.setOnItemClickListener(this);
    }

    @OnClick({R.id.country_lin, R.id.province_lin, R.id.city_lin, R.id.new_password_but,
            R.id.commit_withdrawal_password_but, R.id.added_city_commit_but,
            R.id.download_app_tex, R.id.next_tex, R.id.copy_tex, R.id.go_back_tex, R.id.is_binding_tex
            , R.id.verification_go_back_tex, R.id.verification_ok_tex,R.id.stop_google_tex})
    public void onClick(View view) {
        switch (view.getId()) {
            case R.id.country_lin:   //国
                setType(1);
                scrollPosition(list3, countryTex.getText().toString().trim());
                showPop(countryLin, list3, 1);
                break;
            case R.id.province_lin:   //省
                setType(2);
                scrollPosition(list1, provinceTex.getText().toString().trim());
                showPop(provinceLin, list1, 2);
                break;
            case R.id.city_lin:   //市
                setType(3);
                scrollPosition(list2, cityTex.getText().toString().trim());
                showPop(cityLin, list2, 3);
                break;
            case R.id.new_password_but:  //密码提交
                if (StringUtils.isEmpty(originalPasswordEdit.getText().toString().trim()) ||
                        originalPasswordEdit.getText().toString().trim().length() < 6) {
                    setTs(originalPasswordTex);
                } else if (StringUtils.isEmpty(newPasswordEdit.getText().toString().trim()) ||
                        newPasswordEdit.getText().toString().trim().length() < 6) {
                    originalPasswordTex.setVisibility(View.GONE);
                    setTs(newPasswordTex);
                } else if (StringUtils.isEmpty(confirmNewPasswordEdit.getText().toString().trim()) ||
                        confirmNewPasswordEdit.getText().toString().trim().length() < 6 ||
                        !StringUtils.equals(newPasswordEdit.getText().toString().trim(),
                                confirmNewPasswordEdit.getText().toString().trim())) {

                    confirmNewPasswordTex.setText(getContext().getResources().getString(R.
                            string.inputpwd6));
                    setTs(confirmNewPasswordTex);
                    newPasswordTex.setTextColor(getContext().getResources().getColor(R.color.
                            textColor_downSheet_title));
                } else {
                    confirmNewPasswordTex.setText(R.string.inputpwd2);
                    confirmNewPasswordTex.setTextColor(getContext().getResources().getColor(R.color.
                            textColor_downSheet_title));
                    requestPass(Constants.CHANGELOGINPWD, originalPasswordEdit, confirmNewPasswordEdit);

                }
                break;

            case R.id.commit_withdrawal_password_but:  //密码提交
                if (StringUtils.isEmpty(oldWithdrawalPasswordEdit.getText().toString().trim()) ||
                        oldWithdrawalPasswordEdit.getText().toString().trim().length() < 4) {
                    setTs(oldWithdrawalPasswordTex);
                } else if (StringUtils.isEmpty(newWithdrawalPasswordEdit.getText().toString().trim()) ||
                        newWithdrawalPasswordEdit.getText().toString().trim().length() < 4) {
                    oldWithdrawalPasswordTex.setVisibility(View.GONE);
                    setTs(newWithdrawalPasswordTex);
                } else if (StringUtils.isEmpty(confirmWithdrawalPasswordEdit.getText().toString().trim())) {
                    confirmWithdrawalPasswordTex.setText(R.string.confirm_new_password);
                    setTs(confirmWithdrawalPasswordTex);
                    newWithdrawalPasswordTex.setVisibility(View.GONE);
                } else if (confirmWithdrawalPasswordEdit.getText().toString().trim().length() < 4 ||
                        !StringUtils.equals(confirmWithdrawalPasswordEdit.getText().toString().trim(),
                                newWithdrawalPasswordEdit.getText().toString().trim())) {
                    setTs(confirmWithdrawalPasswordTex);
                    confirmWithdrawalPasswordTex.setText(getContext().getResources().getString(
                            R.string.inputpwd6
                    ));
                    newWithdrawalPasswordTex.setVisibility(View.GONE);
                } else {
                    confirmWithdrawalPasswordTex.setVisibility(View.GONE);
                    requestPass(Constants.CHANGEFUNDPWD, oldWithdrawalPasswordEdit,
                            newWithdrawalPasswordEdit);
                }
                break;

            case R.id.added_city_commit_but:

                if (addedList.size() > 0) {
                    for (AddedCityBean.DataBean dataBean : addedList) {
                        if (StringUtils.equals(addedCityBean.getCity(), dataBean.getCity())) {
                            ToastUtil.toastShortShow(getContext(), getResources().getString(R.
                                    string.duplicate_login_locations));
                            return;
                        }
                    }
                }
                getData();
                break;
            case R.id.download_app_tex:
                if (isDown)
                    return;
//                EvenBusUtils.setEvenBus(new Even(EvenBusCode.GOOGLE_APK,apkUrl));
//                updata = new UpdataUtil(getActivity(), apkUrl, 1);
                downloadAppTex.setText("应用下载中,请稍等....");
                isDown=true;
                ((FragmentUtilAct)getActivity()).setDown(apkUrl);
                break;
            case R.id.next_tex:
                secondaryValidationLin.setVisibility(View.GONE);
                googleBindingLin.setVisibility(View.VISIBLE);
                getQRCode(1, "");
                break;
            case R.id.copy_tex:
                ClipboardManager cmb = (ClipboardManager) getActivity().getSystemService(Context.CLIPBOARD_SERVICE);
                cmb.setText(secretKeyTex.getText());
                ToastUtil.toastShortShow(getContext(), "复制成功");
                break;
            case R.id.go_back_tex:
                googleBindingLin.setVisibility(View.GONE);
                secondaryValidationLin.setVisibility(View.VISIBLE);
                break;
            case R.id.is_binding_tex:
                googleBindingLin.setVisibility(View.GONE);
                verificationLin.setVisibility(View.VISIBLE);
                break;
            case R.id.verification_go_back_tex:
                verificationLin.setVisibility(View.GONE);
                googleBindingLin.setVisibility(View.VISIBLE);
                break;
            case R.id.verification_ok_tex:
                if (!StringUtils.isEmpty(verificationEdit.getText().toString())) {
                    getQRCode(2, verificationEdit.getText().toString());
                } else {
                    ToastUtil.toastShortShow(getContext(), "请输入您的验证码");
                }
                break;
            case R.id.unbundle_close_tex:  //解绑取消
                mCustomPopWindow.dissmiss();
                Uiutils.setStateColor(getActivity());
                break;
            case R.id.unbundle_commit_tex:  //解绑提交
                if (!StringUtils.isEmpty(qrCodeEdit.getText().toString())) {
                    getQRCode(3, qrCodeEdit.getText().toString());
                } else {
                    ToastUtil.toastShortShow(getContext(), "请输入您的验证码");
                }
                break;
            case R.id.stop_google_tex:  //点击停用谷歌验证器
                showPopMenuUnbundle();
                break;
        }
    }
//    private UpdataUtil updata;
    private boolean isDown;
    private String apkUrl ="http://test19.6yc.com/lib/google_authenticator/google_android.apk";

    private QRCodeBean qrCodeBean;

    /**
     * 生成二维码
     */
    private void getQRCode(int type, String code) {
        Map<String, Object> map = new HashMap<>();
//        个人中心谷歌验证相关操作：(操作方法：gen:二维码生成, bind:绑定, unbind:解绑)
        switch (type) {
            case 1:
                map.put("action", "gen");
                break;
            case 2:
                map.put("action", "bind");
                map.put("code", code);
                break;
            case 3:
                map.put("action", "unbind");
                map.put("code", code);
                break;
            case 4:
                map.put("action", "gen");
                break;
        }
        map.put("token", Uiutils.getToken(getContext()));

        NetUtils.get(Constants.GACAPTCHA ,map, true, getContext(),
                new NetUtils.NetCallBack() {
                    @Override
                    public void onSuccess(String object) {
                        switch (type) {
                            case 1:
                                if (!StringUtils.isEmpty(object))
                                    qrCodeBean = Uiutils.stringToObject(object, QRCodeBean.class);

                                if (null != qrCodeBean && null != qrCodeBean.getData()) {
                                    if (!StringUtils.isEmpty(qrCodeBean.getData().getSecret()))
                                        secretKeyTex.setText(qrCodeBean.getData().getSecret());

                                    if (!StringUtils.isEmpty(qrCodeBean.getData().getQrcode())) {
//                                        Bitmap bitmap = ZXingUtils.createQRImage(qrCodeBean.getData().getQrcode(),
////                                                MeasureUtil.dip2px(getContext(), 120),
////                                                MeasureUtil.dip2px(getContext(), 120), null);
////                                        qrCodeImg.setImageBitmap(bitmap);

                                        ImageLoadUtil.ImageLoad(getContext(),qrCodeBean.getData().getQrcode(),
                                                qrCodeImg );
                                    }
                                }
                                break;

                            case 2:
                                ToastUtil.toastShortShow(getContext(), "绑定成功");
                                getActivity().finish();
                                break;
                            case 3:
                                ToastUtil.toastShortShow(getContext(), "解绑成功");
                                getActivity().finish();
                                break;
                            case 4:
                                if (!StringUtils.isEmpty(object))
                                    qrCodeBean = Uiutils.stringToObject(object, QRCodeBean.class);

                                if (null != qrCodeBean && null != qrCodeBean.getData() && !StringUtils.isEmpty(
                                        qrCodeBean.getData().getStatus())) {

                                    if (StringUtils.equals("gen", qrCodeBean.getData().getStatus()))
                                        isBind = false;

                                    if (StringUtils.equals("bind", qrCodeBean.getData().getStatus()))
                                        isBind = true;
                                }
                                break;
                        }
                    }

                    @Override
                    public void onError() {

                    }
                });


    }

    private boolean isBind;

    private void getData() {
        Map<String, Object> map = new HashMap<>();
        map.put("token", Uiutils.getToken(getContext()));

        if (null != addedCityBean && !StringUtils.isEmpty(addedCityBean.getCountry()) && StringUtils.equals("1",
                addedCityBean.getCountry())) {
            addedCityBean.setProvince("");
            addedCityBean.setCity("");
        }

        addedList.add(addedCityBean);

        List<Map<String,Object>> listmap =new ArrayList<>();
        if (null!=addedList&&addedList.size()>0){
            for (AddedCityBean.DataBean dataBean : addedList){
                Map<String,Object> map1 =new HashMap<>();
                map1.put("id",dataBean.getId());
                map1.put("country",dataBean.getCountry());
                map1.put("province",dataBean.getProvince());
                map1.put("city",dataBean.getCity());
                listmap.add(map1);
            }
        }

        map.put("address", listmap);
        NetUtils.post(Constants.CHANGEADDRESS, map, true, getContext(), new
                NetUtils.NetCallBack() {
                    @Override
                    public void onSuccess(String object) {
                        repuestData();
                    }

                    @Override
                    public void onError() {
                        if (addedList.size() > 0)
                            addedList.remove(addedList.size() - 1);
                    }
                });
    }

    /**
     * 改密码
     */
    private void requestPass(String url,
                             EditText oldedit, EditText newedit) {
        SharedPreferences sp = getContext().getSharedPreferences("User", Context.MODE_PRIVATE);
        String olkpwd = "";
        String newpwd = "";
        try {
            olkpwd = Md5.getMD5(oldedit.getText().toString().trim());
            newpwd = Md5.getMD5(newedit.getText().toString().trim());
        } catch (NoSuchAlgorithmException e) {
            e.printStackTrace();
        }

        Map<String,Object> httpParams = new HashMap<>();
        httpParams.put("old_pwd", olkpwd);
        httpParams.put("new_pwd", newpwd);
        httpParams.put("token", sp.getString("API-SID", "Null"));

        NetUtils.post(url, httpParams, false, getContext(),
                new NetUtils.NetCallBack() {
                    @Override
                    public void onSuccess(String object) {
                        Uiutils.pubFish(object, getActivity());
                    }

                    @Override
                    public void onError() {
                    }
                });
    }

    private void setTs(TextView textView) {
        textView.setVisibility(View.VISIBLE);
        textView.setTextColor(getContext().getResources().getColor(R.color.color_fe594b));
        ToastUtil.toastShortShow(getContext(), getContext().getResources().getString(R
                .string.complete_information_submit));
    }

    private void scrollPosition(List<My_item> list, String text) {
        if (!StringUtils.isEmpty(text)) {
            for (int i = 0; i < list.size(); i++) {
                if (StringUtils.equals(list.get(i).getTitle(),
                        text)) {
                    popRec.scrollToPosition(i);
                    break;
                }
            }
        }
    }

    @Override
    public void onItemClick(RecyclerView parent, View view, int position) {
        if (null != mCustomPopWindow) {
            mCustomPopWindow.dissmiss();
            Uiutils.setStateColor(getActivity());
        }
        switch (index) {
            case 1:
                countryTex.setText(list3.get(position).getTitle());
                setData(position, list3);

                if (position != 0) {
                    addedCityBean.setCountry("1");
                    provinceLin.setVisibility(View.INVISIBLE);
                    cityLin.setVisibility(View.INVISIBLE);
                } else {
                    addedCityBean.setCountry("0");
                    provinceLin.setVisibility(View.VISIBLE);
                    cityLin.setVisibility(View.VISIBLE);
                }
                break;
            case 2:
                provinceTex.setText(list1.get(position).getTitle());
                addedCityBean.setProvince(list1.get(position).getTitle());
                setData(position, list1);
                setCityData(position);

                break;
            case 3:
                cityTex.setText(list2.get(position).getTitle());
                addedCityBean.setCity(list1.get(position).getTitle());
                setData(position, list2);
                break;
        }
    }

    private void setCityData(int i) {
        if (list2.size() > 0)
            list2.clear();

        if (null != cityBeans.getData().get(i) && null != cityBeans.getData().get(i).
                getCity() && cityBeans.getData().get(i).
                getCity().size() > 0) {
            for (int j = 0; j < cityBeans.getData().get(i).
                    getCity().size(); j++) {
                if (j == 0) {
                    list2.add(new My_item(cityBeans.getData().get(i).
                            getCity().get(j).getName(), true));
                } else {
                    list2.add(new My_item(cityBeans.getData().get(i).
                            getCity().get(j).getName(), false));
                }
            }
        }

        if (list2.size() > 0)
            cityTex.setText(list2.get(0).getTitle());

        addedCityBean.setCity(list2.get(0).getTitle());
    }

    private void setData(int position, List<My_item> list) {
        for (int i = 0; i < list.size(); i++) {
            if (i == position) {
                list.get(i).setSelected(true);
            } else {
                list.get(i).setSelected(false);
            }
        }
    }

    @Override
    public void onFocusChange(View v, boolean hasFocus) {
        if (hasFocus)
            return;

        switch (v.getId()) {
            case R.id.original_password_edit:  //老密码
                passwordTis(originalPasswordEdit, originalPasswordTex, 6);
                break;
            case R.id.new_password_edit:    //新密码
                passwordTis(newPasswordEdit, newPasswordTex, 6);
                break;
            case R.id.confirm_new_password_edit:   //确认密码
                passwordTis(confirmNewPasswordEdit, confirmNewPasswordTex, 6);

                if (!StringUtils.equals(newPasswordEdit.getText().toString(),
                        confirmNewPasswordEdit.getText().toString())) {
                    confirmNewPasswordTex.setVisibility(View.VISIBLE);
                }
                break;

            case R.id.old_withdrawal_password_edit:   //老取款密码
                passwordTis(oldWithdrawalPasswordEdit, oldWithdrawalPasswordTex, 4);
                break;
            case R.id.new_withdrawal_password_edit:   //新取款密码
                passwordTis(newWithdrawalPasswordEdit, newWithdrawalPasswordTex, 4);
                break;
            case R.id.confirm_withdrawal_password_edit:   //确认取款密码
                passwordTis(confirmWithdrawalPasswordEdit, confirmWithdrawalPasswordTex, 4);
                break;
        }
    }

    private void passwordTis(EditText editText, TextView textView, int num) {
        if (StringUtils.isEmpty(editText.getText().toString())) {
            textView.setVisibility(View.VISIBLE);
        } else if (editText.getText().toString().length() < num) {
            textView.setVisibility(View.VISIBLE);
        } else {
//            textView.setVisibility(View.GONE);
        }
    }

    @Override
    public void getEvenMsg(Even even) {
        switch (even.getCode()) {
            case EvenBusCode.DELETECITIES:
                deleteCities((String) even.getData());
                break;
            case EvenBusCode.GOOGLE_APK_ok:
                downloadAppTex.setText("安卓手机点击下载");
                isDown=false;
                break;
            case EvenBusCode.CHANGE_THEME_STYLE_MYF:
                setThemeColor();
                break;
        }
    }

    private void setThemeColor() {
        Uiutils.setBaColor(getContext(),titlebar, false, null);
        Uiutils.setBaColor(getContext(),newPasswordBut, false, null);
        Uiutils.setBaColor(getContext(),commitWithdrawalPasswordBut, false, null);
        Uiutils.setBaColor(getContext(),addedCityCommitBut, false, null);
        Uiutils.setBaColor(getContext(),nextTex, false, null);
        Uiutils.setBaColor(getContext(),goBackTex, false, null);
        Uiutils.setBaColor(getContext(),isBindingTex, false, null);
        Uiutils.setBaColor(getContext(),verificationGoBackTex, false, null);
        Uiutils.setBaColor(getContext(),verificationOkTex, false, null);

        Uiutils.setBarStye0(titlebar,getContext());
    }

    private void deleteCities(String id) {
        Map<String, Object> map = new HashMap<>();
        map.put("token", Uiutils.getToken(getContext()));
        map.put("id", id);

        NetUtils.post(Constants.DELADDRESS, map, true, getContext(), new NetUtils.NetCallBack() {
            @Override
            public void onSuccess(String object) {
                repuestData();
            }

            @Override
            public void onError() {
            }
        });

    }

}
