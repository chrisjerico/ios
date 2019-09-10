//
//  UGdepositModel.h
//  ug
//
//  Created by ug on 2019/9/10.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol UGrechargeBankModel <NSObject>

@end
@interface UGrechargeBankModel : UGModel<UGrechargeBankModel>

@property (nonatomic, strong) NSString *code;//
@property (nonatomic, strong) NSString *name;//
@end
//======================================
@protocol UGparaModel <NSObject>

@end
@interface UGparaModel : UGModel<UGparaModel>

@property (nonatomic, strong) NSArray <UGrechargeBankModel>*bankList;//银行数组
@property (nonatomic, strong) NSString *fixedAmount;//按钮的数组
@end
//======================================
@protocol UGchannelModel <NSObject>

@end
@interface UGchannelModel : UGModel<UGchannelModel>

@property (nonatomic, strong) NSString *payeeName;//标题
@property (nonatomic, strong) NSString *branchAddress;//支行地址
@property (nonatomic, strong) NSString *address;//地址
@property (nonatomic, strong) NSString *domain;//域
@property (nonatomic, strong) NSString *name;//名字
@property (nonatomic, strong) NSString *account;//银行账户
@property (nonatomic, strong) NSString *qrcode;//银行账户

@property (nonatomic, strong) UGparaModel *para;//银行+按钮数组
@end
//======================================
@protocol UGpaymentModel <NSObject>

@end
@interface UGpaymentModel : UGModel<UGpaymentModel>

@property (nonatomic, strong) NSString *pid;//online 为在线
@property (nonatomic, strong) NSString *name;//名字
@property (nonatomic, strong) NSString *tip;//小标题
@property (nonatomic, strong) NSString *prompt;//提示
@property (nonatomic, strong) NSString *transferPrompt;//提示
@property (nonatomic, strong) NSString *depositPrompt;//提示
@property (nonatomic, strong) NSArray *quickAmount;//默认按钮的数组

@property (nonatomic, strong) NSArray <UGchannelModel>*channel;//呈现的数据数组

@end

//========================================
@protocol UGdepositModel <NSObject>

@end
@interface UGdepositModel : UGModel<UGdepositModel>

@property (nonatomic, strong) NSString *transferPrompt;//线上的提示
@property (nonatomic, strong) NSString *depositPrompt;//线下的提示
@property (nonatomic, strong) NSArray *quickAmount;//默认按钮的数组

@property (nonatomic, strong) NSArray<UGpaymentModel> *payment;

@end

NS_ASSUME_NONNULL_END
