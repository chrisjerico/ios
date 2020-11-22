//
//  UGYYRightMenuView.h
//  ug
//
//  Created by ug on 2019/9/27.
//  Copyright © 2019 ug. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UGAllNextIssueListModel.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^YYRightMenuBlock)(void);

@interface UGYYRightMenuView : UIView

@property (nonatomic, strong) NSString *gameId;
@property (nonatomic, strong) NSString *gameName;
@property (nonatomic, strong) NSString *titleType;//1 为首页，2 为彩种
@property (nonatomic, assign) BOOL showFromLeft;

- (void)show;
@end

NS_ASSUME_NONNULL_END
