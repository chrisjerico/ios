//
//  UGYubaoConversionViewController.m
//  ug
//
//  Created by ug on 2019/5/25.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGYubaoConversionViewController.h"
#import "WavesView.h"
#import "UGConvertCollectionViewCell.h"
#import "UGMissionLevelModel.h"
#import "UGYuebaoInfoModel.h"
#import "UGEncryptUtil.h"
#import "UGYUbaoTitleView.h"
@interface UGYubaoConversionViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UITextFieldDelegate>

@property (nonatomic, strong) UGYUbaoTitleView *titleView;               /**<   自定义导航条 */

@property (weak, nonatomic) IBOutlet UILabel *balanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *dayIncomeLabel;
@property (weak, nonatomic) IBOutlet UILabel *rateLabel;
@property (weak, nonatomic) IBOutlet UITextField *inputTextF;
@property (weak, nonatomic) IBOutlet UILabel *totalAmountLabel;
@property (weak, nonatomic) IBOutlet UILabel *yubaoAmountLabel;

@property (weak, nonatomic) IBOutlet UIView *waveBgView;
@property (weak, nonatomic) IBOutlet UIView *waveBotomView;
@property (nonatomic, strong) WavesView *waveView;

@property (weak, nonatomic) IBOutlet UIView *scrollContentView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollCententHeightConstraint;

@property (weak, nonatomic) IBOutlet UIButton *submitButton;
@property (weak, nonatomic) IBOutlet UIButton *turnInButton;
@property (weak, nonatomic) IBOutlet UIButton *turnOutButton;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray <NSString *> *amountArray;
@property (nonatomic, strong) NSString *inputFundPwd;
@property (nonatomic, strong) NSString *transferType;
@property (weak, nonatomic) IBOutlet UIImageView *bgView;
@property (weak, nonatomic) IBOutlet UIView *yyBgView;

@end

static NSString *convertCellid = @"UGConvertCollectionViewCell";
@implementation UGYubaoConversionViewController
-(void)skin {
	FastSubViewCode(self.view)
    if (Skin1.isBlack||Skin1.is23||Skin1.isGPK) {
        [self.view setBackgroundColor:Skin1.is23 ?RGBA(135 , 135 ,135, 1):Skin1.bgColor];
		[subLabel(@"余额label") setTextColor:[UIColor lightGrayColor]];
		[subLabel(@"利息宝余额label") setTextColor:[UIColor lightGrayColor]];
		[subLabel(@"￥label") setTextColor:[UIColor whiteColor]];
		[_balanceLabel setTextColor:[UIColor whiteColor]];
		[_yubaoAmountLabel setTextColor:[UIColor whiteColor]];
		[_inputTextF setTextColor:[UIColor whiteColor]];
		[_submitButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
		[_submitButton setBackgroundColor:Skin1.navBarBgColor];
		[_turnInButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
		[_turnInButton setBackgroundColor:Skin1.navBarBgColor];
		[_turnOutButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
		[subImageView(@"浪图UIImagV") setHidden:YES];
	}else if ([Skin1.skitType isEqualToString:@"金沙主题"]) {
		[self.view setBackgroundColor:Skin1.bgColor];
		[subLabel(@"余额label") setTextColor:[UIColor lightGrayColor]];
		[subLabel(@"利息宝余额label") setTextColor:[UIColor lightGrayColor]];
		[subLabel(@"￥label") setTextColor:[UIColor blackColor]];
		[_balanceLabel setTextColor:[UIColor blackColor]];
		[_yubaoAmountLabel setTextColor:[UIColor blackColor]];
		[_inputTextF setTextColor:[UIColor blackColor]];
		[_submitButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
		[_submitButton setBackgroundColor:Skin1.navBarBgColor];
		[_turnInButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
		[_turnInButton setBackgroundColor:Skin1.navBarBgColor];
		[_turnOutButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
		[subImageView(@"浪图UIImagV") setHidden:YES];
	} else {
		[self.view setBackgroundColor: [UIColor whiteColor]];
		[subLabel(@"余额label") setTextColor:[UIColor lightGrayColor]];
		[subLabel(@"利息宝余额label") setTextColor:[UIColor lightGrayColor]];
		[subLabel(@"￥label") setTextColor:[UIColor blackColor]];
		[_balanceLabel setTextColor:[UIColor blackColor]];
		[_yubaoAmountLabel setTextColor:[UIColor blackColor]];
		[_inputTextF setTextColor:[UIColor blackColor]];
		[_submitButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
		[_submitButton setBackgroundColor:Skin1.navBarBgColor];
		[_turnInButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
		[_turnInButton setBackgroundColor:Skin1.navBarBgColor];
		[_turnOutButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
		[subImageView(@"浪图UIImagV") setHidden:NO];
	}
	[self setYyBgViewBgColor];
	[CMCommon textFieldSetPlaceholderLabelColor:Skin1.textColor3 TextField:_inputTextF];
}

-(void)setYyBgViewBgColor{
    NSString *skitType = Skin1.skitType;
	
	if (CHAT_TARGET){
		[_yyBgView setBackgroundColor:RGBA(0x4a, 0x77, 0xff, 1)];
		self.waveBotomView.backgroundColor =  [UIColor whiteColor];
		self.waveView.realWaveColor =  RGBA(0x4a, 0x77, 0xff, 1);
	} else if ([@"新年红,石榴红,六合资料,金沙主题,简约模板,火山橙,香槟金" containsString:Skin1.skitType]) {
        [_yyBgView setBackgroundColor:Skin1.navBarBgColor];
        self.waveBotomView.backgroundColor =  Skin1.navBarBgColor;
        self.waveView.realWaveColor =  Skin1.navBarBgColor;
    }
    else if(Skin1.is23) {
        [_yyBgView setBackgroundColor:RGBA(111, 111, 111, 1)];
        self.waveBotomView.backgroundColor =  RGBA(135 , 135 ,135, 1);
        self.waveView.realWaveColor = RGBA(135 , 135 ,135, 1);
    }
    else  {
        [_yyBgView setBackgroundColor:Skin1.yubaoBgColor ? : Skin1.bgColor];
        self.waveBotomView.backgroundColor = Skin1.yubaoBgColor ? : Skin1.bgColor;
        self.waveView.realWaveColor = Skin1.yubaoBgColor ? : Skin1.bgColor;
    }
}

-(void)viewWillAppear:(BOOL)animated{
	[super viewWillAppear:animated];
	[self setYyBgViewBgColor];
}

- (void)viewDidLoad {
	[super viewDidLoad];

	self.title = @"利息宝";
	self.submitButton.layer.cornerRadius = 5;
	self.submitButton.layer.masksToBounds = YES;
	[self.submitButton setBackgroundColor:Skin1.navBarBgColor];
	
	self.turnInButton.layer.cornerRadius = 5;
	self.turnInButton.layer.masksToBounds = YES;
	[self.turnInButton setBackgroundColor:Skin1.navBarBgColor];
	
	self.turnOutButton.layer.cornerRadius = 5;
	self.turnOutButton.layer.masksToBounds = YES;
	
	self.waveView = [[WavesView alloc] initWithFrame:self.waveBgView.bounds];
	[self.waveBgView addSubview:self.waveView];
	self.waveView.backgroundColor = [UIColor clearColor];
	
	self.waveView.maskWaveColor = [UIColor clearColor];
	self.waveView.waveHeight = 10;
	[self.waveView startWaveAnimation];
	
	
    [self skin];
	[self setYyBgViewBgColor];
	
	
	self.transferType = @"in";
	self.inputTextF.delegate = self;
	self.amountArray = @[@"100",@"500",@"1000",@"5000",@"10000",@"全部金额"].mutableCopy;
	self.collectionView.height = self.amountArray.count * 50;
	self.scrollCententHeightConstraint.constant = 250 + self.collectionView.height;
	[self.scrollContentView addSubview:self.collectionView];
	SANotificationEventSubscribe(UGNotificationGetUserInfoComplete, self, ^(typeof (self) self, id obj) {
		[self setupInfo];
	});
	[self setupInfo];
	
	
	
}
- (IBAction)backClick:(id)sender {
	[self.navigationController popViewControllerAnimated:YES];
	
}

- (void)getYuebaoInfo {
    WeakSelf;
	[CMNetwork getYuebaoInfoWithParams:@{@"token":[UGUserModel currentUser].sessid} completion:^(CMResult<id> *model, NSError *err) {
		[CMResult processWithResult:model success:^{
			weakSelf.infoModel = model.data;
			[weakSelf setupInfo];
		} failure:^(id msg) {
			[SVProgressHUD dismiss];
		}];
	}];
}

- (IBAction)submitClick:(id)sender {
	if (![UGUserModel currentUser].hasFundPwd) {
		[SVProgressHUD showInfoWithStatus:@"请先设置取款密码"];
		return ;
	}
	ck_parameters(^{
		ck_parameter_non_empty(self.inputTextF.text, @"请输入转换金额");
	}, ^(id err) {
		[SVProgressHUD showInfoWithStatus:err];
	}, ^{
		
		UIAlertController * alert = [UIAlertController alertControllerWithTitle:nil message:@"请输入提款密码" preferredStyle:UIAlertControllerStyleAlert];
		UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
			
		}];
		UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
			
			if (self.inputFundPwd) {
				
				[self startConversion];
			}
			
		}];
		[alert addAction:cancel];
		[alert addAction:sure];
		[alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
			textField.placeholder = @"请输入提款密码";
			textField.secureTextEntry = YES;
			[textField addTarget:self action:@selector(alertUserAccountInfoDidChange:) forControlEvents:UIControlEventEditingChanged];
		}];
		
		[self presentViewController:alert animated:YES completion:nil];
		
	});
	
	
}

- (void)alertUserAccountInfoDidChange:(UITextField *)sender {
	self.inputFundPwd = sender.text;
	
}

- (void)startConversion {
	
	NSDictionary *params = @{@"money":self.inputTextF.text,
							 @"token":[UGUserModel currentUser].sessid,
							 @"pwd":[UGEncryptUtil md5:self.inputFundPwd],
							 @"inOrOut":self.transferType
	};
	[SVProgressHUD showWithStatus:nil];
	[self.inputTextF resignFirstResponder];
    WeakSelf;
	[CMNetwork yuebaoTransferWithParams:params completion:^(CMResult<id> *model, NSError *err) {
		weakSelf.inputFundPwd = nil;
		[CMResult processWithResult:model success:^{
			[SVProgressHUD showSuccessWithStatus:model.msg];
			SANotificationEventPost(UGNotificationGetUserInfo, nil);
			weakSelf.inputTextF.text = nil;
			[weakSelf.collectionView reloadData];
			[weakSelf getYuebaoInfo];
		} failure:^(id msg) {
			[SVProgressHUD showErrorWithStatus:msg];
		}];
	}];
	
}

- (IBAction)turnInClick:(id)sender {
	[self.submitButton setTitle:@"确认转入" forState:UIControlStateNormal];
	self.inputTextF.placeholder = @"请输入转入金额";
	self.submitButton.backgroundColor = self.turnInButton.backgroundColor;
	self.titleLabel.text = @"转入利息宝";
	self.transferType = @"in";
	
}

- (IBAction)turnOutClick:(id)sender {
	[self.submitButton setTitle:@"确认转出" forState:UIControlStateNormal];
	self.inputTextF.placeholder = @"请输入转出金额";
	self.submitButton.backgroundColor = self.turnOutButton.backgroundColor;
	self.titleLabel.text = @"转出利息宝";
	self.transferType = @"out";
	
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
	return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	
	return self.amountArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	UGConvertCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:convertCellid forIndexPath:indexPath];
	cell.title = self.amountArray[indexPath.row];
	return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
	NSString *amount = self.amountArray[indexPath.row];
	if ([@"全部金额" isEqualToString:amount]) {
		if ([@"in" isEqualToString:self.transferType]) {
			
			self.inputTextF.text = [[UGUserModel currentUser].balance removeFloatAllZero];
		}else {
			self.inputTextF.text = [self.infoModel.balance removeFloatAllZero];
		}
	}else {
		
		self.inputTextF.text = amount;
	}
	
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
	if ([string isEqualToString:@"\n"]) {
		[self.inputTextF resignFirstResponder];
		return NO;
	}
	
	NSString *text = [textField.text stringByReplacingCharactersInRange:range withString:string];
	if (textField == self.inputTextF) {
		if (!text.length) {
			[self.collectionView reloadData];
		}
	}
	
	return YES;
}

- (UICollectionView *)collectionView {
	if (_collectionView == nil) {
		UICollectionViewFlowLayout *layout = ({
			layout = [[UICollectionViewFlowLayout alloc] init];
			layout.minimumLineSpacing = 5;
			layout.minimumInteritemSpacing = 0;
			layout.itemSize = CGSizeMake((UGScreenW - 20)/3, 45);
			
			layout;
			
		});
		
		UICollectionView *collectionView = ({
			collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(5, 85, UGScreenW - 10, 400) collectionViewLayout:layout];
			collectionView.backgroundColor = [UIColor clearColor];
			collectionView.delegate = self;
			collectionView.dataSource = self;
			[collectionView registerNib:[UINib nibWithNibName:@"UGConvertCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:convertCellid];
			
			collectionView;
		});
		
		_collectionView = collectionView;
	}
	return _collectionView;
}

- (void)setupInfo {
	
	self.dayIncomeLabel.text = self.infoModel.todayProfit;
	self.totalAmountLabel.text = [NSString stringWithFormat:@"利息宝余额 %@",self.infoModel.balance];
	NSString *nhl = [NSString stringWithFormat:@"%.4f",self.infoModel.annualizedRate.floatValue * 100];
	self.rateLabel.text = [NSString stringWithFormat:@"年化率 %@%%",[nhl removeFloatAllZero]];
	self.balanceLabel.text = [NSString stringWithFormat:@"%@",[[UGUserModel currentUser].balance removeFloatAllZero]];
	self.yubaoAmountLabel.text = self.infoModel.balance;
}

- (NSMutableArray<NSString *> *)amountArray {
	if (_amountArray == nil) {
		_amountArray = [NSMutableArray array];
		
	}
	
	return _amountArray;
}

@end
