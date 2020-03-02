package com.phoenix.lotterys.main;


import android.annotation.SuppressLint;
import android.content.Context;
import android.content.Intent;
import android.content.res.AssetManager;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.os.AsyncTask;
import android.os.Handler;
import android.os.Message;
import androidx.recyclerview.widget.RecyclerView;
import android.text.TextUtils;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.bumptech.glide.Glide;
import com.bumptech.glide.load.engine.DiskCacheStrategy;
import com.bumptech.glide.request.RequestOptions;
import com.bumptech.glide.request.target.Target;
import com.example.zhouwei.library.CustomPopWindow;
import com.lzy.okgo.OkGo;
import com.lzy.okgo.model.Response;
import com.phoenix.lotterys.R;import com.phoenix.lotterys.R2;
import com.phoenix.lotterys.application.Application;
import com.phoenix.lotterys.main.bean.ConfigBean;
import com.phoenix.lotterys.main.bean.HostBean;
import com.phoenix.lotterys.main.bean.LaunchBean;
import com.phoenix.lotterys.my.adapter.LotteryRecordAdapter;
import com.phoenix.lotterys.my.bean.BaseBean;
import com.phoenix.lotterys.my.bean.My_item;
import com.phoenix.lotterys.util.Constants;
import com.phoenix.lotterys.util.GsonUtil;
import com.phoenix.lotterys.util.NetDialogCallBack;
import com.phoenix.lotterys.util.NetUtils;
import com.phoenix.lotterys.util.SPConstants;
import com.phoenix.lotterys.util.ShareUtils;
import com.phoenix.lotterys.util.Uiutils;
import com.phoenix.lotterys.util.recyclerUtil.BaseRecyclerAdapter;
import com.phoenix.lotterys.view.MaxHeightRecyclerView;
import com.wanxiangdai.commonlibrary.base.BaseActivity;
import com.wanxiangdai.commonlibrary.util.StringUtils;

import java.io.BufferedReader;
import java.io.File;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.URLDecoder;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
import java.util.List;

import butterknife.BindView;
import butterknife.OnClick;

import static com.phoenix.lotterys.util.Constants.ALL_SITES;

/**
 * Date:2019/4/19
 * TIME:13:11
 * author：Luke
 */
public class LaunchActivity extends BaseActivity {

    Application mApp;
    @BindView(R2.id.iv_img)
    ImageView ivImg;
    @BindView(R2.id.skip_bot)
    Button skipBot;
    @BindView(R2.id.skip_bot1)
    Button skipBot1;

    public LaunchActivity() {
        super(R.layout.activity_launch, false, 0);
    }

    private int isFirst = 0;//0 代表第一次 1 代表不是第一次进来
    @SuppressLint("HandlerLeak")
    private Handler handler = new Handler() {
        @Override
        public void handleMessage(Message msg) {
            super.handleMessage(msg);
            switch (msg.what){
                case 1:
                    getData();
                    break;
                case 2:
                    jumpAct();
                    break;
            }
        }
    };

    private void jumpAct() {
        if (isFirst == 1) {
        } else {
            if (type==1){
                if (ShareUtils.getInt(LaunchActivity.this,"sTheme",0)==R.style.AppThemeBlack){
                    ShareUtils.deleShare(LaunchActivity.this,"sTheme");
                    ShareUtils.deleShare(LaunchActivity.this,"ba_top");
                    ShareUtils.deleShare(LaunchActivity.this,"ba_center");
                    ShareUtils.deleShare(LaunchActivity.this,"ba_tbottom");
                }
                startActivity(new Intent(LaunchActivity.this, MainActivity.class));
            }else if (type==2) {
                ShareUtils.putString(this, "themetyp", "5");
                ShareUtils.putInt(LaunchActivity.this, "sTheme", R.style.AppThemeBlack);
                ShareUtils.putInt(LaunchActivity.this, "ba_top", R.color.black1);
                ShareUtils.putInt(LaunchActivity.this, "ba_center", R.color.black);
                ShareUtils.putInt(LaunchActivity.this, "ba_tbottom", R.color.black);
                startActivity(new Intent(LaunchActivity.this, BlackMainActivity.class));
            }
        }
        finish();
    }

    @Override
    public void initView() {
        mApp = (Application) Application.getContextObject();
        String url = SPConstants.getValue(LaunchActivity.this, SPConstants.SP_LAUNCH);
        try {
            new getImageCacheAsyncTask(this).execute(url);
        } catch (Exception e) {
            e.printStackTrace();
        }
        if (!TextUtils.isEmpty(url))
            getLaunchImg(url);
        isFirstLogin();

//        Intent intent = new Intent(mApp, MyIntentService.class);
//        intent.putExtra("type", "3000");
//        startService(intent);

        //是否打开切换全站
        if (ALL_SITES) {
            //测试
            initJsonData();

        } else {
            //正试
            handler.sendEmptyMessageDelayed(1, 2000);//启动页停留两秒后跳转

        }

    }

    private int type;
    private void getData() {
        NetUtils.get(Constants.CONFIG, new HashMap<>(), false, this, new NetUtils.NetCallBack() {
            @Override
            public void onSuccess(String object) {
                ConfigBean configBean =Uiutils.stringToObject(object,ConfigBean.class);
                if (null!=configBean&&null!=configBean.getData()){
                    ShareUtils.saveObject(LaunchActivity.this,SPConstants.CONFIGBEAN,configBean);

                    if ( StringUtils.equals("5",configBean.getData().getMobileTemplateCategory())){
                        type=2;
                    }else{
                        type=1;
                    }
                }
                Message message =new Message();
                message.what=2;
                handler.sendMessage(message);
            }

            @Override
            public void onError() {
                type=1;
                Message message =new Message();
                message.what=2;
                handler.sendMessage(message);
            }
        });

    }

    private HostBean hostBean;
    private void initJsonData() {
        skipBot.setVisibility(View.VISIBLE);
        skipBot1.setVisibility(View.VISIBLE);

        //解析数据
        /**
         * 注意：assets 目录下的Json文件仅供参考，实际使用可自行替换文件
         * 关键逻辑在于循环体
         *
         * */
        String JsonData = getJson("host.json");//获取assets目录下的json文件数据

        if (!StringUtils.isEmpty(JsonData)) {
            hostBean = GsonUtil.fromJson(JsonData, HostBean.class);
        }

        if (null!=hostBean&&null!=hostBean.getList()&&hostBean.getList().size()>0){

            Collections.sort(hostBean.getList(), new Comparator<HostBean.ListBean>() {
                @Override
                public int compare(HostBean.ListBean o1, HostBean.ListBean o2) {
                    return o1.getName().compareTo(o2.getName());
                }
            });

            for (HostBean.ListBean listBean :hostBean.getList()){
                listPop.add(new My_item(listBean.getUrl(),listBean.getName()));
            }
        }

        contentView = LayoutInflater.from(this).inflate(R.layout.city_pop,
                null);

        LinearLayout main_lin = contentView.findViewById(R.id.main_lin);
        main_lin.setBackground(getResources().getDrawable(R.color.white));
        popRec = contentView.findViewById(R.id.pop_rec);
        tis_tex = contentView.findViewById(R.id.tis_tex);
        if (StringUtils.isEmpty(ShareUtils.getString(this,"host",""))){
            tis_tex.setText("test10");
//            Constants. ENCRYPT = false;
            ShareUtils.putString(this, "host", "http://test10.6yc.com");
        } else{
            tis_tex.setText(ShareUtils.getString(this, "host_title", ""));
        }

        tis_tex.setVisibility(View.VISIBLE);
        tis_tex.setGravity(Gravity.CENTER);
        tis_tex.setTextColor(getResources().getColor(R.color.fount1));

        listPop.add(0,new My_item("http://test100f.fhptcdn.com","Michael") );
        listPop.add(0,new My_item("http://t005f.fhptcdn.com","老虎") );
        listPop.add(0,new My_item("http://test20.6yc.com","朗朗") );
        listPop.add(0,new My_item("http://test29f.fhptcdn.com","小冬") );
        listPop.add(0,new My_item("http://test08.6yc.com","阿海") );

        listPop.add(0,new My_item("http://103.9.230.243","test083") );
        listPop.add(0,new My_item("http://test10.6yc.com","test10") );


        LotteryRecordAdapter adapterPop = new LotteryRecordAdapter(this, listPop, R.layout.city_pop_adapter);
        Uiutils.setRec(this, popRec, 1);
        popRec.setAdapter(adapterPop);
        adapterPop.setOnItemClickListener(new BaseRecyclerAdapter.OnItemClickListener() {
            @Override
            public void onItemClick(RecyclerView parent, View view, int position) {
                tis_tex.setText(listPop.get(position).getTitle());
                ShareUtils.putString(LaunchActivity.this,"host",listPop.get(position).getV());
                ShareUtils.putString(LaunchActivity.this,"host_title",listPop.get(position).getTitle());
            }
        });

        popupWindowBuilder = Uiutils.setPopSetting(this, contentView,
                ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT,
                true, true, 0.5f);

//        popWindow = popupWindowBuilder.create();
//        popWindow.showAtLocation(contentView, Gravity.CENTER, 0, 0);
    }

    private List<My_item> listPop = new ArrayList<>();
    private MaxHeightRecyclerView popRec;
    private CustomPopWindow.PopupWindowBuilder popupWindowBuilder;
    private CustomPopWindow popWindow;
    private View contentView;
    private TextView tis_tex;
    /**
     * 从asset目录下读取fileName文件内容
     *
     * @param fileName 待读取asset下的文件名
     * @return 得到省市县的String
     */
    private String getJson(String fileName) {
        StringBuilder stringBuilder = new StringBuilder();
        try {
            AssetManager assetManager = getAssets();
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




    private void getLaunchImg(String saveUrl) {
        OkGo.<String>get(URLDecoder.decode(Constants.BaseUrl() + Constants.LAUNCHIMAGES))
                .tag(this)//
                .execute(new NetDialogCallBack(mApp, false, mApp, true, LaunchBean.class) {
                    @Override
                    public void onUi(Object o) throws IOException {
                        LaunchBean lb = (LaunchBean) o;
                        if (lb != null && lb.getCode() == 0 && lb.getData() != null && lb.getData().size() > 0) {
                            String url = lb.getData().get(0).getPic();
                            SPConstants.setValue(mApp, SPConstants.SP_User, SPConstants.SP_LAUNCH, url);
                            if (!TextUtils.isEmpty(saveUrl) && !saveUrl.equals("Null")) {
                            } else {
                                if (ivImg != null) {
                                    RequestOptions options = new RequestOptions().skipMemoryCache(true)
                                            .diskCacheStrategy(DiskCacheStrategy.ALL);
                                    Glide.with(LaunchActivity.this)
                                            .load(url)
                                            .apply(options)
                                            .into(ivImg);
                                }
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

    private void isFirstLogin() {
        isFirst = getApplication().getSharedPreferences("isFirst", MODE_PRIVATE).getInt("isFirst", 0);
    }

    @OnClick({R.id.skip_bot,R.id.skip_bot1})
    public void onClick(View v) {
        switch (v.getId()){
            case R.id.skip_bot:
                handler.sendEmptyMessageDelayed(1, 0);//启动页停留两秒后跳转
//                startActivity(new Intent(LaunchActivity.this, MainActivity.class));
                break;
            case R.id.skip_bot1:
                popWindow = popupWindowBuilder.create();
        popWindow.showAtLocation(contentView, Gravity.BOTTOM, 0, 0);
                Uiutils.setStateColor(this);
                break;
        }

    }


    private class getImageCacheAsyncTask extends AsyncTask<String, Void, File> {
        private final Context context;

        public getImageCacheAsyncTask(Context context) {
            this.context = context;
        }

        @Override
        protected File doInBackground(String... params) {
            String imgUrl = params[0];
            try {
                return Glide.with(context)
                        .load(imgUrl)
                        .downloadOnly(Target.SIZE_ORIGINAL, Target.SIZE_ORIGINAL)
                        .get();
            } catch (Exception ex) {
                return null;
            }
        }

        @Override
        protected void onPostExecute(File result) {
            if (result == null) {
                return;
            }
            //此path就是对应文件的缓存路径
            String path = result.getPath();
            Bitmap bmp = BitmapFactory.decodeFile(path);
            if (bmp != null && !bmp.isRecycled() && ivImg != null) {
                ivImg.setImageBitmap(bmp);
            }
        }
    }
}
