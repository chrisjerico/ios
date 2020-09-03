//
//  YNHLPrizeDetailView.h
//  UGBWApp
//
//  Created by ug on 2020/9/3.
//  Copyright © 2020 ug. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^YNHLPrizeDetailViewBetBlock)(void);
typedef void(^YNHLPrizeDetailViewCancelBlock)(void);


@interface YNHLPrizeDetailView : UIView
@property (nonatomic, copy) YNHLPrizeDetailViewBetBlock betClickBlock;
@property (nonatomic, copy) YNHLPrizeDetailViewCancelBlock cancelBlock;
@property (nonatomic, strong) UGNextIssueModel *nextIssueModel;
- (void)show;
@end

NS_ASSUME_NONNULL_END
