//
//  UGPostDetailVC.h
//  ug
//
//  Created by fish on 2019/10/27.
//  Copyright © 2019 ug. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UGLHPostModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface UGPostDetailVC : UIViewController

@property (nonatomic, strong) UGLHPostModel *pm;
@property (nonatomic, assign) BOOL willComment;

@property (nonatomic) void (^didCommentOrLike)(UGLHPostModel *pm);
@property (nonatomic) void (^didDelete)(void);
@end

NS_ASSUME_NONNULL_END
