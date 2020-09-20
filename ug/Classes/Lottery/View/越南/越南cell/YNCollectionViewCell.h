//
//  YNCollectionViewCell.h
//  UGBWApp
//
//  Created by ug on 2020/8/16.
//  Copyright © 2020 ug. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UGGameBetModel;
NS_ASSUME_NONNULL_BEGIN

@interface YNCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong) UGGameBetModel *item;
@end

NS_ASSUME_NONNULL_END
