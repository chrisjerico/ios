//
//  UGGameplayModel.m
//  ug
//
//  Created by ug on 2019/6/10.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGGameplayModel.h"

@implementation UGBetModel

@end


@implementation UGGameBetModel

+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"id":@"playId",
                                                       @"played_groupid":@"groupId"
                                                       }];
}

//
//- (void)encodeWithCoder:(NSCoder *)aCoder
//{
//    [aCoder encodeObject:self.playId forKey:@"playId"];
//    [aCoder encodeObject:self.playIds forKey:@"playIds"];
//    [aCoder encodeObject:self. betInfo forKey:@"betInfo"];
//    
//    [aCoder encodeObject:self.name forKey:@"name"];
//    [aCoder encodeObject:self.typeName forKey:@"typeName"];
//    [aCoder encodeObject:self. code forKey:@"code"];
//    
//    [aCoder encodeObject:self.gameId forKey:@"gameId"];
//    [aCoder encodeObject:self.groupId forKey:@"groupId"];
//    [aCoder encodeObject:self. odds forKey:@"odds"];
//    
//    
//    [aCoder encodeObject:self.offlineOdds forKey:@"offlineOdds"];
//    [aCoder encodeObject:self.minMoney forKey:@"minMoney"];
//    [aCoder encodeObject:self. maxMoney forKey:@"maxMoney"];
//    
//    [aCoder encodeObject:self.maxTurnMoney forKey:@"maxTurnMoney"];
//    [aCoder encodeObject:self.from_id forKey:@"from_id"];
//    [aCoder encodeObject:self. rebate forKey:@"rebate"];
//    
//    [aCoder encodeObject:self.groupNum forKey:@"groupNum"];
//    [aCoder encodeObject:self.groupColor forKey:@"groupColor"];
//    [aCoder encodeObject:self. title forKey:@"title"];
//    
//    [aCoder encodeObject:self.money forKey:@"money"];
//    [aCoder encodeObject:self.typeName2 forKey:@"typeName2"];
// 
//}

//- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder
//{
//    if (self = [super init]) {
// 
//        self.playId = [aDecoder decodeObjectForKey:@"playId"];
//        self.playIds = [aDecoder decodeObjectForKey:@"playIds"];
//        self.betInfo = [aDecoder decodeObjectForKey:@"betInfo"];
//        
//        self.name = [aDecoder decodeObjectForKey:@"name"];
//        self.typeName = [aDecoder decodeObjectForKey:@"typeName"];
//        self.code = [aDecoder decodeObjectForKey:@"code"];
//        
//        self.gameId = [aDecoder decodeObjectForKey:@"gameId"];
//        self.groupId = [aDecoder decodeObjectForKey:@"groupId"];
//        self.odds = [aDecoder decodeObjectForKey:@"odds"];
//        
//        self.offlineOdds = [aDecoder decodeObjectForKey:@"offlineOdds"];
//        self.minMoney = [aDecoder decodeObjectForKey:@"minMoney"];
//        self.maxMoney = [aDecoder decodeObjectForKey:@"maxMoney"];
//        
//        self.maxTurnMoney = [aDecoder decodeObjectForKey:@"maxTurnMoney"];
//        self.from_id = [aDecoder decodeObjectForKey:@"from_id"];
//        self.rebate = [aDecoder decodeObjectForKey:@"rebate"];
//        
//        self.groupNum = [aDecoder decodeObjectForKey:@"groupNum"];
//        self.groupColor = [aDecoder decodeObjectForKey:@"groupColor"];
//        self.title = [aDecoder decodeObjectForKey:@"title"];
//        
//        self.money = [aDecoder decodeObjectForKey:@"money"];
//        self.typeName2 = [aDecoder decodeObjectForKey:@"typeName2"];
//  
//    }
//    
//    return self;
//            
//}
@end

@implementation UGGameplaySectionModel

+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"id":@"groupId",
                                                       @"plays":@"list"
                                                       }];
}

@end

@implementation UGGameplayModel
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"playGroups":@"list"
                                                       }];
}

@end

@implementation UGPlayOddsModel


@end
