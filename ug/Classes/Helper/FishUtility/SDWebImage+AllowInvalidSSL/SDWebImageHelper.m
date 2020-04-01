//
//  SDWebImageHelper.m
//  ug
//
//  Created by fish on 2019/12/14.
//  Copyright © 2019 ug. All rights reserved.
//

#import "SDWebImageHelper.h"
#import "FLAnimatedImageView.h"

@interface UIImageView (SDWebImageHelper)
@end

@implementation UIImageView (SDWebImageHelper)
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [UIImageView jr_swizzleMethod:@selector(sd_setImageWithURL:placeholderImage:options:context:progress:completed:) withMethod:@selector(cc_sd_setImageWithURL:placeholderImage:options:context:progress:completed:) error:nil];
    });
}

- (void)cc_sd_setImageWithURL:(nullable NSURL *)url
          placeholderImage:(nullable UIImage *)placeholder
                   options:(SDWebImageOptions)options
                   context:(nullable SDWebImageContext *)context
                  progress:(nullable SDImageLoaderProgressBlock)progressBlock
                 completed:(nullable SDExternalCompletionBlock)completedBlock {
    if (options) {
        options |= SDWebImageAllowInvalidSSLCertificates;
    } else {
        options = SDWebImageAllowInvalidSSLCertificates;
    }
    [self cc_sd_setImageWithURL:url placeholderImage:placeholder options:options context:context progress:progressBlock completed:completedBlock];
}
@end
