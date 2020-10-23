//
//  HomeRankingView.h
//  UGBWApp
//
//  Created by fish on 2020/10/16.
//  Copyright © 2020 ug. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HomeRankingView : UIView

- (void)start;/**<   开始滚动动画 */
- (void)pause;/**<   暂停滚动 */

- (void)reloadData:(void (^)(BOOL succ))completion;
@end

NS_ASSUME_NONNULL_END
