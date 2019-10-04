//
//  AlertHelper.m
//  C
//
//  Created by fish on 2017/10/30.
//  Copyright © 2017年 fish. All rights reserved.
//

#import "AlertHelper.h"

@implementation AlertHelper

#pragma mark - AlertView

+ (UIAlertController *)showAlertView: (NSString *)title msg:(NSString *)msg btnTitles:(NSArray *)btnTitles {
    return [AlertHelper showAlertViewWithVC:nil title:title message:msg btnTitles:btnTitles];
}

+ (UIAlertController *)showAlertViewWithVC:(UIViewController *)vc
                                     title:(NSString *)title
                                   message:(NSString *)message
                                 btnTitles:(NSArray *)btnTitles
{
    UIAlertController *ac = [UIAlertController alertWithTitle:title msg:message btnTitles:btnTitles];
    if (vc == nil) {
        [NavController1 presentViewController:ac animated:true completion:nil];
    } else {
        [vc presentViewController:ac animated:YES completion:nil];
    }
    return ac;
}

+ (UIAlertController *)showActionSheet:(NSString *)title msg:(NSString *)msg btnTitles:(NSArray *)btnTitles cancel:(NSString *)cancel {
    UIAlertController *ac = [UIAlertController actionSheetWithTitle:title msg:msg btnTitles:btnTitles cancel:(NSString *)cancel];
    [NavController1 presentViewController:ac animated:true completion:nil];
    return ac;
}

@end
