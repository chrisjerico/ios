package com.phoenix.lotterys.home.fragment;


import android.annotation.SuppressLint;
import android.content.Context;
import android.content.SharedPreferences;
import android.graphics.Color;
import androidx.recyclerview.widget.GridLayoutManager;
import androidx.recyclerview.widget.RecyclerView;
import android.view.View;

import com.phoenix.lotterys.R;import com.phoenix.lotterys.R2;
import com.phoenix.lotterys.application.BaseFragments;
import com.phoenix.lotterys.home.adapter.LotteryticketAdapter;
import com.phoenix.lotterys.main.MainActivity;
import com.phoenix.lotterys.main.bean.GameTypeBean;
import com.phoenix.lotterys.util.SPConstants;
import com.phoenix.lotterys.util.Uiutils;
import com.phoenix.lotterys.view.SignViewPager;
import com.wanxiangdai.commonlibrary.util.DividerGridItemDecoration;

import butterknife.BindView;

/**
 * 彩票.
 */
@SuppressLint("ValidFragment")
public class GamesFragment extends BaseFragments {

    @BindView(R2.id.rv_ticket)
    RecyclerView rvTicket;
    LotteryticketAdapter lotteryticketAdapter;
    SignViewPager signViewPager;
    MainActivity mActivity;
    SharedPreferences sp;
    GameTypeBean game;
    int pos;

    public void setSignViewPager(SignViewPager signViewPager) {
        this.signViewPager = signViewPager;
    }

    public GamesFragment(GameTypeBean game, int pos) {
        super(R.layout.fragment_lottery_ticket);
        this.game = game;
        this.pos = pos;
    }

    @Override
    public void initView(View view) {
        mActivity = (MainActivity) getActivity();
        sp = getContext().getSharedPreferences(SPConstants.SP_User, Context.MODE_PRIVATE);
        if (signViewPager != null) {
            signViewPager.setObjectForPosition(view, pos);
            initRecyclerView();
        }
    }

    private void initRecyclerView() {
        if (game == null) {
            return;
        }
        lotteryticketAdapter = new LotteryticketAdapter(game.getList(), getActivity());
        rvTicket.setAdapter(lotteryticketAdapter);
        rvTicket.setLayoutManager(new GridLayoutManager(getActivity(), 3));
        rvTicket.addItemDecoration(new DividerGridItemDecoration(getActivity(),
                DividerGridItemDecoration.BOTH_SET, 20, Color.rgb(255, 255, 255)));
        lotteryticketAdapter.setListener(new LotteryticketAdapter.OnClickListener() {
            @Override
            public void onClickListener(View view, int position) {
                String token = sp.getString(SPConstants.SP_API_SID, SPConstants.SP_NULL);
                if (!token.equals(SPConstants.SP_NULL)) {
//                    if (game.getAlias().equals("lottery")) {
//                        Intent intent = new Intent(getContext(), TicketDetailsActivity.class);
//                        TicketDetails td = new TicketDetails();
//                        td.setGameId(game.getList().get(position).getId());
//                        td.setTitle(game.getList().get(position).getTitle());
//                        td.setGameType(game.getList().get(position).getGameType());
//                        td.setIsInstant(game.getList().get(position).getIsInstant());
//                        Gson gson = new Gson();
//                        String ticketDetails = gson.toJson(td);
//                        intent.putExtra("ticketDetails", ticketDetails);
//                        OpenHelper.startActivity(getContext(), intent);
//                    } else if (game.getList().get(position).getIsPopup() == 0) {
//                        if (game.getList().get(position).getSupportTrial().equals("1"))
//                            goGame(position);
//                        else if (game.getList().get(position).getSupportTrial().equals("0"))
//                            if (Uiutils.isTourist(getActivity())){
//                                return;
//                            }else {
//                                goGame(position);
//                            }
//                    } else if (game.getList().get(position).getIsPopup() == 1) {
//                        Intent intent = new Intent();
//                        intent.putExtra("id", game.getList().get(position).getId());
//                        intent.putExtra("name", game.getList().get(position).getCategory());
//                        intent.putExtra("title", game.getList().get(position).getTitle());
//                        intent.putExtra("supportTrial", game.getList().get(position).getSupportTrial());
////                        intent.putExtra("isInstant", game.getGames().get(position).i);
//                        intent.setClass(getContext(), ElectronicActivity.class);
//                        startActivity(intent);
//                    }
                } else {
//                    startActivity(new Intent(getContext(), LoginActivity.class));
                    Uiutils.login(getContext());
                }
            }
        });
    }


}
