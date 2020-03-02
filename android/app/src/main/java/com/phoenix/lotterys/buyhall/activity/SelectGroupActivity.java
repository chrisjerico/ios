package com.phoenix.lotterys.buyhall.activity;

import android.content.Context;
import android.content.Intent;
import androidx.recyclerview.widget.LinearLayoutManager;
import android.view.View;
import com.google.gson.Gson;
import com.google.gson.JsonObject;
import com.lzy.okgo.OkGo;
import com.lzy.okgo.model.Response;
import com.phoenix.lotterys.R;import com.phoenix.lotterys.R2;
import com.phoenix.lotterys.chat.adapter.ChatListAdapter;
import com.phoenix.lotterys.chat.entity.ChatListEntity;
import com.phoenix.lotterys.chat.entity.TicketListEntity;
import com.phoenix.lotterys.my.bean.BaseBean;
import com.phoenix.lotterys.service.chat.ChatManager;
import com.phoenix.lotterys.service.chat.entity.SendEntity;
import com.phoenix.lotterys.util.Constants;
import com.phoenix.lotterys.util.FormatUtils;
import com.phoenix.lotterys.util.NetDialogCallBack;
import com.phoenix.lotterys.util.SPConstants;
import com.phoenix.lotterys.util.SecretUtils;
import com.phoenix.lotterys.util.ToastUtils;
import com.scwang.smartrefresh.layout.SmartRefreshLayout;
import com.wanxiangdai.commonlibrary.base.BaseActivity;
import com.yanzhenjie.recyclerview.SwipeRecyclerView;
import java.net.URLDecoder;
import butterknife.BindView;
import butterknife.OnClick;

/**
 * @author : Wu
 * @e-mail : wu_developer@outlook.com
 * @date : 2019/12/13 16:47
 * @description :
 */
public class SelectGroupActivity extends BaseActivity {

    private static final String KEY_BEAN = "key_bean";

    public static void start(Context context, TicketListEntity.DataBean bean) {
        Intent intent = new Intent(context, SelectGroupActivity.class);
        intent.putExtra(KEY_BEAN, bean);
        context.startActivity(intent);
    }

    @BindView(R2.id.rv_list)
    SwipeRecyclerView rvList;
    @BindView(R2.id.smart_refresh_layout)
    SmartRefreshLayout smartRefreshLayout;

    private TicketListEntity.DataBean mBean;

    private ChatListAdapter mChatListAdapter;

    @Override
    protected boolean isHaveBar() {
        return false;
    }

    @Override
    protected boolean addGroupStatusBarPadding() {
        return true;
    }

    public SelectGroupActivity() {
        super(R.layout.activity_select_group, true, true);
    }

    @Override
    public void initView() {
        mBean = (TicketListEntity.DataBean) getIntent().getSerializableExtra(KEY_BEAN);

        mChatListAdapter = new ChatListAdapter(rvList, false);
        mChatListAdapter.setOnItemClickListener(this::send);
        rvList.setLayoutManager(new LinearLayoutManager(this));
        rvList.setAdapter(mChatListAdapter);

        smartRefreshLayout.setOnRefreshListener(refreshLayout -> getData());

        smartRefreshLayout.autoRefresh();
    }

    @OnClick(R.id.ib_back)
    public void onClick(View view) {
        switch (view.getId()) {
            case R.id.ib_back:
                finish();
                break;
        }
    }

    private void getData() {
        String token = SPConstants.getValue(this, SPConstants.SP_API_SID);

        OkGo.<String>post(URLDecoder.decode(Constants.BaseUrl() + Constants.CHAT_LIST + (Constants.ENCRYPT ? Constants.SIGN : "")))
                .tag(this)
                .params("token", SecretUtils.DESede(token))
                .params("scope", SecretUtils.DESede(String.valueOf(1)))
                .params("sign", SecretUtils.RsaToken())
                .execute(new NetDialogCallBack(this, false, this, true, ChatListEntity.class) {
                    @Override
                    public void onUi(Object o) {
                        ChatListEntity b = (ChatListEntity) o;
                        if (b != null && b.getCode() == 0) {
                            mChatListAdapter.setData(b.getData().getConversationList());
                        }
                    }

                    @Override
                    public void onErr(BaseBean bb) {
                    }

                    @Override
                    public void onFailed(Response<String> response) {
                    }

                    @Override
                    public void onFinish() {
                        smartRefreshLayout.finishRefresh();
                        smartRefreshLayout.finishLoadMore();
                    }
                });
//                .setGsonAdapter(builder -> builder.registerTypeAdapter(ChatListEntity.class, new ChatListEntity.Adapter())));
    }

    public void send(ChatListEntity.DataBean.ConversationListBean targetBean) {
        try {
            StringBuilder msgBuilder = new StringBuilder();
            msgBuilder.append("游戏：").append(mBean.getGameName())
                    .append("\\n期号：").append(mBean.getTurnNum())
//                .append("\\n玩法：").append("")
                    .append("\\n内容：");

            JsonObject betJson = new JsonObject();
            betJson.addProperty("playType", "NORMAL");
            betJson.addProperty("betSrc", 0);
            betJson.addProperty("betFollowFlag", true);
            betJson.addProperty("ftime", System.currentTimeMillis() / 1000);

            betJson.addProperty("gameId", Long.valueOf(mBean.getGameId()));
            betJson.addProperty("gameName", mBean.getGameName());
            betJson.addProperty("turnNum", mBean.getTurnNum());
            betJson.addProperty("totalNums", mBean.getTotalNums());
            betJson.addProperty("totalMoney", mBean.getTotalMoney());

            for (int i = 0; i < mBean.getBetBean().size(); i++) {
                TicketListEntity.DataBean.BetBeanBean betBean = mBean.getBetBean().get(i);
                betJson.addProperty("betBean[" + i + "][name]", betBean.getName());
                betJson.addProperty("betBean[" + i + "][betNum]", FormatUtils.formatInt(betBean.getBetNum(), 0));
                betJson.addProperty("betBean[" + i + "][playId]", betBean.getPlayId());
                betJson.addProperty("betBean[" + i + "][playIds]", betBean.getPlayIds());
                betJson.addProperty("betBean[" + i + "][money]", FormatUtils.formatDouble(betBean.getMoney(), 0.0));
                betJson.addProperty("betBean[" + i + "][betInfo]", betBean.getBetInfo());
                betJson.addProperty("betBean[" + i + "][odds]", betBean.getOdds());

                msgBuilder.append("\\n").append(betBean.getName())
                        .append(" 金额：￥").append(betBean.getMoney());
            }
            msgBuilder.append("\\n共计：").append(mBean.getTotalNums()).append("注")
                    .append("\\n金额：").append(mBean.getTotalMoney()).append("元");

            SendEntity sendEntity;
            if (targetBean.getType() == 1) {
                sendEntity = SendEntity.getGroupText(this, String.valueOf(targetBean.getRoomId())
                        , msgBuilder.toString(), false);
            } else {
                sendEntity = SendEntity.getPrivateText(this, String.valueOf(targetBean.getUid()),
                        targetBean.getNickname(), msgBuilder.toString(), false);
            }

            JsonObject json = new Gson().toJsonTree(sendEntity).getAsJsonObject();
            json.addProperty("betFollowFlag", true);
            json.add("betUrl", betJson);
            json.add("msgJson", new Gson().toJsonTree(mBean));

            ChatManager.getInstance().send(json.toString());

            ToastUtils.ToastUtils("分享成功", this);
            finish();
        } catch (Exception e) {
            e.printStackTrace();
            ToastUtils.ToastUtils("分享数据格式错误", this);
        }
    }
}
