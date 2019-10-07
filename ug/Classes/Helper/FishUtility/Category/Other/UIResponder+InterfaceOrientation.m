//
//  UIResponder+InterfaceOrientation.m
//  C
//
//  Created by fish on 2018/10/11.
//  Copyright © 2018年 fish. All rights reserved.
//

#import "UIResponder+InterfaceOrientation.h"
#import "zj_runtime_property.h"

@implementation UIResponder (InterfaceOrientation)

_ZJRuntimeProperty_Assign(UIInterfaceOrientation, io, setIo);

+ (void)setWindowInterfaceOrientation:(UIInterfaceOrientation)io {
    NSDictionary *dict = @{@(UIInterfaceOrientationPortrait):@true,
                           @(UIInterfaceOrientationPortraitUpsideDown):@true,
                           @(UIInterfaceOrientationLandscapeLeft):@true,
                           @(UIInterfaceOrientationLandscapeRight):@true,};
    if (dict[@(io)]) {
        ((UIResponder *)[UIApplication sharedApplication].delegate).io = io;
        [[UIApplication sharedApplication].delegate application:[UIApplication sharedApplication] supportedInterfaceOrientationsForWindow:[UIApplication sharedApplication].keyWindow];
        [UIViewController attemptRotationToDeviceOrientation];
    }
}

- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(nullable UIWindow *)window {
    switch (self.io) {
        case UIInterfaceOrientationPortrait:
        default:
            return UIInterfaceOrientationMaskPortrait;
            
        case UIInterfaceOrientationPortraitUpsideDown:
            return UIInterfaceOrientationMaskPortraitUpsideDown;
        case UIInterfaceOrientationLandscapeLeft:
            return UIInterfaceOrientationMaskLandscapeLeft;
        case UIInterfaceOrientationLandscapeRight:
            return UIInterfaceOrientationMaskLandscapeRight;
    }
}

@end
