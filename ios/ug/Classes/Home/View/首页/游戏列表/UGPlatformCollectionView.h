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
@property (nonatomic, strong) NSString * iid;;//类型 //ob.name = 热门游戏 7 ob.name = 彩票游戏 1 ob.name = 真人视讯 2
@property (nonatomic, assign)NSInteger typeIndex;
@property (nonatomic, copy) void(^gameTypeSelectBlock)(NSInteger index);
@property (nonatomic, copy) void(^gameItemSelectBlock)(GameModel *game);

@property (nonatomic, strong) NSArray <GameModel *> *dataArray;

- (instancetype)initWithFrame:(CGRect)frame;
@end

@interface CollectionFooter : UICollectionReusableView

@property (nonatomic) UGGameSubCollectionView *gameSubCollectionView;
@property (nonatomic) NSArray<GameSubModel*> *sourceData;

@property (nonatomic) void(^gameItemSelectBlock)(GameModel *game);
@end
NS_ASSUME_NONNULL_END
