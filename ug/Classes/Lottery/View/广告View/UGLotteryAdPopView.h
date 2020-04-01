//
//  UGLotteryAdPopView.h
//  ug
//
//  Created by ug on 2019/8/2.
//  Copyright © 2019 ug. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UGAllNextIssueListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface UGLotteryAdPopView : UIView
@property (nonatomic) UGNextIssueModel *nm;

- (void)show;
@end

NS_ASSUME_NONNULL_END
