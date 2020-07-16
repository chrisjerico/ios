//
//  DZPTwoTableViewCell.h
//  UGBWApp
//
//  Created by ug on 2020/5/5.
//  Copyright © 2020 ug. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DZPTwoTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *rowLB;
@property (weak, nonatomic) IBOutlet UILabel *numberLB;
@property (weak, nonatomic) IBOutlet UILabel *recordLB;

@end

NS_ASSUME_NONNULL_END
