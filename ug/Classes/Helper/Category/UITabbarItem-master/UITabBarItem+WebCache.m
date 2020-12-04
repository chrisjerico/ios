//
//  UITabBarItem+WebCache.m
//  zyf
//
//  Created by zyf on 15/7/24.
//  Copyright (c) 2015年 zyf. All rights reserved.
// UIImageRenderingModeAlwaysTemplate

#import "UITabBarItem+WebCache.h"

@implementation UITabBarItem (WebCache)

- (void)zy_setImageWithURL:(NSString *)urlString withImage:(UIImage *)placeholderImage {
    
    [[ZYImageCacheManager sharedImageCacheManager] getImageWithUrl:urlString complete:^(UIImage *image) {
        //使用图片
        if (image == NULL) {
            self.image = [placeholderImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        } else {
            
            self.image = [self scaleImage:[image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] toScale:0.5];

        }
    }];
}

- (void)zy_setImageWithURL:(NSString *)urlString placeholderImage:(UIImage *)placeholderImage {
    self.image = [placeholderImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self zy_setImageWithURL:urlString withImage:placeholderImage];
}

- (void)zy_setSelectImageWithURL:(NSString *)urlString withImage:(UIImage *)placeholderImage {
    [[ZYImageCacheManager sharedImageCacheManager] getImageWithUrl:urlString complete:^(UIImage *image) {
        //使用图片
        if (image == NULL) {
            self.selectedImage = [placeholderImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        } else {
            self.selectedImage = [self scaleImage:[image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] toScale:0.5];

        }
    }];
}

- (void)zy_setSelectImageWithURL:(NSString *)urlString placeholderImage:(UIImage *)placeholderImage {
    self.selectedImage = [placeholderImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self zy_setSelectImageWithURL:urlString withImage:placeholderImage];
}

- (UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize {
//    UIGraphicsBeginImageContextWithOptions(CGSizeMake(image.size.width * scaleSize, image.size.height * scaleSize), NO, 0);
//    [image drawInRect:CGRectIntegral(CGRectMake(0, 0, image.size.width * scaleSize, image.size.height * scaleSize))];
//    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(25, 25), NO, 0);
        [image drawInRect:CGRectIntegral(CGRectMake(0, 0, 25, 25))];
        UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return [scaledImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
}

@end