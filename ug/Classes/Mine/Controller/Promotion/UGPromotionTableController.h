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
    PromotionTableTypeMember,//会员管理 1
    PromotionTableTypeBettingReport,//投注报表 2
    PromotionTableTypeBettingRecord,//投注记录 3
    PromotionTableTypeDomainBinding,//域名绑定 4
    PromotionTableTypeDepositStatement,//存款报表 5
    PromotionTableTypeDepositRecord,//存款记录 6
    PromotionTableTypeWithdrawalReport,//提款报表 7
    PromotionTableTypeWithdrawalRcord, //提款记录 8
    PromotionTableTypeRealityReport,//真人报表 9
    PromotionTableTypeRealityRcord //真人记录 10
    
};
@interface UGPromotionTableController : UIViewController

- (instancetype)initWithTableType:(PromotionTableType )tableType;
@end

NS_ASSUME_NONNULL_END
