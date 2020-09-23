//
//  UGTimeLotteryBetCollectionViewCell.h
//  ug
//
//  Created by ug on 2019/5/11.
//  Copyright © 2019 ug. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UGGameBetModel;

NS_ASSUME_NONNULL_BEGIN

@interface UGTimeLotteryBetCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;//表头
@property (weak, nonatomic) IBOutlet UILabel *numberLB;//数字


@property (nonatomic, strong) UGGameBetModel *item;
@end

NS_ASSUME_NONNULL_END
