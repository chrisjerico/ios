//
//  UGPlatformTitleCollectionViewCell.h
//  ug
//
//  Created by ug on 2019/5/2.
//  Copyright © 2019 ug. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameCategoryDataModel.h"

@class UGPlatformModel;
NS_ASSUME_NONNULL_BEGIN

@interface UGPlatformTitleCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) GameCategoryModel *item;

@end

NS_ASSUME_NONNULL_END
