package com.phoenix.lotterys.util;

import android.animation.ObjectAnimator;
import android.animation.ValueAnimator;
import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Color;
import android.graphics.Point;
import android.graphics.drawable.GradientDrawable;
import android.os.Build;
import android.os.CountDownTimer;
import androidx.annotation.RequiresApi;
import androidx.recyclerview.widget.GridLayoutManager;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;
import android.text.Html;
import android.text.Spannable;
import android.text.SpannableStringBuilder;
import android.text.style.ForegroundColorSpan;
import android.util.Base64;
import android.util.DisplayMetrics;
import android.util.Log;
import android.util.SparseArray;
import android.view.Display;
import android.view.View;
import android.view.Window;
import android.view.WindowManager;
import android.widget.PopupWindow;
import android.widget.TextView;

import com.example.zhouwei.library.CustomPopWindow;
import com.phoenix.lotterys.BuildConfig;
import com.phoenix.lotterys.R;import com.phoenix.lotterys.R2;
import com.phoenix.lotterys.main.bean.ConfigBean;
import com.phoenix.lotterys.my.activity.BlackLoginActivity;
import com.phoenix.lotterys.my.activity.LoginActivity;
import com.phoenix.lotterys.my.bean.BaseBean;
import com.phoenix.lotterys.my.bean.My_item;
import com.phoenix.lotterys.view.ArcView;
import com.phoenix.lotterys.view.CustomTitleBar;
import com.phoenix.lotterys.view.SeekAttentionView;
import com.wanxiangdai.commonlibrary.base.BaseActivity;
import com.wanxiangdai.commonlibrary.util.MeasureUtil;
import com.wanxiangdai.commonlibrary.util.StringUtils;
import com.wanxiangdai.commonlibrary.util.ToastUtil;

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

public class Uiutils {
    static public int getScreenWidthPixels(Context context) {

        DisplayMetrics dm = new DisplayMetrics();
        ((WindowManager) context.getSystemService(Context.WINDOW_SERVICE)).getDefaultDisplay()
                .getMetrics(dm);
        return dm.widthPixels;
    }

    static public int dipToPx(Context context, int dip) {
        return (int) (dip * getScreenDensity(context) + 0.5f);
    }

    static public float getScreenDensity(Context context) {
        try {
            DisplayMetrics dm = new DisplayMetrics();
            ((WindowManager) context.getSystemService(Context.WINDOW_SERVICE)).getDefaultDisplay()
                    .getMetrics(dm);
            return dm.density;
        } catch (Exception e) {
            return DisplayMetrics.DENSITY_DEFAULT;
        }
    }

    /**
     * 公共方法（设置title 左img事件和右img不展示（常用提出））
     *
     * @param titlebar 自定义 title
     * @param activity 当前页面
     */
    public static void setBarStye(CustomTitleBar titlebar, Activity activity) {
        String themetyp = ShareUtils.getString(activity, "themetyp", "");
        String themid = ShareUtils.getString(activity, "themid", "");
        if (!StringUtils.isEmpty(themetyp) && StringUtils.equals("4", themetyp) &&
                !StringUtils.isEmpty(themetyp) && StringUtils.equals("25", themid)) {
            titlebar.setBackground(activity.getResources().getDrawable(getTheme(activity)));
        }
        titlebar.setRIghtTvVisibility(0x00000008);
        titlebar.setLeftIconOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                activity.finish();
            }
        });
    }

    /**
     * 公共方法（设置title 左img事件和右img不展示（常用提出））
     *
     * @param titlebar 自定义 title
     * @param activity 当前页面
     */
    public static void setBarStye1(CustomTitleBar titlebar, Activity activity) {
        titlebar.setRIghtTvVisibility(0x00000008);
        titlebar.setLeftIconOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                activity.finish();
            }
        });
    }

    /**
     * 公共方法（设置title 左img事件和右img不展示（常用提出））
     *
     * @param titlebar 自定义 title
     * @param activity 当前页面
     */
    public static void setBarStye0(View titlebar, Context activity) {
        if (null == titlebar)
            return;

        String themetyp = ShareUtils.getString(activity, "themetyp", "");
        String themid = ShareUtils.getString(activity, "themid", "");
        if (!StringUtils.isEmpty(themetyp) && StringUtils.equals("4", themetyp) &&
                !StringUtils.isEmpty(themetyp) && StringUtils.equals("25", themid)) {
            titlebar.setBackground(activity.getResources().getDrawable(getTheme(activity)));
        }
    }


    /**
     * 获取过去或者未来 任意天内的日期数组
     *
     * @param intervals intervals天内
     * @return 日期数组
     */
    public static ArrayList<String> test(int intervals) {
        ArrayList<String> pastDaysList = new ArrayList<>();
//        ArrayList<String> fetureDaysList = new ArrayList<>();
        for (int i = 0; i < intervals; i++) {
            pastDaysList.add(getPastDate(i));
//            fetureDaysList.add(getFetureDate(i));
        }
        return pastDaysList;
    }

    /**
     * 获取过去第几天的日期
     *
     * @param past
     * @return
     */
    public static String getPastDate(int past) {
        Calendar calendar = Calendar.getInstance();
        calendar.set(Calendar.DAY_OF_YEAR, calendar.get(Calendar.DAY_OF_YEAR) - past);
        Date today = calendar.getTime();
        SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
        String result = format.format(today);
        Log.e(null, result);
        return result;
    }


    public static String getPastDate(int past, Date date) {
        Calendar calendar = Calendar.getInstance();
        calendar.setTime(date);
        calendar.set(Calendar.DAY_OF_YEAR, calendar.get(Calendar.DAY_OF_YEAR) - past);
        Date today = calendar.getTime();
        SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
        String result = format.format(today);
        Log.e(null, result);
        return result;
    }

    /**
     * 获取未来 第 past 天的日期
     *
     * @param past
     * @return
     */
    public static String getFetureDate(int past) {
        Calendar calendar = Calendar.getInstance();
        calendar.set(Calendar.DAY_OF_YEAR, calendar.get(Calendar.DAY_OF_YEAR) + past);
        Date today = calendar.getTime();
        SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
        String result = format.format(today);
        Log.e(null, result);
        return result;
    }

    /**
     * 获取 token
     *
     * @param context
     * @return
     */
    public static String getToken(Context context) {
        String token = "";
        SharedPreferences sp = context.getSharedPreferences("User", Context.MODE_PRIVATE);
        token = sp.getString("API-SID", "Null");

        if (StringUtils.isEmpty(token) || StringUtils.equals("Null", token) ||
                StringUtils.equals("null", token))
            token = "";

        return token;
    }

    /**
     * 获取 token
     *
     * @param context
     * @return
     */
    public static boolean getToken0(Context context) {
        String token = "";
        SharedPreferences sp = context.getSharedPreferences("User", Context.MODE_PRIVATE);
        token = sp.getString("API-SID", "Null");
        if (StringUtils.isEmpty(token) || StringUtils.equals("Null", token)) {
            Uiutils.login(context);
            return true;
        } else {
            return false;
        }
    }

    /**
     * get 请求入参封装
     * 方法名称:transMapToString
     * 传入参数:map
     * 返回值:String 形如 username'chenziwen^password'1234
     */
    public static String transMapToString(Map map) {
        java.util.Map.Entry entry;
        StringBuffer sb = new StringBuffer();
        sb.append("&");
        for (Iterator iterator = map.entrySet().iterator(); iterator.hasNext(); ) {
            entry = (java.util.Map.Entry) iterator.next();
            sb.append(entry.getKey().toString()).append("=").append(null == entry.getValue() ? "" :
                    entry.getValue().toString()).append(iterator.hasNext() ? "&" : "");
        }
        return sb.toString();
    }

    /**
     * 公用请求成功退出方法
     *
     * @param object
     * @param activity
     */
    public static void pubFish(Object object, Activity activity) {
        if (null != object) {
            BaseBean baseBean = GsonUtil.fromJson((String) object, BaseBean.class);
            if (null != baseBean && !StringUtils.isEmpty(baseBean.getMsg()))
                ToastUtil.toastShortShow(activity, baseBean.getMsg());
            activity.finish();
        }
    }

    /**
     * 公共设置 RecyclerView基本配制
     *
     * @param context
     * @param id
     * @param recyclerView
     */
    public static void setRec(Context context, RecyclerView recyclerView, int id) {
        //设置布局管理器
        LinearLayoutManager linearLayoutManager = new LinearLayoutManager(context);
        recyclerView.setLayoutManager(linearLayoutManager);
        recyclerView.addItemDecoration(new SpacesItemDecoration(context, id));
    }

    /**
     * 公共设置 RecyclerView基本配制
     *
     * @param context
     * @param id
     * @param recyclerView
     */
    public static void setRec(Context context, RecyclerView recyclerView, int id, int i) {
        //设置布局管理器
        GridLayoutManager layoutManager = new GridLayoutManager(context, id);
        GridItemDecoration divider = new GridItemDecoration.Builder(context)
                .setHorizontalSpan(R.dimen.dp_1)
                .setVerticalSpan(R.dimen.dp_1)
                .setColorResource(i)
                .setShowLastLine(true)
                .build();
        recyclerView.addItemDecoration(divider);
        recyclerView.setLayoutManager(layoutManager);
    }

    /**
     * 公共设置 RecyclerView基本配制
     *
     * @param context
     * @param id
     * @param recyclerView
     */
    public static void setRec0(Context context, RecyclerView recyclerView, int id, int i) {
        //设置布局管理器
        GridLayoutManager layoutManager = new GridLayoutManager(context, id);
        GridItemDecoration divider = new GridItemDecoration.Builder(context)
                .setHorizontalSpan(R.dimen.dp_1)
                .setVerticalSpan(R.dimen.dp_1)
                .setColorResource(i)
                .setShowLastLine(false)
                .build();
        recyclerView.addItemDecoration(divider);
        recyclerView.setLayoutManager(layoutManager);
    }


    /**
     * 公共设置 RecyclerView基本配制
     *
     * @param context
     * @param id
     * @param recyclerView
     */
    public static void setRec(Context context, RecyclerView recyclerView, int id, int i, int type) {
        //设置布局管理器
        GridLayoutManager layoutManager = new GridLayoutManager(context, id);
        GridItemDecoration divider = new GridItemDecoration.Builder(context)
                .setHorizontalSpan(R.dimen.dp_10)
                .setVerticalSpan(R.dimen.dp_10)
                .setColorResource(i)
                .setShowLastLine(true)
                .build();
        recyclerView.addItemDecoration(divider);
        recyclerView.setLayoutManager(layoutManager);
    }


    /**
     * 公共设置 RecyclerView基本配制
     *
     * @param context
     * @param id
     * @param recyclerView
     */
    public static void setRec(Context context, RecyclerView recyclerView, int id, boolean isLevel) {
        //设置布局管理器
        recyclerView.setLayoutManager(new LinearLayoutManager(context,
                LinearLayoutManager.HORIZONTAL, false));
        recyclerView.addItemDecoration(new SpacesItemDecoration(context, id));
    }

    /**
     * 公用pop 设置属性
     *
     * @param context
     * @param contentView 加载lay
     * @param with
     * @param hight
     * @param isDiss      是否点外边隐藏
     * @param isDack      是否在透明
     * @param darkValue   透明值
     * @return
     */
    public static CustomPopWindow.PopupWindowBuilder setPopSetting(Context context,
                                                                   View contentView, int with, int hight, boolean isDiss, boolean isDack,
                                                                   float darkValue) {

        CustomPopWindow.PopupWindowBuilder popupWindowBuilder = null;
        popupWindowBuilder = new CustomPopWindow.PopupWindowBuilder(context)
                .size(with, hight)
                .setView(contentView)
                .enableOutsideTouchableDissmiss(isDiss)
                .setOnDissmissListener(new PopupWindow.OnDismissListener() {
                    @Override
                    public void onDismiss() {
                        if (null != contentView)
                            setStateColor((Activity) context);
                    }
                })
                .enableBackgroundDark(isDack)
                .setBgDarkAlpha(darkValue); // 控制亮度

        return popupWindowBuilder;

    }

    /**
     * 公用pop 设置属性
     *
     * @param context
     * @param contentView 加载lay
     * @param with
     * @param hight
     * @param isDiss      是否点外边隐藏
     * @param isDack      是否在透明
     * @param darkValue   透明值
     * @return
     */
    public static CustomPopWindow.PopupWindowBuilder setPopSetting1(Context context,
                                                                    View contentView, int with, int hight, boolean isDiss, boolean isDack,
                                                                    float darkValue) {

        CustomPopWindow.PopupWindowBuilder popupWindowBuilder = null;
        popupWindowBuilder = new CustomPopWindow.PopupWindowBuilder(context)
                .size(with, hight)
                .setView(contentView)
                .enableOutsideTouchableDissmiss(isDiss)
                .enableBackgroundDark(isDack)
                .setBgDarkAlpha(darkValue); // 控制亮度

        return popupWindowBuilder;

    }

    /**
     * 设置背景变暗的值
     *
     * @param darkValue
     * @return
     */
    public static void setBgDarkAlpha(Activity activity, float darkValue) {
        Window mWindow = activity.getWindow();
        WindowManager.LayoutParams params = mWindow.getAttributes();
        params.alpha = darkValue;
        mWindow.setAttributes(params);
    }

    /**
     * 将毫秒数换算成 00:00 形式
     */
    public static String getMinuteSecond(long time) {
        long days = time / (1000 * 60 * 60 * 24);
        long hours = (time % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60);
        long minutes = (time % (1000 * 60 * 60)) / (1000 * 60);
        long seconds = (time % (1000 * 60)) / 1000;
        String strMinute = minutes < 10 ? "0" + minutes : "" + minutes;
        String strSecond = seconds < 10 ? "0" + seconds : "" + seconds;
        String strHour = hours < 10 ? "0" + hours : "" + hours;
        if (days == 0) {
            return strHour + ":" + strMinute + ":"
                    + strSecond;
        }
        return days + "天" + strHour + ":" + strMinute + ":"
                + strSecond;
    }

    /**
     * @param timerArray
     */
    public static void cancelAllTimers(SparseArray<CountDownTimer> timerArray) {
        if (timerArray == null) {
            return;
        }
        int size = timerArray.size();
        for (int i = 0; i < size; i++) {
            CountDownTimer cdt = timerArray.get(timerArray.keyAt(i));
            if (cdt != null) {
                cdt.cancel();
            }
        }
    }

    /***
     *  宽度的百分比
     * @param context
     * @param percentage  百分比
     * @return
     */
    public static int getWiht(Activity context, double percentage) {
        int value = 0;
        WindowManager m = context.getWindowManager();
        Display d = m.getDefaultDisplay(); // 为获取屏幕宽、高
        android.view.WindowManager.LayoutParams p = context.getWindow().getAttributes();
        p.width = d.getWidth(); // 宽度设置为屏幕的0.7
        context.getWindow().setAttributes(p);
        value = (new Double(p.width * percentage)).intValue();
        return value;
    }

    public static void excutesucmd(Activity activity, String currenttempfilepath) {
        Process process = null;
        OutputStream out = null;
        InputStream in = null;
        try {
            // 请求root
            process = Runtime.getRuntime().exec("su");
            out = process.getOutputStream();
            // 调用安装
            out.write(("pm install -r " + currenttempfilepath + "\n").getBytes());
            in = process.getInputStream();
            int len = 0;
            byte[] bs = new byte[256];
            while (-1 != (len = in.read(bs))) {
                String state = new String(bs, 0, len);
                if (state.equals("success\n")) {
                    //安装成功后的操作

                    //静态注册自启动广播
                    Intent intent = new Intent();
                    //与清单文件的receiver的anction对应
                    intent.setAction("android.intent.action.PACKAGE_REPLACED");
                    //发送广播
                    activity.sendBroadcast(intent);
                }
            }
        } catch (IOException e) {
            e.printStackTrace();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (out != null) {
                    out.flush();
                    out.close();
                }
                if (in != null) {
                    in.close();
                }
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
    }

    /**
     * Android 重启应用本身
     *
     * @param context
     */
    public static void restartApplication(Context context) {
        final Intent intent = context.getPackageManager().getLaunchIntentForPackage(context.getPackageName());
        intent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP);
        context.startActivity(intent);
        android.os.Process.killProcess(android.os.Process.myPid());
    }

    /**
     * 字符串转类
     *
     * @param string 字符串
     * @param clazz  类
     * @param <T>    t
     * @return t
     */
    public static <T> T stringToObject(String string, Class clazz) {
        return (T) GsonUtil.fromJson(string, clazz);
    }

    public static String getTwo(String str) {
        //方法一：最简便的方法，调用DecimalFormat类
        DecimalFormat df = new DecimalFormat("0.00");
        double adds = 0.0;
        if (!StringUtils.isEmpty(str)) {
            adds = Double.parseDouble(str);
            return df.format(adds);
        } else {
            return "";
        }


    }

    public static SpannableStringBuilder setSype(String context, int start, int end, String color) {
        //为文本框设置多种颜色
        SpannableStringBuilder style = new SpannableStringBuilder(context);
        ForegroundColorSpan foregroundColorSpan = new ForegroundColorSpan(Color.parseColor(color));
        style.setSpan(foregroundColorSpan, start, end, Spannable.SPAN_EXCLUSIVE_EXCLUSIVE);
        return style;
    }

    /**
     * 是否是游客并去登录
     *
     * @param context
     * @return
     */
    public static boolean isTourist1(Context context) {
        SharedPreferences sp = context.getSharedPreferences("User", Context.MODE_PRIVATE);
        String userType = sp.getString("userType", "Null");
        if (!StringUtils.isEmpty(userType) && StringUtils.equals("guest", userType)) {
            return true;
        }
        return false;
    }

    /**
     * 是否是游客并去登录
     *
     * @param context
     * @return
     */
    public static boolean isTourist2(Context context) {
        SharedPreferences sp = context.getSharedPreferences("User", Context.MODE_PRIVATE);
        String userType = sp.getString("userType", "Null");
        if (StringUtils.equals("Null", userType) || StringUtils.equals("guest", userType)) {
//            Intent intent = null;
//            if (Uiutils.setBaColor(context,null)){
//                intent = new Intent(context, BlackLoginActivity.class);
//            }else{
//                intent = new Intent(context, LoginActivity.class);
//            }
//            context.startActivity(intent);
            Uiutils.login(context);
            return true;
        }
        return false;
    }


    /**
     * 是否是游客并去登录
     *
     * @param context
     * @return
     */
    public static boolean isTourist(Context context) {
        SharedPreferences sp = context.getSharedPreferences("User", Context.MODE_PRIVATE);
        String userType = sp.getString("userType", "Null");
        if (!StringUtils.isEmpty(userType) && StringUtils.equals("guest", userType)) {
//            Intent intent = new Intent(context, LoginActivity.class);
//            context.startActivity(intent);
            Uiutils.login(context);
            return true;
        }
        return false;
    }

    public static String getPassHin(Context context) {
        ConfigBean configBean = (ConfigBean) ShareUtils.getObject(context, SPConstants.CONFIGBEAN, ConfigBean.class);
        String name = "请输入6-16位字母加数字";
        if (null != configBean) {
            if (StringUtils.isEmpty(configBean.getData().getPass_length_min()) ||
                    StringUtils.isEmpty(configBean.getData().getPass_length_max()) ||
                    Integer.parseInt(configBean.getData().getPass_length_min()) < 6) {
                if (StringUtils.isEmpty(configBean.getData().getPass_limit())) {
                    name = "请输入6-16位字母加数字";
                } else if (StringUtils.equals("0", configBean.getData().getPass_limit())) {
                    name = "请输入6-16位密码";
                } else if (StringUtils.equals("1", configBean.getData().getPass_limit())) {
                    name = "请输入6-16位数字字母";
                } else if (StringUtils.equals("2", configBean.getData().getPass_limit())) {
                    name = "请输入6-16位数字字母符号";
                }
            } else {
                if (StringUtils.isEmpty(configBean.getData().getPass_limit())) {
                    name = "请输入" + configBean.getData().getPass_length_min() + "-" +
                            configBean.getData().getPass_length_max() + "位字母加数字";
                } else if (StringUtils.equals("0", configBean.getData().getPass_limit())) {
                    name = "请输入" + configBean.getData().getPass_length_min() + "-" +
                            configBean.getData().getPass_length_max() + "位密码";
                } else if (StringUtils.equals("1", configBean.getData().getPass_limit())) {
                    name = "请输入" + configBean.getData().getPass_length_min() + "-" +
                            configBean.getData().getPass_length_max() + "位数字字母";
                } else if (StringUtils.equals("2", configBean.getData().getPass_limit())) {
                    name = "请输入" + configBean.getData().getPass_length_min() + "-" +
                            configBean.getData().getPass_length_max() + "位数字字母符号";
                }
            }
        }
        return name;
    }

    /**
     * textview.settext做非空处理
     *
     * @param textView
     * @param name
     */
    public static void setText(TextView textView, String name) {

        if (null == textView)
            return;

        if (StringUtils.isEmpty(name)) {
            textView.setText("");
        } else {
            if (name.contains("<p>")) {
                CharSequence charSequence = Html.fromHtml(name);
                textView.setText(charSequence);
            } else {
                textView.setText(name);
            }
        }
    }

    /**
     * 签名加密
     *
     * @param map
     */
    public static Map<String, Object> sginEncrypt(Map<String, Object> map) {
        if (null != map) {
            for (String key : map.keySet()) {
                try {
                    if (map.get(key) instanceof Double ||
                            map.get(key) instanceof Long ||
                            map.get(key) instanceof Integer ||
                            map.get(key) instanceof String) {

                        map.put(key, SecretUtils.DESede((String) map.get(key)));
                    } else if (map.get(key) instanceof List) {
                        if (null != ((List) map.get(key)) && ((List) map.get(key)).size() > 0) {
                            List<Object> list = ((List) map.get(key));
                            for (int i = 0; i < list.size(); i++) {
                                if (list.get(i) instanceof Double ||
                                        list.get(i) instanceof Long ||
                                        list.get(i) instanceof Integer ||
                                        list.get(i) instanceof String) {
                                    list.set(i, SecretUtils.DESede((String) map.get(list.get(i))));
                                } else if (list.get(i) instanceof Map) {
                                    if (null != list.get(i) && ((Map) list.get(i)).size() > 0) {
                                        for (Object keyslist : ((Map) list.get(i)).keySet()) {
                                            if (((Map) list.get(i)).get(keyslist) instanceof Double ||
                                                    ((Map) list.get(i)).get(keyslist) instanceof Long ||
                                                    ((Map) list.get(i)).get(keyslist) instanceof Integer ||
                                                    ((Map) list.get(i)).get(keyslist) instanceof String) {
                                                ((Map) list.get(i)).put(keyslist, SecretUtils.DESede((String) ((Map) list.get(i)).get(keyslist)));
                                            }
                                        }
                                    }
                                }
                            }
                            map.put(key, list);
                        }
                    } else if (map.get(key) instanceof Map) {
                        if (null != map.get(key) && ((Map) map.get(key)).size() > 0) {
                            for (String keys : map.keySet()) {
                                if (map.get(key) instanceof Double ||
                                        map.get(key) instanceof Long ||
                                        map.get(key) instanceof Integer ||
                                        map.get(key) instanceof String) {
                                    ((Map) map.get(key)).put(keys, SecretUtils.DESede((String) map.get(keys)));
                                }
                            }
                        }

                        map.put(key, ((Map) map.get(key)));
                    }

                } catch (Exception e) {

                }
            }
            map.put("sign", SecretUtils.RsaToken());
        }
        return map;
    }

    /***
     * 请求成功提示
     * @param object
     * @param context
     */
    public static void onSuccessTao(String object, Context context) {
        BaseBean baseBean = Uiutils.stringToObject(object, BaseBean.class);
        if (null != baseBean && !StringUtils.isEmpty(baseBean.getMsg()))
            ToastUtil.toastShortShow(context, baseBean.getMsg());
    }

    // 两次点击按钮之间的点击间隔不能少于1000毫秒
    public static final int MIN_CLICK_DELAY_TIME = 500;
    public static long lastClickTime = 0;

    public static boolean isFastClick() {
        boolean flag = false;
        long curClickTime = System.currentTimeMillis();
        if ((curClickTime - lastClickTime) >= MIN_CLICK_DELAY_TIME) {
            flag = true;
        }
        lastClickTime = curClickTime;
        return flag;
    }

    public static String romTwo(String time) {
        if (StringUtils.isEmpty(time)) {
            return "";
        } else {
            if (time.length() > 1) {
                return time.substring(2, time.length());
            }

            return time;
        }
    }


    public static Bitmap base64ToBitmap(String base64Data) {
        byte[] bytes = Base64.decode(base64Data, Base64.DEFAULT);
        return BitmapFactory.decodeByteArray(bytes, 0, bytes.length);
    }

    /**
     * 屏幕宽（可减边距）
     *
     * @param context
     * @return
     */
    public static int getWith(Context context, int id) {
        Point point = MeasureUtil.getScreenSize(context);
        int with = point.x - MeasureUtil.dip2px(context
                , id);

        return with;
    }


    public static void setBa(Context context, View holder) {
        int type = ShareUtils.getInt(context, "sTheme", 0);
        switch (type) {
            case R.style.AppTheme:
                holder.setBackgroundResource(R.drawable.shape_home_custom_item_bg);
                break;
            case R.style.AppTheme1:
                holder.setBackgroundResource(R.drawable.shape_home_ticket_bg1);
                if (BuildConfig.FLAVOR.equals("c213")) {
                    GradientDrawable drawable = (GradientDrawable) holder.getBackground();
                    drawable.setStroke(2, context.getResources().getColor(R.color.white));
                }
                break;
            case R.style.AppTheme2:
                holder.setBackgroundResource(R.drawable.shape_home_ticket_bg2);
                break;
            case R.style.AppTheme3:
                holder.setBackgroundResource(R.drawable.shape_home_ticket_bg3);
                break;
            case R.style.AppTheme4:
                holder.setBackgroundResource(R.drawable.shape_home_ticket_bg4);
                break;
            case R.style.AppTheme5:
                holder.setBackgroundResource(R.drawable.shape_home_ticket_bg5);
                break;
            case R.style.AppTheme6:
                holder.setBackgroundResource(R.drawable.shape_home_ticket_bg6);
                break;
            case R.style.AppTheme7:
                holder.setBackgroundResource(R.drawable.shape_home_ticket_bg7);
                break;
            case R.style.AppTheme8:
                holder.setBackgroundResource(R.drawable.shape_home_ticket_bg8);
                break;
            case R.style.AppTheme9:
                holder.setBackgroundResource(R.drawable.shape_home_ticket_bg9);
                break;
            case R.style.AppTheme10:
                holder.setBackgroundResource(R.drawable.shape_home_ticket_bg10);
                break;
            case R.style.AppTheme11:
                holder.setBackgroundResource(R.drawable.shape_home_ticket_bg11);
                break;
            case R.style.AppTheme12:
                holder.setBackgroundResource(R.drawable.shape_home_ticket_bg12);
                break;
            case R.style.AppTheme13:
                holder.setBackgroundResource(R.drawable.shape_home_ticket_bg13);
                break;
            case R.style.AppTheme14:
                holder.setBackgroundResource(R.drawable.shape_home_ticket_bg14);
                break;
            case R.style.AppTheme15:
            case R.style.AppTheme20_c199:
                holder.setBackgroundResource(R.drawable.shape_home_ticket_bg15);
                break;
            case R.style.AppTheme16:
                holder.setBackgroundResource(R.drawable.shape_home_ticket_bg16);
                break;
            case R.style.AppTheme17:
                holder.setBackgroundResource(R.drawable.shape_home_ticket_bg17);
                break;
            case R.style.AppTheme18:
                holder.setBackgroundResource(R.drawable.shape_home_ticket_bg18);
                break;
            case R.style.AppTheme19:
                holder.setBackgroundResource(R.drawable.shape_home_ticket_bg19);
                break;
            case R.style.AppTheme20:
                holder.setBackgroundResource(R.drawable.shape_home_ticket_bg20);
                break;
            case R.style.AppTheme21:
                holder.setBackgroundResource(R.drawable.shape_home_ticket_bg21);
                break;
            case R.style.AppTheme34:
                holder.setBackgroundResource(R.drawable.shape_home_ticket_bg34);
            case R.style.AppTheme35:
            case R.style.AppTheme36:
                holder.setBackgroundResource(R.drawable.shape_home_ticket_bg35);
                break;
            default:
                if (Uiutils.isSite("c228"))
                    holder.setBackgroundResource(R.drawable.shape_home_ticket);
                else
                    holder.setBackgroundResource(R.drawable.shape_home_ticket_bg1);

                break;
        }
    }

    public static void setBa1(Context context, View holder) {
        int type = ShareUtils.getInt(context, "sTheme", 0);
        switch (type) {
            case R.style.AppTheme:
                holder.setBackgroundResource(R.drawable.shape_home_custom_item_bg);
                break;
            case R.style.AppTheme1:
                holder.setBackgroundResource(R.drawable.shape_home_ticket_bg1);
                break;
            case R.style.AppTheme2:
                holder.setBackgroundResource(R.drawable.shape_home_ticket_bg2);
                break;
            case R.style.AppTheme3:
                holder.setBackgroundResource(R.drawable.shape_home_ticket_bg3);
                break;
            case R.style.AppTheme4:
                holder.setBackgroundResource(R.drawable.shape_home_ticket_bg4);
                break;
            case R.style.AppTheme5:
                holder.setBackgroundResource(R.drawable.shape_home_ticket_bg5);
                break;
            case R.style.AppTheme6:
                holder.setBackgroundResource(R.drawable.shape_home_ticket_bg6);
                break;
            case R.style.AppTheme7:
                holder.setBackgroundResource(R.drawable.shape_home_ticket_bg7);
                break;
            case R.style.AppTheme8:
                holder.setBackgroundResource(R.drawable.shape_home_ticket_bg8);
                break;
            case R.style.AppTheme9:
                holder.setBackgroundResource(R.drawable.shape_home_ticket_bg9);
                break;
            case R.style.AppTheme10:
                holder.setBackgroundResource(R.drawable.shape_home_ticket_bg10);
                break;
            case R.style.AppTheme11:
                holder.setBackgroundResource(R.drawable.shape_home_ticket_bg11);
                break;
            case R.style.AppTheme12:
                holder.setBackgroundResource(R.drawable.shape_home_ticket_bg12);
                break;
            case R.style.AppTheme13:
                holder.setBackgroundResource(R.drawable.shape_home_ticket_bg13);
                break;
            case R.style.AppTheme14:
                holder.setBackgroundResource(R.drawable.shape_home_ticket_bg14);
                break;
            case R.style.AppTheme15:
            case R.style.AppTheme20_c199:
                holder.setBackgroundResource(R.drawable.shape_home_ticket_bg15);
                break;
            case R.style.AppTheme16:
                holder.setBackgroundResource(R.drawable.shape_home_ticket_bg16);
                break;
            case R.style.AppTheme17:
                holder.setBackgroundResource(R.drawable.shape_home_ticket_bg17);
                break;
            case R.style.AppTheme18:
                holder.setBackgroundResource(R.drawable.shape_home_ticket_bg18);
                break;
            case R.style.AppTheme19:
                holder.setBackgroundResource(R.drawable.shape_home_ticket_bg19);
                break;
            case R.style.AppTheme20:
                holder.setBackgroundResource(R.drawable.shape_home_ticket_bg20);
                break;
            case R.style.AppTheme21:
                holder.setBackgroundResource(R.drawable.shape_home_ticket_bg21);
                break;
            case R.style.AppTheme34:
                holder.setBackgroundResource(R.drawable.shape_home_ticket_bg34);
                break;
            default:
                holder.setBackgroundResource(R.drawable.shape_home_ticket_bg1);
                break;
        }
    }

    public static void setMyBa(Context context, View holder) {
        int type = ShareUtils.getInt(context, "sTheme", 0);
        switch (type) {
            case R.style.AppTheme:
                holder.setBackgroundResource(R.drawable.theme_ba22);
                break;
            case R.style.AppTheme1:
                holder.setBackgroundResource(R.drawable.theme_ba1);
                break;
            case R.style.AppTheme2:
                holder.setBackgroundResource(R.drawable.theme_ba2);
                break;
            case R.style.AppTheme3:
                holder.setBackgroundResource(R.drawable.theme_ba3);
                break;
            case R.style.AppTheme4:
                holder.setBackgroundResource(R.drawable.theme_ba4);
                break;
            case R.style.AppTheme5:
                holder.setBackgroundResource(R.drawable.theme_ba5);
                break;
            case R.style.AppTheme6:
                holder.setBackgroundResource(R.drawable.theme_ba6);
                break;
            case R.style.AppTheme7:
                holder.setBackgroundResource(R.drawable.theme_ba7);
                break;
            case R.style.AppTheme8:
                holder.setBackgroundResource(R.drawable.theme_ba8);
                break;
            case R.style.AppTheme9:
                holder.setBackgroundResource(R.drawable.theme_ba9);
                break;
            case R.style.AppTheme10:
                holder.setBackgroundResource(R.drawable.theme_ba10);
                break;
            case R.style.AppTheme11:
                holder.setBackgroundResource(R.drawable.theme_ba11);
                break;
            case R.style.AppTheme12:
                holder.setBackgroundResource(R.drawable.theme_ba12);
                break;
            case R.style.AppTheme13:
                holder.setBackgroundResource(R.drawable.theme_ba13);
                break;
            case R.style.AppTheme14:
                holder.setBackgroundResource(R.drawable.theme_ba14);
                break;
            case R.style.AppTheme15:
            case R.style.AppTheme20_c199:
                holder.setBackgroundResource(R.drawable.theme_ba15);
                break;
            case R.style.AppTheme16:
                holder.setBackgroundResource(R.drawable.theme_ba16);
                break;
            case R.style.AppTheme17:
                holder.setBackgroundResource(R.drawable.theme_ba17);
                break;
            case R.style.AppTheme18:
                holder.setBackgroundResource(R.drawable.theme_ba18);
                break;
            case R.style.AppTheme19:
                holder.setBackgroundResource(R.drawable.theme_ba19);
                break;
            case R.style.AppTheme20:
                holder.setBackgroundResource(R.drawable.theme_ba20);
                break;
            case R.style.AppTheme21:
                holder.setBackgroundResource(R.drawable.theme_ba21);
                break;
            case R.style.AppTheme34:
                holder.setBackgroundResource(R.drawable.theme_ba34);
                break;
        }
    }

    public static void setBaColor(Context context, View view, boolean isarc, ArcView arcView) {
        if (0 != ShareUtils.getInt(context, "ba_top", 0)) {
            if (isarc && arcView != null)
                arcView.bgColor(context.getResources().getColor(ShareUtils.getInt(context, "ba_top", 0)));
            else if (!isarc && view != null)
                view.setBackgroundColor(context.getResources().getColor(ShareUtils.getInt(context, "ba_top", 0)));
        }

        if (view instanceof CustomTitleBar) {
            setBarStye0(view, context);
        }
    }

    public static boolean setBaColor(Context context, View view) {
        if (ShareUtils.getInt(context, "sTheme", 0) == R.style.AppThemeBlack) {
            if (0 != ShareUtils.getInt(context, "ba_center", 0)) {
                if (null != view)
                    view.setBackgroundColor(context.getResources().getColor(ShareUtils.getInt(
                            context, "ba_center", 0)));

                return true;
            }
        }
        return false;
    }


    public static void goWebView(Context context, String url, String title) {
//        Intent  intent = new Intent(context, AgentWebActivity.class);
//        intent.putExtra("url",url);
//        intent.putExtra("title",title);
//        context.startActivity(intent);

//        Bundle build = new Bundle();
//        build.putString("url", url.startsWith("http") ? url : "http://" + url);
//        build.putString("title", title);
//        FragmentUtilAct.startAct(context, new PubWebviewFrag(), build);

        if (!StringUtils.isEmpty(title) && StringUtils.equals("在线客服", title)) {
            SkipGameUtil.loadInnerWebviewUrl1(url, context, "isShowTitle", "");
        } else {
            SkipGameUtil.loadInnerWebviewUrl(url, context, "isShowTitle", "");
        }

    }


    public interface OnItemClickListener {
        void onItemClick(View view, int position);
    }


    public interface OnItemListener {
        void onItemClick(View view, My_item my_item);
    }

    public static void login(Context context) {
        ConfigBean configBean = (ConfigBean) ShareUtils.getObject(context, SPConstants.CONFIGBEAN, ConfigBean.class);
        if (configBean != null && configBean.getData() != null && configBean.getData().getMobileTemplateCategory() != null && configBean.getData().getMobileTemplateCategory().equals("5")) {
            context.startActivity(new Intent(context, BlackLoginActivity.class));
        } else {
            context.startActivity(new Intent(context, LoginActivity.class));
        }
    }

    public static boolean isSite(String siteName) {
        if (!StringUtils.isEmpty(siteName) && !StringUtils.isEmpty(BuildConfig.FLAVOR) &&
                StringUtils.equals(BuildConfig.FLAVOR.toLowerCase(), siteName.toLowerCase())) {
            return true;
        } else {
            return false;
        }
    }

    public static String getDateStr(Date date, String format) {
        if (format == null || format.isEmpty()) {
            format = "yyyy-MM-dd HH:mm:ss";
        }
        SimpleDateFormat formatter = new SimpleDateFormat(format);
        return formatter.format(date);
    }

    public static String getDateStr(String time) {
        String names = "";
        SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        Date nowDate = new Date();
        Date oldDate = null;
        try {
            if (!StringUtils.isEmpty(time)) {
                oldDate = formatter.parse(time);
            }
            if (null != oldDate) {
                long timeDiff = (nowDate.getTime() - oldDate.getTime()) / 1000;
                if (timeDiff < 1 * 60) {
                    // 1小時内
                    return "刚刚";
                } else if (timeDiff < 1 * 60 * 60) {
                    // 1小時内
                    return (int) (timeDiff / 60) + "分钟前";
                } else if (timeDiff < 24 * 60 * 60
//                    && oldDate.getDate() == nowDate.getDate()
                ) {
                    // 24小時内
                    return (int) (timeDiff / 3600) + "小时前";
                } else {
                    String newtime = Uiutils.getPastDate(1);
                    if (!StringUtils.isEmpty(newtime) && !StringUtils.isEmpty(time) && time.contains(newtime)) {
                        return "昨天";
                    } else {
                        return time;
                    }
                }
            }
        } catch (Exception e) {
        }
        return names;
    }


    @RequiresApi(api = Build.VERSION_CODES.ICE_CREAM_SANDWICH)
    public static void viewSloshing(View iv) {
        ObjectAnimator nopeAnimator = SeekAttentionView.tada(iv);
        nopeAnimator.setRepeatCount(ValueAnimator.INFINITE);
        nopeAnimator.start();
    }


    public static int getTheme(Context context) {
        String name = ShareUtils.getString(context, "themid", "");
        int id = 0;
        switch (name) {
            case "23":
                id = R.drawable.theme_ba23;
                break;
            case "24":
                id = R.drawable.theme_ba24;
                break;
            case "25":
                id = R.drawable.theme_ba25;
                break;
            case "26":
                id = R.drawable.theme_ba26;
                break;
            case "27":
                id = R.drawable.theme_ba27;
                break;
            case "28":
                id = R.drawable.theme_ba28;
                break;
            case "29":
                id = R.drawable.theme_ba29;
                break;
            case "30":
                id = R.drawable.theme_ba30;
                break;
            case "31":
                id = R.drawable.theme_ba31;
                break;
            case "32":
                id = R.drawable.theme_ba32;
                break;
            case "33":
                id = R.drawable.theme_ba33;
                break;
        }
        return id;
    }


    /**
     * 加载html标签
     *
     * @param bodyHTML
     * @return
     */
    public static String getHtmlData(String bodyHTML) {
        String head = "<head>" +
                "<meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0, user-scalable=no\"> " +
                "<style>img{max-width: 100%; width:auto; height:auto!important;}</style>" +
                "<style>* {font-size:10px !important}</style>" +
                "</head>";
        return "<html>" + head + "<body>" + bodyHTML + "</body></html>";

    }

    /**
     * 加载html标签
     *
     * @param bodyHTML
     * @return
     */
    public static String getHtmlData1(String bodyHTML) {
        String head = "<head>" +
                "<meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0, user-scalable=no\"> " +
                "<style>img{max-width: 100%; width:auto; height:auto!important;}</style>" +
                "</head>";
        return "<html>" + head + "<body>" + bodyHTML + "</body></html>";

    }

    public static void setStateColor(Activity activity) {
        if (null == activity)
            return;

        String themetyp = ShareUtils.getString(activity, "themetyp", "");
        String themid = ShareUtils.getString(activity, "themid", "");
        if (!StringUtils.isEmpty(themetyp) && StringUtils.equals("4", themetyp) &&
                !StringUtils.isEmpty(themid) && StringUtils.equals("25", themid)) {
            ((BaseActivity) activity).setStatusBarView();

        }
    }

    public static boolean isTheme(Context context) {
        String themetyp = ShareUtils.getString(context, "themetyp", "");
        String themid = ShareUtils.getString(context, "themid", "");
        if (!StringUtils.isEmpty(themetyp) && StringUtils.equals("4", themetyp) &&
                !StringUtils.isEmpty(themetyp) && StringUtils.equals("25", themid)) {
            return true;
        } else {
            return false;
        }
    }


    public static boolean isSixBa(Context context) {
        String themetyp = ShareUtils.getString(context, "themetyp", "");
        if (!StringUtils.isEmpty(themetyp) && StringUtils.equals("0", themetyp)
                && (Uiutils.isSite("c085")
                || Uiutils.isSite("c175") || Uiutils.isSite("c073") || Uiutils.isSite("c169")
                || Uiutils.isSite("a002") || Uiutils.isSite("c190") || Uiutils.isSite("c200") || Uiutils.isSite("c208") || Uiutils.isSite("c212")
                || Uiutils.isSite("c001")|| Uiutils.isSite("c134"))
        ) {
            return true;
        }
        return false;
    }

    public static String parsePercent(Object obj) {
        Double d = Double.parseDouble(obj.toString());
        java.text.NumberFormat percentFormat = java.text.NumberFormat.getPercentInstance();
        percentFormat.setMaximumFractionDigits(2); //最大小数位数
        percentFormat.setMaximumIntegerDigits(3);//最大整数位数
        percentFormat.setMinimumFractionDigits(3); //最小小数位数
        percentFormat.setMinimumIntegerDigits(1);//最小整数位数
        return percentFormat.format(d);//自动转换成百分比显示
    }


}

