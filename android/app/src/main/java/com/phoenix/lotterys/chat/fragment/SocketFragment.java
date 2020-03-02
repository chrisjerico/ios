package com.phoenix.lotterys.chat.fragment;

import android.os.Handler;
import android.os.Message;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;
import android.util.Log;
import android.view.View;
import android.widget.EditText;
import android.widget.TextView;

import com.phoenix.lotterys.R;import com.phoenix.lotterys.R2;
import com.phoenix.lotterys.application.BaseFragments;
import com.phoenix.lotterys.chat.SocketClent;
import com.phoenix.lotterys.chat.adapter.ChatRecyAdapter;
import com.phoenix.lotterys.chat.bean.ContextMsg;

import java.net.URI;
import java.util.ArrayList;
import java.util.List;

import butterknife.BindView;
import butterknife.OnClick;

public class SocketFragment extends BaseFragments {
    private static final String url = "ws:///";
    private static final int STATUS_MESSAGE = 100;
    @BindView(R2.id.chat_recy)
    RecyclerView chatRecy;
    @BindView(R2.id.edit_context)
    EditText editContext;
    @BindView(R2.id.txt_send)
    TextView txtSend;
    private List<ContextMsg> msgList;
    private URI uri;
    private ChatRecyAdapter chatRecyAdapter;
    SocketClent client;
    private Handler mhandler = new Handler() {
        @Override
        public void handleMessage(Message msg) {
            super.handleMessage(msg);
            String mess = (String) msg.obj;
            switch (msg.what) {
                case STATUS_MESSAGE:
                    setListSent(mess, ContextMsg.TYPE_RECEIVED);
                    break;
            }
        }
    };

    private List<ContextMsg> getList() {
        msgList = new ArrayList<>();
        msgList.add(new ContextMsg("你好", ContextMsg.TYPE_RECEIVED));
        msgList.add(new ContextMsg("hello", ContextMsg.TYPE_SENT));
        msgList.add(new ContextMsg("见到你很高兴", ContextMsg.TYPE_RECEIVED));

        return msgList;
    }

    private void setListSent(String send, int type) {
        if (type == ContextMsg.TYPE_SENT) {
            msgList.add(new ContextMsg(send, ContextMsg.TYPE_SENT));
            editContext.setText("");
        } else {
            msgList.add(new ContextMsg(send, ContextMsg.TYPE_RECEIVED));
        }
        Log.e("msgList",""+msgList);
        chatRecy.setLayoutManager(new LinearLayoutManager(getContext()));
        chatRecyAdapter = new ChatRecyAdapter(getContext(), msgList);
        chatRecy.setAdapter(chatRecyAdapter);

        chatRecyAdapter.notifyDataSetChanged();
        chatRecy.scrollToPosition(chatRecyAdapter.getItemCount() - 1);

    }

    public SocketFragment() {
        super(R.layout.socketfragment);
    }

    public static SocketFragment getInstance() {
        return new SocketFragment();
    }

    @Override
    public void initView(View view) {
        getList();
        setListSent("111", ContextMsg.TYPE_RECEIVED);

    }

    @Override
    public void onDestroy() {
        super.onDestroy();
//activity 销毁时 关闭连接
        closeConnect();
    }

    //打开socket连接
    private void initSocketClient() {
        uri = URI.create(url);
        client = new SocketClent(uri) {
            @Override
            public void onMessage(String message) {
                Log.e("onMessage", message);
//                ReceivedMsg receivedMsg = GsonManager.getGson(message, ReceivedMsg.class);
//                Message msg = new Message();
//                msg.what = STATUS_MESSAGE;
//                msg.obj = receivedMsg.getMsg().getContent();
//                mhandler.sendMessage(msg);
            }

        };
        connect();
    }

    //连接
    private void connect() {
        new Thread() {
            @Override
            public void run() {
                try {
                    client.connectBlocking();
                    Log.e("connectBlocking", "连接成功");
                    if (client.isOpen()) {
//                        senJsonInit();
                    }

                } catch (InterruptedException e) {
                    e.printStackTrace();
                }
            }
        }.start();

    }

    //断开连接
    private void closeConnect() {
        try {
            if (null != client) {
                client.close();

            }
        } catch (Exception e) {
            e.printStackTrace();
            Log.e("Socket", "断开连接异常");
        } finally {
            client = null;
        }
    }

    //发送消息

    /**
     *
     */
    private void sendMsg(String msg) {
        if (null != client) {
            client.send(msg);
            Log.e("发送的消息", msg);
        }
    }


    @OnClick(R.id.txt_send)
    public void onViewClicked() {
    }
}
