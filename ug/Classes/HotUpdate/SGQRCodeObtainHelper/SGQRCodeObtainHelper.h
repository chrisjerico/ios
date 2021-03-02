//
//  SGQRCodeObtainHelper.h
//  UGBWApp
//
//  Created by fish on 2021/3/2.
//  Copyright © 2021 ug. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SGQRCodeObtainHelper : NSObject

+ (void)openAlbum:(void (^)(NSString *ret))block;
+ (void)openFlashlight:(BOOL)open;
@end

NS_ASSUME_NONNULL_END
