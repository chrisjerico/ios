//
//  UGNoticeModel.h
//  ug
//
//  Created by ug on 2019/6/23.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol UGNoticeModel <NSObject>

@end
@interface UGNoticeModel : UGModel<UGNoticeModel>
@property (nonatomic, strong) NSString *noticeId;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, assign) NSInteger nodeId;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *channel;
@property (nonatomic, strong) NSString *addTime;
@property (nonatomic, strong) NSString *updateTime;

@property (nonatomic, assign) BOOL hiddenBottomLine;

@end


@interface UGNoticeTypeModel : UGModel

@property (nonatomic, strong) NSArray<UGNoticeModel> *popup;
@property (nonatomic, strong) NSArray<UGNoticeModel> *scroll;

@end

NS_ASSUME_NONNULL_END
