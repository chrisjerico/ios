//
//  UGPromotion4rowTableViewCell.h
//  ug
//
//  Created by ug on 2019/9/8.
//  Copyright © 2019 ug. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^Promotion4rowButtonBlock)(void);


@interface UGPromotion4rowTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *firstLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondLabel;
@property (weak, nonatomic) IBOutlet UILabel *thirdLabel;
@property (weak, nonatomic) IBOutlet UILabel *fourthLabel;


@property (weak, nonatomic) IBOutlet UIButton *fouthButton;
@property (nonatomic, copy) Promotion4rowButtonBlock promotion4rowButtonBlock;
@end

NS_ASSUME_NONNULL_END
