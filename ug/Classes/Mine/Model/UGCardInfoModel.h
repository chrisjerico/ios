//
//  UGCardInfoModel.h
//  ug
//
//  Created by ug on 2019/6/25.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface UGCardInfoModel : UGModel
@property (nonatomic, strong) NSString *bankCard;
@property (nonatomic, strong) NSString *bankId;
@property (nonatomic, strong) NSString *bankName;
@property (nonatomic, strong) NSString *ownerName;
@property (nonatomic, strong) NSString *bankAddr;

+ (instancetype)currentBankCardInfo;

+ (void)setCurrentBankCardInfo:(UGCardInfoModel *)bankCard;

@end

NS_ASSUME_NONNULL_END
