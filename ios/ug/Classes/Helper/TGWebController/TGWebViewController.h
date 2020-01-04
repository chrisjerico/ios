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

@property (nonatomic,strong) TGWebProgressLayer *webProgressLayer;
/** 相关链接*/
@property (nonatomic, strong) NSString *url;

@property (nonatomic,strong) WKWebView *tgWebView;

/** 标题 */
@property (nonatomic, strong) NSString *webTitle;

/** 进度条颜色 */
@property (nonatomic,strong) UIColor *progressColor;

@end


