//
//  UGPormotionUserInfoView.m
//  ug
//
//  Created by ug on 2019/9/9.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGPormotionUserInfoView.h"

@interface UGPormotionUserInfoView ()
@property (weak, nonatomic) IBOutlet UILabel *enableLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *regtimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *superiorLabel;
@property (weak, nonatomic) IBOutlet UILabel *coinLabel;
@property (weak, nonatomic) IBOutlet UILabel *myCoinLabel;
@property (weak, nonatomic) IBOutlet UITextField *moneyTextField;


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
        [self setBackgroundColor: [[UGSkinManagers shareInstance] setbgColor]];

    }
    return self;
    
}

-(IBAction)fillingClicked{
    //充值
    [self teamTransferDate];
}

- (IBAction)close:(id)sender {
    [self hiddenSelf];
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
    
    NSDictionary *params = @{@"token":[UGUserModel currentUser].sessid,
                             @"coin":str,
                             @"uid":_item.uid
                             };
    
    [SVProgressHUD showWithStatus:nil];
    //    WeakSelf;
    [CMNetwork teamTransferWithParams:params completion:^(CMResult<id> *model, NSError *err) {
        [CMResult processWithResult:model success:^{
            
            [SVProgressHUD showSuccessWithStatus:model.msg];
            
           [self hiddenSelf];
            
        } failure:^(id msg) {
            
            [SVProgressHUD showErrorWithStatus:msg];
            
        }];
    }];
}


@end
