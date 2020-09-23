//
//  NewLotteryGameCollectionViewCell.h
//  UGBWApp
//
//  Created by fish on 2020/9/23.
//  Copyright © 2020 ug. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UGNextIssueModel;
NS_ASSUME_NONNULL_BEGIN

@interface NewLotteryGameCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong) UGNextIssueModel *item;
@end

NS_ASSUME_NONNULL_END
