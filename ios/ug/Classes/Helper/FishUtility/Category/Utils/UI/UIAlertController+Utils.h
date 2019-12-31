//
//  UIAlertController+Utils.h
//  C
//
//  Created by fish on 2017/10/30.
//  Copyright © 2017年 fish. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIAlertAction (Utils)
@property (nonatomic) void (^block)(UIAlertAction *aa);
@end


@interface UIAlertController (Utils)

+ (instancetype)alertWithTitle:(NSString *)title msg:(NSString *)msg btnTitles:(NSArray <NSString *>*)btnTitles;
+ (instancetype)actionSheetWithTitle:(NSString *)title msg:(NSString *)msg  btnTitles:(NSArray <NSString *>*)btnTitles cancel:(NSString *)cancel;

- (void)setActionAtIndex:(NSInteger)index handler:(void (^)(UIAlertAction *aa))handler;
- (void)setActionAtTitle:(NSString *)title handler:(void (^)(UIAlertAction *aa))handler;


- (BOOL)shouldAutorotate;

@end
