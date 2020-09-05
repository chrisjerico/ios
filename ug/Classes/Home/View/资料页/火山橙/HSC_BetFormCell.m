//
//  HSC_BetFormCell.m
//  ug
//
//  Created by tim swift on 2020/1/18.
//  Copyright © 2020 ug. All rights reserved.
//

#import "HSC_BetFormCell.h"
@interface HSC_BetFormCell()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *gameImageView;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;



@end
@implementation HSC_BetFormCell

- (void)prepareForReuse {
    [super prepareForReuse];
    
    self.nameLabel.text = @[@"b***3",@"q***e",@"re***6",@"ow***e2",@"w***e",@"j0***w",@"t***83",@"g***98",@"p***w",@"x***w",@"a***s",@"i**32",][rand()%12] ;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)bindName:(NSString *)name time:(NSString *)time gameImageName:(NSString *)image number:(NSString *)number {
    _nameLabel.text = name;
    _timeLabel.text = time;
    _gameImageView.image = [UIImage imageNamed:image];
    NSString * gameName = @"香港六合彩";
    if ([image isEqualToString:@"hsc_form_game_2"]) {
        gameName = @"六合秒秒彩";
    } else if ([image isEqualToString:@"hsc_form_game_3"]) {
        gameName = @"幸运飞艇";
    } else if ([image isEqualToString:@"hsc_form_game_4"]) {
        gameName = @"香港六合彩";
    }else if ([image isEqualToString:@"hsc_form_game_1"]) {
        gameName = @"秒秒彩";
    }
    NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"我在%@投注了", gameName]];
    NSMutableAttributedString * amountAttributedSting = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@元", number]];
    [amountAttributedSting setColor:UIColor.redColor];
    [attributedString appendAttributedString:amountAttributedSting];
    [attributedString appendAttributedString: [[NSAttributedString alloc] initWithString:@"你也来试试吧"]];
    _contentLabel.attributedText = attributedString;
}

@end
