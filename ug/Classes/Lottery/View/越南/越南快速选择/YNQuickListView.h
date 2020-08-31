//
//  YNQuickListView.h
//  UGBWApp
//
//  Created by andrew on 2020/8/2.
//  Copyright © 2020 ug. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UGGameplayModel.h"
NS_ASSUME_NONNULL_BEGIN

typedef void(^QuickListBlock)(UICollectionView *collectionView,NSIndexPath* indexPath);
@interface YNQuickListView : UICollectionView
@property (nonatomic, strong)NSString *type;//类型
@property (nonatomic, strong)NSMutableArray<UGGameBetModel *> *dataArry;//数据

@property (nonatomic, copy) QuickListBlock collectIndexBlock;
@end

NS_ASSUME_NONNULL_END
