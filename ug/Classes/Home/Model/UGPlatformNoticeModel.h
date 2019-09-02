//
//  UGPlatformNoticeModel.h
//  ug
//
//  Created by ug on 2019/5/31.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface UGPlatformNoticeModel : UGModel

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *content;

@property (nonatomic, assign) BOOL hiddenBottomLine;


@end

NS_ASSUME_NONNULL_END
