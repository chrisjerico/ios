//
//  UGTableViewController.h
//  ug
//
//  Created by ug on 2019/10/1.
//  Copyright © 2019 ug. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UGLHCategoryListModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface UGTableViewController : UITableViewController
@property (nonatomic, strong) UGLHCategoryListModel *clm;
@end

NS_ASSUME_NONNULL_END
