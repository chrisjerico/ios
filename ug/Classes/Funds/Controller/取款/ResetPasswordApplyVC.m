//
//  ResetPasswordApplyVC.m
//  UGBWApp
//
//  Created by xionghx on 2020/10/18.
//  Copyright © 2020 ug. All rights reserved.
//

#import "ResetPasswordApplyVC.h"
#import "CMNetwork+Upload.h"
#import "AFHTTPSessionManager.h"
#import "URLModel.h"
@interface ResetPasswordApplyVC ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *cardNumberField;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UIButton *picButton1;
@property (weak, nonatomic) IBOutlet UIButton *picButton2;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;

@property (weak, nonatomic) IBOutlet UIView *cardNumberView;
@property (weak, nonatomic) IBOutlet UIView *phoneNumberView;
@property (weak, nonatomic) IBOutlet UIView *passwordVIew;
@property (weak, nonatomic) IBOutlet UIView *idPicView;

@property (strong, nonatomic) UIButton *seletedButon;
@property (strong, nonatomic) URLModel *firstPic;
@property (strong, nonatomic) URLModel *secondPic;

@end

@implementation ResetPasswordApplyVC
- (void)dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewDidLoad {
	[super viewDidLoad];
	self.navigationItem.title = @"忘记取款密码";
	NSDictionary * configDic = @{@"bank": self.cardNumberView, @"mobile": self.phoneNumberView, @"id": self.idPicView};
	for (NSString *key in UGSystemConfigModel.currentConfig.coinPwdAuditOptionAry) {
		[(UIView *)configDic[key] setHidden:false];
	}
	self.submitButton.layer.cornerRadius = 5;
	self.submitButton.layer.masksToBounds = true;
	self.submitButton.backgroundColor = Skin1.navBarBgColor;
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textfieldEditChange:) name:@"UITextFieldTextDidChangeNotification" object:self.passwordField];
	
}
- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
}

- (IBAction)uploadButtonAction:(UIButton *)sender {
	UIAlertController * alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
	WeakSelf;
	[alert addAction: [UIAlertAction actionWithTitle:@"从相册中选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
		[weakSelf showImagePickerWith:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
	}]];
	if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
		[alert addAction: [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
			[weakSelf showImagePickerWith:UIImagePickerControllerSourceTypeCamera];
		}]];
	}
	
	[alert addAction: [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler: nil]];
	[self presentViewController:alert animated:true completion:^{
		weakSelf.seletedButon = sender;
	}];
	
}



- (void)showImagePickerWith:(UIImagePickerControllerSourceType)sourceType {
	
	UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
	imagePicker.sourceType = sourceType;
	imagePicker.delegate = self;
	[self presentViewController:imagePicker animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey, id> *)info {
	UIImage *image = info[UIImagePickerControllerOriginalImage];
	NSLog(@"%@", info);
	[picker dismissViewControllerAnimated:true completion:nil];
	[SVProgressHUD showWithStatus:nil];
	WeakSelf;
	[CMNetwork uploadIdentityWithParams:@{@"token":UGUserModel.currentUser.sessid} image:image completion:^(CMResult<URLModel*> *result, NSError *err) {
		if (err) {
			[SVProgressHUD showErrorWithStatus:err.localizedDescription];
			return;
		}
		[SVProgressHUD dismiss];
		if (weakSelf.seletedButon) {
			[weakSelf.seletedButon setImage:image forState:UIControlStateNormal];
			if ( weakSelf.seletedButon == weakSelf.picButton1 ) {
				weakSelf.firstPic = result.data;
			} else {
				weakSelf.secondPic = result.data;
			}
		}
	}];
}
- (IBAction)submitAction:(id)sender {
	NSMutableDictionary * params = @{@"token":UGUserModel.currentUser.sessid}.mutableCopy;
	for (NSString *key in UGSystemConfigModel.currentConfig.coinPwdAuditOptionAry) {
		if ([key isEqualToString:@"bank"]) {
			if ([self.cardNumberField.text length] > 19 || [self.cardNumberField.text length] < 6) {
				[SVProgressHUD showErrorWithStatus:@"请输入6到19位数的银行卡号"];
				return;
			}
			params[@"bankNo"] = self.cardNumberField.text;
		} else if ([key isEqualToString:@"mobile"]) {
			if ([self.phoneNumberField.text length] != 11) {
				[SVProgressHUD showErrorWithStatus:@"请输入11位手机号码"];
				return;
			}
			params[@"mobile"] = self.phoneNumberField.text;
			
		} else if ([key isEqualToString:@"id"]) {
			if (!self.firstPic) {
				[SVProgressHUD showErrorWithStatus:@"请上传身份证正面照片"];
				return;
			}
			if (!self.secondPic) {
				[SVProgressHUD showErrorWithStatus:@"请上传身份证反面照片"];
				return;
			}
			NSString * identityPathDot = [NSString stringWithFormat:@"%@,%@",self.firstPic.path,self.secondPic.path];
			params[@"identityPathDot"] = identityPathDot;
		}
	}
	
	if ([self.passwordField.text length] != 4) {
		[SVProgressHUD showErrorWithStatus:@"请输入四位取款密码"];
		return;
	}
	params[@"coinpwd"] = self.passwordField.text;
	[SVProgressHUD showWithStatus:nil];
	[CMNetwork applyFundPwWithParams:params.copy completion:^(CMResult<id> *model, NSError *err) {
		if (err.code != 0) {
			[SVProgressHUD showErrorWithStatus:err.localizedDescription];
		} else {
			[SVProgressHUD showSuccessWithStatus:@"申请已提交"];
		}
		dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
			[SVProgressHUD dismiss];
			[UINavigationController.current popViewControllerAnimated:true];
		});
	}];
	
}
- (void)textfieldEditChange:(NSNotification *)notification
{
	UITextField *textField = notification.object;
	
	if (textField.text.length > 4)
	{
		textField.text = [textField.text substringToIndex:4];
	}
}
@end
