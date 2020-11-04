//
//  InviteCodeGenerateVC.m
//  UGBWApp
//
//  Created by xionghx on 2020/11/3.
//  Copyright © 2020 ug. All rights reserved.
//

#import "InviteCodeGenerateVC.h"

@interface InviteCodeGenerateVC ()
@property (weak, nonatomic) IBOutlet UITextField *lengthField;
@property (weak, nonatomic) IBOutlet UITextField *numberField;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *lengthLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (nonatomic, assign) NSInteger segmentIndex;
@end

@implementation InviteCodeGenerateVC

- (void)viewDidLoad {
    [super viewDidLoad];
	self.segmentIndex = 0;
	InviteCodeConfigModel *inviteCodeModel = UGSystemConfigModel.currentConfig.inviteCode;
	self.titleLabel.text = inviteCodeModel.displayWord;
	self.typeLabel.text = [NSString stringWithFormat:@"%@类别", inviteCodeModel.displayWord];
	self.lengthLabel.text = [NSString stringWithFormat:@"%@长度", inviteCodeModel.displayWord];
	self.numberLabel.text = [NSString stringWithFormat:@"%@数量", inviteCodeModel.displayWord];

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
