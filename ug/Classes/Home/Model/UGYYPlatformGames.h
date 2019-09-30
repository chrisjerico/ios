//
//  UGYYPlatformGames.h
//  ug
//
//  Created by ug on 2019/9/30.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol UGYYGames <NSObject>

@end
@interface UGYYGames :NSObject<UGYYGames>
@property (nonatomic , copy) NSString              * isSeal;
@property (nonatomic , copy) NSString              * isClose;
@property (nonatomic , copy) NSString              * isInstant;
@property (nonatomic , copy) NSString              * gameId;
@property (nonatomic , copy) NSString              * isHot;
@property (nonatomic , copy) NSString              * title;
@property (nonatomic , copy) NSString              * gameTypeName;
@property (nonatomic , copy) NSString              * pic;
@property (nonatomic , copy) NSString              * gameType;
@property (nonatomic , copy) NSString              * name;
@property (nonatomic , copy) NSNumber              * isPopup;//1 有下级菜单
@property (nonatomic , copy) NSString              * category;
@property (nonatomic , copy) NSString              * gameCat;
@property (nonatomic , copy) NSString              * gameSymbol;
@property (nonatomic , copy) NSNumber              * supportTrial;
@end
@protocol UGYYPlatformGames <NSObject>

@end
@interface UGYYPlatformGames : UGModel<UGYYPlatformGames>
@property (nonatomic , copy) NSArray<UGYYGames *>              * games;
@property (nonatomic , copy) NSString              * category;
@property (nonatomic , copy) NSString              * categoryName;
@end

NS_ASSUME_NONNULL_END
