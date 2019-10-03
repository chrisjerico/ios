//
//  UGLotteryAssistantTableViewCell.m
//  ug
//
//  Created by ug on 2019/5/11.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGLotteryAssistantTableViewCell.h"
#import "UGChanglongaideModel.h"

@interface UGLotteryAssistantTableViewCell ()

@property (weak, nonatomic) IBOutlet UIView *betView1;
@property (weak, nonatomic) IBOutlet UIView *betView2;

@property (weak, nonatomic) IBOutlet UIImageView *logoView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *issueLabel;
@property (weak, nonatomic) IBOutlet UILabel *lotteryTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *playCateNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *playNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;

@property (weak, nonatomic) IBOutlet UILabel *playNameLabel1;
@property (weak, nonatomic) IBOutlet UILabel *oddsLabel1;
@property (weak, nonatomic) IBOutlet UILabel *playNameLabel2;
@property (weak, nonatomic) IBOutlet UILabel *oddsLabel2;

@end
@implementation UGLotteryAssistantTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.playCateNameLabel.layer.cornerRadius = 3;
    self.playCateNameLabel.layer.masksToBounds = YES;
    self.countLabel.layer.cornerRadius = 3;
    self.countLabel.layer.masksToBounds = YES;
    self.playNameLabel.layer.cornerRadius = 3;
    self.playNameLabel.layer.masksToBounds = YES;
    self.betView1.layer.cornerRadius= 5;
    self.betView1.layer.masksToBounds = YES;
    self.betView2.layer.cornerRadius = 5;
    self.betView2.layer.masksToBounds = YES;
    self.betView1.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.betView1.layer.borderWidth = 0.7;
    self.betView2.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.betView2.layer.borderWidth = 0.7;
    
}

- (void)setItem:(UGChanglongaideModel *)item {
    _item = item;

    [self.logoView sd_setImageWithURL:[NSURL URLWithString:item.logo] placeholderImage:[UIImage imageNamed:@"loading"]];
    self.titleLabel.text = item.title;
    self.issueLabel.text = item.issue;
    NSString *lotteryTime = [CMCommon getNowTimeWithEndTimeStr:item.closeTime currentTimeStr:item.serverTime];
    if (lotteryTime) {
        self.lotteryTimeLabel.text = lotteryTime;
    }else {
        self.lotteryTimeLabel.text = @"已封盘";
    }
    self.playCateNameLabel.text = item.playCateName;
    self.playNameLabel.text = item.playName;
    self.countLabel.text = item.count;
    if (item.betList.count) {
        
        UGBetItemModel *item0 = item.betList.firstObject;
        self.playNameLabel1.text = item0.playName;
        self.oddsLabel1.text = item0.odds;
        if (item0.select) {
            self.betView1.backgroundColor = [[UGSkinManagers shareInstance] setNavbgColor];
            self.playNameLabel1.textColor = [UIColor whiteColor];
            self.oddsLabel1.textColor = [UIColor whiteColor];
        }else {
            self.betView1.backgroundColor = [UIColor whiteColor];
            self.playNameLabel1.textColor = [UIColor blackColor];
            self.oddsLabel1.textColor = [UIColor blackColor];
        }
        
        UGBetItemModel *item1 = item.betList.lastObject;
        self.playNameLabel2.text = item1.playName;
        self.oddsLabel2.text = item1.odds;
        if (item1.select) {
            self.betView2.backgroundColor = [[UGSkinManagers shareInstance] setNavbgColor];
            self.playNameLabel2.textColor = [UIColor whiteColor];
            self.oddsLabel2.textColor = [UIColor whiteColor];
        }else {
            self.betView2.backgroundColor = [UIColor whiteColor];
            self.playNameLabel2.textColor = [UIColor blackColor];
            self.oddsLabel2.textColor = [UIColor blackColor];
        }
    }
    
   
    
}
- (IBAction)betItem0Click:(id)sender {
    if (self.betItemSelectBlock) {
        self.betItemSelectBlock(0);
    }
    
}
- (IBAction)betItem1Click:(id)sender {
    if (self.betItemSelectBlock) {
        self.betItemSelectBlock(1);
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
