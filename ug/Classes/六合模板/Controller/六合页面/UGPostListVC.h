//
//  UGPostListVC.h
//  ug
//
//  Created by fish on 2019/10/27.
//  Copyright © 2019 ug. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UGLHCategoryListModel.h"

NS_ASSUME_NONNULL_BEGIN

// 帖子列表
@interface UGPostListVC : UIViewController

- (void)refreshData;  /**<   重新拉取第一页的数据 */

// 以下参数二选一，只传一个即可
@property (nonatomic, strong) UGLHCategoryListModel *clm;               /**<   六合栏目Model（高手论坛、极品专帖） */
@property (nonatomic, copy) CCSessionModel *(^request)(NSInteger page); /**<   数据请求 */

@end

NS_ASSUME_NONNULL_END
