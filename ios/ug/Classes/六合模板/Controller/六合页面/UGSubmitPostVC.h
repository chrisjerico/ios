//
//  UGSubmitPostVC.h
//  ug
//
//  Created by fish on 2019/10/27.
//  Copyright © 2019 ug. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UGLHCategoryListModel.h"

NS_ASSUME_NONNULL_BEGIN

// 发贴
@interface UGSubmitPostVC : UIViewController

@property (nonatomic, strong) UGLHCategoryListModel *clm;   /**<   六合栏目Model */
@property (nonatomic) void (^didSubmitAction)(void);
@end

NS_ASSUME_NONNULL_END
