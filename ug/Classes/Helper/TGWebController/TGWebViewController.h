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
/** 相关链接  第1条请求*/
@property (nonatomic, strong) NSString *url;

/** 相关链接  第2条请求    当第1条请求成功后请求*/
@property (nonatomic, strong) NSString *url2;
/** 相关链接  第2条请求    当第1条请求成功后请求,界面覆盖不显示内容*/
@property (nonatomic)  BOOL isShow;

@property (nonatomic,strong) WKWebView *tgWebView;

/** 标题 */
@property (nonatomic, strong) NSString *webTitle;

/** 进度条颜色 */
@property (nonatomic,strong) UIColor *progressColor;


@property (nonatomic, strong) void (^didReceiveScriptMessage)(NSString *name, id body); /**<   收到js讯息 */

@end


