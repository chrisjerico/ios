//
//  UGagentApplyInfo.h
//  ug
//
//  Created by ug on 2019/9/23.
//  Copyright © 2019 ug. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UGagentApplyInfo : UGModel
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *qq;
@property (nonatomic, strong) NSString *mobile;//
@property (nonatomic, strong) NSString *applyReason;//申请理由
@property (nonatomic, strong) NSString *reviewResult;//拒绝的理由
@property (nonatomic, strong) NSNumber *reviewStatus;//0 未提交  1 待审核  2 审核通过 3 审核拒绝
@property (nonatomic, assign) BOOL isAgent;//是否是代理  true 是   false 否
@end

NS_ASSUME_NONNULL_END
