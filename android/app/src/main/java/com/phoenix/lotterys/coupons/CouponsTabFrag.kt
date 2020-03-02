package com.phoenix.lotterys.coupons

import android.content.Context
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
import com.phoenix.lotterys.main.FragmentUtilAct
import kotlinx.android.synthetic.main.activity_select_lottery_ticket.*
import kotlinx.android.synthetic.main.coupons_tab_frag.view.*
import org.jetbrains.anko.find
import java.io.Serializable


/**
 * 文件描述:  优惠券分类
 * 创建者: IAN
 * 创建时间: 2019/7/3 12:56
 */
class CouponsTabFrag : BaseFragments(R.layout.coupons_tab_frag, true, true) {

    companion object {
        fun start(ctx: Context, data: Map<String, String>) {
            val fgt = CouponsTabFrag()
            val bdl = Bundle()
            bdl.putSerializable("data", data as Serializable)
            fgt.arguments = bdl
            FragmentUtilAct.startAct(ctx, fgt)
        }
    }


    override fun initView(v: View) {
        val bean = arguments?.getSerializable("data") as Map<String, String>
        initTabs(v, bean)
        v.titlebar.setLeftIconOnClickListener { activity?.finish() }
    }

    private fun initTabs(view: View, data: Map<String, String>) {
        //需要在头部手动加入一个全部优惠
        val lstData = mutableListOf(Pair("", "全部优惠"))
        lstData.addAll(data.toList())

        //生成 标签
        val tabs = lstData.map {
            val mission1 = CouponsFragment(true, true)
            val bdl1 = Bundle()
            bdl1.putString("type", it.first)
            mission1.arguments = bdl1
            mission1
        }

        val adapter = TabAdapter(childFragmentManager, tabs)

        view.view_pager?.offscreenPageLimit = 3
        view.view_pager?.adapter = adapter
        view.view_pager?.addOnPageChangeListener(TabLayout.TabLayoutOnPageChangeListener(view.tb_coupons_tab))

        view.tb_coupons_tab?.setupWithViewPager(view.view_pager)

        view.tb_coupons_tab?.addOnTabSelectedListener(object : TabLayout.OnTabSelectedListener {
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
        lstData.withIndex().map {
            val tab = view.tb_coupons_tab?.getTabAt(it.index)
//            view.tb_coupons_tab?.addTab(tab!!)

            tab?.setCustomView(R.layout.coupon_tab_frag_cust_tab)
            val textView = tab?.customView?.findViewById<TextView>(R.id.tab_name)
            textView?.text = it.value.second
            if (it.index == 0) {
                selectTab(textView)
            }
        }
    }

    private fun selectTab(tabName: TextView?) {
//        tabName?.setBackgroundResource(R.drawable.shape_translucent_black)
        tabName?.setBackgroundColor(context?.resources?.getColor(R.color.transparent22)!!)
//        tabName?.setTextColor(context?.resources?.getColor(R.color.white)!!)
    }

    private fun unSelectTab(tabName: TextView?) {
        tabName?.setBackgroundColor(context?.resources?.getColor(R.color.transparent)!!)
//        tabName?.setTextColor(context?.resources?.getColor(R.color.white)!!)
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