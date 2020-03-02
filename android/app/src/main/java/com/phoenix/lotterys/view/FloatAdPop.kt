package com.phoenix.lotterys.view

import android.content.Context
import android.view.View
import com.bumptech.glide.Glide
import com.phoenix.lotterys.R
import com.phoenix.lotterys.home.bean.FloatAdBean
import kotlinx.android.synthetic.main.pop_float_ad.view.*
import org.jetbrains.anko.sdk27.coroutines.onClick
import razerdp.basepopup.BasePopupWindow

class FloatAdPop(context: Context?) : BasePopupWindow(context) {

    private var clickLis: View.OnClickListener? = null

    override fun onCreateContentView(): View {
        setAllowDismissWhenTouchOutside(false)
        setBackPressEnable(false)
        setBackgroundColor(context.resources.getColor(R.color.transparent))

        val view = createPopupById(R.layout.pop_float_ad)

        view.iv_ad_close.onClick {
            dismiss()
        }

        view.iv_float_ad.onClick {
            clickLis?.onClick(it)
        }

        return view
    }

    fun refreshData(bean: FloatAdBean.DataBean): FloatAdPop {
        Glide.with(context)
                .load(bean.image)
                .into(contentView.iv_float_ad)
        return this
    }

    fun setOnClickImageListener(lis: View.OnClickListener): FloatAdPop {
        this.clickLis = lis
        return this
    }
}