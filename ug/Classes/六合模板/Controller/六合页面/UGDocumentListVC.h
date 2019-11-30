//
//  UGDocumentListVC.h
//  ug
//
//  Created by fish on 2019/10/27.
//  Copyright © 2019 ug. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UGLHCategoryListModel.h"

NS_ASSUME_NONNULL_BEGIN

// 每期资料、公式规律
@interface UGDocumentListVC : UIViewController

@property (nonatomic, strong) UGLHCategoryListModel *clm;   /**<   六合栏目Model */
@end

NS_ASSUME_NONNULL_END
