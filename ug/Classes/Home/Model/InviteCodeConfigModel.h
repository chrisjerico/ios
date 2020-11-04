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

@end

NS_ASSUME_NONNULL_END
