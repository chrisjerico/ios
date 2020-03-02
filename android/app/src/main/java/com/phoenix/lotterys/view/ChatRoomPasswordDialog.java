package com.phoenix.lotterys.view;

import android.app.Dialog;
import android.content.Context;
import androidx.annotation.NonNull;
import android.view.View;
import android.widget.EditText;
import com.phoenix.lotterys.R;import com.phoenix.lotterys.R2;
import com.wanxiangdai.commonlibrary.util.SystemUtils;

import butterknife.BindView;
import butterknife.ButterKnife;
import butterknife.OnClick;

/**
 * @author : Wu
 * @e-mail : wu_developer@outlook.com
 * @date : 2020/01/09 15:48
 * @description :
 */
public class ChatRoomPasswordDialog extends Dialog {

    public interface OnPasswordListener {
        void onSureClick(String password);

        void onDismiss();
    }

    @BindView(R2.id.et_input)
    EditText etInput;

    private OnPasswordListener mOnPasswordListener;

    public ChatRoomPasswordDialog(@NonNull Context context) {
        super(context, R.style.MyMDDialog);
        //点击屏幕空白消失
        setCanceledOnTouchOutside(false);
        //点击返回键消失
        setCancelable(false);
        setContentView(R.layout.dialog_chat_room_password);
        ButterKnife.bind(this, this);
    }

    public ChatRoomPasswordDialog setOnPasswordListener(OnPasswordListener mOnPasswordListener) {
        this.mOnPasswordListener = mOnPasswordListener;
        return this;
    }

    @OnClick({R.id.fl_parent, R.id.btn_cancel, R.id.btn_sure})
    public void onViewClicked(View view) {
        switch (view.getId()) {
            case R.id.fl_parent:
            case R.id.btn_cancel:
                dismiss();
                break;
            case R.id.btn_sure:
                setOnDismissListener(null);
                if (mOnPasswordListener != null) {
                    mOnPasswordListener.onSureClick(etInput.getText().toString());
                }
                dismiss();
                break;
        }
    }

    @Override
    public void show() {
        super.show();
        setOnDismissListener(dialog -> mOnPasswordListener.onDismiss());

        etInput.getText().clear();
        etInput.requestFocus();
        etInput.requestFocusFromTouch();
        SystemUtils.openKeyBord(etInput.getContext(), etInput);
    }

    @Override
    public void dismiss() {
        SystemUtils.closeKeyBord(etInput.getContext(), etInput);
        super.dismiss();
    }
}
