//
//  LHPostCommentInputView.m
//  C
//
//  Created by fish on 2019/4/1.
//  Copyright © 2019 fish. All rights reserved.
//

#import "LHPostCommentInputView.h"

#define TextViewMinHeight 60
#define FontSize 14

@interface LHPostCommentInputView ()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *textView;      /**<    输入框TextView */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *inputViewBottomConstraint;

@property (nonatomic) void (^onSend)(NSString *text, BOOL willFlow);
@property (nonatomic) void (^onCancel)(void);
@end

@implementation LHPostCommentInputView

+ (NSMutableDictionary *)bufferText {
    static NSMutableDictionary *bt;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        bt = [@{} mutableCopy];
    });
    return bt;
}

+ (LHPostCommentInputView *)show1:(UGLHPostModel *)pm {
    NSString *textKey = _NSString(@"pm-%@", pm.cid);
    
    __weak LHPostCommentInputView *aciv = _LoadView_from_nib_(@"LHPostCommentInputView");
    FastSubViewCode(aciv);
    subLabel(@"标题Label").text = @"评论";
    subLabel(@"占位文本Label").text = @"请写出您的评论...";
    aciv.textView.attributedText = [self bufferText][textKey];
    aciv.onCancel = ^{
        [LHPostCommentInputView bufferText][textKey] = aciv.textView.attributedText;
    };
    aciv.onSend = ^(NSString *text, BOOL willFlow) {
        [HUDHelper showLoadingViewWithSuperview:aciv];
        [NetworkManager1 lhdoc_postContentReply:pm.cid rid:nil content:text].completionBlock = ^(CCSessionModel *sm) {
            [HUDHelper hideLoadingView];
            if (!sm.error) {
                if (aciv.didComment)
                    aciv.didComment(text);
                aciv.textView.text = @"";
                [aciv.textView resignFirstResponder];
                [AlertHelper showAlertView:sm.responseObject[@"msg"] msg:nil btnTitles:@[@"确定"]];
            } else {
                NSNumber *hasNickname = sm.responseObject[@"extra"][@"hasNickname"];
                if (hasNickname && !hasNickname.boolValue) {
                    sm.noShowErrorHUD = true;
                    
                    __block UITextField *__tf = nil;
                    [LEEAlert alert].config
                    .LeeTitle(@"论坛昵称")
                    .LeeContent(@"为了保护您的隐私，请绑定论坛昵称")
                    .LeeAddTextField(^(UITextField *textField) {
                        textField.placeholder = @"请输入昵称：1-8个汉字";
                        textField.textColor = [UIColor darkGrayColor];
                        textField.限制长度 = 8;
                        __tf = textField;
                    })
                    .LeeCancelAction(@"取消", nil) // 点击事件的Block如果不需要可以传nil
                    .LeeDestructiveAction(@"好的", ^{
                        if (!__tf.text) {
                            return ;
                        }
                        if (!__tf.text.isChinese) {
                            [HUDHelper showMsg:@"请输入纯汉字昵称"];
                            return;
                        }
                        [NetworkManager1 lhcdoc_setNickname:__tf.text].successBlock = ^(id responseObject) {
                            if (aciv.onSend) {
                                aciv.onSend(text, willFlow);
                            }
                        };
                    })
                    .leeShouldActionClickClose(^(NSInteger index){
                        // 是否可以关闭回调, 当即将关闭时会被调用 根据返回值决定是否执行关闭处理
                        // 这里演示了与输入框非空校验结合的例子
                        BOOL result = ![__tf.text isEqualToString:@""];
                        result = index == 1 ? result : YES;
                        return result;
                    })
                    .LeeShow();
                }
            }
        };
    };
    [aciv textViewDidChange:aciv.textView];
    [aciv show];
    return aciv;
}
+ (LHPostCommentInputView *)show2:(UGLHPostCommentModel *)pcm {
    NSString *textKey = _NSString(@"pcm-%@", pcm.pid);
    
    __weak LHPostCommentInputView *aciv = _LoadView_from_nib_(@"LHPostCommentInputView");
    FastSubViewCode(aciv);
    subLabel(@"标题Label").text = @"回复";
    subLabel(@"占位文本Label").text = _NSString(@"回复@%@", pcm.nickname);
    aciv.textView.attributedText = [self bufferText][textKey];
    aciv.onCancel = ^{
        [LHPostCommentInputView bufferText][textKey] = aciv.textView.attributedText;
    };
    aciv.onSend = ^(NSString *text, BOOL willFlow) {
        [HUDHelper showLoadingViewWithSuperview:aciv];
        [NetworkManager1 lhdoc_postContentReply:pcm.cid rid:pcm.pid content:text].completionBlock = ^(CCSessionModel *sm) {
            [HUDHelper hideLoadingView];
            if (!sm.error) {
                if (aciv.didComment)
                    aciv.didComment(text);
                aciv.textView.text = @"";
                [aciv.textView resignFirstResponder];
                [AlertHelper showAlertView:sm.responseObject[@"msg"] msg:nil btnTitles:@[@"确定"]];
            } else {
                NSNumber *hasNickname = sm.responseObject[@"extra"][@"hasNickname"];
                if (hasNickname && !hasNickname.boolValue) {
                    sm.noShowErrorHUD = true;
                    
                    __block UITextField *__tf = nil;
                    [LEEAlert alert].config
                    .LeeTitle(@"论坛昵称")
                    .LeeContent(@"为了保护您的隐私，请绑定论坛昵称")
                    .LeeAddTextField(^(UITextField *textField) {
                        textField.placeholder = @"请输入昵称：1-8个汉字";
                        textField.textColor = [UIColor darkGrayColor];
                        textField.限制长度 = 8;
                        __tf = textField;
                    })
                    .LeeCancelAction(@"取消", nil) // 点击事件的Block如果不需要可以传nil
                    .LeeDestructiveAction(@"好的", ^{
                        if (!__tf.text) {
                            return ;
                        }
                        if (!__tf.text.isChinese) {
                            [HUDHelper showMsg:@"请输入纯汉字昵称"];
                            return;
                        }
                        [NetworkManager1 lhcdoc_setNickname:__tf.text].successBlock = ^(id responseObject) {
                            if (aciv.onSend) {
                                aciv.onSend(text, willFlow);
                            }
                        };
                    })
                    .leeShouldActionClickClose(^(NSInteger index){
                        // 是否可以关闭回调, 当即将关闭时会被调用 根据返回值决定是否执行关闭处理
                        // 这里演示了与输入框非空校验结合的例子
                        BOOL result = ![__tf.text isEqualToString:@""];
                        result = index == 1 ? result : YES;
                        return result;
                    })
                    .LeeShow();
                }
            }
        };
    };
    [aciv textViewDidChange:aciv.textView];
    [aciv show];
    return aciv;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    _textView.delegate = self;
    _inputViewBottomConstraint.constant = -180;
    
    __weakSelf_(__self);
    [self xw_addNotificationForName:UIKeyboardWillShowNotification block:^(NSNotification * _Nonnull noti) {
        CGFloat h = [noti.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
        [UIView animateWithDuration:0.35 animations:^{
            __self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
            __self.inputViewBottomConstraint.constant = h;
            [__self layoutIfNeeded];
        }];
    }];
    [self xw_addNotificationForName:UIKeyboardWillHideNotification block:^(NSNotification * _Nonnull noti) {
        [UIView animateWithDuration:0.35 animations:^{
            __self.inputViewBottomConstraint.constant = -180;
            [__self layoutIfNeeded];
            __self.backgroundColor = [UIColor clearColor];
        } completion:^(BOOL finished) {
            [__self removeFromSuperview];
            
            if (__self.onCancel)
                __self.onCancel();
        }];
    }];
    [_textView aspect_hookSelector:@selector(canPerformAction:withSender:) withOptions:AspectPositionInstead usingBlock:^(id<AspectInfo> aInfo) {
        BOOL ret = false;
        [aInfo.originalInvocation setReturnValue:&ret];
    } error:nil];
    [_textView becomeFirstResponder];
}

- (void)show {
    self.frame = APP.Bounds;
    [TabBarController1.view addSubview:self];
}


#pragma mark - IBAction

// 点击背景取消评论
- (IBAction)onBackgroundBtnClick:(UIButton *)sender {
    [_textView resignFirstResponder];
}

// 转发
- (IBAction)onSelectForwardBtnClick:(UIButton *)sender {
    UIButton *icon = [sender.superview viewWithTagString:@"转发图标Button"];
    icon.selected = !icon.selected;
}

// 发送评论或回复
- (IBAction)onSendBtnClick:(UIButton *)sender {
    if (!_textView.text.length) {
        [HUDHelper showMsg:@"内容不能为空！"];
        return;
    }
    
    UIButton *icon = [sender.superview viewWithTagString:@"转发图标Button"];
    if (_onSend)
        _onSend(_textView.text, icon.selected);
}


#pragma mark - UITextViewDelegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if (![text isEqualToString:@""]) { // 非删除
        // 文本长度限制
        NSString *resultString = [textView.text stringByReplacingCharactersInRange:range withString:text];
        if (resultString.length >= textView.text.length && resultString.length > 150) {
            [HUDHelper showMsg:@"不得超过150字符"];
            return false;
        }
    }
    
    // 使用户输入文字始终是黑色
    textView.typingAttributes = @{NSForegroundColorAttributeName:[UIColor blackColor], NSFontAttributeName:[UIFont systemFontOfSize:FontSize]};
    return true;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    if (!UGLoginIsAuthorized()) {
        SANotificationEventPost(UGNotificationShowLoginView, nil);
        return false;
    }
    return true;
}

- (void)textViewDidChange:(UITextView *)textView {
    CGFloat h = [textView.attributedText boundingRectWithSize:CGSizeMake(textView.contentSize.width - 10, MAXFLOAT)
                                                      options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                      context:nil].size.height;
    h += 10;
    textView.cc_constraints.height.constant = MAX(h, TextViewMinHeight);
    
    [textView.superview viewWithTagString:@"占位文本Label"].hidden = textView.text.length;
    [textView.superview layoutIfNeeded];
}

@end
