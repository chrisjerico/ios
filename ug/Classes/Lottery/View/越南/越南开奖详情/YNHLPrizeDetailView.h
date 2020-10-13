//
//  YNHLPrizeDetailView.h
//  UGBWApp
//
//  Created by ug on 2020/9/3.
//  Copyright © 2020 ug. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YNView.h"
NS_ASSUME_NONNULL_BEGIN
typedef void(^YNHLPrizeDetailViewBetBlock)(void);
typedef void(^YNHLPrizeDetailViewCancelBlock)(void);


@interface YNHLPrizeDetailView : YNView
@property (nonatomic, copy) YNHLPrizeDetailViewBetBlock betClickBlock;
@property (nonatomic, copy) YNHLPrizeDetailViewCancelBlock cancelBlock;
@property (nonatomic, strong) UGNextIssueModel *nextIssueModel;
@property (nonatomic, strong) NSString *selCode;//选中的越南菜code
@property (nonatomic) BOOL isHide8View;//河内 隐藏  八等奖View
- (void)show;
@end

NS_ASSUME_NONNULL_END
