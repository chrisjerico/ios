//
//  UGPromoteModel.h
//  ug
//
//  Created by ug on 2019/6/23.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol UGPromoteModel <NSObject>


@end
@interface UGPromoteModel : UGModel<UGPromoteModel>
@property (nonatomic, strong) NSString *promoteId;
@property (nonatomic, strong) NSString *pic;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, assign) NSInteger category;

@end

@interface UGPromoteListModel : UGModel

@property (nonatomic, strong) NSString *style;
@property (nonatomic, strong) NSArray<UGPromoteModel> *list;



@end

NS_ASSUME_NONNULL_END
