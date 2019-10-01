//
//  UGPlatformTitleCollectionView.h
//  ug
//
//  Created by ug on 2019/5/2.
//  Copyright © 2019 ug. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^PlatformTitleSelectBlock)(NSInteger selectIndex);

@interface UGPlatformTitleCollectionView : UGView

@property (nonatomic, copy) PlatformTitleSelectBlock platformTitleSelectBlock;
@property (nonatomic, assign) NSInteger selectIndex;
@property (nonatomic, strong) NSArray *gameTypeArray;

@end

NS_ASSUME_NONNULL_END
