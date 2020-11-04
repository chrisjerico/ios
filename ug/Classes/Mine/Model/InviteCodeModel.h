//
//  InviteCodeModel.h
//  UGBWApp
//
//  Created by xionghx on 2020/11/2.
//  Copyright © 2020 ug. All rights reserved.
//

#import "UGModel.h"

NS_ASSUME_NONNULL_BEGIN
@protocol InviteCodeModel <NSObject>

@end
@interface InviteCodeModel : UGModel
@property (nonatomic, strong) NSString *codeId;
@property (nonatomic, strong) NSString *uid;
@property (nonatomic, strong) NSString *invite_code;
@property (nonatomic, strong) NSString *created_time;
@property (nonatomic, strong) NSString *user_type;
@property (nonatomic, strong) NSNumber *used_num;
@property (nonatomic, strong) NSString *user_type_txt;
@property (nonatomic, strong) NSString *url;

@end



NS_ASSUME_NONNULL_END
