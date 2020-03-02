package com.phoenix.lotterys.my.fragment

import android.annotation.SuppressLint
import android.content.Context
import android.content.Intent
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import android.text.TextUtils
import android.text.format.DateUtils
import android.util.Log
import android.view.View
import android.widget.ImageView
import android.widget.TextView
import com.lzy.okgo.OkGo
import com.lzy.okgo.model.Response
import com.phoenix.lotterys.R
import com.phoenix.lotterys.application.BaseFragments
import com.phoenix.lotterys.coupons.adapter.CouponsAdapter
import com.phoenix.lotterys.coupons.bean.CouponsBean
import com.phoenix.lotterys.main.webview.GoWebActivity
import com.phoenix.lotterys.my.bean.BaseBean
import com.phoenix.lotterys.my.bean.RedEnvelopesBean
import com.phoenix.lotterys.util.*
import com.phoenix.lotterys.util.recyclerUtil.BaseRecyclerAdapter
import com.phoenix.lotterys.util.recyclerUtil.BaseRecyclerHolder
import com.scwang.smartrefresh.layout.api.RefreshLayout
import com.scwang.smartrefresh.layout.listener.OnLoadMoreListener
import com.scwang.smartrefresh.layout.listener.OnRefreshListener
import kotlinx.android.synthetic.main.red_envelopes_fgt.*
import kotlinx.android.synthetic.main.red_envelopes_fgt.view.*
import org.jetbrains.anko.find
import java.io.IOException
import java.net.URLDecoder
import java.util.*

/**
 * 文件描述:扫雷记录、红包记录
 * 创建者: IAN
 * 创建时间: 2019/7/3 19:51
 */
@SuppressLint("ValidFragment")
class RedEnvelopesFragment @SuppressLint("ValidFragment") constructor()
    : BaseFragments(R.layout.red_envelopes_fgt), BaseRecyclerAdapter.OnItemClickListener, OnRefreshListener, OnLoadMoreListener {
    //
//    @BindView(R2.id.titlebar)
//    CustomTitleBar titlebar
//    @BindView(R2.id.iv_back)
//    ImageView iv_back
//
//    @BindView(R2.id.mail_rec)
//    RecyclerView rec_view
//    @BindView(R2.id.smart_refresh_layout)
//    smart_refresh_layout smart_refresh_layout
    private val postion = 0
    private val contextTex: TextView? = null
    private val contentView: View? = null
    private var adapter: RedAdapter? = null
    private var page = 1
    private val rows = 20
    private var redBean: RedEnvelopesBean? = null
    private val list = ArrayList<RedEnvelopesBean.DataBean.ListBean>()
    //    private val mCustomPopWindow: CustomPopWindow? = null
//    var isRead = false
//    var isHide = false
    override fun initView(v: View) {
        v.titlebar.setRIghtTvVisibility(0x00000008)
        v.titlebar.setLeftIconOnClickListener { activity?.finish() }
//
        val linearLayoutManager = androidx.recyclerview.widget.LinearLayoutManager(context)
        v.rec_view.layoutManager = linearLayoutManager
//        v.rec_view.addItemDecoration(SpacesItemDecoration(context, 3))

        adapter = RedAdapter(context, mutableListOf(), R.layout.red_envelopes_item)

//        adapter.setOnItemClickListener(this)
        v.rec_view.adapter = adapter

        v.smart_refresh_layout.setOnRefreshListener(this)
        v.smart_refresh_layout.setOnLoadMoreListener(this)

        v.smart_refresh_layout.setEnableLoadMore(false)
        v.smart_refresh_layout.setEnableRefresh(true)
//
//        contentView = LayoutInflater.from(getContext()).inflate(R.layout.revoke_pop, null)
//        contentView.findViewById(R.id.clear_tex).setOnClickListener(this)
//        contentView.findViewById(R.id.commit_tex).setOnClickListener(this)
//        ((TextView) contentView.findViewById(R.id.title_tex)).setText(R.string.message_content)
//        contextTex = ((TextView) contentView.findViewById(R.id.context_tex))
//
//        popupWindowBuilder = Uiutils.setPopSetting(getContext(), contentView,
//                MeasureUtil.dip2px(getContext(), 300),
//                ViewGroup.LayoutParams.WRAP_CONTENT,
//                true, true, 0.5f)
//
        requestData(true)
//        if(isHide)
//            titlebar.setIvBackHide(View.GONE)
//
        Uiutils.setBaColor(context, v.titlebar, false, null)
        Uiutils.setBarStye0(v.titlebar, context)

        if (arguments?.get("type") == RED_MINE) {
            v.titlebar.setText(resources.getString(R.string.red_mine_envelopes))
        } else {
            v.titlebar.setText(resources.getString(R.string.red_envelopes))
        }
    }

    private fun requestData(isShow: Boolean) {
        val map = HashMap<String, Any>()
        val type = arguments?.get("type") ?: ""
        map["type"] = type
        map["token"] = Uiutils.getToken(context)
        map["page"] = "$page"
        map["rows"] = "$rows"


//        OkGo.get<String>(URLDecoder.decode(Constants.BaseUrl() + Constants.RED_ENVELOPES))
//                .tag(this) //
//                .execute(object : NetDialogCallBack(context, true, this,
//                        true, RedEnvelopesBean::class.java) {
//                    @Throws(IOException::class)
//                    override fun onUi(o: Any) {
//                        redBean = o as RedEnvelopesBean
//                        if (page == 1 && list.isNotEmpty()) {
//                            list.clear()
//                        }
//                    }
//
//                    @Throws(IOException::class)
//                    override fun onErr(bb: BaseBean) {
//                        smart_refresh_layout.finishRefresh()
//                    }
//
//                    override fun onFailed(response: Response<String>) {
//                        smart_refresh_layout.finishRefresh()
//                    }
//                })

        NetUtils.post(Constants.RED_ENVELOPES, map, true, context, object : NetUtils.NetCallBack {
            override fun onSuccess(obj: String?) {
                smart_refresh_layout.finishRefresh()
                smart_refresh_layout.finishLoadMore()
                redBean = GsonUtil.fromJson(obj, RedEnvelopesBean::class.java)

                if (page == 1 && list.isNotEmpty()) {
                    list.clear()
                }

                if(redBean?.data?.list?.isNotEmpty() == true) {
                    list.addAll(redBean!!.data!!.list)
                }

                if (redBean?.data?.total != null && list.size < redBean?.data?.total!!.toInt()) {
                    smart_refresh_layout.setEnableLoadMore(true)
                } else {
                    smart_refresh_layout.setEnableLoadMore(false)
                }

                adapter?.updateData(list.toMutableList())
            }

            override fun onError() {
                smart_refresh_layout?.finishRefresh()
                smart_refresh_layout?.finishLoadMore()
            }
        })
//        NetUtils.get(Constants.MSGLIST , map, true, context
//                , NetUtils.NetCallBack() {
//                    @Override
//                    public void onSuccess(String object) {
//                        smart_refresh_layout.finishRefresh()
//                        smart_refresh_layout.finishLoadMore()
//
//                        mailFragBean = GsonUtil.fromJson(object, MailFragBean.class)
//
//                        if (page == 1) {
//                            if (list.size() > 0)
//                                list.clear()
//                        }
//
//
//                        if (null != mailFragBean && null != mailFragBean.getData() && null != mailFragBean.
//                                getData().getList() && mailFragBean.getData().getList().size() > 0) {
//                            list.addAll(mailFragBean.getData().getList())
//                        }
//
//                        if (null != mailFragBean && list.size() != mailFragBean.getData().getTotal()) {
//                            smart_refresh_layout.setEnableLoadMore(true)
//                        } else {
//                            smart_refresh_layout.setEnableLoadMore(false)
//                        }
//
//                        adapter.notifyDataSetChanged()
//                    }
//
//                    @Override
//                    public void onError() {
//                        if (null!=smart_refresh_layout) {
//                            smart_refresh_layout.finishRefresh()
//                            smart_refresh_layout.finishLoadMore()
//                        }
//                    }
//                })
    }

    override fun onItemClick(parent: androidx.recyclerview.widget.RecyclerView, view: View, position: Int) { //        //防止快速点击
//        if (!Uiutils.isFastClick()) {
//            return
//        }
//        this.postion = position
//        contextTex.setText(list.get(position)
//                .getContent())
//        mCustomPopWindow = popupWindowBuilder.create()
//        mCustomPopWindow.showAtLocation(contentView, Gravity.CENTER, 0, 0)
//       Uiutils.setStateColor(getActivity())
//
//        setRead()
    }

//    override fun onClick(v: View) { //        switch (v.getId()) {
//            case R.id.clear_tex:
//                mCustomPopWindow.dissmiss()
//                Uiutils.setStateColor(getActivity())
//                break
//            case R.id.commit_tex:
//                mCustomPopWindow.dissmiss()
//                Uiutils.setStateColor(getActivity())
//                break
//            case R.id.iv_back:
//                if (isRead) {
//                    EventBus.getDefault().post(new Even(EvenBusCode.READ))
//                }
//                if (!isHide)
//                    getActivity().finish()
//                break
//
//        }
//    }

//    override fun onResume() {
//        super.onResume()
//        focus
//    }//        getView().setFocusableInTouchMode(true)
//        getView().requestFocus()
//        getView().setOnKeyListener(new View.OnKeyListener() {
//            @Override
//            public boolean onKey(View v, int keyCode, KeyEvent event) {
//                if (event.getAction() == KeyEvent.ACTION_UP && keyCode == KeyEvent.KEYCODE_BACK) {
//                    // 监听到返回按钮点击事件
//                    if (isRead) {
//                        EventBus.getDefault().post(new Even(EvenBusCode.READ))
//                    }
//                    if (!isHide)
//                        getActivity().finish()
//                    return true
//                }
//                return false
//            }
//        })

//    //主界面获取焦点
//    private val focus: Unit
//        private get() { //        getView().setFocusableInTouchMode(true)
////        getView().requestFocus()
////        getView().setOnKeyListener(new View.OnKeyListener() {
////            @Override
////            public boolean onKey(View v, int keyCode, KeyEvent event) {
////                if (event.getAction() == KeyEvent.ACTION_UP && keyCode == KeyEvent.KEYCODE_BACK) {
////                    // 监听到返回按钮点击事件
////                    if (isRead) {
////                        EventBus.getDefault().post(new Even(EvenBusCode.READ))
////                    }
////                    if (!isHide)
////                        getActivity().finish()
////                    return true
////                }
////                return false
////            }
////        })
//        }

//    private fun setRead() { //        Map<String,Object> httpParams = new HashMap<>()
////        httpParams.put("token", Uiutils.getToken(getContext()))
////        httpParams.put("id", list.get(postion).getId())
////
////        NetUtils.post(Constants.READMSG, httpParams, true, getContext(),
////                new NetUtils.NetCallBack() {
////                    @Override
////                    public void onSuccess(String object) {
////                        list.get(postion).setIsRead(1)
////                        adapter.notifyDataSetChanged()
////                        isRead = true
////
////
////                    }
////
////                    @Override
////                    public void onError() {
////                    }
////                })
//    }

    override fun onLoadMore(refreshLayout: RefreshLayout) {
        page++
        requestData(false)
    }

    override fun onRefresh(refreshLayout: RefreshLayout) {
        page = 1
        requestData(false)
    }

//    override fun onDestroy() {
//        //        if (isRead) {
////            EventBus.getDefault().post(new Even(EvenBusCode.READ))
////        }
//        super.onDestroy()
//    }

//    override fun getEvenMsg(even: Even<*>?) { //        switch (even.getCode()) {
////            case EvenBusCode.CHANGE_THEME_STYLE_MYF:
////                Uiutils.setBaColor(getContext(),titlebar, false, null)
////                break
////        }
//    }

    override fun onTransformResume() {
        page = 1
        requestData(false)
    }

//    init {
//        this.isHide = isHide
//    }

    companion object {
        const val RED_NORMAL = "1"         //普通红包
        const val RED_MINE = "2"        //扫雷红包
    }
}

class RedAdapter(context: Context?, list: MutableList<RedEnvelopesBean.DataBean.ListBean>, itemLayoutId: Int)
    : BaseRecyclerAdapter<RedEnvelopesBean.DataBean.ListBean>(context, list, itemLayoutId) {

    override fun convert(holder: BaseRecyclerHolder?, item: RedEnvelopesBean.DataBean.ListBean?, position: Int, isScrolling: Boolean) {
        holder?.itemView?.find<ImageView>(R.id.iv_bg)?.alpha = if (position % 2 == 0) 0.3f else 0.2f
        holder?.itemView?.find<TextView>(R.id.tv_date)?.text = StampToDate.stampToDate2(item?.createTime!! * 1000)
        holder?.itemView?.find<TextView>(R.id.tv_des)?.text = item.operateText
        val pms = if(item.operate == "1" || item.operate == "4") "-" else "+"
        holder?.itemView?.find<TextView>(R.id.tv_red_money)?.text = pms + item.amount
    }

}