//
//  YNHZMPrizeDetailView.h
//  UGBWApp
//
//  Created by ug on 2020/9/3.
//  Copyright © 2020 ug. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^YNHZMPrizeDetailViewBetBlock)(void);
typedef void(^YNHZMPrizeDetailViewCancelBlock)(void);
@interface YNHZMPrizeDetailView : UIView
@property (nonatomic, copy) YNHZMPrizeDetailViewBetBlock betClickBlock;
@property (nonatomic, copy) YNHZMPrizeDetailViewCancelBlock cancelBlock;
@property (nonatomic, strong) UGNextIssueModel *nextIssueModel;
- (void)show;
@end

NS_ASSUME_NONNULL_END
