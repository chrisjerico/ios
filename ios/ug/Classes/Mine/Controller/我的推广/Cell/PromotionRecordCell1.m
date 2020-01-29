//
//  PromotionRecordCell1.m
//  ug
//
//  Created by xionghx on 2020/1/11.
//  Copyright © 2020 ug. All rights reserved.
//

#import "PromotionRecordCell1.h"
@interface PromotionRecordCell1()
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *itemLabels;

@end

@implementation PromotionRecordCell1
- (void)bindOtherReport:(UGrealBetStatModel *)model {
	((UILabel *)self.itemLabels[0]).text = [model.level stringValue];
	((UILabel *)self.itemLabels[1]).text = model.date;
	((UILabel *)self.itemLabels[2]).text = model.bet_sum;
	((UILabel *)self.itemLabels[3]).text = model.netAmount;
}
- (void)bindBetReport:(UGbetStatModel *)model {
    int intLevel = [model.level intValue];
    if (intLevel == 0) {
         ((UILabel *)self.itemLabels[0]).text = @"全部下线";
    }
    else{
         ((UILabel *)self.itemLabels[0]).text = [NSString stringWithFormat:@"%d级下线",intLevel];
    }
    if ([CMCommon stringIsNull:model.date]) {
        ((UILabel *)self.itemLabels[1]).text = @"--";
    } else {
        ((UILabel *)self.itemLabels[1]).text = model.date;
    }
	((UILabel *)self.itemLabels[2]).text = model.bet_sum;
	((UILabel *)self.itemLabels[3]).text = model.fandian_sum;

}
- (void)bindBetRecord:(UGBetListModel *)model {
	((UILabel *)self.itemLabels[0]).text = [model.level stringValue];
	((UILabel *)self.itemLabels[1]).text = model.date;
	((UILabel *)self.itemLabels[2]).text = model.username;
	((UILabel *)self.itemLabels[3]).text = model.money;

}
//存款报表
- (void)bindDepositList:(UGdepositStatModel *)model {
    int intLevel = [model.level intValue];
    if (intLevel == 0) {
        ((UILabel *)self.itemLabels[0]).text = @"全部下线";
    }
    else{
        ((UILabel *)self.itemLabels[0]).text = [NSString stringWithFormat:@"%d级下线",intLevel];
    }
    ((UILabel *)self.itemLabels[0]).text = [model.level stringValue];
    if ([CMCommon stringIsNull:model.date]) {
        ((UILabel *)self.itemLabels[1]).text = @"--";
    } else {
        ((UILabel *)self.itemLabels[1]).text = model.date;
    }
    ((UILabel *)self.itemLabels[2]).text = model.amount;
    int intMember = [model.member intValue];
    if (intMember) {
        ((UILabel *)self.itemLabels[3]).text = [NSString stringWithFormat:@"%d人",intMember];
    } else {
        ((UILabel *)self.itemLabels[3]).text = @"--";
    }
}
//提款报表
- (void)bindWithdrawalsList:(UGwithdrawStatModel *)model {
    int intLevel = [model.level intValue];
    if (intLevel == 0) {
        ((UILabel *)self.itemLabels[0]).text = @"全部下线";
    }
    else{
        ((UILabel *)self.itemLabels[0]).text = [NSString stringWithFormat:@"%d级下线",intLevel];
    }
    ((UILabel *)self.itemLabels[0]).text = [model.level stringValue];
    if ([CMCommon stringIsNull:model.date]) {
        ((UILabel *)self.itemLabels[1]).text = @"--";
    } else {
        ((UILabel *)self.itemLabels[1]).text = model.date;
    }
    ((UILabel *)self.itemLabels[2]).text = model.amount;
    int intMember = [model.member intValue];
    if (intMember) {
        ((UILabel *)self.itemLabels[3]).text = [NSString stringWithFormat:@"%d人",intMember];
    } else {
        ((UILabel *)self.itemLabels[3]).text = @"--";
    }

}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:false animated:animated];

    // Configure the view for the selected state
}

@end
