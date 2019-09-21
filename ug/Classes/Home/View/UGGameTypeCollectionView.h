//
//  UGGameTypeCollectionView.h
//  ug
//
//  Created by ug on 2019/5/2.
//  Copyright © 2019 ug. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameCategoryDataModel.h"

@class UGPlatformModel;
@class UGPlatformGameModel;
NS_ASSUME_NONNULL_BEGIN

typedef void(^PlatformSelectBlock)(NSInteger selectIndex);
typedef void(^GameItemSelectBlock)(UGPlatformGameModel *game);
@interface UGGameTypeCollectionView : UIView

@property (nonatomic, copy)  PlatformSelectBlock platformSelectBlock;
@property (nonatomic, copy) GameItemSelectBlock gameItemSelectBlock;
@property (nonatomic, assign) NSInteger selectIndex;
@property (nonatomic, strong) NSArray<GameCategoryModel*> *gameTypeArray;

@end

NS_ASSUME_NONNULL_END
