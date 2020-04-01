//
//  UGPlatformTitleCollectionView.h
//  ug
//
//  Created by ug on 2019/5/2.
//  Copyright © 2019 ug. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameCategoryDataModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^PlatformTitleSelectBlock)(NSInteger selectIndex);

@interface UGPlatformTitleCollectionView : UIView

@property (nonatomic) PlatformTitleSelectBlock platformTitleSelectBlock;
@property (nonatomic) NSInteger selectIndex;
@property (nonatomic) NSArray<GameCategoryModel *> *gameTypeArray;

@end

NS_ASSUME_NONNULL_END
