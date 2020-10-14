//
//  YNQuickListCollectionViewCell.h
//  UGBWApp
//
//  Created by andrew on 2020/7/31.
//  Copyright © 2020 ug. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UGGameBetModel;
NS_ASSUME_NONNULL_BEGIN

@interface YNQuickListCollectionViewCell : UICollectionViewCell
@property (nonatomic) BOOL hasSelected;//是否有 可以选择的数量
@property (nonatomic) BOOL hasBgColor;//是否可以背景变灰
@property (nonatomic, strong) UGGameBetModel *item;
@end

NS_ASSUME_NONNULL_END
