//
//  UGBetDetailView.h
//  ug
//
//  Created by ug on 2019/5/14.
//  Copyright © 2019 ug. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UGNextIssueModel;
NS_ASSUME_NONNULL_BEGIN

typedef void(^BetDetailViewBetBlock)(void);
typedef void(^BetDetailViewCancelBlock)(void);
@interface UGBetDetailView : UGView

@property (nonatomic, copy) BetDetailViewBetBlock betClickBlock;
@property (nonatomic, copy) BetDetailViewCancelBlock cancelBlock;
@property (nonatomic, copy) NSArray *dataArray;
@property (nonatomic, strong) UGNextIssueModel *nextIssueModel;

- (void)show;
@end

NS_ASSUME_NONNULL_END
