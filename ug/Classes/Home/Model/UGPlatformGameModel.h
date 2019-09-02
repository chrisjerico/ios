//
//  UGPlatformGameModel.h
//  ug
//
//  Created by ug on 2019/6/14.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol UGSubGameModel <NSObject>

@end
@interface UGSubGameModel : UGModel<UGSubGameModel>
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *code;
@property (nonatomic, strong) NSString *pic;
@property (nonatomic, strong) NSString *type;


@end

@protocol UGPlatformGameModel <NSObject>

@end
@interface UGPlatformGameModel : UGModel<UGPlatformGameModel>
@property (nonatomic, strong) NSString *gameId;
@property (nonatomic, strong) NSString *category;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *short_name;
@property (nonatomic, strong) NSString *gameType;
@property (nonatomic, strong) NSString *gameTypeName;
@property (nonatomic, strong) NSString *gameCat;
@property (nonatomic, strong) NSString *gameSymbol;
@property (nonatomic, assign) BOOL isPopup;
@property (nonatomic, strong) NSString *sort;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *customise;
@property (nonatomic, strong) NSString *pic;
@property (nonatomic, strong) NSString *imgName;
@property (nonatomic, assign) BOOL isHot;
@property (nonatomic, strong) NSString *balance;//额度转换列表 真人余额
@property (nonatomic, assign) BOOL refreshing;


//@property (nonatomic, strong) NSArray<UGSubGameModel> *gameList;

@end

@protocol UGPlatformModel <NSObject>

@end
@interface UGPlatformModel : UGModel<UGPlatformModel>

@property (nonatomic, strong) NSString *category;
@property (nonatomic, strong) NSString *categoryName;
@property (nonatomic, strong) NSArray<UGPlatformGameModel> *games;
@end

NS_ASSUME_NONNULL_END
