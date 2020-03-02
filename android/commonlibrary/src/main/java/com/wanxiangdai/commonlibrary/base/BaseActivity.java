package com.wanxiangdai.commonlibrary.base;

import android.content.Context;
import android.content.SharedPreferences;
import android.graphics.Rect;
import android.os.Build;
import android.os.Bundle;
import android.os.Looper;
import android.os.MessageQueue;
import androidx.annotation.NonNull;
import androidx.fragment.app.FragmentManager;
import androidx.fragment.app.FragmentTransaction;
import androidx.appcompat.app.AppCompatActivity;

import android.view.LayoutInflater;
import android.view.MotionEvent;
import android.view.View;
import android.view.ViewGroup;
import android.view.Window;
import android.view.WindowManager;
import android.view.inputmethod.InputMethodManager;
import android.widget.EditText;

import com.gyf.barlibrary.ImmersionBar;
import com.kingja.loadsir.core.LoadService;
import com.wanxiangdai.commonlibrary.R;
import com.wanxiangdai.commonlibrary.util.AppManager;
import com.wanxiangdai.commonlibrary.util.EvenBusUtil.Even;
import com.wanxiangdai.commonlibrary.util.EvenBusUtil.EvenBusUtils;
import com.wanxiangdai.commonlibrary.util.SoftHideKeyBoardUtil;
import com.wanxiangdai.commonlibrary.util.StringUtils;
import com.wanxiangdai.commonlibrary.util.ToastUtil;
import com.wanxiangdai.commonlibrary.util.ViewUtil;
import com.wanxiangdai.commonlibrary.view.TitleBar;

import org.greenrobot.eventbus.Subscribe;
import org.greenrobot.eventbus.ThreadMode;

import butterknife.ButterKnife;
import butterknife.Unbinder;
import rx.Subscription;

/**
 * Created by lottery on 2018/3/3
 */

public abstract class BaseActivity extends BaseKtActivity {
//     * 页面打开时的时间戳
//     */
//    private Date beginTimeStamp;
    FragmentManager mManager;
    FragmentTransaction mTransaction;
    /**
     * 最后一次返回按钮操作事件
     */
    private long lastEventTime;

    /**
     * 推出app的等待时间
     */
    private static int TIME_TO_WAIT = 3 * 1000;
    /**
     * 加载界面的资源id
     */
    protected int mLayoutResID = -1;
    /**
     * 是否需要关闭app
     */
    protected boolean mNeedFinishApp = false;

    protected TitleBar mTitle;

    protected LayoutInflater mLayoutInflater;

    //页面侧滑
//    protected SlideBackLayout mSlideBackLayout;

    //RxBus
    protected Subscription rxBusSubscription;

    //状态栏
    protected ImmersionBar mImmersionBar;

    //各种状态图
    protected LoadService mLoadService;

    /**
     * 是否开启EvenBus
     */
    public boolean isOpenEvenBus;

    /**
     * 是否开启ButterKnife
     */
    public boolean isButterKnife;
    private Unbinder unbinder;

    protected boolean addGroupStatusBarPadding() {
        return false;
    }

    /**
     * @param layoutResID 界面资源文件id
     */
    public BaseActivity(int layoutResID) {
        this.mLayoutResID = layoutResID;
    }

    /**
     * @param layoutResID 界面资源文件id
     */
    public BaseActivity(boolean isGame,int layoutResID) {
        this.mLayoutResID = layoutResID;
        this.isGame = isGame;
    }

    private boolean isGame;
    /**
     * @param layoutResID 界面资源文件id
     */
    public BaseActivity(int layoutResID,boolean isHaveBar ,int id ) {
        this.mLayoutResID = layoutResID;
        this.isHaveBar =isHaveBar;
    }

    /**
     * @param layoutResID 界面资源文件id
     */
    public BaseActivity(int layoutResID,boolean isButterKnife,boolean isOpenEvenBus) {
        this.mLayoutResID = layoutResID;
        this.isButterKnife = isButterKnife;
        this.isOpenEvenBus = isOpenEvenBus;
    }

    /**
     * @param layoutResID 界面资源文件id
     */
    public BaseActivity(boolean isHaveBar,int layoutResID,boolean isButterKnife,boolean isOpenEvenBus) {
        this.mLayoutResID = layoutResID;
        this.isButterKnife = isButterKnife;
        this.isOpenEvenBus = isOpenEvenBus;
        this.isHaveBar = isHaveBar;
    }

    private int type;
    /**
     * @param layoutResID 界面资源文件id
     */
    public BaseActivity(int layoutResID,boolean isButterKnife,boolean isOpenEvenBus,int type) {
        this.mLayoutResID = layoutResID;
        this.isButterKnife = isButterKnife;
        this.isOpenEvenBus = isOpenEvenBus;
        this.type =type;
    }


    /**
     * @param layoutResID 界面资源文件id
     */
    public BaseActivity(int layoutResID,boolean isButterKnife,boolean isOpenEvenBus,boolean needFinishApp) {
        this.mLayoutResID = layoutResID;
        this.isButterKnife = isButterKnife;
        this.isOpenEvenBus = isOpenEvenBus;
        this.mNeedFinishApp = needFinishApp;
    }

    private boolean isall;
    /**
     * @param layoutResID 界面资源文件id
     */
    public BaseActivity(int layoutResID,boolean isButterKnife,boolean isOpenEvenBus,boolean isall,int id) {
        this.mLayoutResID = layoutResID;
        this.isButterKnife = isButterKnife;
        this.isOpenEvenBus = isOpenEvenBus;
        this.isall = isall;
    }

    /**
     * @param layoutResID   界面资源文件id
     * @param needFinishApp 该界面是否可以退出app
     */
    public BaseActivity(int layoutResID, boolean needFinishApp) {
        this.mLayoutResID = layoutResID;
        this.mNeedFinishApp = needFinishApp;
    }
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        mManager = getSupportFragmentManager();
//        if (savedInstanceState != null) {
//            mTransaction = mManager.beginTransaction();
//            mTransaction.remove(mManager.findFragmentByTag("clzs"));
//            mTransaction.remove(mManager.findFragmentByTag("tgsy"));
//            mTransaction.remove(mManager.findFragmentByTag("rwzx"));
//            mTransaction.commitAllowingStateLoss();
//        }



        AppManager.getAppManager().addActivity(this);

        SharedPreferences sharedPreferences = getSharedPreferences("User", Context.MODE_PRIVATE);
        int sTheme = sharedPreferences.getInt("sTheme", 0);

        if (sTheme!=0&&type==0&&isHaveBar()) {
            //设置主题
            setTheme(sTheme);
        }else{
//            requestWindowFeature(Window.FEATURE_NO_TITLE);//去掉标题拦
            requestWindowFeature(Window.FEATURE_NO_TITLE);//隐藏标题栏
            getWindow().setFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN,WindowManager.LayoutParams.FLAG_FULLSCREEN);//隐藏状态栏
        }

        BaseApplication.getInstance().getActivityManager().pushActivity(this);
        setContentView(mLayoutResID);

//        if (isButterKnife){
        unbinder = ButterKnife.bind(this);
//        }

        if (isOpenEvenBus){
            EvenBusUtils.register(this);
        }

        mLayoutInflater = (LayoutInflater) (this)
                .getSystemService(LAYOUT_INFLATER_SERVICE);
        //初始化状态栏
        if (isHaveBar) {
            initImmersionBar();
        }else{
//            int ba_top = sharedPreferences.getInt("ba_top", 0);
            //在BaseActivity里初始化
            mImmersionBar = ImmersionBar.with(this)
                    .statusBarColor(R.color.transparent6)
                    .statusBarDarkFont(true, 0.2f);
            mImmersionBar.init();
        }

        getIntentData();
        beforeInitView();
        initLoadService();
        initView();
    }

    //界面是否需要loadSir 需要则重写
    public void initLoadService() {

    }

    public void initImmersionBar() {
        SharedPreferences sharedPreferences = getSharedPreferences("User", Context.MODE_PRIVATE);
        if (isGame){
            int ba_top = sharedPreferences.getInt("ba_top", 0);
            //在BaseActivity里初始化
            mImmersionBar = ImmersionBar.with(this)
                    .statusBarColor(ba_top == 0 ? R.color.ba_top_1 : ba_top)
                    .statusBarDarkFont(true, 0.2f);
            mImmersionBar.init();
        }else if (isall){
            initImmersionBar1();
        }else {

            String themetyp = sharedPreferences.getString("themetyp", "");
            String themid = sharedPreferences.getString("themid", "");
            if (!StringUtils.isEmpty(themetyp) && StringUtils.equals("4", themetyp) &&
                    !StringUtils.isEmpty(themid) && StringUtils.equals("25", themid)) {
                getWindow().setSoftInputMode(WindowManager.LayoutParams.SOFT_INPUT_STATE_HIDDEN|
                        WindowManager.LayoutParams.SOFT_INPUT_ADJUST_PAN);

//                getWindow().setSoftInputMode(PopupWindow.INPUT_METHOD_NEEDED);
//                getWindow().setSoftInputMode(WindowManager.LayoutParams.SOFT_INPUT_ADJUST_RESIZE);

                SoftHideKeyBoardUtil.assistActivity(this);
                if (Build.VERSION.SDK_INT >= 21) {
                    setStatusBarView();
                }
            } else {
                int ba_top = sharedPreferences.getInt("ba_top", 0);
                //在BaseActivity里初始化
                mImmersionBar = ImmersionBar.with(this)
                        .statusBarColor(ba_top == 0 ? R.color.ba_top_1 : ba_top)
                        .statusBarDarkFont(true, 0.2f);
                mImmersionBar.init();
            }
        }
    }

    public void initImmersionBar1() {
        //在BaseActivity里初始化
        mImmersionBar = ImmersionBar.with(this)
                .statusBarColor("#6987f5")
                .statusBarDarkFont(true,0.2f);
        mImmersionBar.init();
    }

    public void initImmersionBar2() {
        //延时加载数据，保证Statusbar绘制完成后再findview。
        Looper.myQueue().addIdleHandler(new MessageQueue.IdleHandler() {
            @Override
                public boolean queueIdle() {
                if (isStatusBar()) {
                    initStatusBar2();
                    //不加监听,也能实现改变statusbar颜色的效果。但是会出现问题：比如弹软键盘后,弹popwindow后,引起window状态改变时,statusbar的颜色就会复原.
                    getWindow().getDecorView().addOnLayoutChangeListener(new View.OnLayoutChangeListener() {
                        @Override
                        public void onLayoutChange(View v, int left, int top, int right, int bottom, int oldLeft, int oldTop, int oldRight, int oldBottom) {
                            initStatusBar2();
                            getWindow().getDecorView().removeOnLayoutChangeListener(this);
                        }
                    });
                }
                return false;
            }
        });

//        if (null!=statusBarView)
//        statusBarView.setBackgroundColor(this.getResources().getColor(R.color.colorAccent));
    }

    //此方法设置与initView()之前    比如设置状态栏
    public void beforeInitView() {
    }

    public void initView() {

    }


    @Override
    protected void onResume() {
        super.onResume();
//        beginTimeStamp = new Date();

    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        AppManager.getAppManager().finishActivity(this);
        //取消RxBus订阅
        if (rxBusSubscription != null) {
            rxBusSubscription.unsubscribe();
            rxBusSubscription = null;
        }
        //在BaseActivity里销毁
        if (mImmersionBar != null) {
            mImmersionBar.destroy();
        }

//        if (isButterKnife && null!=unbinder){
        unbinder.unbind();
//        }

        if (isOpenEvenBus){
            EvenBusUtils.unregister(this);
        }

        ViewUtil.fixInputMethodManagerLeak(this);
    }

    @Override
    protected void onPause() {
        super.onPause();
//        Date date = new Date();
//        int diff = (int) ((date.getTime() - beginTimeStamp.getTime()) / 1000);

    }

    /**
     * 关闭界面，重写了系统的方法，在里面增加了系统Activity堆栈管理功能
     */
    @Override
    public void finish() {
        BaseApplication.getInstance().getActivityManager().popActivity(this);
        super.finish();
    }

    /**
     * 关闭除指定界面以外的所有Activity
     *
     * @param cls 指定界面
     */
    public void finishAllExt(Class<?> cls) {
        BaseApplication.getInstance().getActivityManager().popAllActivityExceptOne(cls);
    }

    /**
     * 关闭所有Activity
     */
    public void finishAll() {
        BaseApplication.getInstance().getActivityManager().popAllActivity();
    }

    /**
     * 返回按钮点击事件，已经封装完毕，非必要，请勿重写
     */
    @Override
    public void onBackPressed() {
        if (mNeedFinishApp) {
            long currentEventTime = System.currentTimeMillis();
            if ((currentEventTime - lastEventTime) > TIME_TO_WAIT) {
                ToastUtil.toastShortShow(this, "再按一次退出app");
                lastEventTime = currentEventTime;
            } else {
                finishAll();
                android.os.Process.killProcess(android.os.Process.myPid());
                Runtime.getRuntime().gc();
            }
        } else {
            super.onBackPressed();
        }
    }

    /**
     * initTitle:初始化标题. <br/>
     *
     * @param id 标题资源文件id
     */
    public void initTitle(int id, int bgcolor, int titlecolor) {
        if (mTitle == null) {
            mTitle = new TitleBar(this, findViewById(android.R.id.content), id, bgcolor, titlecolor);
        }
    }

    /**
     * initTitle:初始化标题. <br/>
     *
     * @param name 标题文本
     */
    public void initTitle(String name, int bgcolor, int titlecolor) {
        mTitle = new TitleBar(this, findViewById(android.R.id.content), name, bgcolor, titlecolor);
    }

    /**
     * 弹出界面提示内容
     *
     * @param msg 提示内容文字内容
     */
    public void showToast(String msg) {
        ToastUtil.toastShortShow(this, msg);
    }


    /**
     * 得到界面跳转过来的数值，如果上一个界面有数据传递过来，那么这边需要进行重写该方法
     */
    public void getIntentData() {

    }

    /**
     * 事件的分发
     *
     * @param ev
     * @return
     */
    @Override
    public boolean dispatchTouchEvent(MotionEvent ev) {
        if (ev.getAction() == MotionEvent.ACTION_DOWN) {
            View v = getCurrentFocus();
            if (isShouldHideInput(v, ev)) {

                InputMethodManager imm = (InputMethodManager) getSystemService(Context.INPUT_METHOD_SERVICE);
                if (imm != null) {
                    imm.hideSoftInputFromWindow(v.getWindowToken(), 0);
                }
            }
            return super.dispatchTouchEvent(ev);
        }
        // 必不可少，否则所有的组件都不会有TouchEvent了
        if (getWindow().superDispatchTouchEvent(ev)) {
            return true;
        }
        return onTouchEvent(ev);
    }

    /**
     * 判断软键盘是否需要隐藏
     *
     * @param v
     * @param event
     * @return
     */
    public boolean isShouldHideInput(View v, MotionEvent event) {
        if (v != null && (v instanceof EditText)) {
            int[] leftTop = {0, 0};
            //获取输入框当前的location位置
            v.getLocationInWindow(leftTop);
            int left = leftTop[0];
            int top = leftTop[1];
            int bottom = top + v.getHeight();
            int right = left + v.getWidth();
            if (event.getX() > left && event.getX() < right
                    && event.getY() > top && event.getY() < bottom) {
                // 点击的是输入框区域，保留点击EditText的事件
                return false;
            } else {
                return true;
            }
        }
        return false;
    }

    private boolean isHaveBar =true ;

    /**
     * 公共接收msg
     * @param even msg 数据
     */
    @Subscribe(threadMode = ThreadMode.MAIN)
    public void onGetMessage(Even even) {
        getEvenMsg(even);
    }

    /**
     * 统一处理
     * @param even
     */
    public void getEvenMsg(Even even){
//        switch (even.getCode()){
//            case EvenBusCode.SEN_MESSAGE:
//                Log.e("base==","你好");
//                ToastUtil.toastShortShow(this,"你好");
//                break;
//        }
    }


    /**
     * 设置状态栏（渐变）
     * <p>
     * https://www.jb51.net/article/124110.htm
     * <p>
     * https://blog.csdn.net/u010127332/article/details/81502950
     */
    public void setStatusBarView() {
        //延时加载数据，保证Statusbar绘制完成后再findview。
//        Looper.myQueue().addIdleHandler(new MessageQueue.IdleHandler() {
//            @Override
//            public boolean queueIdle() {
        if (isStatusBar()) {
            initStatusBar();
            //不加监听,也能实现改变statusbar颜色的效果。但是会出现问题：比如弹软键盘后,弹popwindow后,引起window状态改变时,statusbar的颜色就会复原.
            getWindow().getDecorView().addOnLayoutChangeListener(new View.OnLayoutChangeListener() {
                @Override
                public void onLayoutChange(View v, int left, int top, int right, int bottom, int oldLeft, int oldTop, int oldRight, int oldBottom) {
                    initStatusBar();
                    getWindow().getDecorView().removeOnLayoutChangeListener(this);
                }
            });
        }
//                //只走一次
//                return false;
//                }
//        });
    }
    private View statusBarView;
    /**
     * 颜色渐变
     */
    private void initStatusBar() {
        if (statusBarView == null) {
            //利用反射机制修改状态栏背景
            int identifier = getResources().getIdentifier("statusBarBackground", "id", "android");
            statusBarView = getWindow().findViewById(identifier);
        }

        getTheme(this);
//        if (statusBarView != null) {
//            statusBarView.setBackgroundResource(getTheme(this));
//        } else {
//            Log.e("aa","statusBarView is null.");
//        }
    }

    private void initStatusBar2() {
        if (statusBarView == null) {
            //利用反射机制修改状态栏背景
            int identifier = getResources().getIdentifier("statusBarBackground", "id", "android");
            statusBarView = getWindow().findViewById(identifier);
        }

        if (null!=statusBarView)
            statusBarView.setBackgroundColor(this.getResources().getColor(R.color.color_6987f5));
//        getTheme(this);
//        if (statusBarView != null) {
//            statusBarView.setBackgroundResource(getTheme(this));
//        } else {
//            Log.e("aa","statusBarView is null.");
//        }
    }

    protected boolean isStatusBar() {
        return true;
    }

    private  void getTheme(Context context){
        if (statusBarView == null)
            return;

        SharedPreferences sharedPreferences = getSharedPreferences("User", Context.MODE_PRIVATE);
        String id = sharedPreferences.getString("themid","");
        switch (id){
            case "23":
                statusBarView.setBackgroundResource(R.drawable.theme_ba23);
                break;
            case "24":
                statusBarView.setBackgroundResource(R.drawable.theme_ba24);
                break;
            case "25":
                statusBarView.setBackgroundResource(R.drawable.theme_ba25);
                break;
            case "26":
                statusBarView.setBackgroundResource(R.drawable.theme_ba26);
                break;
            case "27":
                statusBarView.setBackgroundResource(R.drawable.theme_ba27);
                break;
            case "28":
                statusBarView.setBackgroundResource(R.drawable.theme_ba28);
                break;
            case "29":
                statusBarView.setBackgroundResource(R.drawable.theme_ba29);
                break;
            case "30":
                statusBarView.setBackgroundResource(R.drawable.theme_ba30);
                break;
            case "31":
                statusBarView.setBackgroundResource(R.drawable.theme_ba31);
                break;
            case "32":
                statusBarView.setBackgroundResource(R.drawable.theme_ba32);
                break;
            case "33":
                statusBarView.setBackgroundResource(R.drawable.theme_ba33);
                break;
        }

    }

    private View findViewFocus(ViewGroup viewGroup, MotionEvent event) {
        View view = null;
        int childCount = viewGroup.getChildCount();
        for (int i = 0; i < childCount; i++) {
            view = viewGroup.getChildAt(i);
            Rect outRect = new Rect();
            view.getGlobalVisibleRect(outRect);
            if (outRect.contains((int) event.getRawX(), (int) event.getRawY())) {
                if (view instanceof ViewGroup) {
                    return findViewFocus((ViewGroup) view, event);
                } else {
                    return view;
                }
            }
        }
        return view;
    }

    protected boolean isHaveBar() {
        return true;
    }
}
