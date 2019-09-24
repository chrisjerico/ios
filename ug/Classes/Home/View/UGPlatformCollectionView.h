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
typedef void(^GameTypeSelectBlock)(NSInteger index);
typedef void(^GameItemSelectBlock)(GameModel *game);

@interface UGPlatformCollectionView : UICollectionView
@property (nonatomic, copy) GameTypeSelectBlock gameTypeSelectBlock;
@property (nonatomic, copy) GameItemSelectBlock gameItemSelectBlock;

@property (nonatomic, strong) NSArray *dataArray;
- (instancetype)initWithFrame:(CGRect)frame;

@end

@interface CollectionFooter : UICollectionReusableView

@property (nonatomic, strong) UGGameSubCollectionView * gameSubCollectionView;
@property(nonatomic, strong)NSArray<GameSubModel*> *sourceData;

@property (nonatomic, copy) GameItemSelectBlock gameItemSelectBlock;


@end
NS_ASSUME_NONNULL_END
