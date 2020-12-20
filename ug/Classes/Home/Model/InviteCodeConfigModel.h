//
//  InviteCodeConfigModel.h
//  UGBWApp
//
//  Created by xionghx on 2020/11/4.
//  Copyright © 2020 ug. All rights reserved.
//

#import "UGModel.h"

NS_ASSUME_NONNULL_BEGIN
@protocol InviteCodeConfigModel <NSObject>

@end

@interface InviteCodeConfigModel : UGModel

@property(nonatomic, strong)NSString* codeSwith;
@property(nonatomic, strong)NSString* displayWord;
@property(nonatomic, strong)NSString* canGenNum;
@property(nonatomic, strong)NSString* canUseNum;
@property(nonatomic, strong)NSString* randomSwitch;
@property(nonatomic, strong)NSString* randomLength;
@property(nonatomic, strong)NSString* noticeSwitch;//邀请码说明栏开关
@property(nonatomic, strong)NSString* noticeText;//邀请码说明栏文字

@end

NS_ASSUME_NONNULL_END
