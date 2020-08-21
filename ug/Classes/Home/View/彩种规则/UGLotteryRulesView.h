//
//  UGLotteryRulesView.h
//  ug
//
//  Created by ug on 2019/6/1.
//  Copyright © 2019 ug. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UGLotteryRulesView : UIView
@property (nonatomic, copy) NSString *gameId;   /**<   id，根据参数请求内容 */

@property (nonatomic, copy) NSString *title;    /**<   标题 */
@property (nonatomic, copy) NSString *content;  /**<   直接显示的内容 */

- (void)show;
@end

NS_ASSUME_NONNULL_END
