//
//  UGGameNavigationView.h
//  ug
//
//  Created by xionghx on 2019/10/2.
//  Copyright © 2019 ug. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameCategoryDataModel.h"


NS_ASSUME_NONNULL_BEGIN

@interface UGGameNavigationView : UICollectionView
@property(nonatomic, strong)NSArray<GameModel *> * sourceData;

@end

@interface UGGameNavigationViewCell : UICollectionViewCell
@property(nonatomic, strong)GameModel* model;

@end

NS_ASSUME_NONNULL_END
