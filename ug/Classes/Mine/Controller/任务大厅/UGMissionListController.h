//
//  UGMissionListController.h
//  ug
//
//  Created by ug on 2019/5/10.
//  Copyright © 2019 ug. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UGMissionListController : UITableViewController
@property (nonatomic, strong)NSString *typeid;//任务类型

-(void)dataReLoad;
@end

NS_ASSUME_NONNULL_END
