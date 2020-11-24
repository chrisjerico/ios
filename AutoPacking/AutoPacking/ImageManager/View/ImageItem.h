//
//  ImageItem.h
//  AutoPacking
//
//  Created by fish on 2020/11/24.
//  Copyright © 2020 fish. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ImageModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ImageItem : NSCollectionViewItem

@property (nonatomic, strong) ImageModel *im;
@property (nonatomic, strong) void (^didClick)(void);
@end

NS_ASSUME_NONNULL_END
