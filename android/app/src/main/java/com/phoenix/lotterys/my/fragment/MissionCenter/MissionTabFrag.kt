package com.phoenix.lotterys.my.fragment.MissionCenter

import android.os.Bundle
import com.google.android.material.tabs.TabLayout
import androidx.fragment.app.Fragment
import androidx.fragment.app.FragmentManager
import androidx.fragment.app.FragmentPagerAdapter
import androidx.viewpager.widget.PagerAdapter
import android.view.View
import android.widget.TextView
import com.phoenix.lotterys.R
import com.phoenix.lotterys.application.BaseFragments
import com.phoenix.lotterys.my.bean.MissionCategoryBean
import com.phoenix.lotterys.util.Constants
import com.phoenix.lotterys.util.GsonUtil
import com.phoenix.lotterys.util.NetUtils
import com.phoenix.lotterys.util.NetUtils.NetCallBack
import kotlinx.android.synthetic.main.mission_tab_frag.view.*
import org.jetbrains.anko.find
import rx.Observable
import rx.android.schedulers.AndroidSchedulers
import java.util.concurrent.TimeUnit


/**
 * 文件描述:  任务大厅分类
 * 创建者: IAN
 * 创建时间: 2019/7/3 12:56
 */
class MissionTabFrag : BaseFragments(R.layout.mission_tab_frag, true, true) {

    override fun initView(v: View) {
        getData(false)
    }

    private fun initTabs(bean: MissionCategoryBean) {

        //生成 标签
        val tabs = bean.data.withIndex().map {
            val mission1 = MissionHallFrag()
            val bdl1 = Bundle()
            bdl1.putString("type", it.value.id)
            mission1.arguments = bdl1
            mission1
        }

        val adapter = TabAdapter(childFragmentManager, tabs)

        view?.view_pager?.offscreenPageLimit = 3
        view?.view_pager?.adapter = adapter
        view?.view_pager?.addOnPageChangeListener(TabLayout.TabLayoutOnPageChangeListener(view?.tb_missing_tab))

        view?.tb_missing_tab?.setupWithViewPager(view?.view_pager)

        view?.tb_missing_tab?.addOnTabSelectedListener(object : TabLayout.OnTabSelectedListener{
            override fun onTabReselected(p0: TabLayout.Tab?) {

            }

            override fun onTabUnselected(p0: TabLayout.Tab?) {
                val tabName = p0?.customView?.find<TextView>(R.id.tab_name)
                unSelectTab(tabName)
            }

            override fun onTabSelected(p0: TabLayout.Tab?) {
                val tabName = p0?.customView?.find<TextView>(R.id.tab_name)
                selectTab(tabName)
            }
        })

        //对标签设置样式
        bean.data.withIndex().map {
            val tab = view?.tb_missing_tab?.getTabAt(it.index)
//            view?.tb_missing_tab?.addTab(tab!!)

            tab?.setCustomView(R.layout.mission_tab_frag_cust_tab)
            val textView = tab?.customView?.findViewById<TextView>(R.id.tab_name)
            textView?.text = bean.data[it.index].sortName
            if(it.index == 0) {
                selectTab(textView)
            }
        }
    }

    private fun selectTab(tabName: TextView?) {
        tabName?.setBackgroundResource(R.drawable.shape_ticket_dialog_title_bg_5)
        tabName?.setTextColor(context?.resources?.getColor(R.color.white)!!)
    }

    private fun unSelectTab(tabName: TextView?) {
        tabName?.setBackgroundColor(context?.resources?.getColor(R.color.transparent)!!)
        tabName?.setTextColor(context?.resources?.getColor(R.color.black1)!!)
    }

    private fun getData(b: Boolean) {
        NetUtils.get(Constants.CENTER_CATEGORY, mapOf(), b, context, object : NetCallBack {
            override fun onSuccess(str: String) {
                val bean = GsonUtil.fromJson(str, MissionCategoryBean::class.java)
                initTabs(bean)
            }

            override fun onError() {

            }
        })
    }

    inner class TabAdapter(fm: androidx.fragment.app.FragmentManager, private val fgts: List<androidx.fragment.app.Fragment>) : androidx.fragment.app.FragmentPagerAdapter(fm) {

        override fun getCount(): Int {
            return fgts.size
        }

        override fun getItemPosition(`object`: Any): Int {
            return androidx.viewpager.widget.PagerAdapter.POSITION_NONE
        }

        override fun getItem(p0: Int): androidx.fragment.app.Fragment {
            return fgts[p0]
        }
    }
}