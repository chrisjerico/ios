//
//  UGAgentViewController.h
//  ug
//
//  Created by ug on 2019/9/15.
//  Copyright © 2019 ug. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UGagentApplyInfo;
NS_ASSUME_NONNULL_BEGIN

@interface UGAgentViewController : UGViewController

@property (nonatomic, strong) UGagentApplyInfo *item;

@property (nonatomic, strong) NSString  *fromVC;

@end

NS_ASSUME_NONNULL_END
