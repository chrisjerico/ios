//
//  ScratchParamModel.h
//  UGBWApp
//
//  Created by xionghx on 2020/8/30.
//  Copyright © 2020 ug. All rights reserved.
//

#import "UGModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ScratchParamModel <NSObject>

@end
@interface ScratchParamModel : UGModel<ScratchParamModel>
@property(nonatomic, strong)id  content_turntable;
@property(nonatomic, assign)NSInteger activity_show;

@end


NS_ASSUME_NONNULL_END
