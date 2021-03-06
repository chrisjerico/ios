//
//  UGCell190HeaderView.h
//  ug
//
//  Created by ug on 2020/2/27.
//  Copyright © 2020 ug. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UGPromoteModel;
NS_ASSUME_NONNULL_BEGIN
typedef void(^UGCell190HeaderViewClickBlcok)(void);
typedef void(^UGCell19HeaderViewBlcok)(void);
@interface UGCell190HeaderView : UITableViewHeaderFooterView
@property (nonatomic, strong) UGPromoteModel *item;
@property (nonatomic, copy) UGCell190HeaderViewClickBlcok clickBllock;
@property (nonatomic, copy) UGCell19HeaderViewBlcok hBllock;

+ (CGFloat)heightWithModel:(UGPromoteModel *)item;
@end

NS_ASSUME_NONNULL_END
