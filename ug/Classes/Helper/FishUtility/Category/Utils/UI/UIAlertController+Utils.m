//
//  UIAlertController+Utils.m
//  C
//
//  Created by fish on 2017/10/30.
//  Copyright © 2017年 fish. All rights reserved.
//

#import "UIAlertController+Utils.h"
#import "zj_runtime_property.h"

@implementation UIAlertAction (Utils)

_ZJRuntimeProperty_Copy(void (^)(UIAlertAction *aa), block, setBlock);

@end


@implementation UIAlertController (Utils)

+ (instancetype)alertWithTitle:(NSString *)title msg:(NSString *)msg btnTitles:(NSArray <NSString *>*)btnTitles {
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:UIAlertControllerStyleAlert];
    for (NSString *btnTitle in btnTitles) {
        [ac addAction:[UIAlertAction actionWithTitle:btnTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (action.block)
                action.block(action);
        }]];
    }
    return ac;
}

+ (instancetype)actionSheetWithTitle:(NSString *)title msg:(NSString *)msg  btnTitles:(NSArray <NSString *>*)btnTitles cancel:(NSString *)cancel {
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:UIAlertControllerStyleActionSheet];
    for (NSString *btnTitle in btnTitles) {
        [ac addAction:[UIAlertAction actionWithTitle:btnTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (action.block)
                action.block(action);
        }]];
    }
    
    if (cancel.length) {
        [ac addAction:[UIAlertAction actionWithTitle:cancel style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            if (action.block)
                action.block(action);
        }]];
    }
    return ac;
}

- (void)setActionAtIndex:(NSInteger)index handler:(void (^)(UIAlertAction *))handler {
    self.actions[index].block = handler;
}

- (void)setActionAtTitle:(NSString *)title handler:(void (^)(UIAlertAction *))handler {
    for (UIAlertAction *aa in self.actions) {
        if ([aa.title isEqualToString:title])
            aa.block = handler;
    }
}

- (BOOL)shouldAutorotate
{
    return NO;
}

@end
