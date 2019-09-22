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

@interface UGPlatformCollectionView : UICollectionView
@property (nonatomic, copy) GameTypeSelectBlock gameTypeSelectBlock;

@property (nonatomic, strong) NSArray *dataArray;
- (instancetype)initWithFrame:(CGRect)frame;

@end

@interface CollectionFooter : UICollectionReusableView

@property (nonatomic, strong) UGGameSubCollectionView * gameSubCollectionView;
@property(nonatomic, strong)NSArray<GameSubModel*> *sourceData;



@end
NS_ASSUME_NONNULL_END
