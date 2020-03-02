package com.phoenix.lotterys.view;

import android.content.Context;
import androidx.appcompat.widget.AppCompatCheckBox;
import android.util.AttributeSet;

import com.phoenix.lotterys.R;import com.phoenix.lotterys.R2;

/**
 * Greated by Luke
 * on 2019/8/9
 */
public class RoundCheckBox extends AppCompatCheckBox {
    public  RoundCheckBox(Context context) {
        this(context, null);
    }

    public  RoundCheckBox(Context context, AttributeSet attrs) {
        this(context, attrs, R.attr.radioButtonStyle);
    }

    public  RoundCheckBox(Context context, AttributeSet attrs, int defStyleAttr) {
        super(context, attrs, defStyleAttr);
    }
}
