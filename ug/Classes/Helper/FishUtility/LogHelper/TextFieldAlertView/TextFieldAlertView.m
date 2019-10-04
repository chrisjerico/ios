//
//  TextFieldAlertView.m
//  C
//
//  Created by fish on 2018/3/23.
//  Copyright © 2018年 fish. All rights reserved.
//

#import "TextFieldAlertView.h"

@interface TextFieldAlertView ()
@property (weak, nonatomic) IBOutlet UIView *alertView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@end

@implementation TextFieldAlertView

- (void)awakeFromNib {
    [super awakeFromNib];
    // 键盘事件
    __weakSelf_(__self);
    [self xw_addNotificationForName:UIKeyboardWillShowNotification block:^(NSNotification * _Nonnull noti) {
        CGRect rect = [[[noti userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
        CGFloat offsetY = __self.alertView.height/2 + rect.size.height - APP.Height/2 + 30;
        __self.alertView.zj_constraints.centerY.constant = MIN(-offsetY, 0);
    }];
    [self xw_addNotificationForName:UIKeyboardWillHideNotification block:^(NSNotification * _Nonnull noti) {
        __self.alertView.zj_constraints.centerY.constant = 0;
    }];
}

- (void)didMoveToSuperview {
    [super didMoveToSuperview];
    _titleLabel.text = _NSString(@"请输入%@", _title);
    _textField.placeholder = _placeholder ? : _titleLabel.text;
    _textField.text = _text;
}

- (void)show {
    self.alpha = 0;
    self.frame = APP.Window.bounds;
    [NavController1.topView addSubview:self];
    _alertView.transform = CGAffineTransformMakeScale(1.5, 1.5);
    
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 1;
        _alertView.transform = CGAffineTransformIdentity;
    }];
    [_textField becomeFirstResponder];
}

- (void)showToWindow {
    self.alpha = 0;
    self.frame = APP.Window.bounds;
    [APP.Window addSubview:self];
    _alertView.transform = CGAffineTransformMakeScale(1.5, 1.5);
    
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 1;
        _alertView.transform = CGAffineTransformIdentity;
    }];
    [_textField becomeFirstResponder];
}

- (IBAction)hide {
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (IBAction)onConfirmBtnClick:(UIButton *)sender {
    if (_didConfirmBtnClick)
        _didConfirmBtnClick(self, _textField.text);
}

@end
