//
//  PromotionMemberRechargeVC.m
//  ug
//
//  Created by xionghx on 2020/1/10.
//  Copyright © 2020 ug. All rights reserved.
//

#import "PromotionMemberRechargeVC.h"

@interface PromotionMemberRechargeVC ()
@property (weak, nonatomic) IBOutlet UILabel *relationShipLabel;
@property (weak, nonatomic) IBOutlet UILabel *memberNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *memberBalanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *myBalanceLabel;
@property (weak, nonatomic) IBOutlet UITextField *rechargeField;
@property (weak, nonatomic) IBOutlet UILabel *tipsLabel;

@property(nonatomic, strong)UGinviteLisModel * promotionMember;

@end

@implementation PromotionMemberRechargeVC

- (void)viewDidLoad {
    [super viewDidLoad];
	self.relationShipLabel.text = nil;
	self.memberNameLabel.text = nil;
	self.memberBalanceLabel.text = nil;
	self.myBalanceLabel.text = nil;
}
- (void)bindMember:(UGinviteLisModel *)member {
	self.promotionMember = member;
	self.relationShipLabel.text = [NSString stringWithFormat:@"%@>%@", UGUserModel.currentUser.username, member.username];
	self.memberNameLabel.text = member.name.length > 0 ? member.name: member.username;
	self.memberBalanceLabel.text = member.coin;
	self.myBalanceLabel.text = UGUserModel.currentUser.balance;
}
- (IBAction)cancelButtonTaped:(id)sender {
}
- (IBAction)confirmButtonTaped:(id)sender {
}


@end
