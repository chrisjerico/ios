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
@property (nonatomic, strong)NSString *code;//类型
@property (nonatomic, strong)NSMutableArray<UGGameBetModel *> *dataArry;//数据

@property (nonatomic, copy) QuickListBlock collectIndexBlock;

@property (nonatomic) int selecedCount;// 可以选择的数量  （偏斜2 偏斜3 偏斜4 串烧4 串烧8 串烧10）

@property (nonatomic) BOOL seleced;//是否有 可以选择的数量

@property (nonatomic, strong)NSMutableArray<NSString *> *selecedDataArry;//已选中数据
@end

NS_ASSUME_NONNULL_END
