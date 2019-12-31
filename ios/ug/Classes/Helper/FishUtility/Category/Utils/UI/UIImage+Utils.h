//
//  UIImage+ImageWithURL.h
//  Eyesir
//
//  Created by fish on 16/7/5.
//  Copyright © 2016年 huangchucai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Utils)

@property (readonly, nonatomic) CGFloat width;
@property (readonly, nonatomic) CGFloat height;




#pragma mark - Scale

+ (UIImage *)compressImage:(UIImage *)image toByte:(NSUInteger)maxLength;
+ (void)compressImages:(NSArray <UIImage *>*)imgs toByte:(NSUInteger)maxLength block:(void (^)(NSInteger index, UIImage *img))block;

- (void)compressToByte:(NSUInteger)maxLength block:(void (^)(UIImage *img))block;   /**<    压缩图片到接近指定长度 */

- (UIImage *)imageWithScale:(CGPoint)scale;         /**<    缩放图片：scale.x 表示宽度缩放比例 */
- (UIImage *)imageWithSize:(CGSize)size;            /**<    缩放图片 */
- (UIImage *)imageWithWidth:(CGFloat)width;         /**<    缩放图片 */


#pragma mark - Download

+ (UIImage *)imageWithURL:(NSURL *)url;
+ (void)imageWithURL:(NSURL *)url completed:(void (^)(UIImage *image, NSURL *imageURL))completed;
+ (void)imageWithContentsOfFile:(NSString *)path completed:(void (^)(UIImage *image, NSString *path))completed;


#pragma mark - Watermark

- (UIImage *)imageWithWatermark:(UIImage *)watermark rect:(CGRect)rect;

#pragma mark - Get image with color
/**
 颜色转UIImage
 
 @param color 颜色
 @return 图片
 */
+(UIImage*)createImageWithColor:(UIColor*) color andSize:(CGSize)size;
@end
