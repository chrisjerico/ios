//
//  UGTaskTableViewCell.h
//  UGBWApp
//
//  Created by andrew on 2020/7/22.
//  Copyright © 2020 ug. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UGMissionModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface UGTaskTableViewCell : UITableViewCell
@property (nonatomic, strong) NSArray<UGMissionModel *> *typeArray;    /**<   type分类数据数组 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableHeightConstraint;
@end

NS_ASSUME_NONNULL_END
