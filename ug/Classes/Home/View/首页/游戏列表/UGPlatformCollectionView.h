//
//  UGPlatformCollectionView.h
//  ug
//
//  Created by xionghx on 2019/9/22.
//  Copyright © 2019 ug. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UGGameSubCollectionView.h"

NS_ASSUME_NONNULL_BEGIN

@interface UGPlatformCollectionView : UICollectionView
@property (nonatomic, strong) NSString * style;//类型  0=九宫格；1=列表式
@property (nonatomic, assign)NSInteger typeIndex;
@property (nonatomic, copy) void(^gameTypeSelectBlock)(NSInteger index);
@property (nonatomic, copy) void(^gameItemSelectBlock)(GameModel *game);

@property (nonatomic, strong) NSArray <GameModel *> *dataArray;
@property (nonatomic, strong) NSArray<GameCategoryModel *> * subType;/**<   二级分类数据 */

- (instancetype)initWithFrame:(CGRect)frame;
@end

@interface CollectionFooter : UICollectionReusableView

@property (nonatomic) UGGameSubCollectionView *gameSubCollectionView;
@property (nonatomic) NSArray<GameSubModel*> *sourceData;

@property (nonatomic) void(^gameItemSelectBlock)(GameModel *game);
@end
NS_ASSUME_NONNULL_END
