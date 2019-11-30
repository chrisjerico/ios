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

// 帖子列表（高手论坛、极品专帖）
@interface UGPostListVC : UIViewController

@property (nonatomic, strong) UGLHCategoryListModel *clm;   /**<   六合栏目Model */
@property (nonatomic, assign) NSInteger isHistory;
@end

NS_ASSUME_NONNULL_END
