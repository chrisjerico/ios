package com.phoenix.lotterys.my.fragment;

import android.os.Bundle;
import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;
import android.util.Log;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.example.zhouwei.library.CustomPopWindow;
import com.phoenix.lotterys.R;import com.phoenix.lotterys.R2;
import com.phoenix.lotterys.application.BaseFragments;
import com.phoenix.lotterys.home.fragment.SixThemeBbsDetailFrament;
import com.phoenix.lotterys.main.FragmentUtilAct;
import com.phoenix.lotterys.my.adapter.DynamicAdapter;
import com.phoenix.lotterys.my.adapter.PubAttentionSonAdapter;
import com.phoenix.lotterys.my.bean.CommentBean;
import com.phoenix.lotterys.my.bean.FavContentListBean;
import com.phoenix.lotterys.my.bean.FormulaBean;
import com.phoenix.lotterys.my.bean.HistoryContentBean;
import com.phoenix.lotterys.my.bean.MailFragBean;
import com.phoenix.lotterys.util.Constants;
import com.phoenix.lotterys.util.NetUtils;
import com.phoenix.lotterys.util.Uiutils;
import com.phoenix.lotterys.util.recyclerUtil.BaseRecyclerAdapter;
import com.scwang.smartrefresh.layout.SmartRefreshLayout;
import com.scwang.smartrefresh.layout.api.RefreshLayout;
import com.scwang.smartrefresh.layout.listener.OnLoadMoreListener;
import com.scwang.smartrefresh.layout.listener.OnRefreshListener;
import com.wanxiangdai.commonlibrary.util.EvenBusUtil.Even;
import com.wanxiangdai.commonlibrary.util.EvenBusUtil.EvenBusCode;
import com.wanxiangdai.commonlibrary.util.EvenBusUtil.EvenBusUtils;
import com.wanxiangdai.commonlibrary.util.MeasureUtil;
import com.wanxiangdai.commonlibrary.util.StringUtils;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import butterknife.BindView;
import butterknife.OnClick;

/**
 * 文件描述: 六合公共(例表)
 * 创建者: IAN
 * 创建时间: 2019/10/18 12:35
 */
public class PubAttentionSonFrag extends BaseFragments implements OnRefreshListener,
        OnLoadMoreListener, BaseRecyclerAdapter.OnItemClickListener, View.OnClickListener {


    @BindView(R2.id.mail_rec)
    RecyclerView mailRec;
    @BindView(R2.id.smart_refresh_layout)
    SmartRefreshLayout smartRefreshLayout;
    @BindView(R2.id.go_essayist_tex)
    TextView goEssayistTex;
    @BindView(R2.id.like_tex)
    TextView likeTex;
    @BindView(R2.id.go_essayist_tex1)
    TextView goEssayistTex1;
    @BindView(R2.id.attention_tex)
    TextView attentionTex;
    @BindView(R2.id.go_comm)
    LinearLayout goComm;
    @BindView(R2.id.main_lin)
    LinearLayout mainLin;
    @BindView(R2.id.empty_lin)
    LinearLayout emptyLin;

    private List<Serializable> list = new ArrayList<>();
    private BaseRecyclerAdapter<Serializable> adapter;

    public PubAttentionSonFrag() {
        super(R.layout.pub_attention_son_frag, true, true);
    }

    private int type;

    private int page = 1;
    private int rows = 20;

    private String id;

    private String contentId;

    private CommentBean.DataBean.ListBean listBean;

    private String isLike;
    @Override
    public void initView(View view) {
        goComm.setVisibility(View.GONE);

        type = getArguments().getInt("type");
        id = getArguments().getString("id");
        contentId = getArguments().getString("contentId");
        listBean = (CommentBean.DataBean.ListBean) getArguments().getSerializable("listBean");

        if (null!=listBean&&!StringUtils.isEmpty(listBean.getIsLike()))
            isLike =listBean.getIsLike();

        smartRefreshLayout.setOnRefreshListener(this);
        smartRefreshLayout.setOnLoadMoreListener(this);
        smartRefreshLayout.setEnableLoadMore(false);
        smartRefreshLayout.setEnableRefresh(true);

        setAda();
    }

    private CustomPopWindow.PopupWindowBuilder popupWindowBuilder;
    private View contentView;
    private CustomPopWindow mCustomPopWindow;

    private TextView title_tex;
    private TextView money_tex;

    private void setPop(String title,String money) {
        contentView = LayoutInflater.from(getContext()).inflate(R.layout.component_pop, null);
        contentView.findViewById(R.id.clear_tex).setOnClickListener(this);
        contentView.findViewById(R.id.commit_tex).setOnClickListener(this);

        title_tex =((TextView) contentView.findViewById(R.id.title_tex));
        money_tex =((TextView) contentView.findViewById(R.id.money_tex));

        popupWindowBuilder = Uiutils.setPopSetting(getContext(), contentView,
                MeasureUtil.dip2px(getContext(), 300),
                ViewGroup.LayoutParams.WRAP_CONTENT,
                true, true, 0.5f);

        Uiutils.setText(title_tex,title);
        if (StringUtils.isEmpty(money)){
            Uiutils.setText(money_tex,"打赏 "+0 +" 元");
        }else{
            Uiutils.setText(money_tex,"打赏 "+money +" 元");
        }

        mCustomPopWindow = popupWindowBuilder.create();
        mCustomPopWindow.showAtLocation(contentView, Gravity.CENTER, 0, 0);
        Uiutils.setStateColor(getActivity());
    }

    private void  show(String title,String money){
        setPop(title,money);
    }

    private void getRe(boolean b) {
        switch (type) {
            case 12:
                getLiuHe(b);
                break;
            case 13:
                getLiuHe(b);
                break;
            case 17:
                getList(b);
                break;
            case 11:
                getContentList(b);
                break;
            case 4:
                getFansList(b);
                break;
            case 5:
                getFansList(b);
                break;
            case 3:
                getFansList(b);
                break;
            case 2:
                getFansList(b);
                break;
            case 1:
                getFansList(b);
                break;
            default:
                getData(b);
                break;
        }
    }

    private void getFansList(boolean b) {
        String url = null;
        if (type == 4) {
            url = Constants.FANSLIST;
        }else if (type == 5) {
            url = Constants.CONTENTFANSLIST;
        }else if (type == 3) {
            url = Constants.HISTORYCONTENT;
        }else if (type == 2) {
            url = Constants.FAVCONTENTLIST;
        }else if (type == 1) {
            url = Constants.FOLLOWLIST;
        } else {
            url = Constants.FANSLIST;
        }

        Map<String, Object> map = new HashMap<>();
        map.put("token", Uiutils.getToken(getContext()));
        if (type!=2) {
            map.put("page", page + "");
            map.put("rows", rows + "");
        }
        NetUtils.get(url, map, b, getContext(), new NetUtils.NetCallBack() {
            @Override
            public void onSuccess(String object) {
                if (null != smartRefreshLayout) {
                    smartRefreshLayout.finishLoadMore();
                    smartRefreshLayout.finishRefresh();
                }
                if (type==4||type==5||type==1){
                commentBean = Uiutils.stringToObject(object, CommentBean.class);
                if (null != commentBean && null != commentBean.getData() && null != commentBean.getData().getList()) {
                    if (page == 1)
                        list.clear();

                    if (commentBean.getData().getList().size() > 0)
                        list.addAll(commentBean.getData().getList());

                    if (null != adapter) {
                        adapter.notifyDataSetChanged();
                    }
                    if (list.size() == commentBean.getData().getTotal()) {
                        smartRefreshLayout.setEnableLoadMore(false);
                    } else {
                        smartRefreshLayout.setEnableLoadMore(true);
                    }
                 }
                }else if (type==3){
                    historyContentBean = Uiutils.stringToObject(object, HistoryContentBean.class);
                    if (null != historyContentBean && null != historyContentBean.getData() && null
                            != historyContentBean.getData().getList()) {
                        if (page == 1)
                            list.clear();

                        if (historyContentBean.getData().getList().size() > 0)
                            list.addAll(historyContentBean.getData().getList());

                        if (null != adapter) {
                            adapter.notifyDataSetChanged();
                        }
                        if (list.size() == historyContentBean.getData().getTotal()) {
                            smartRefreshLayout.setEnableLoadMore(false);
                        } else {
                            smartRefreshLayout.setEnableLoadMore(true);
                        }
                    }
                }
                else if (type==2){
                    favContentListBean = Uiutils.stringToObject(object, FavContentListBean.class);
                    if (null != favContentListBean && null != favContentListBean.getData() ) {
                        if (page == 1)
                            list.clear();

                        if (favContentListBean.getData().size() > 0)
                            list.addAll(favContentListBean.getData());

                        if (null != adapter) {
                            adapter.notifyDataSetChanged();
                        }
                    }
                }
                    if (list.size()==0){
                        emptyLin.setVisibility(View.VISIBLE);
                    }else{
                        emptyLin.setVisibility(View.GONE);
                    }

            }

            @Override
            public void onError() {
                if (null != smartRefreshLayout) {
                    smartRefreshLayout.finishLoadMore();
                    smartRefreshLayout.finishRefresh();
                }
            }
        });

    }

    private FormulaBean formulaBean;

    private void getContentList(boolean b) {
        String alias = getArguments().getString("alias");
        Map<String, Object> map = new HashMap<>();
        map.put("alias", alias);
        map.put("page", page + "");
        map.put("rows", rows + "");
        map.put("token", Uiutils.getToken(getContext()));

        NetUtils.get(Constants.CONTENTLIST, map, b, getContext(), new NetUtils.NetCallBack() {
            @Override
            public void onSuccess(String object) {
                if (null != smartRefreshLayout) {
                    smartRefreshLayout.finishLoadMore();
                    smartRefreshLayout.finishRefresh();
                }

                formulaBean = Uiutils.stringToObject(object, FormulaBean.class);

                if (null != formulaBean && null != formulaBean.getData()) {

                    if (page == 1) {
                        if (list.size() > 0)
                            list.clear();
                    }

                    if (null != formulaBean.getData().getList() && formulaBean.getData().getList().size() > 0)
                        list.addAll(formulaBean.getData().getList());

                    if (null != adapter) {
                        adapter.notifyDataSetChanged();
                    }

                    if (list.size() == formulaBean.getData().getTotal()) {
                        smartRefreshLayout.setEnableLoadMore(false);
                    } else {
                        smartRefreshLayout.setEnableLoadMore(true);
                    }
                    if (list.size()==0){
                        emptyLin.setVisibility(View.VISIBLE);
                    }else{
                        emptyLin.setVisibility(View.GONE);
                    }
                }
            }

            @Override
            public void onError() {
                if (null != smartRefreshLayout) {
                    smartRefreshLayout.finishLoadMore();
                    smartRefreshLayout.finishRefresh();
                }
            }
        });
    }

    private CommentBean commentBean;
    private HistoryContentBean historyContentBean;
    private FavContentListBean favContentListBean;

    private void getList(boolean b) {
        Map<String, Object> map = new HashMap<>();
        map.put("contentId", contentId);
        map.put("replyPId", id);
        map.put("page", page + "");
        map.put("rows", rows + "");
        map.put("token", Uiutils.getToken(getContext()));

        NetUtils.get(Constants.CONTENTREPLYLIST, map, b, getContext(), new NetUtils.NetCallBack() {
            @Override
            public void onSuccess(String object) {
                if (null != smartRefreshLayout) {
                    smartRefreshLayout.finishLoadMore();
                    smartRefreshLayout.finishRefresh();
                }
                commentBean = Uiutils.stringToObject(object, CommentBean.class);

                if (null != commentBean && null != commentBean.getData() && null != commentBean.getData().getList()) {
                    if (page == 1)
                        list.clear();

                    if (null != listBean)
                        list.add(listBean);

                    if (commentBean.getData().getList().size() > 0)
                        list.addAll(commentBean.getData().getList());

                    if (null != adapter) {
                        adapter.notifyDataSetChanged();
                    }
                    if (null != listBean) {
                        if (list.size() - 1 == commentBean.getData().getTotal()) {
                            smartRefreshLayout.setEnableLoadMore(false);
                        } else {
                            smartRefreshLayout.setEnableLoadMore(true);
                        }
                    } else {
                        if (list.size() == commentBean.getData().getTotal()) {
                            smartRefreshLayout.setEnableLoadMore(false);
                        } else {
                            smartRefreshLayout.setEnableLoadMore(true);
                        }
                    }
                    if (list.size()==0){
                        emptyLin.setVisibility(View.VISIBLE);
                    }else{
                        emptyLin.setVisibility(View.GONE);
                    }
                }
            }
            @Override
            public void onError() {
            }
        });

    }

    private MailFragBean mailFragBean;
    private void getLiuHe(boolean b) {
        Map<String, Object> map = new HashMap<>();
        if (type == 12)
            map.put("showFav", "0");
        if (type == 13)
            map.put("showFav", "1");

        map.put("page", page + "");
        map.put("rows", rows + "");
        map.put("token", Uiutils.getToken(getContext()));

        NetUtils.get(Constants.TKLIST, map, b, getContext(), new NetUtils.NetCallBack() {
            @Override
            public void onSuccess(String object) {
                if (null != smartRefreshLayout) {
                    smartRefreshLayout.finishRefresh();
                    smartRefreshLayout.finishLoadMore();
                }
                mailFragBean = Uiutils.stringToObject(object, MailFragBean.class);

                if (null != mailFragBean && null != mailFragBean.getData() && null != mailFragBean.getData()
                        .getList()) {

                    if (page == 1)
                        list.clear();

                    if (mailFragBean.getData().getList().size() > 0) {
                        list.addAll(mailFragBean.getData().getList());
                    }

                    if (null != adapter)
                        adapter.notifyDataSetChanged();

                    if (list.size() == mailFragBean.getData().getTotal()) {
                        smartRefreshLayout.setEnableLoadMore(false);
                    } else {
                        smartRefreshLayout.setEnableLoadMore(true);
                    }

                } else {
                    smartRefreshLayout.setEnableLoadMore(false);
                }
                if (list.size()==0){
                    emptyLin.setVisibility(View.VISIBLE);
                }else{
                    emptyLin.setVisibility(View.GONE);
                }

            }

            @Override
            public void onError() {
                if (null != smartRefreshLayout) {
                    smartRefreshLayout.finishRefresh();
                    smartRefreshLayout.finishLoadMore();
                }
            }
        });
    }

    private void getData(boolean b) {
        if (null != adapter)
            adapter.notifyDataSetChanged();
    }

    private void setAda() {
        switch (type) {
            case 1:
                Uiutils.setRec(getContext(), mailRec, 0);
                adapter = new PubAttentionSonAdapter(getContext(), list, R.layout.attention_adapter, type);
                break;
            case 2:
                Uiutils.setRec(getContext(), mailRec, 0);
                adapter = new PubAttentionSonAdapter(getContext(), list, R.layout.attention_adapter, type);
                break;
            case 3:
                Uiutils.setRec(getContext(), mailRec, 1);
                adapter = new DynamicAdapter(getContext(), list, R.layout.dynamic_adapter, type);
                break;
            case 4:
                Uiutils.setRec(getContext(), mailRec, 0);
                adapter = new PubAttentionSonAdapter(getContext(), list, R.layout.attention_adapter, type);
                break;
            case 5:
                Uiutils.setRec(getContext(), mailRec, 0);
                adapter = new PubAttentionSonAdapter(getContext(), list, R.layout.attention_adapter, type);
                break;
            case 11: //公式
                Uiutils.setRec(getContext(), mailRec, 0);
                adapter = new PubAttentionSonAdapter(getContext(), list, R.layout.attention_formula_adapter, type);
                adapter.setOnItemClickListener(this);
                break;
            case 12: //六合图库
                Uiutils.setRec(getContext(), mailRec, 0);
                adapter = new PubAttentionSonAdapter(getContext(), list, R.layout.attention_adapter, type);
                break;
            case 13: //六合图库
                Uiutils.setRec(getContext(), mailRec, 0);
                adapter = new PubAttentionSonAdapter(getContext(), list, R.layout.attention_adapter, type);
                break;
            case 17: //六合图库
                mainLin.setBackgroundColor(getContext().getResources().getColor(R.color.color_white));
                Uiutils.setRec(getContext(), mailRec, 0);
                if (null != listBean)
                    list.add(listBean);
                adapter = new PubAttentionSonAdapter(getContext(), list, R.layout.comment_item, 97, true);

                goComm.setVisibility(View.VISIBLE);
                likeTex.setVisibility(View.INVISIBLE);
                goEssayistTex1.setVisibility(View.INVISIBLE);
                attentionTex.setVisibility(View.INVISIBLE);
                break;

        }
        mailRec.setAdapter(adapter);
        adapter.setOnItemClickListener(this);
    }

    @Override
    public void onLoadMore(@NonNull RefreshLayout refreshLayout) {
        page++;
        getRe(false);
    }

    @Override
    public void onRefresh(@NonNull RefreshLayout refreshLayout) {
        page = 1;
        getRe(false);
    }

    private String cid;
    private String alias;
    private FormulaBean.DataBean.ListBean listBean000;
    @Override
    public void onItemClick(RecyclerView parent, View view, int position) {
        Bundle build = null;
        switch (type) {
            case 2:
                build = new Bundle();
                if (list.size()>=position&&null!=list.get(position)&&list.get(position) instanceof  FavContentListBean.DataBean) {
                    FavContentListBean.DataBean dataBean =(FavContentListBean.DataBean)list.get(position);
                    if (null!=dataBean&&!StringUtils.isEmpty(dataBean.getCid())) {
                        cid = dataBean.getCid();
                        alias= dataBean.getAlias();
                        if ((!StringUtils.isEmpty(dataBean.getHasPay())&&StringUtils.equals("0",dataBean.getHasPay())&&
                                (!StringUtils.isEmpty(dataBean.getPrice())&&Double.parseDouble(dataBean.getPrice())>0))){
                            show(dataBean.getTitle(),dataBean.getPrice());
                        }else{
                         switch (dataBean.getAlias()){
                             case "forum" :
                                 FragmentUtilAct.startAct(getContext(), SixThemeBbsDetailFrament.getInstance("论坛详情", dataBean.getCid(),dataBean.getAlias()));
                                 break;
                             case "gourmet" :
                                 FragmentUtilAct.startAct(getContext(), SixThemeBbsDetailFrament.getInstance("论坛详情", dataBean.getCid(),dataBean.getAlias()));
                                 break;
                             default:
                                 build = new Bundle();
                                 build.putInt("type", 18);
                                 build.putString("id", dataBean.getCid());
                                 build.putString("type1", dataBean.getType());
                                 build.putString("type2", dataBean.getType2());
                                 FragmentUtilAct.startAct(getActivity(), new PubAttentionFrag(), build);
                                 break;
                         }

                        }
                    }
                }
                break;
            case 3:
                if (list.size()>=position&&null!=list.get(position)&&list.get(position) instanceof HistoryContentBean.DataBean.ListBean) {
                    HistoryContentBean.DataBean.ListBean dataBean = (HistoryContentBean.DataBean.ListBean) list.get(position);
                    if (null!=dataBean&&!StringUtils.isEmpty(dataBean.getCid())){
                        cid = dataBean.getCid();
                        alias= dataBean.getAlias();
                        if ((!StringUtils.isEmpty(dataBean.getHasPay())&&StringUtils.equals("0",dataBean.getHasPay())&&
                                (!StringUtils.isEmpty(dataBean.getPrice())&&Double.parseDouble(dataBean.getPrice())>0))){
                            show(dataBean.getTitle(),dataBean.getPrice());
                        }else{
                            FragmentUtilAct.startAct(getContext(), SixThemeBbsDetailFrament.getInstance("论坛详情", dataBean.getCid(),dataBean.getAlias()));
                        }
                    }
                }
                break;
            case 11:
                if (list.size()>=position&&null!=list.get(position)&&list.get(position) instanceof FormulaBean.DataBean.ListBean) {
                    FormulaBean.DataBean.ListBean dataBean = (FormulaBean.DataBean.ListBean) list.get(position);
                    if (null!=dataBean&&!StringUtils.isEmpty(dataBean.getCid())){
                        cid = dataBean.getCid();
                        alias= dataBean.getAlias();
                        if ((!StringUtils.isEmpty(dataBean.getHasPay())&&StringUtils.equals("0",dataBean.getHasPay())&&
                                (!StringUtils.isEmpty(dataBean.getPrice())&&Double.parseDouble(dataBean.getPrice())>0))){
                            listBean000 = dataBean ;
                            show(dataBean.getTitle(),dataBean.getPrice());
                        }else{
                            particulars(dataBean);
                            break;
                        }
                    }
                }
                break;
            case 12:
                build = new Bundle();
                build.putInt("type", 4);
                build.putString("main_id", "5");
                build.putString("id", ((MailFragBean.DataBean.ListBean) list.get(position)).getId());
                FragmentUtilAct.startAct(getActivity(), new PubAttentionFrag(), build);
                break;
            case 13:
                build = new Bundle();
                build.putInt("type", 4);
                build.putString("main_id", "5");
                build.putString("id", ((MailFragBean.DataBean.ListBean) list.get(position)).getId());
                FragmentUtilAct.startAct(getActivity(), new PubAttentionFrag(), build);
                break;
        }
    }

    private void particulars(FormulaBean.DataBean.ListBean position) {
        if (null==position)return;

        Bundle build;
        build = new Bundle();
        build.putInt("type", 4);
        build.putString("main_id", "4");
        build.putString("name",position.getTitle());
        build.putString("id", position.getCid());
        FragmentUtilAct.startAct(getActivity(), new PubAttentionFrag(), build);

        position =null;
    }

    private  int pos =-1;
    @Override
    public void getEvenMsg(Even even) {
        switch (even.getCode()) {
            case EvenBusCode.UNFRIENDED:
                cancelAttention((int)even.getData());
                break;
            case EvenBusCode.ATTENTION:
                cancelAttention1((int)even.getData());
                break;
            case EvenBusCode.LIKE:
                 pos =(Integer) even.getData();
                HistoryContentBean.DataBean.ListBean listBean =null;
                if (list.size()>=pos&&pos!=-1){
                    listBean =(HistoryContentBean.DataBean.ListBean)list.get(pos);
                }
                if (null!=listBean){
                    setComment((StringUtils.isEmpty(listBean.getIsLike())||StringUtils.equals("1",listBean.getIsLike()))
                            ?"0":"1","1",listBean.getCid());
                }
                break;
            case EvenBusCode.COMMENT1:
//                if (!Uiutils.isFastClick())
//                    return;
                Log.e("COMMENT1===","//");
                if (list.size()>=((Integer)even.getData())){
                    int id  = (Integer)even.getData();
                    if (list.get(id) instanceof CommentBean.DataBean.ListBean ) {
                        CommentBean.DataBean.ListBean listBean0 = (CommentBean.DataBean.ListBean) list.
                                get((Integer) even.getData());

                        if (null != listBean0) {
                            pos = (Integer) even.getData();
                            setComment((!StringUtils.isEmpty(listBean0.getIsLike()) && StringUtils.equals("1", listBean0.getIsLike()))
                                    ? "0" : "1", "2", listBean0.getId());
                        }
                    }
                }
                break;
        }
    }

    private void cancelAttention(int id) {
        Map<String,Object> map =new HashMap<>();
        String url = "";
        if (list.size()>=id) {
            if (list.get(id) instanceof CommentBean.DataBean.ListBean) {
                CommentBean.DataBean.ListBean listBean = (CommentBean.DataBean.ListBean) list.get(id);
                if (null == listBean)
                    return;
                map.put("posterUid", listBean.getPosterUid());
                map.put("followFlag","0");
                url = Constants.FOLLOWPOSTER;
            }else{
                return;
            }
        }else{
            return;
        }

        map.put("token",Uiutils.getToken(getContext()));

        NetUtils.get(url, map, true, getContext(), new NetUtils.NetCallBack() {
            @Override
            public void onSuccess(String object) {
                    Uiutils.onSuccessTao(object,getContext());

                    if (list.size()>=id)
                        list.remove(id);

                    if (null!=adapter)
                        adapter.notifyDataSetChanged();

                if (list.size()==0){
                    emptyLin.setVisibility(View.VISIBLE);
                }else{
                    emptyLin.setVisibility(View.GONE);
                }
            }

            @Override
            public void onError() {

            }
        });

    }
    private void cancelAttention1(int id) {
//        if (list.size(id;
        Map<String,Object> map =new HashMap<>();
        String url = "";
        if (list.size()>=id) {
            if (list.get(id) instanceof FavContentListBean.DataBean) {
                FavContentListBean.DataBean listBean = (FavContentListBean.DataBean) list.get(id);
                if (null == listBean)
                    return;
                map.put("id", listBean.getCid());
                map.put("favFlag", "0");
                map.put("type", "2");
                url = Constants.DOFAVORITES;
            }else{
                return;
            }
        }else{
            return;
        }
        map.put("token",Uiutils.getToken(getContext()));

        NetUtils.get(url, map, true, getContext(), new NetUtils.NetCallBack() {
            @Override
            public void onSuccess(String object) {
                Uiutils.onSuccessTao(object,getContext());

                if (list.size()>=id)
                    list.remove(id);

                if (null!=adapter)
                    adapter.notifyDataSetChanged();

                if (list.size()==0){
                    emptyLin.setVisibility(View.VISIBLE);
                }else{
                    emptyLin.setVisibility(View.GONE);
                }
            }

            @Override
            public void onError() {

            }
        });

    }

    private void setComment(String likeFlag ,String type,String rid ){
        if (StringUtils.isEmpty(rid))
            return;

        Log.e("setComment==",rid+"//000");
        Map<String,Object> map =new HashMap<>();
        map.put("rid",rid);
        map.put("likeFlag",likeFlag);
        map.put("type",type);
        map.put("token",Uiutils.getToken(getContext()));

        NetUtils.get(Constants.LIKEPOST, map, true, getContext(), new NetUtils.NetCallBack() {
            @Override
            public void onSuccess(String object) {
                Uiutils.onSuccessTao(object,getContext());
                       if (pos!=-1&&list.size()>=pos){
                           if (list.get(pos) instanceof HistoryContentBean.DataBean.ListBean){
                               if (!StringUtils.isEmpty(likeFlag)&&StringUtils.equals("1",likeFlag)) {
                                   if (!StringUtils.isEmpty(((HistoryContentBean.DataBean.ListBean) list.get(pos)).getLikeNum())) {
                                       int i = Integer.parseInt(((HistoryContentBean.DataBean.ListBean) list.get(pos)).getLikeNum());
                                       ((HistoryContentBean.DataBean.ListBean) list.get(pos)).setLikeNum(i+1 + "");
                                   }
                               }else{
                                   if (!StringUtils.isEmpty(((HistoryContentBean.DataBean.ListBean) list.get(pos)).getLikeNum())) {
                                       int i = Integer.parseInt(((HistoryContentBean.DataBean.ListBean) list.get(pos)).getLikeNum());
                                       ((HistoryContentBean.DataBean.ListBean) list.get(pos)).setLikeNum(i-1 + "");
                                   }
                               }
                               ((HistoryContentBean.DataBean.ListBean) list.get(pos)).setIsLike(likeFlag);
                               if (null!=adapter)
                                   adapter.notifyDataSetChanged();
                           }else if (list.get(pos) instanceof CommentBean.DataBean.ListBean){
                               CommentBean.DataBean.ListBean listBean =(CommentBean.DataBean.ListBean)list.get(pos);
                               if (null!=listBean){
                                   if (!StringUtils.isEmpty(((CommentBean.DataBean.ListBean) list.get(pos)).getIsLike())) {
                                       if (StringUtils.equals("1", ((CommentBean.DataBean.ListBean) list.get(pos)).getIsLike())) {
                                           ((CommentBean.DataBean.ListBean) list.get(pos)).setIsLike("0");
                                           if (!StringUtils.isEmpty(((CommentBean.DataBean.ListBean) list.get(pos)).getLikeNum())&&
                                                   Integer.parseInt(((CommentBean.DataBean.ListBean) list.get(pos)).getLikeNum())>0) {
                                               int i = Integer.parseInt(((CommentBean.DataBean.ListBean) list.get(pos)).getLikeNum())-1;
                                               ((CommentBean.DataBean.ListBean) list.get(pos)).setLikeNum(i + "");
                                           }else{
                                               ((CommentBean.DataBean.ListBean) list.get(pos)).setLikeNum("");
                                           }
                                       } else {
                                           ((CommentBean.DataBean.ListBean) list.get(pos)).setIsLike("1");
                                           if (!StringUtils.isEmpty(((CommentBean.DataBean.ListBean) list.get(pos)).getLikeNum())
                                                   && Integer.parseInt(((CommentBean.DataBean.ListBean) list.get(pos)).getLikeNum())>0) {
                                               int i = Integer.parseInt(((CommentBean.DataBean.ListBean) list.get(pos)).getLikeNum())+1;
                                               ((CommentBean.DataBean.ListBean) list.get(pos)).setLikeNum(i + "");
                                           }else{
                                               ((CommentBean.DataBean.ListBean) list.get(pos)).setLikeNum("1");
                                           }
                                       }
                                   }

                                   if (null!=adapter)
                                       adapter.notifyDataSetChanged();
                               }

                           }
                       }
            }

            @Override
            public void onError() {
            }
        });
    }

    @OnClick({R.id.go_essayist_tex})
    public void onClick(View view) {
        switch (view.getId()) {
            case R.id.go_essayist_tex:
                Bundle build = new Bundle();
                build.putInt("type", 10);
                build.putString("contentId", contentId);
                build.putString("replyPId", id);
                FragmentUtilAct.startAct(getActivity(), new PubAttentionFrag(), build);
                break;
            case R.id.clear_tex:
                if (null != mCustomPopWindow){
                    mCustomPopWindow.dissmiss();
                    Uiutils.setStateColor(getActivity());}
                break;
            case R.id.commit_tex:
                if (null != mCustomPopWindow){
                    mCustomPopWindow.dissmiss();
                Uiutils.setStateColor(getActivity());
        }
                goPlay();
                break;
        }
    }

    private void goPlay() {
        if (StringUtils.isEmpty(cid)||StringUtils.isEmpty(alias))
            return;

        Map<String,Object> map =new HashMap<>();
        map.put("cid",cid);
        map.put("token",Uiutils.getToken(getContext()));

        NetUtils.post(Constants.BUYCONTENT, map, true, getContext(), new NetUtils.NetCallBack() {
            @Override
            public void onSuccess(String object) {
                Uiutils.onSuccessTao(object,getContext());
                if (type!=11)
                FragmentUtilAct.startAct(getContext(), SixThemeBbsDetailFrament.getInstance("论坛详情", cid,alias));
                else
                    particulars(listBean000);
            }

            @Override
            public void onError() {
            }
        });
    }

    @Override
    public void onDestroy() {
        Log.e("aaaa","///");
        if (type==17){
            if (list.size()>0){
                if (list.get(0) instanceof CommentBean.DataBean.ListBean){
                    CommentBean.DataBean.ListBean listBean =(CommentBean.DataBean.ListBean)list.get(0);
                    if (null!=listBean) {
                        if (!StringUtils.isEmpty(isLike) && !StringUtils.isEmpty(listBean.getIsLike()) &&
                                !StringUtils.equals(isLike, listBean.getIsLike())) {
                            EvenBusUtils.setEvenBus(new Even(EvenBusCode.COMMENT2));
                        }
                    }
                }
            }
        }
        super.onDestroy();
    }


    @Override
    public void onResume() {
        super.onResume();
        page = 1;
        getRe(true);

    }
}
