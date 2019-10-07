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
    UIAlertController *ac = [UIAlertController alertWithTitle:title msg:msg btnTitles:btnTitles];
    [NavController1 presentViewController:ac animated:true completion:nil];
    return ac;
}

+ (UIAlertController *)showActionSheet:(NSString *)title msg:(NSString *)msg btnTitles:(NSArray *)btnTitles cancel:(NSString *)cancel {
    UIAlertController *ac = [UIAlertController actionSheetWithTitle:title msg:msg btnTitles:btnTitles cancel:(NSString *)cancel];
    [NavController1 presentViewController:ac animated:true completion:nil];
    return ac;
}

@end
