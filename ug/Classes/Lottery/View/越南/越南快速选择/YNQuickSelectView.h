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
#import "YNQuickListView.h"
NS_ASSUME_NONNULL_BEGIN
typedef void(^YNQuickListBlock)(UICollectionView *collectionView,NSIndexPath* indexPath,NSInteger selectedSegmentIndex);
@interface YNQuickSelectView : UIView
@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (nonatomic, strong )UGGameBetModel *bet;
@property (nonatomic, strong) HMSegmentedControl *segmentedControl;

@property (nonatomic, copy) YNQuickListBlock ynCollectIndexBlock;

@property (nonatomic) int selecedCount;// 可以选择的数量  （偏斜2 偏斜3 偏斜4 串烧4 串烧8 串烧10）

@property (nonatomic) BOOL seleced;//是否有 可以选择的数量

@property (nonatomic,strong)  NSMutableArray <YNQuickListView *> *itemViewArray;//views 数组

-(void)reload;
@end

NS_ASSUME_NONNULL_END
