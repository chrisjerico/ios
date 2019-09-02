//
//  QDAlertView.h
//  xxxxxx
//
//  Created by chenxiaolong on 15/9/6.
//
//

#import <UIKit/UIKit.h>

@interface QDAlertView : UIAlertView

@property(nonatomic, strong) void(^clickedButtonAtIndexBlock)(UIAlertView *alertView, NSInteger buttonIndex);

/**
 *  自带block的alertView
 *
 *  @param title             题头
 *  @param message           提示信息
 *  @param completionBlock   回调函数
 *  @param cancelButtonTitle 取消按钮名称
 *  @param otherButtonTitles 其他按钮名称
 *
 *  @return UIAlertView
 */
- (instancetype)initWithTitle:(NSString *)title
                      message:(NSString *)message
              completionBlock:(void (^)(UIAlertView *alertView, NSInteger buttonIndex))completionBlock
            cancelButtonTitle:(NSString *)cancelButtonTitle
            otherButtonTitles:(NSString *)otherButtonTitles, ...NS_REQUIRES_NIL_TERMINATION;

/**
 *  带block的消息提示
 *
 *  @param title             题头
 *  @param message           提示信息
 *  @param cancelButtonTitle 取消按钮名称
 *  @param otherButtonTitle  其他按钮名称
 *  @param completionBlock   回调函数
 */
+ (void)showWithTitle:(NSString *)title
              message:(NSString *)message
    cancelButtonTitle:(NSString *)cancelButtonTitle
     otherButtonTitle:(NSString *)otherButtonTitle
      completionBlock:(void (^)(UIAlertView *alertView, NSInteger buttonIndex))completionBlock;

/**
 *  alert消息提示
 *
 *  @param title   题头
 *  @param message 提示信息
 */
+ (void)showWithTitle:(NSString *)title message:(NSString *)message;

@end
