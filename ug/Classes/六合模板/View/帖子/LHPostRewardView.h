//
//  LHPostRewardView.h
//  ug
//
//  Created by fish on 2019/12/1.
//  Copyright © 2019 ug. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UGLHPostModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LHPostRewardView : UIView

@property (nonatomic, strong) UGLHPostModel *pm;
@property (nonatomic, copy) void (^didConfirmBtnClick)(LHPostRewardView *prv, double price);
- (void)show;
- (IBAction)hide:(UIButton *_Nullable)sender;
@end

NS_ASSUME_NONNULL_END
