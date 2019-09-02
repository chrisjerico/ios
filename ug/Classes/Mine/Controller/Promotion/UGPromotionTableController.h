//
//  UGPromotionTableController.h
//  ug
//
//  Created by ug on 2019/5/9.
//  Copyright © 2019 ug. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_OPTIONS(NSInteger, PromotionTableType) {
    PromotionTableTypeMember,//会员管理
    PromotionTableTypeBettingReport,//投注报表
    PromotionTableTypeBettingRecord,//投注记录
    PromotionTableTypeDomainBinding,//域名绑定
    PromotionTableTypeDepositStatement,//存款报表
    PromotionTableTypeDepositRecord,//存款记录
    PromotionTableTypeWithdrawalReport,//提款报表
    PromotionTableTypeWithdrawalRcord //提款记录
    
};
@interface UGPromotionTableController : UIViewController

- (instancetype)initWithTableType:(PromotionTableType )tableType;
@end

NS_ASSUME_NONNULL_END
