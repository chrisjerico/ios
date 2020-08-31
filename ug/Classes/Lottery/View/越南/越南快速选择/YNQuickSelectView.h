//
//  YNQuickSelectView.h
//  UGBWApp
//
//  Created by andrew on 2020/7/27.
//  Copyright © 2020 ug. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UGGameplayModel.h"
#import "HMSegmentedControl.h"
NS_ASSUME_NONNULL_BEGIN
typedef void(^YNQuickListBlock)(UICollectionView *collectionView,NSIndexPath* indexPath,NSInteger selectedSegmentIndex);
@interface YNQuickSelectView : UIView
@property (nonatomic, strong )UGGameBetModel *bet;
@property (nonatomic, strong) HMSegmentedControl *segmentedControl;

@property (nonatomic, copy) YNQuickListBlock ynCollectIndexBlock;

-(void)reload;
@end

NS_ASSUME_NONNULL_END
