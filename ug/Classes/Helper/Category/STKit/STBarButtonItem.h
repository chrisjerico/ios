//
//  STBarButtonItem.h
//  Copyright © 2016年 ST. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STButton.h"

@interface STBarButtonItem : UIBarButtonItem

+ (STBarButtonItem *)barButtonItemWithTitle:(NSString *)title
                                     target:(id)target
                                     action:(SEL)action;

+ (STBarButtonItem *)barButtonItemWithImageName:(NSString *)imageName
                                         target:(id)target
                                         action:(SEL)action;

+ (STBarButtonItem *)barButtonItemWithImageName:(NSString *)imageName
                                          title:(NSString *)title
                                         target:(id)target
                                         action:(SEL)action;
+ (STBarButtonItem *)barButtonItemWithImageName:(NSString *)imageName
                                         target:(id)target
                                         action:(SEL)action
                                          badge:(BOOL)badge;
+ (STBarButtonItem *)barButtonItemLeftWithImageName:(NSString *)imageName
                                                title:(NSString *)title
                                               target:(id)target
                                               action:(SEL)action;



// ——————————————————————————————————————————
// Block 方法

+ (STBarButtonItem *)barButtonItemWithTitle:(NSString *)title block:(void (^)(UIButton *sender))block;
+ (STBarButtonItem *)barButtonItemWithImageName:(NSString *)imageName block:(void (^)(UIButton *sender))block;
+ (STBarButtonItem *)barButtonItemWithImageName:(NSString *)imageName title:(NSString *)title block:(void (^)(UIButton *sender))block;
+ (STBarButtonItem *)barButtonItemWithImageName:(NSString *)imageName badge:(BOOL)badge block:(void (^)(UIButton *sender))block;
+ (STBarButtonItem *)barButtonItemLeftWithImageName:(NSString *)imageName title:(NSString *)title block:(void (^)(UIButton *sender))block;


@end
