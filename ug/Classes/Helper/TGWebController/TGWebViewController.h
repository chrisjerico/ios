//
//  TGWebViewController.h
//  TGWebViewController
//
//  Created by 赵群涛 on 2017/9/15.
//  Copyright © 2017年 QR. All rights reserved.
// https://github.com/zhaoquntao/TGWebViewController

#import <UIKit/UIKit.h>
#import "TGWebProgressLayer.h"
@interface TGWebViewController :  UIViewController

@property (nonatomic) WKWebView *tgWebView;

@property (nonatomic) TGWebProgressLayer *webProgressLayer;

/** 相关链接*/
@property (nonatomic, copy) NSString *url;

/** 标题 */
@property (nonatomic, copy) NSString *webTitle;

/** 进度条颜色 */
@property (nonatomic) UIColor *progressColor;

- (void)setWebViewFrame:(CGRect)frame;

@end

