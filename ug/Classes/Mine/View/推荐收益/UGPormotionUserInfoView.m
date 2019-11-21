//
//  UGPormotionUserInfoView.m
//  ug
//
//  Created by ug on 2019/9/9.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGPormotionUserInfoView.h"
#import "SGBrowserView.h"
@interface UGPormotionUserInfoView ()
@property (weak, nonatomic) IBOutlet UILabel *enableLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *regtimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *superiorLabel;
@property (weak, nonatomic) IBOutlet UILabel *coinLabel;
@property (weak, nonatomic) IBOutlet UILabel *myCoinLabel;
@property (weak, nonatomic) IBOutlet UITextField *moneyTextField;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;  /**<   标题*/
@property (weak, nonatomic) IBOutlet UIButton *canneBtn;
@property (weak, nonatomic) IBOutlet UIButton *okBtn;


@end

@implementation UGPormotionUserInfoView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self = [[NSBundle mainBundle] loadNibNamed:@"UGPormotionUserInfoView" owner:self options:0].firstObject;
        self.frame = frame;
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 5;
        self.moneyTextField.keyboardType = UIKeyboardTypeDecimalPad;
//
        [self makeRoundedCorner:6];
        
        _canneBtn.layer.cornerRadius = 5;
        _canneBtn.layer.borderWidth = 1;
        _canneBtn.layer.borderColor =   RGBA(219, 219, 219, 1).CGColor;
        
        _okBtn.layer.cornerRadius = 5;
        
        FastSubViewCode(self)
        if ([Skin1.skitType isEqualToString:@"黑色模板"]) {
            [self setBackgroundColor: Skin1.bgColor];
            [self.titleLabel setTextColor:[UIColor whiteColor]];
            [subLabel(@"账号状态lable") setTextColor:[UIColor whiteColor]];
            [subLabel(@"用户姓名label") setTextColor:[UIColor whiteColor]];
            [subLabel(@"注册时间label") setTextColor:[UIColor whiteColor]];
            [subLabel(@"上级关系label") setTextColor:[UIColor whiteColor]];
            [subLabel(@"用户余额label") setTextColor:[UIColor whiteColor]];
            [subLabel(@"我的余额label") setTextColor:[UIColor whiteColor]];
            [subLabel(@"充值金额label") setTextColor:[UIColor whiteColor]];
            [_nameLabel setTextColor:[UIColor whiteColor]];
            [_regtimeLabel setTextColor:[UIColor whiteColor]];
            [_superiorLabel setTextColor:[UIColor whiteColor]];
            [_moneyTextField setTextColor:[UIColor whiteColor]];
        } else {
            [self setBackgroundColor: [UIColor whiteColor]];
            [self.titleLabel setTextColor:[UIColor blackColor]];
            [subLabel(@"账号状态lable") setTextColor:[UIColor blackColor]];
            [subLabel(@"用户姓名label") setTextColor:[UIColor blackColor]];
            [subLabel(@"注册时间label") setTextColor:[UIColor blackColor]];
            [subLabel(@"上级关系label") setTextColor:[UIColor blackColor]];
            [subLabel(@"用户余额label") setTextColor:[UIColor blackColor]];
            [subLabel(@"我的余额label") setTextColor:[UIColor blackColor]];
            [subLabel(@"充值金额label") setTextColor:[UIColor blackColor]];
            [_nameLabel setTextColor:[UIColor blackColor]];
            [_regtimeLabel setTextColor:[UIColor blackColor]];
            [_superiorLabel setTextColor:[UIColor blackColor]];
            [_moneyTextField setTextColor:[UIColor blackColor]];
        }
         [CMCommon textFieldSetPlaceholderLabelColor:Skin1.textColor3 TextField:_moneyTextField];

    }
    return self;
    
}

-(IBAction)fillingClicked{
    //充值
    [self teamTransferDate];
}

- (IBAction)close:(id)sender {
//    [self hiddenSelf];
    [SGBrowserView hide];
}

- (void)show {
    
    UIWindow* window = UIApplication.sharedApplication.keyWindow;
    UIView* maskView = [[UIView alloc] initWithFrame:window.bounds];
    UIView* view = self;
    view.hidden = NO;
    
    maskView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    maskView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    
    [maskView addSubview:view];
    [window addSubview:maskView];
    
}

- (void)hiddenSelf {
    
    UIView* view = self;
    self.superview.backgroundColor = [UIColor clearColor];
    [view.superview removeFromSuperview];
    [view removeFromSuperview];
    
}

#pragma mark-- 其他方法
- (void)setItem:(UGinviteLisModel *)item {
    _item = item;
    self.enableLabel.text = item.enable;
    if ([CMCommon stringIsNull:item.name]) {
        self.nameLabel.text = @"--";
    } else {
        self.nameLabel.text = item.name;
    }
    self.regtimeLabel.text = item.regtime;
    
    UGUserModel *user = [UGUserModel currentUser];
    
    self.superiorLabel.text = [NSString stringWithFormat:@"%@>%@",user.username,item.username];
    self.coinLabel.text =  [NSString stringWithFormat:@"￥%@",item.coin];
    double floatString = [user.balance doubleValue];
    self.myCoinLabel.text =   [NSString stringWithFormat:@"￥%.2f",floatString];
    

    
}
#pragma mark -- 网络请求
//线下充值c=team&a=transfer
- (void)teamTransferDate{
    
    //    NSString *date = @"2019-09-04";
    //将昵称输入框两边空格去掉
    NSString *str = [self.moneyTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if ([CMCommon stringIsNull:[UGUserModel currentUser].sessid]) {
        return;
    }
    NSDictionary *params = @{@"token":[UGUserModel currentUser].sessid,
                             @"coin":str,
                             @"uid":_item.uid
                             };
    
    [SVProgressHUD showWithStatus:nil];
    //    WeakSelf;
    [CMNetwork teamTransferWithParams:params completion:^(CMResult<id> *model, NSError *err) {
        [CMResult processWithResult:model success:^{
            
            [SVProgressHUD showSuccessWithStatus:model.msg];
            
//           [self hiddenSelf];
            [SGBrowserView hide];
            
        } failure:^(id msg) {
            
            [SVProgressHUD showErrorWithStatus:msg];
            
        }];
    }];
}


@end
