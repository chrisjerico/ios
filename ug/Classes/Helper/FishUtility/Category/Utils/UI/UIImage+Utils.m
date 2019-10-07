//
//  UIImage+ImageWithURL.m
//  Eyesir
//
//  Created by fish on 16/7/5.
//  Copyright © 2016年 huangchucai. All rights reserved.
//

#import "UIImage+Utils.h"
#import "UIImage+MultiFormat.h"

@implementation UIImage (Utils)

- (CGFloat)width {
    return self.size.width;
}

- (CGFloat)height {
    return self.size.height;
}


#pragma mark - Scale

+ (UIImage *)compressImage:(UIImage *)image toByte:(NSUInteger)maxLength {
    // Compress by quality
    CGFloat compression = 1;
    NSData *data = UIImageJPEGRepresentation(image, compression);
//    NSLog(@"压缩前图片大小：%lu", data.length);
    if (data.length < maxLength) return image;
    
    CGFloat max = 1;
    CGFloat min = 0;
    for (int i = 0; i < 6; ++i) {
        compression = (max + min) / 2;
        data = UIImageJPEGRepresentation(image, compression);
        if (data.length < maxLength * 0.9) {
            min = compression;
        } else if (data.length > maxLength) {
            max = compression;
        } else {
            break;
        }
    }
    UIImage *resultImage = [UIImage imageWithData:data];
    if (data.length < maxLength) return resultImage;
    
    // Compress by size
    NSUInteger lastDataLength = 0;
    while (data.length > maxLength && data.length != lastDataLength) {
        lastDataLength = data.length;
        CGFloat ratio = (CGFloat)maxLength / data.length;
        CGSize size = CGSizeMake((NSUInteger)(resultImage.size.width * sqrtf(ratio)),
                                 (NSUInteger)(resultImage.size.height * sqrtf(ratio))); // Use NSUInteger to prevent white blank
        UIGraphicsBeginImageContext(size);
        [resultImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
        resultImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        data = UIImageJPEGRepresentation(resultImage, compression);
    }
//    NSLog(@"压缩后图片大小：%lu", data.length);
    return resultImage;
}

+ (void)compressImages:(NSArray <UIImage *>*)imgs toByte:(NSUInteger)maxLength block:(void (^)(NSInteger index, UIImage *img))block {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        for (int i=0; i<imgs.count; i++) {
            UIImage *img = [UIImage compressImage:imgs[i] toByte:maxLength];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (block)
                    block(i, img);
            });
        }
    });
}

- (void)compressToByte:(NSUInteger)maxLength block:(void (^)(UIImage *img))block {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        UIImage *img = [UIImage compressImage:self toByte:maxLength];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (block)
                block(img);
        });
    });
}

- (UIImage *)imageWithScale:(CGPoint)scale {
    CGSize size = CGSizeMake(self.width * scale.x, self.height * scale.y);
    return [self imageWithSize:size];
}

- (UIImage *)imageWithSize:(CGSize)size {
    CGFloat w = size.width;
    CGFloat h = size.height;
    
//    UIGraphicsBeginImageContext(CGSizeMake(w, h));  // 图片模糊
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale); // 解决图片模糊问题
    [self drawInRect:CGRectMake(0, 0, w, h)];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

- (UIImage *)imageWithWidth:(CGFloat)width {
    return [self imageWithSize:CGSizeMake(width, self.height/self.width * width)];
}


#pragma mark - Download

+ (nullable UIImage *)imageWithURL:(NSURL *)url {
    return [UIImage sd_imageWithData:[NSData dataWithContentsOfURL:url]];
}

+ (void)imageWithURL:(nonnull NSURL *)url completed:(nonnull void (^)(UIImage * _Nullable image, NSURL * _Nonnull imageURL))completed {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        UIImage *img = [UIImage imageWithURL:url];
        dispatch_async(dispatch_get_main_queue(), ^{
            completed(img, url);
        });
    });
}

+ (void)imageWithContentsOfFile:(NSString *)path completed:(nonnull void (^)(UIImage * _Nullable image, NSString * _Nonnull path))completed {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        UIImage *img = [[UIImage alloc] initWithContentsOfFile:path];
        dispatch_async(dispatch_get_main_queue(), ^{
            completed(img, path);
        });
    });
}


#pragma mark - Watermark

- (UIImage *)imageWithWatermark:(UIImage *)watermark rect:(CGRect)rect {
    UIGraphicsBeginImageContextWithOptions(self.size, false, 0);
    [self drawInRect:CGRectMake(0, 0, self.width, self.height)];
    [watermark drawInRect:rect];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

#pragma mark - Get image with color
/**
 颜色转UIImage
 
 @param color 颜色
 @return 图片
 */
+(UIImage*)createImageWithColor:(UIColor*) color andSize:(CGSize)size
{
    CGRect rect=CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}
@end
