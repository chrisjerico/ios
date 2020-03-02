package com.phoenix.lotterys.my.fragment.recommend;

import android.content.ClipboardManager;
import android.content.Context;
import android.graphics.Bitmap;
import android.view.View;
import android.widget.CompoundButton;
import android.widget.ImageView;
import android.widget.Switch;
import android.widget.TextView;

import com.phoenix.lotterys.R;import com.phoenix.lotterys.R2;
import com.phoenix.lotterys.application.BaseFragments;
import com.phoenix.lotterys.main.bean.ConfigBean;
import com.phoenix.lotterys.my.bean.RecommendBean;
import com.phoenix.lotterys.my.bean.UserInfo;
import com.phoenix.lotterys.util.Constants;
import com.phoenix.lotterys.util.GsonUtil;
import com.phoenix.lotterys.util.NetUtils;
import com.phoenix.lotterys.util.SPConstants;
import com.phoenix.lotterys.util.ShareUtils;
import com.phoenix.lotterys.util.Uiutils;
import com.phoenix.lotterys.util.ZXingUtils;
import com.wanxiangdai.commonlibrary.util.MeasureUtil;
import com.wanxiangdai.commonlibrary.util.StringUtils;
import com.wanxiangdai.commonlibrary.util.ToastUtil;

import java.util.HashMap;
import java.util.Map;

import butterknife.BindView;

import static com.phoenix.lotterys.util.ShowItem.subZeroAndDot;

/**
 * 文件描述:推荐信息
 * 创建者: IAN
 * 创建时间: 2019/8/22 21:32
 */

/*
* 弃用   20191007
* */
public class RecommendInformationFrag extends BaseFragments implements View.OnClickListener, CompoundButton.OnCheckedChangeListener {

    @BindView(R2.id.my_name_tex)
    TextView myNameTex;
    @BindView(R2.id.my_id_tex)
    TextView myIdTex;
    @BindView(R2.id.recommend_img)
    ImageView recommendImg;
    @BindView(R2.id.commission_rate_tex)
    TextView commissionRateTex;
    @BindView(R2.id.money_tex)
    TextView moneyTex;
    @BindView(R2.id.recommended_members_tex)
    TextView recommendedMembersTex;
    @BindView(R2.id.recommended_members_tex1)
    TextView recommendedMembersTex1;
    @BindView(R2.id.tv_sample)
    TextView tvSample;
    public RecommendInformationFrag() {
        super(R.layout.recommend_information_frag, true, true);
    }


    private UserInfo userInfo;

    @Override
    public void initView(View view) {
        userInfo = (UserInfo) ShareUtils.getObject(getContext(), SPConstants.USERINFO, UserInfo.class);

        if (null != userInfo && null != userInfo.getData()) {
            myNameTex.setText(userInfo.getData().getUsr());
            myIdTex.setText(userInfo.getData().getUid());
        }
        setView(view);

        ConfigBean configBean = (ConfigBean) ShareUtils.getObject(getContext(), SPConstants.CONFIGBEAN, ConfigBean.class);
        if (null!=configBean&&null!=configBean.getData()&& !StringUtils.isEmpty(configBean.getData()
        .getMyreco_img())&&StringUtils.equals("1",configBean.getData()
                .getMyreco_img()))
            recommendImg.setVisibility(View.GONE);

        getData();
    }
    private View recommendAdaView1;
    private TextView recommendAdaView1CopylinkTex;
    private TextView recommendAdaView1Url;
    private Switch recommendAdaView1SwitchV;
    private ImageView recommendAdaView1qrCodeImg;

    private View recommendAdaView2;
    private TextView recommendAdaView2CopylinkTex;
    private TextView recommendAdaView2Url;
    private Switch recommendAdaView2SwitchV;
    private ImageView recommendAdaView2qrCodeImg;

    private void setView (View view){
        recommendAdaView1 =view.findViewById(R.id.recommend_ada_view1);
        recommendAdaView1CopylinkTex =recommendAdaView1.findViewById(R.id.copylink_tex);
        recommendAdaView1CopylinkTex.setTag(recommendAdaView1);
        recommendAdaView1CopylinkTex.setOnClickListener(this);
        recommendAdaView1Url =recommendAdaView1.findViewById(R.id.url);
        recommendAdaView1SwitchV =recommendAdaView1.findViewById(R.id.switch_v);
        recommendAdaView1SwitchV.setTag(recommendAdaView1);
        recommendAdaView1SwitchV.setOnCheckedChangeListener(this);
        recommendAdaView1qrCodeImg =recommendAdaView1.findViewById(R.id.qr_code_img);

        recommendAdaView2 =view.findViewById(R.id.recommend_ada_view2);
        ((TextView)recommendAdaView2.findViewById(R.id.subpage_name_tex)).setText("注册推荐地址");
        recommendAdaView2CopylinkTex =recommendAdaView2.findViewById(R.id.copylink_tex);
        recommendAdaView2CopylinkTex.setTag(recommendAdaView2);
        recommendAdaView2CopylinkTex.setOnClickListener(this);
        recommendAdaView2Url =recommendAdaView2.findViewById(R.id.url);
        recommendAdaView2SwitchV =recommendAdaView2.findViewById(R.id.switch_v);
        recommendAdaView2SwitchV.setTag(recommendAdaView2);
        recommendAdaView2SwitchV.setOnCheckedChangeListener(this);
        recommendAdaView2qrCodeImg =recommendAdaView2.findViewById(R.id.qr_code_img);

    }

    private void getData() {
        Map<String, Object> map = new HashMap<>();
        map.put("token", Uiutils.getToken(getContext()));

        NetUtils.get(Constants.INVITEINFO ,map, true, getContext(),
                new NetUtils.NetCallBack() {
                    @Override
                    public void onSuccess(String object) {

                        recommendBean = GsonUtil.fromJson(object, RecommendBean.class);

                        if (null!=recommendBean&&null!=recommendBean.getData()) {

                            setDa();
                        }
                    }

                    @Override
                    public void onError() {

                    }
                });
    }

    private void setDa() {
        recommendAdaView1Url.setText(recommendBean.getData().getLink_i());
        recommendAdaView2Url.setText(recommendBean.getData().getLink_r());
        String fd = subZeroAndDot(recommendBean.getData().getFanDian());
        String result = "="+(1000*Double.parseDouble(fd)/100)+"元";
        tvSample.setText("您推荐的会员在下注结算后,佣金会自动按照比例加到您的资金账户上。例如:您所推荐的会员下注1000元,您的收益=1000元*"+fd+"%"+result);
        Bitmap bitmap = ZXingUtils.createQRImage(recommendBean.getData().getLink_i(),
                MeasureUtil.dip2px(getContext(), 200),
                MeasureUtil.dip2px(getContext(), 200), null);
        recommendAdaView1qrCodeImg.setImageBitmap(bitmap);


        Bitmap bitmap1 = ZXingUtils.createQRImage(recommendBean.getData().getLink_r(),
                MeasureUtil.dip2px(getContext(), 200),
                MeasureUtil.dip2px(getContext(), 200), null);
        recommendAdaView2qrCodeImg.setImageBitmap(bitmap1);

        commissionRateTex.setText(recommendBean.getData().getFandian_intro());
        recommendedMembersTex.setText(recommendBean.getData().getMonth_member());
        recommendedMembersTex1.setText(recommendBean.getData().getTotal_member());
        moneyTex.setText(recommendBean.getData().getMonth_earn());
    }
    private RecommendBean recommendBean;

    @Override
    public void onClick(View v) {
        switch (v.getId()){
            case R.id.copylink_tex:
                ClipboardManager cmb = (ClipboardManager) getContext().getSystemService(Context.CLIPBOARD_SERVICE);
                if (v.getTag()==recommendAdaView1){
                    cmb.setText(recommendAdaView1Url.getText());
                }else
                    if (v.getTag()==recommendAdaView2){
                    cmb.setText(recommendAdaView2Url.getText());
                }
                ToastUtil.toastShortShow(getContext(), "复制成功");
                break;
        }
    }

    @Override
    public void onCheckedChanged(CompoundButton buttonView, boolean isChecked) {
        if (buttonView==recommendAdaView1SwitchV){
            if (isChecked) {
                recommendAdaView1qrCodeImg.setVisibility(View.VISIBLE);
          } else {
                recommendAdaView1qrCodeImg.setVisibility(View.GONE);
           }
        }else{
                if (isChecked) {
                    recommendAdaView2qrCodeImg.setVisibility(View.VISIBLE);
             } else {
                    recommendAdaView2qrCodeImg.setVisibility(View.GONE);
                }
        }
    }
}
