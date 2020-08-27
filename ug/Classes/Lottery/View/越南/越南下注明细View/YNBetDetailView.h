//
//  YNBetDetailView.h
//  UGBWApp
//
//  Created by ug on 2020/8/24.
//  Copyright © 2020 ug. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UGGameplayModel.h"

@class UGNextIssueModel;
NS_ASSUME_NONNULL_BEGIN

typedef void(^YNBetDetailViewBetBlock)(void);
typedef void(^YNBetDetailViewCancelBlock)(void);
@interface YNBetDetailView : UIView

@property (nonatomic, copy) YNBetDetailViewBetBlock betClickBlock;
@property (nonatomic, copy) YNBetDetailViewCancelBlock cancelBlock;
@property (nonatomic, copy) NSArray <UGGameBetModel *> *dataArray;
@property (nonatomic, strong) UGNextIssueModel *nextIssueModel;
@property (nonatomic, copy) NSString *code;
- (void)show;
@end

NS_ASSUME_NONNULL_END
