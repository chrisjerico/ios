//
//  UGPromotion5rowButtonTableViewCell.h
//  ug
//
//  Created by ug on 2019/9/8.
//  Copyright © 2019 ug. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^Promotion5rowButtonBlock)(void);

@interface UGPromotion5rowButtonTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *firstLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondLabel;
@property (weak, nonatomic) IBOutlet UILabel *thirdLabel;
@property (weak, nonatomic) IBOutlet UILabel *fourthLabel;
@property (weak, nonatomic) IBOutlet UILabel *fifthLabel;

@property (weak, nonatomic) IBOutlet UIButton *fifthButton;

@property (nonatomic, copy) Promotion5rowButtonBlock promotion5rowButtonBlock;

@end

NS_ASSUME_NONNULL_END
