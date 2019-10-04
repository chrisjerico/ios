//
//  TextFieldAlertView.h
//  C
//
//  Created by fish on 2018/3/23.
//  Copyright © 2018年 fish. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TextFieldAlertView : UIView

@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *placeholder;
@property (nonatomic, copy) NSString *text;

@property (nonatomic) void (^didConfirmBtnClick)(__weak TextFieldAlertView *tfav, NSString *text);

- (void)show;
- (void)hide;
- (void)showToWindow;
@end
