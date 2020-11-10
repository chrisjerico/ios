//
//  InviteCodeGenerateVC.m
//  UGBWApp
//
//  Created by xionghx on 2020/11/3.
//  Copyright © 2020 ug. All rights reserved.
//

#import "InviteCodeGenerateVC.h"
#import "IBButton.h"

@interface InviteCodeGenerateVC ()
@property (weak, nonatomic) IBOutlet UITextField *lengthField;
@property (weak, nonatomic) IBOutlet UITextField *numberField;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *lengthLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet IBButton *confirmButton;
@property (weak, nonatomic) IBOutlet IBButton *randomButton;
@property (nonatomic, assign) NSInteger segmentIndex;
@end

@implementation InviteCodeGenerateVC

- (void)viewDidLoad {
    [super viewDidLoad];
	self.segmentIndex = 0;
	InviteCodeConfigModel *inviteCodeModel = UGSystemConfigModel.currentConfig.inviteCode;
	self.titleLabel.text = inviteCodeModel.displayWord;
	self.typeLabel.text = [NSString stringWithFormat:@"%@类型", inviteCodeModel.displayWord];
	self.lengthLabel.text = inviteCodeModel.displayWord;
	self.numberLabel.text = @"生成数量";
	self.confirmButton.backgroundColor = Skin1.navBarBgColor;
	self.lengthField.placeholder = [NSString stringWithFormat:@"请输入%@长度", inviteCodeModel.displayWord];
	self.numberField.placeholder = [NSString stringWithFormat:@"最多可生成%@%@", inviteCodeModel.canGenNum, inviteCodeModel.displayWord];
	[self.randomButton setHidden: ![inviteCodeModel.randomSwitch isEqualToString:@"1"]];

    // Do any additional setup after loading the view from its nib.
}
- (IBAction)dismissAction:(id)sender {
	[self dismissViewControllerAnimated:true completion:nil];
}
- (IBAction)confirmAction:(id)sender {
	
	
	NSNumber * length = [NSNumber numberWithString: self.lengthField.text];
	if (!(length.intValue > 0)) {
		[SVProgressHUD showErrorWithStatus:@"请输入邀请码长度"];
		return;;
	}
	
	NSNumber * number = [NSNumber numberWithString: self.numberField.text];
	if (!(number.intValue > 0)) {
		[SVProgressHUD showErrorWithStatus:@"请输入邀请码数量"];
		return;;
	}

	NSLog(@"%@", length);
		[CMNetwork generateInviteCodeWithParams:@{@"length": length, @"count": number, @"user_type": [NSNumber numberWithInteger:self.segmentIndex]} completion:^(CMResult<id> *model, NSError *err) {
			
			if (err) {
				[SVProgressHUD showErrorWithStatus:err.localizedDescription];
				return;
			}
			if (self.delegate && [self.delegate respondsToSelector:@selector(generated)]) {
				[self dismissViewControllerAnimated:true completion:nil];
				[self.delegate generated];
			}
			NSLog(@"%@", model);
		}];
}
- (IBAction)radomGenerateAction:(id)sender {
	[CMNetwork generateInviteCodeWithParams:@{ @"length": @4, @"count": @1,@"randomCheck": @1, @"user_type": [NSNumber numberWithInteger:self.segmentIndex]} completion:^(CMResult<id> *model, NSError *err) {
		
		if (err) {
			[SVProgressHUD showErrorWithStatus:err.localizedDescription];
			return;
		}
		if (self.delegate && [self.delegate respondsToSelector:@selector(generated)]) {
			[self dismissViewControllerAnimated:true completion:nil];
			[self.delegate generated];
		}
		NSLog(@"%@", model.data);
	}];
}
//randomCheck
- (IBAction)typeChanged:(UISegmentedControl *)sender {
	self.segmentIndex = sender.selectedSegmentIndex;
}

@end
