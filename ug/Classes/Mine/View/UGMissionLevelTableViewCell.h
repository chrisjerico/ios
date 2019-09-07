//
//  UGMissionLevelTableViewCell.h
//  ug
//
//  Created by ug on 2019/5/16.
//  Copyright © 2019 ug. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UGlevelsModel;
NS_ASSUME_NONNULL_BEGIN

@interface UGMissionLevelTableViewCell : UITableViewCell

@property (nonatomic, strong) UGlevelsModel *item;

-(void)setSectionBgColor:(UIColor *)bgColor levelsSectionStr:(NSString *)levelsSectionStr;

@end

NS_ASSUME_NONNULL_END
