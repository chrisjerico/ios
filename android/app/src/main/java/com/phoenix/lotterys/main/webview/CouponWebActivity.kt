package com.phoenix.lotterys.main.webview

import android.content.Context
import android.view.View
import com.phoenix.lotterys.R
import com.phoenix.lotterys.coupons.bean.CouponsBean
import com.wanxiangdai.commonlibrary.util.ImageLoadUtil
import kotlinx.android.synthetic.main.coupon_web_activity.*
import org.jetbrains.anko.startActivity

class CouponWebActivity: GoWebActivity(R.layout.coupon_web_activity) {

//    companion object {
//        fun start(ctx: Context, bean: CouponsBean.DataBean.ListBean) {
//            ctx.startActivity<CouponWebActivity>("data" to bean)
//        }
//    }

    override fun initView() {
        super.initView()

        top_area_ll.visibility = View.VISIBLE
        val bean = intent.getSerializableExtra(CouponsBean.DataBean.ListBean.TAG) as CouponsBean.DataBean.ListBean?
        ImageLoadUtil.ImageLoadGifRound(bean?.pic, this, iv_img)
        tv_title.text = bean?.title
    }

}