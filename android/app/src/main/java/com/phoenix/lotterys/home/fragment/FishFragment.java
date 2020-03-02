package com.phoenix.lotterys.home.fragment;

import android.annotation.SuppressLint;
import android.content.Intent;
import android.graphics.Color;
import androidx.recyclerview.widget.GridLayoutManager;
import androidx.recyclerview.widget.RecyclerView;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.EditText;

import com.lzy.okgo.OkGo;
import com.lzy.okgo.model.Response;
import com.phoenix.lotterys.R;import com.phoenix.lotterys.R2;
import com.phoenix.lotterys.home.activity.ElectronicActivity;
import com.phoenix.lotterys.home.adapter.LotteryticketAdapter;
import com.phoenix.lotterys.home.bean.GameUrlBean;
import com.phoenix.lotterys.home.bean.RecommendBean;
import com.phoenix.lotterys.my.bean.BaseBean;
import com.phoenix.lotterys.util.Constants;
import com.phoenix.lotterys.util.NetDialogCallBack;
import com.phoenix.lotterys.util.SPConstants;
import com.phoenix.lotterys.util.SecretUtils;
import com.phoenix.lotterys.util.Uiutils;
import com.phoenix.lotterys.view.SignViewPager;
import com.phoenix.lotterys.view.tddialog.TDialog;
import com.wanxiangdai.commonlibrary.base.BaseFragment;
import com.wanxiangdai.commonlibrary.util.DividerGridItemDecoration;

import java.io.IOException;
import java.net.URLDecoder;
import java.util.List;

import butterknife.BindView;

/**
 * 捕鱼
 */

/*
 * 使用新的界面代替可删除
 * */
@SuppressLint("ValidFragment")
public class FishFragment extends BaseFragment {
    @BindView(R2.id.rv_ticket)
    RecyclerView rvTicket;
    LotteryticketAdapter lotteryticketAdapter;
    SignViewPager signViewPager;
    List<RecommendBean> fish;
    public void setSignViewPager(SignViewPager signViewPager) {
        this.signViewPager = signViewPager;
    }

    public FishFragment(List<RecommendBean> fish) {
        super(R.layout.fragment_lottery_ticket);
        this.fish = fish;
    }

    @Override
    public void initView(View view) {
        if (signViewPager != null)
            signViewPager.setObjectForPosition(view, 5);
        initRecyclerView();
    }

    private void initRecyclerView() {
        if(fish==null){
            return;
        }
//        lotteryticketAdapter = new LotteryticketAdapter(fish, getActivity());
        rvTicket.setAdapter(lotteryticketAdapter);
        rvTicket.setLayoutManager(new GridLayoutManager(getActivity(), 3));
        rvTicket.addItemDecoration(new DividerGridItemDecoration(getActivity(),
                DividerGridItemDecoration.BOTH_SET, 20, Color.rgb(255, 255, 255)));
        lotteryticketAdapter.setListener(new LotteryticketAdapter.OnClickListener() {
            @Override
            public void onClickListener(View view, int position) {
                if(fish.get(position).getIsPopup()==0){
                    String[] array = getContext().getResources().getStringArray(R.array.affirm_list);
                    String[] hint_list = getContext().getResources().getStringArray(R.array.hint_list);
                    View inflate = LayoutInflater.from(getContext()).inflate(R.layout.alertext_from, null);
                    final EditText et = (EditText) inflate.findViewById(R.id.from_et);
                    TDialog mTDialog = new TDialog(getActivity(), TDialog.Style.Center, array, hint_list[0],
                            hint_list[1]+ fish.get(position).getTitle()+
                                    hint_list[2],""
                            , new TDialog.onItemClickListener() {
                        @Override
                        public void onItemClick(Object object, int pos) {
                            goGame(position);
                        }
                    });
                    mTDialog.setMsgGravity(Gravity.CENTER);
                    mTDialog.setMsgPaddingLeft(10, 5, 10, 0);
                    mTDialog.setItemTextColorAt(0, getResources().getColor(R.color.textColor_alert_button_cancel));
                    mTDialog.addView(inflate);
                    mTDialog.setItemVisibility();
                    mTDialog.show();
                }else if(fish.get(position).getIsPopup()==1){
                    Intent intent=new Intent();
                    intent.putExtra("id",fish.get(position).getId());
                    intent.putExtra("name",fish.get(position).getCategory());
                    intent.putExtra("title",fish.get(position).getTitle());
                    intent.setClass(getContext(), ElectronicActivity.class);
                    startActivity(intent);
                }
            }
        });
    }



    private static String UrlModel = "id=%s&token=%s";
    private void goGame(int position) {
        String token = SPConstants.getValue(getContext(), SPConstants.SP_API_SID);
        if(token.equals("Null")){
//            startActivity(new Intent(getContext(), LoginActivity.class));
            Uiutils.login(getContext());
            return;
        }


        OkGo.<String>get(URLDecoder.decode(Constants.BaseUrl()+Constants.GOTOGAMEREAL +String.format(UrlModel, SecretUtils.DESede(fish.get(position).getId()),SecretUtils.DESede(token))+"&sign="+SecretUtils.RsaToken()))//
                .tag(this)//
                .execute(new NetDialogCallBack(getContext(), true, getContext(),
                        true, GameUrlBean.class) {
                    @Override
                    public void onUi(Object o) throws IOException {
                        GameUrlBean url = (GameUrlBean)o;
                        if(url!=null&&url.getCode()==0){
//                            Intent intent = new Intent(getActivity(), WebActivity.class);
////                            intent.putExtra("url", "http://test10.6yc.com/mobile/real/goToGame/42/1");
//                            Log.e("okurl",""+Constants.BaseUrl+Constants.PATH+url.getData());
//                            intent.putExtra("url", Constants.BaseUrl+Constants.PATH+url.getData());
//                            startActivity(intent);

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
}
