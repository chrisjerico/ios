//
//  LHPostPayView.h
//  ug
//
//  Created by fish on 2019/12/1.
//  Copyright © 2019 ug. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UGLHPostModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LHPostPayView : UIView

@property (nonatomic, strong) UGLHPostModel *pm;
@property (nonatomic, copy) void (^didConfirmBtnClick)(LHPostPayView *ppv);
- (void)show;
- (IBAction)hide:(UIButton *_Nullable)sender;
@end

NS_ASSUME_NONNULL_END
