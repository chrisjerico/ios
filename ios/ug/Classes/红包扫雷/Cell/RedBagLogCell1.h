//
//  RedBagLogCell1.h
//  ug
//
//  Created by ug on 2020/2/15.
//  Copyright © 2020 ug. All rights reserved.
//

#import "UGTableViewCell.h"
#import "RedBagLogModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface RedBagLogCell1 : UGTableViewCell
-(void)bindRedBagLog: (RedBagLogModel *)model row:(int )row;
@end

NS_ASSUME_NONNULL_END
