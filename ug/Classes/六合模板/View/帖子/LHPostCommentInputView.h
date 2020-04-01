//
//  LHPostCommentInputView.h
//  C
//
//  Created by fish on 2019/4/1.
//  Copyright © 2019 fish. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UGLHPostModel.h"
#import "UGLHPostCommentModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LHPostCommentInputView : UIView

@property (nonatomic) void (^didComment)(NSString *text);

+ (LHPostCommentInputView *)show1:(UGLHPostModel *)pm;                /**<    评论帖子 */
+ (LHPostCommentInputView *)show2:(UGLHPostCommentModel *)pcm;        /**<    回复评论 */
@end

NS_ASSUME_NONNULL_END
