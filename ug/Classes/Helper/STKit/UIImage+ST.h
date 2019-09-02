//
//  UIImage+ST.h

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (ST)

//生成最原始的二维码
+ (CIImage *)qrCodeImageWithContent:(NSString *)content;

//根据大小重绘，使二维码变高清
+ (UIImage *)qrCodeImageWithContent:(NSString *)content codeImageSize:(CGFloat)size;

//改变二维码颜色
+ (UIImage *)qrCodeImageWithContent:(NSString *)content codeImageSize:(CGFloat)size red:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue;
@end

NS_ASSUME_NONNULL_END
