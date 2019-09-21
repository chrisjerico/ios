//
//  UGGameSubCollectionView.h
//  ug
//
//  Created by xionghx on 2019/9/21.
//  Copyright © 2019 ug. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameCategoryDataModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface UGGameSubCollectionView : UICollectionView

@property(nonatomic, strong)NSArray<GameSubModel*> *sourceData;

- (instancetype)initWithFrame:(CGRect)frame;

@end


@interface CollectionCell : UICollectionViewCell
@property (nonatomic, strong) GameSubModel* model;

@end

NS_ASSUME_NONNULL_END
