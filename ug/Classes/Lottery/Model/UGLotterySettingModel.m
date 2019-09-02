//
//  UGLotterySettingModel.m
//  ug
//
//  Created by ug on 2019/7/29.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGLotterySettingModel.h"

@implementation UGZodiacModel

@end

@implementation UGLotterySettingModel

- (NSArray<UGZodiacModel> *)tails {
    NSMutableArray *array = [NSMutableArray array];
    UGZodiacModel *model0 = [[UGZodiacModel alloc] init];
    model0.name = @"0尾";
    model0.nums = @[@"10",@"20",@"30",@"40",];
    [array addObject:model0];
    
    for (int i = 1; i < 10; i++) {
        UGZodiacModel *model = [[UGZodiacModel alloc] init];
        model.name = [NSString stringWithFormat:@"%d尾",i];
        NSMutableArray *mutArr = [NSMutableArray array];
        for (int y = 0; y < 5; y++) {
            NSString *numStr = [NSString stringWithFormat:@"%d%d",y,i];
            [mutArr addObject:numStr];
        }
        model.nums = mutArr.copy;
        [array addObject:model];
    }
    
    return array.copy;
}

@end
