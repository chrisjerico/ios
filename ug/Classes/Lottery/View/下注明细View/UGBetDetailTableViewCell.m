
//  UGBetDetailTableViewCell.m
//  ug
//
//  Created by ug on 2019/5/14.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGBetDetailTableViewCell.h"
#import "UGGameplayModel.h"

@interface UGBetDetailTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UILabel *oddsLabel;
@property (weak, nonatomic) IBOutlet UITextField *amountField;

@end
@implementation UGBetDetailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
	
	[self.amountField addTarget:self action:@selector(amountEdited:) forControlEvents:UIControlEventAllEditingEvents];
	
	UILabel * label = [UILabel new];
	label.text = @" 元 ";
	self.amountField.rightView = label;
	self.amountField.rightViewMode = UITextFieldViewModeAlways;
	
}
- (IBAction)delectClick:(id)sender {
    if (self.delectBlock) {
        self.delectBlock();
    }
}

- (void)setItem:(UGBetModel *)item {
    _item = item;
    if (item.displayInfo.length) {
         self.numberLabel.text = [NSString stringWithFormat:@"%@-%@",item.title,item.displayInfo];
    }else if (item.betInfo.length) {
        self.numberLabel.text = [NSString stringWithFormat:@"%@-%@",item.title,item.betInfo];
    }else {
         self.numberLabel.text = [NSString stringWithFormat:@"%@-%@",item.title,item.name];
    }
    self.amountField.text = [NSString stringWithFormat:@"%@",item.money];
    self.oddsLabel.text = [NSString stringWithFormat:@"%@%@",@"@",[item.odds removeFloatAllZero]];

}


- (void)amountEdited: (UITextField *)sender {
	if (self.amountEditedBlock) {
		self.amountEditedBlock([sender.text floatValue]);
	}
	
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}


@end
