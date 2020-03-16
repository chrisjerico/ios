//
//  QDAlertView.m
//  xxxxxx
//
//  Created by chenxiaolong on 15/9/6.
//
//

#import "QDAlertView.h"

@implementation QDAlertView


- (id) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        self.delegate = self;
    }
    
    return self;
}

- (id) initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        self.delegate = self;
    }
    
    return self;
}

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
            otherButtonTitles:(NSString *)otherButtonTitles, ... {
    
    self = [super initWithTitle:title
                        message:message
                       delegate:self
              cancelButtonTitle:cancelButtonTitle
              otherButtonTitles:otherButtonTitles, nil];
    
    if (self) {
        if (otherButtonTitles) {
            va_list args;
            va_start(args, otherButtonTitles);
            id object = nil;
            do {
                object = va_arg(args, id);
                if (object) {
                    [self addButtonWithTitle:object];
                }
            } while (object);
            va_end(args);
        }
        
        [self setClickedButtonAtIndexBlock:completionBlock];
    }
    
    return self;
}

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
      completionBlock:(void (^)(UIAlertView *alertView, NSInteger buttonIndex))completionBlock {
    QDAlertView *alertView = [[QDAlertView alloc] initWithTitle:title
                                                        message:message
                                                completionBlock:completionBlock
                                              cancelButtonTitle:cancelButtonTitle
                                              otherButtonTitles:otherButtonTitle, nil];
     dispatch_async(dispatch_get_main_queue(), ^{
        [alertView show];
    });
}

/**
 *  alert消息提示
 *
 *  @param title   题头
 *  @param message 提示信息
 */
+ (void)showWithTitle:(NSString *)title message:(NSString *)message {
    QDAlertView *alertView = [[QDAlertView alloc] initWithTitle:title
                                                        message:message
                                                completionBlock:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
     dispatch_async(dispatch_get_main_queue(), ^{
        [alertView show];
    });
}



#pragma UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (_clickedButtonAtIndexBlock) {
        _clickedButtonAtIndexBlock(alertView, buttonIndex);
    }
}


@end
