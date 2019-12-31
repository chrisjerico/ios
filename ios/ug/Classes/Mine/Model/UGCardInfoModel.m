//
//  UGCardInfoModel.m
//  ug
//
//  Created by ug on 2019/6/25.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGCardInfoModel.h"
#define filePath  [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]stringByAppendingPathComponent:@"ugGameBankCardInfoModel"]

UGCardInfoModel * cardInfo = nil;
@implementation UGCardInfoModel

+ (instancetype)currentBankCardInfo {
    if (cardInfo == nil) {
        //解档
        UGCardInfoModel *decodedUser = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
        
        cardInfo = decodedUser;
    }
    
    return cardInfo;
    
}

+ (void)setCurrentBankCardInfo:(UGCardInfoModel *)bankCard {
    cardInfo = bankCard;
    //归档
    [NSKeyedArchiver archiveRootObject:bankCard toFile:filePath];
    
}

@end
