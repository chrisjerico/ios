//
//  UGPostCell1.h
//  ug
//
//  Created by fish on 2019/11/29.
//  Copyright © 2019 ug. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UGLHPostModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface UGPostCell1 : UITableViewCell

@property (nonatomic, strong) UGLHPostModel *pm;

@property (nonatomic) void (^didCommentBtnClick)(UGLHPostModel *pm);  /**<    点击评论 */

+ (CGFloat)heightWithModel:(UGLHPostModel *)pm;
+ (CGSize)collectionViewSizeWithModel:(UGLHPostModel *)pm;
+ (CGSize)itemSizeWithModel:(UGLHPostModel *)pm;
@end

NS_ASSUME_NONNULL_END
