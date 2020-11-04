//
//  InviteCodeListModel.h
//  UGBWApp
//
//  Created by xionghx on 2020/11/2.
//  Copyright © 2020 ug. All rights reserved.
//

#import "UGModel.h"
#import "InviteCodeModel.h"

NS_ASSUME_NONNULL_BEGIN


@protocol InviteCodeListModel <NSObject>

@end
@interface InviteCodeListModel : UGModel
@property (nonatomic, strong)NSArray<InviteCodeModel> * list;

@end
NS_ASSUME_NONNULL_END
