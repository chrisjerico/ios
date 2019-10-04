//
//  HUDHelper.h
//  C
//
//  Created by fish on 2017/10/30.
//  Copyright © 2017年 fish. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MsgView;
@class LoadingView;


@interface HUDHelper : NSObject

// 请先选择一个PPT开始播放
+ (void)showPlayerTips;

// ——— Msg
+ (MsgView *)showMsg:(NSString *)msg;
+ (MsgView *)showMsg:(NSString *)msg duration:(CGFloat)dur;
+ (MsgView *)showMsg:(NSString *)msg duration:(CGFloat)dur superview:(UIView *)superview;
+ (void)hideMsg;
+ (void)hideMsg:(UIView *)superview;

// ——— loading View
+ (LoadingView *)showLoadingView;
+ (LoadingView *)showLoadingViewWithSuperview:(UIView *)superview;
+ (void)hideLoadingView;
+ (void)hideLoadingView:(UIView *)superview;
+ (void)hideLoadingView:(UIView *)superview tagString:(NSString *)tagString;

@end

// ——————————————————————————————————————
//////////////////

// 文字提示Toast
@interface MsgView : UIView
+ (instancetype)msgView:(NSString *)msg;
@end

// LoadingView
@interface LoadingView : UIView
+ (instancetype)loadingView;
@property (nonatomic) UIImage *icon;            /**<   Loading Image */
@property (nonatomic) CGPoint iconOffset;       /**<   距离中心点的偏移量 */
@property (nonatomic) CGFloat iconWidth;        /**<   缩放，default is 84 */
@property (nonatomic) NSTimeInterval duration;  /**<   存活时长（秒），default is 30 */

- (void)moveBelowToNavigationBar;
@end
