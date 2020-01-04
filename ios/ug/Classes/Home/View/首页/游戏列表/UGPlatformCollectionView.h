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
