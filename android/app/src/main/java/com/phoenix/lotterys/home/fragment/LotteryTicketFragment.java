package com.phoenix.lotterys.home.fragment;


import android.annotation.SuppressLint;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.graphics.Color;
import androidx.recyclerview.widget.GridLayoutManager;
import androidx.recyclerview.widget.RecyclerView;
import android.view.View;

import com.google.gson.Gson;
import com.lzy.okgo.OkGo;
import com.lzy.okgo.model.Response;
import com.phoenix.lotterys.R;import com.phoenix.lotterys.R2;
import com.phoenix.lotterys.buyhall.activity.TicketDetailsActivity;
import com.phoenix.lotterys.buyhall.bean.LotteryBuyBean;
import com.phoenix.lotterys.buyhall.bean.TicketDetails;
import com.phoenix.lotterys.helper.OpenHelper;
import com.phoenix.lotterys.home.adapter.LotteryticketAdapter;
import com.phoenix.lotterys.home.bean.RecommendBean;
import com.phoenix.lotterys.main.MainActivity;
import com.phoenix.lotterys.util.Constants;
import com.phoenix.lotterys.util.DialogCallBack;
import com.phoenix.lotterys.util.GsonUtil;
import com.phoenix.lotterys.util.SPConstants;
import com.phoenix.lotterys.util.ShareUtils;
import com.phoenix.lotterys.util.Uiutils;
import com.phoenix.lotterys.view.SignViewPager;
import com.wanxiangdai.commonlibrary.base.BaseFragment;
import com.wanxiangdai.commonlibrary.util.DividerGridItemDecoration;

import java.net.URLDecoder;
import java.util.List;

import butterknife.BindView;

/**
 * 彩票.
 */
@SuppressLint("ValidFragment")
public class LotteryTicketFragment extends BaseFragment {

    @BindView(R2.id.rv_ticket)
    RecyclerView rvTicket;
    LotteryticketAdapter lotteryticketAdapter;
    SignViewPager signViewPager;
    MainActivity mActivity;
    private LotteryBuyBean mlott;
    SharedPreferences sp;
    List<RecommendBean> lottery;
    public void setSignViewPager(SignViewPager signViewPager) {
        this.signViewPager = signViewPager;
    }

    public LotteryTicketFragment(List<RecommendBean> lottery) {
        super(R.layout.fragment_lottery_ticket);
        this.lottery = lottery;
    }

    @Override
    public void initView(View view) {
        mActivity = (MainActivity) getActivity();
        sp = getContext().getSharedPreferences(SPConstants.SP_User, Context.MODE_PRIVATE);
        if (signViewPager != null)
            signViewPager.setObjectForPosition(view, 0);
      initRecyclerView();
    }
    private void initRecyclerView() {
        if(lottery==null){
            return;
        }
//        lotteryticketAdapter = new LotteryticketAdapter(lottery, getActivity());
        rvTicket.setAdapter(lotteryticketAdapter);
        rvTicket.setLayoutManager(new GridLayoutManager(getActivity(), 3));
        rvTicket.addItemDecoration(new DividerGridItemDecoration(getActivity(),
                DividerGridItemDecoration.BOTH_SET, 20, Color.rgb(255, 255, 255)));
        lotteryticketAdapter.setListener(new LotteryticketAdapter.OnClickListener() {
            @Override
            public void onClickListener(View view, int position) {
                String token  = sp.getString(SPConstants.SP_API_SID, SPConstants.SP_NULL);
                if (!token.equals(SPConstants.SP_NULL)) {
                    Intent intent = new Intent(getContext(), TicketDetailsActivity.class);
                    TicketDetails td = new TicketDetails();
                    td.setGameId(lottery.get(position).getId());
                    td.setTitle(lottery.get(position).getTitle());
                    td.setGameType(lottery.get(position).getGameType());
                    ShareUtils.putString(getContext(),"isInstant",lottery.get(position).getIsInstant());
                    Gson gson = new Gson();
                    String ticketDetails = gson.toJson(td);
                    intent.putExtra("ticketDetails", ticketDetails);
                    OpenHelper.startActivity(getContext(), intent);
//                    mSelect(position);
                }else {
//                    startActivity(new Intent(getContext(), LoginActivity.class));
                    Uiutils.login(getContext());
                }
            }
        });
    }

    private void mSelect(int position) {
        switch (position) {
            case 0:
                skipActivity(2,3);
                break;
            case 1:
                skipActivity(1,1);
                break;
            case 2:
                skipActivity(1,2);
                break;
            case 3:
                skipActivity(0,0);
                break;
            case 4:
                skipActivity(2,2);
                break;
            case 5:
                skipActivity(4,0);
                break;
            case 6:
                skipActivity(3,0);
                break;
            case 7:
                skipActivity(2,5);
                break;
            case 8:
                skipActivity(2,6);
                break;
            case 9:
                skipActivity(2,4);
                break;

            default:

        }
    }

    private void skipActivity(int position,int pos) {
//        try {
//            mlott = Constants.getmLotteryBuyBean();
//            Intent intent = new Intent(getContext(), TicketDetailsActivity.class);
//            TicketDetails td = new TicketDetails();
//            td.setTitle(mlott.getData().get(position).getList().get(pos).getTitle());
//            td.setPreNum(mlott.getData().get(position).getList().get(pos).getPreNum());
//            td.setLotteryTime(mlott.getData().get(position).getList().get(pos).getCurOpenTime());
//            td.setPreLotteryTime(mlott.getData().get(position).getList().get(pos).getPreOpenTime());
//            td.setEndtime(mlott.getData().get(position).getList().get(pos).getCurCloseTime());
//            td.setGameId(mlott.getData().get(position).getList().get(pos).getId());
//
//            ShareUtils.putString(getContext(),"isInstant",
//                    mlott.getData().get(position).getList().get(pos).getIsInstant());
//            Gson gson = new Gson();
//            String ticketDetails = gson.toJson(td);
//            intent.putExtra("ticketDetails", ticketDetails);
//            OpenHelper.startActivity(getContext(), intent);
//        }catch (Exception e){
//            e.printStackTrace();
//        }
    }

    private void getLotteryBuy(int position) {
        OkGo.<String>get(URLDecoder.decode(Constants.BaseUrl()+Constants.LOTTERYBUY))//
                .tag(this)//
                .execute(new DialogCallBack(getContext(), false, LotteryTicketFragment.this,
                        true) {
                    @Override
                    public void onSuccess(Response<String> response) {
                        super.onSuccess(response);
                        if (response.code() == 200) {
                            LotteryBuyBean lotteryBuyBean = GsonUtil.fromJson(response.body(), LotteryBuyBean.class);
                            if (lotteryBuyBean != null && lotteryBuyBean.getCode() == 0) {
//                                Constants.setmLotteryBuyBean(lotteryBuyBean);
                                mSelect(position);
                            }
                        }
                    }

                    @Override
                    public void onFinish() {
                        super.onFinish();
                    }
                });
    }
}
