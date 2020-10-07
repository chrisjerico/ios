//
//  UGNextIssueModel.m
//  ug
//
//  Created by ug on 2019/5/15.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGAllNextIssueListModel.h"

@implementation UGNextIssueModel
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id":@"gameId",
                                                       @"preResult":@"preNumSx"
                                                       }];
}

+ (instancetype)modelWithGameId:(NSString *)gameId {
    for (UGAllNextIssueListModel *listGame in UGAllNextIssueListModel.lotteryGamesArray) {
        for (UGNextIssueModel *nim in listGame.list)
            if ([nim.gameId isEqualToString:gameId])
                return nim;
    }
    return nil;
}



@end

@implementation UGAllNextIssueListModel

static NSArray<UGAllNextIssueListModel *> *__lotteryGamesArray = nil;

+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id":@"gameId",
                                                      
                                                       }];
}

+ (NSArray<UGAllNextIssueListModel *> *)lotteryGamesArray {
    return __lotteryGamesArray;
}

+ (void)setLotteryGamesArray:(NSArray<UGAllNextIssueListModel *> *)lotteryGamesArray {
    __lotteryGamesArray = [lotteryGamesArray mutableCopy];
}

@end


