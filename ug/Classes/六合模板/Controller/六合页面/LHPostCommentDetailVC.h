//
//  LHPostCommentDetailVC.h
//  ug
//
//  Created by fish on 2019/11/29.
//  Copyright © 2019 ug. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UGLHPostCommentModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LHPostCommentDetailVC : UIViewController

@property (nonatomic, strong) UGLHPostCommentModel *pcm;    /**<   评论Model */
@property (nonatomic) void (^didReply)(UGLHPostCommentModel *pcm);
@property (nonatomic) void (^didLike)(UGLHPostCommentModel *pcm);
@end

NS_ASSUME_NONNULL_END
