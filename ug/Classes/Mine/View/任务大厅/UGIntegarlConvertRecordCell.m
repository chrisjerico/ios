//
//  UGIntegarlConvertRecordCell.m
//  ug
//
//  Created by ug on 2019/5/17.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGIntegarlConvertRecordCell.h"
#import "UGCreditsLogModel.h"


@interface UGIntegarlConvertRecordCell ()
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *integralLabel;
@property (weak, nonatomic) IBOutlet UILabel *gnewIntLabel;
@property (weak, nonatomic) IBOutlet UILabel *addTimeLabel;


@end
@implementation UGIntegarlConvertRecordCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    if ([Skin1.skitType isEqualToString:@"黑色模板"]) {
        [self setBackgroundColor: Skin1.bgColor];
        [self.typeLabel setTextColor:Skin1.textColor1];
        [self.integralLabel setTextColor:Skin1.textColor1];
        [self.gnewIntLabel setTextColor:Skin1.textColor1];
        [self.addTimeLabel setTextColor:Skin1.textColor1];
    } else {
        [self setBackgroundColor: [UIColor whiteColor]];
        [self.typeLabel setTextColor:[UIColor blackColor]];
        [self.integralLabel setTextColor:[UIColor blackColor]];
        [self.gnewIntLabel setTextColor:[UIColor blackColor]];
        [self.addTimeLabel setTextColor:[UIColor blackColor]];
    }
    

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setItem:(UGCreditsLogModel *)item {
    _item = item;
    self.typeLabel.text = item.type;
    self.integralLabel.text = item.integral;
    self.gnewIntLabel.text = item.gnewInt;
    self.addTimeLabel.text = item.addTime;
}
@end
