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

@end
