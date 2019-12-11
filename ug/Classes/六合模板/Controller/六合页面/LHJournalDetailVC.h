//
//  LHJournalDetailVC.h
//  ug
//
//  Created by fish on 2019/11/30.
//  Copyright © 2019 ug. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UGLHCategoryListModel.h"
#import "UGLHGalleryModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LHJournalDetailVC : UIViewController

@property (nonatomic, strong) UGLHCategoryListModel *clm;   /**<   六合栏目Model */
@property (nonatomic, strong) UGLHGalleryModel *gm;         /**<   图库Model */
@property (nonatomic, strong) NSString *pid;                /**<   选中帖子 */
@end

NS_ASSUME_NONNULL_END
