//
//  SGQRCodeObtainHelper.m
//  UGBWApp
//
//  Created by fish on 2021/3/2.
//  Copyright © 2021 ug. All rights reserved.
//

#import "SGQRCodeObtainHelper.h"
#import "SGQRCode.h"

@implementation SGQRCodeObtainHelper

+ (SGQRCodeObtain *)obtain {
    static SGQRCodeObtain *obtain = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        obtain = [SGQRCodeObtain QRCodeObtain];
        [obtain setBlockWithQRCodeObtainAlbumDidCancelImagePickerController:^(SGQRCodeObtain *obtain) {
            [obtain stopRunning];
        }];
    });
    return obtain;
}

+ (void)openAlbum:(void (^)(NSString *ret))block {
    SGQRCodeObtain *obtain = [SGQRCodeObtainHelper obtain];
    [obtain startRunningWithBefore:nil completion:nil];
    [obtain establishAuthorizationQRCodeObtainAlbumWithController:APP.Window.rootViewController];
    [obtain setBlockWithQRCodeObtainAlbumResult:^(SGQRCodeObtain *obtain, NSString *result) {
        [obtain stopRunning];
        if (block)
            block(result);
    }];
}

+ (void)openFlashlight:(BOOL)open {
    SGQRCodeObtain *obtain = [SGQRCodeObtainHelper obtain];
    if (open)
        [obtain openFlashlight];
    else
        [obtain closeFlashlight];
}

@end
