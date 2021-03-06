//
//  UGConvertCollectionViewCell.h
//  ug
//
//  Created by ug on 2019/5/16.
//  Copyright © 2019 ug. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UGMissionLevelModel;
NS_ASSUME_NONNULL_BEGIN

@interface UGConvertCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UGMissionLevelModel *item;

@property (nonatomic, strong) NSString *title;


@end

NS_ASSUME_NONNULL_END
