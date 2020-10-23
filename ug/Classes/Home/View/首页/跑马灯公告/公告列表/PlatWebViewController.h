//
//  PlatWebViewController.h
//  UGBWApp
//
//  Created by ug on 2020/8/20.
//  Copyright © 2020 ug. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PlatWebViewController : UIViewController

@property (weak, nonatomic)  UIViewController *supVC;
/** 相关链接*/
@property (nonatomic, strong) NSString *url;

@property (weak, nonatomic) IBOutlet WKWebView *mWKView;

/** 进度条颜色 */
@property (nonatomic,strong) UIColor *progressColor;

/** 标题 */
@property (nonatomic, strong) NSString *webTitle;

@property (nonatomic, strong) void (^didReceiveScriptMessage)(NSString *name, id body); /**<   收到js讯息 */
@end

NS_ASSUME_NONNULL_END
