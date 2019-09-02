//
//  UGMessageModel.h
//  ug
//
//  Created by ug on 2019/5/22.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol UGMessageModel <NSObject>

@end
@interface UGMessageModel : UGModel<UGMessageModel>
//msg
@property (nonatomic, strong) NSString *messageId;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, assign) BOOL isRead;
@property (nonatomic, strong) NSString *updateTime;
@property (nonatomic, strong) NSString *readTime;

//feedback
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *createTime;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, strong) NSString *pid;
@property (nonatomic, assign) NSInteger type;

@end

@interface UGMessageListModel : UGModel

@property (nonatomic, assign) NSInteger total;
@property (nonatomic, assign) NSInteger readTotal;
@property (nonatomic, strong) NSArray<UGMessageModel> *list;

@end

NS_ASSUME_NONNULL_END
