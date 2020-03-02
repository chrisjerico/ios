package com.phoenix.lotterys.buyhall.activity

import android.content.Context
import com.phoenix.lotterys.R
import com.phoenix.lotterys.util.Uiutils
import com.wanxiangdai.commonlibrary.base.BaseActivity
import kotlinx.android.synthetic.main.activity_buy_hall_type.*
import org.jetbrains.anko.startActivity

/**
 * Created by Luke
 * on 2019/6/13
 */
class BuyHallTypeActivity : BaseActivity(R.layout.activity_buy_hall_type) {

    companion object {
        fun start(ctx: Context) {
            ctx.startActivity<BuyHallTypeActivity>()

        }
    }

    override fun initView() {
        super.initView()
        titlebar.setLeftIconOnClickListener {
            finish()
        }

        Uiutils.setBaColor(this, titlebar, false, null)
        Uiutils.setBarStye0(titlebar, this)

    }
}