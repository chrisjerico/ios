//
//  SDWebImaeA.h
//  AutoPacking
//
//  Created by fish on 2020/11/24.
//  Copyright © 2020 fish. All rights reserved.
//

#ifndef SDWebImaeA_h
#define SDWebImaeA_h

#import "SDWebImageCompat.h"


#import "SDWebImageManager.h"
#import "SDWebImageCacheKeyFilter.h"
#import "SDWebImageCacheSerializer.h"
#import "SDImageCacheConfig.h"
#import "SDImageCache.h"
#import "SDMemoryCache.h"
#import "SDDiskCache.h"
#import "SDImageCacheDefine.h"
#import "SDImageCachesManager.h"
#import "UIView+WebCache.h"
#import "UIImageView+WebCache.h"
#import "UIImageView+HighlightedWebCache.h"
#import "SDWebImageDownloaderConfig.h"
#import "SDWebImageDownloaderOperation.h"
#import "SDWebImageDownloaderRequestModifier.h"
#import "SDWebImageDownloaderResponseModifier.h"
#import "SDWebImageDownloaderDecryptor.h"
#import "SDImageLoader.h"
#import "SDImageLoadersManager.h"
#import "UIButton+WebCache.h"
#import "SDWebImagePrefetcher.h"
#import "UIView+WebCacheOperation.h"
#import "UIImage+Metadata.h"
#import "UIImage+MultiFormat.h"
#import "UIImage+MemoryCacheCost.h"
#import "UIImage+ExtendedCacheData.h"
#import "SDWebImageOperation.h"
#import "SDWebImageDownloader.h"
#import "SDWebImageTransition.h"
#import "SDWebImageIndicator.h"
#import "SDImageTransformer.h"
#import "UIImage+Transform.h"
#import "SDAnimatedImage.h"
#import "SDAnimatedImageView.h"
#import "SDAnimatedImageView+WebCache.h"
#import "SDAnimatedImagePlayer.h"
#import "SDImageCodersManager.h"
#import "SDImageCoder.h"
#import "SDImageAPNGCoder.h"
#import "SDImageGIFCoder.h"
#import "SDImageIOCoder.h"
#import "SDImageFrame.h"
#import "SDImageCoderHelper.h"
#import "SDImageGraphics.h"
#import "SDGraphicsImageRenderer.h"
#import "UIImage+GIF.h"
#import "UIImage+ForceDecode.h"
#import "NSData+ImageContentType.h"
#import "SDWebImageDefine.h"
#import "SDWebImageError.h"
#import "SDWebImageOptionsProcessor.h"
#import "SDImageIOAnimatedCoder.h"
#import "SDImageHEICCoder.h"
#import "SDImageAWebPCoder.h"


// Mac
#if __has_include(<SDWebImage/NSImage+Compatibility.h>)
#import "NSImage+Compatibility.h"
#endif
#if __has_include(<SDWebImage/NSButton+WebCache.h>)
#import "NSButton+WebCache.h"
#endif
#if __has_include(<SDWebImage/SDAnimatedImageRep.h>)
#import "SDAnimatedImageRep.h"
#endif

#endif /* SDWebImaeA_h */
