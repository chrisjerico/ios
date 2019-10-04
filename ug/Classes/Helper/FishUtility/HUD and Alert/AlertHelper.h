//
//  AlertHelper.h
//  C
//
//  Created by fish on 2017/10/30.
//  Copyright © 2017年 fish. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AlertHelper : NSObject

// ——— UIAlertController
+ (UIAlertController *)showAlertView:(NSString *)title msg:(NSString *)msg btnTitles:(NSArray *)btnTitles;
+ (UIAlertController *)showAlertViewWithVC:(UIViewController *)vc
                                     title:(NSString *)title
                                   message:(NSString *)message
                                 btnTitles:(NSArray *)btnTitles;

+ (UIAlertController *)showActionSheet:(NSString *)title msg:(NSString *)msg btnTitles:(NSArray *)btnTitles cancel:(NSString *)cancel;

@end
