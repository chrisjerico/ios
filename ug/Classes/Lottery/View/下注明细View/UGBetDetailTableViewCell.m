
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
    if (self.delectBlock)
        self.delectBlock();
}

- (void)setItem:(UGBetModel *)item {
    _item = item;
    
    if ([item.typeName isEqualToString:@"连肖"]||[item.typeName isEqualToString:@"连尾"]) {
        self.numberLabel.text = ({

                           NSString *name = item.title;
                          NSString *num = item.displayInfo.length ? item.displayInfo : (item.betInfo.length ? item.betInfo : item.name);
                          _NSString(@"%@_[%@]", name, num);

        });
    }
    else {
        self.numberLabel.text = ({

                    NSString *name = item.alias.length ? item.alias : item.title;
                   NSString *num = item.displayInfo.length ? item.displayInfo : (item.betInfo.length ? item.betInfo : item.name);
                   _NSString(@"%@[%@]", name, num);

           });
    }
    
    self.amountField.text = _NSString(@"%@", item.money);
    self.oddsLabel.text = _NSString(@"@%@", [item.odds removeFloatAllZero]);
    
    // 以下玩法不允许求改金额
    NSArray *titles = @[@"连码", @"连肖", @"合肖", @"连尾", @"自选不中", ];
    self.amountField.userInteractionEnabled = true;
    for (NSString *title in titles) {
        if ([item.title containsString:title] || [item.typeName containsString:title])
            self.amountField.userInteractionEnabled = false;
    }
}

- (void)amountEdited: (UITextField *)sender {
	if (self.amountEditedBlock) {
		self.amountEditedBlock([sender.text floatValue]);
	}
}

@end
