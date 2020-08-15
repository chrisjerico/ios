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

@property (nonatomic, strong) UGGameBetModel *item;
@end

NS_ASSUME_NONNULL_END
