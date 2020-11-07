//
//  UGNextIssueModel.m
//  ug
//
//  Created by ug on 2019/5/15.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGAllNextIssueListModel.h"
#import "GameCategoryDataModel.h"

@implementation UGNextIssueModel
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id":@"gameId",
                                                       @"preResult":@"preNumSx"
                                                       }];
}

+ (instancetype)modelWithGameId:(NSString *)gameId model:(GameModel *)model{
    for (UGAllNextIssueListModel *listGame in UGAllNextIssueListModel.lotteryGamesArray) {
        for (UGNextIssueModel *nim in listGame.list)
            if ([nim.gameId isEqualToString:gameId])
                return nim;
    }
    
    if(model){
        UGNextIssueModel *nim2 = [UGNextIssueModel new];
        nim2.gameId = model.gameId;
        nim2.title = model.name;
        nim2.logo = model.icon;
        nim2.name = model.name;
        nim2.gameType = model.gameType;
        nim2.logo = model.logo;
        return nim2;
    }
    return nil;


}



@end

@implementation UGAllNextIssueListModel

static NSArray<UGAllNextIssueListModel *> *__lotteryGamesArray = nil;

+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id":@"gameId",
                                                       @"name":@"name",
                                                       }];
}

+ (NSArray<UGAllNextIssueListModel *> *)lotteryGamesArray {
    return __lotteryGamesArray;
}

+ (void)setLotteryGamesArray:(NSArray<UGAllNextIssueListModel *> *)lotteryGamesArray {
    __lotteryGamesArray = [lotteryGamesArray mutableCopy];
}

@end


