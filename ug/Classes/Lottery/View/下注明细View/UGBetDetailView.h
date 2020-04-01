//
//  UGBetDetailView.h
//  ug
//
//  Created by ug on 2019/5/14.
//  Copyright © 2019 ug. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UGGameplayModel.h"

@class UGNextIssueModel;
NS_ASSUME_NONNULL_BEGIN

typedef void(^BetDetailViewBetBlock)(void);
typedef void(^BetDetailViewCancelBlock)(void);
@interface UGBetDetailView : UIView

@property (nonatomic, copy) BetDetailViewBetBlock betClickBlock;
@property (nonatomic, copy) BetDetailViewCancelBlock cancelBlock;
@property (nonatomic, copy) NSArray <UGGameBetModel *> *dataArray;
@property (nonatomic, strong) UGNextIssueModel *nextIssueModel;
@property (nonatomic, copy) NSString *code;
- (void)show;
@end

NS_ASSUME_NONNULL_END
