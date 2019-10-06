//
//  UGLotteryGameCollectionViewCell.h
//  ug
//
//  Created by ug on 2019/6/28.
//  Copyright © 2019 ug. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UGNextIssueModel;
NS_ASSUME_NONNULL_BEGIN

@interface UGLotteryGameCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong) UGNextIssueModel *item;
@property (nonatomic, strong) NSString *time;
@end

NS_ASSUME_NONNULL_END
