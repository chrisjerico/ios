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
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *itemViews;
@end

@implementation PromotionRecordCell1

- (void)celBgColor:(int)row {
    if (row%2) {
        [((UIView *)self.itemViews[0]) setBackgroundColor:RGBA(244, 245, 245, 0.7)];
        [((UIView *)self.itemViews[1]) setBackgroundColor:RGBA(244, 245, 245, 0.7)];
        [((UIView *)self.itemViews[2]) setBackgroundColor:RGBA(244, 245, 245, 0.7)];
        [((UIView *)self.itemViews[3]) setBackgroundColor:RGBA(244, 245, 245, 0.7)];
      
    } else {
        if (Skin1.isBlack) {
            [((UIView *)self.itemViews[0]) setBackgroundColor:Skin1.CLBgColor];
            [((UIView *)self.itemViews[1]) setBackgroundColor:Skin1.CLBgColor];
            [((UIView *)self.itemViews[2]) setBackgroundColor:Skin1.CLBgColor];
            [((UIView *)self.itemViews[3]) setBackgroundColor:Skin1.CLBgColor];
         
        } else {
            [((UIView *)self.itemViews[0]) setBackgroundColor:[UIColor whiteColor]];
            [((UIView *)self.itemViews[1]) setBackgroundColor:[UIColor whiteColor]];
            [((UIView *)self.itemViews[2]) setBackgroundColor:[UIColor whiteColor]];
            [((UIView *)self.itemViews[3]) setBackgroundColor:[UIColor whiteColor]];
         
        }
    }
}

//其他报表
- (void)bindOtherReport:(UGrealBetStatModel *)model row:(int )row{
    
     [self celBgColor:row];
    
    int intLevel = [model.level intValue];
    if (intLevel == 0) {
         ((UILabel *)self.itemLabels[0]).text = @"全部下线";
    }
    else{
         ((UILabel *)self.itemLabels[0]).text = [NSString stringWithFormat:@"%@级下线",[CMCommon switchNumber:intLevel]];
    }
    if ([CMCommon stringIsNull:model.date]) {
        ((UILabel *)self.itemLabels[1]).text = @"--";
    } else {
        ((UILabel *)self.itemLabels[1]).text = model.date;
    }
	((UILabel *)self.itemLabels[2]).text = model.bet_sum;
	((UILabel *)self.itemLabels[3]).text = model.netAmount;
}


- (void)bindBetReport:(UGbetStatModel *)model row:(int )row{
    
    [self celBgColor:row];
    
    int intLevel = [model.level intValue];
    if (intLevel == 0) {
         ((UILabel *)self.itemLabels[0]).text = @"全部下线";
    }
    else{
         ((UILabel *)self.itemLabels[0]).text = [NSString stringWithFormat:@"%@级下线",[CMCommon switchNumber:intLevel]];
    }
    if ([CMCommon stringIsNull:model.date]) {
        ((UILabel *)self.itemLabels[1]).text = @"--";
    } else {
        ((UILabel *)self.itemLabels[1]).text = model.date;
    }
	((UILabel *)self.itemLabels[2]).text = model.bet_sum;
	((UILabel *)self.itemLabels[3]).text = model.fandian_sum;

}
- (void)bindBetRecord:(UGBetListModel *)model row:(int )row{
    
     [self celBgColor:row];
    
    int intLevel = [model.level intValue];
    if (intLevel == 0) {
         ((UILabel *)self.itemLabels[0]).text = @"全部下线";
    }
    else{
         ((UILabel *)self.itemLabels[0]).text = [NSString stringWithFormat:@"%@级下线",[CMCommon switchNumber:intLevel]];
    }
    if ([CMCommon stringIsNull:model.date]) {
        ((UILabel *)self.itemLabels[1]).text = @"--";
    } else {
        ((UILabel *)self.itemLabels[1]).text = model.date;
    }
	((UILabel *)self.itemLabels[2]).text = model.username;
	((UILabel *)self.itemLabels[3]).text = model.money;

}
//存款报表
- (void)bindDepositList:(UGdepositStatModel *)model row:(int )row{
    
     [self celBgColor:row];
    
    int intLevel = [model.level intValue];
    if (intLevel == 0) {
        ((UILabel *)self.itemLabels[0]).text = @"全部下线";
    }
    else{
        ((UILabel *)self.itemLabels[0]).text = [NSString stringWithFormat:@"%@级下线",[CMCommon switchNumber:intLevel]];
    }
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
- (void)bindWithdrawalsList:(UGwithdrawStatModel *)model row:(int )row{
    
     [self celBgColor:row];
    
    int intLevel = [model.level intValue];
    if (intLevel == 0) {
        ((UILabel *)self.itemLabels[0]).text = @"全部下线";
    }
    else{
        ((UILabel *)self.itemLabels[0]).text = [NSString stringWithFormat:@"%@级下线",[CMCommon switchNumber:intLevel]];
    }
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

//存款记录
- (void)bindDepositRecord:(UGdepositListModel *)model row:(int )row{
    
     [self celBgColor:row];
    
    int intLevel = [model.level intValue];

    ((UILabel *)self.itemLabels[0]).text = [NSString stringWithFormat:@"%@级下线",[CMCommon switchNumber:intLevel]];
    ((UILabel *)self.itemLabels[1]).text = model.username;
    if ([CMCommon stringIsNull:model.date]) {
        ((UILabel *)self.itemLabels[2]).text = @"--";
    } else {
        ((UILabel *)self.itemLabels[2]).text = model.date;
    }
    ((UILabel *)self.itemLabels[3]).text = model.amount;
}

//提款记录
- (void)bindWithdrawalRecord:(UGwithdrawListModel *)model row:(int )row{
    
     [self celBgColor:row];
    
    int intLevel = [model.level intValue];

    ((UILabel *)self.itemLabels[0]).text = [NSString stringWithFormat:@"%@级下线",[CMCommon switchNumber:intLevel]];
    ((UILabel *)self.itemLabels[1]).text = model.username;
    if ([CMCommon stringIsNull:model.date]) {
        ((UILabel *)self.itemLabels[2]).text = @"--";
    } else {
        ((UILabel *)self.itemLabels[2]).text = model.date;
    }
    ((UILabel *)self.itemLabels[3]).text = model.amount;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    if (Skin1.isBlack) {
        [((UILabel *)self.itemLabels[0]) setTextColor:Skin1.textColor1];
        [((UILabel *)self.itemLabels[1]) setTextColor:Skin1.textColor1];
        [((UILabel *)self.itemLabels[2]) setTextColor:Skin1.textColor1];
        [((UILabel *)self.itemLabels[3]) setTextColor:Skin1.textColor1];
        
        [((UIView *)self.itemViews[0]) setBackgroundColor:Skin1.textColor4];
        [((UIView *)self.itemViews[1]) setBackgroundColor:Skin1.textColor4];
        [((UIView *)self.itemViews[2]) setBackgroundColor:Skin1.textColor4];
        [((UIView *)self.itemViews[3]) setBackgroundColor:Skin1.textColor4];

        
        [self setBackgroundColor:Skin1.CLBgColor];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:false animated:animated];

    // Configure the view for the selected state
}

@end
