//
//  UGLotteryTicketCollectionViewCell.h
//  ug
//
//  Created by ug on 2019/5/3.
//  Copyright © 2019 ug. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UGNextIssueModel;
NS_ASSUME_NONNULL_BEGIN

@interface UGLotteryCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UGNextIssueModel *item;
@property (nonatomic, strong) NSString *time;

@end

NS_ASSUME_NONNULL_END
