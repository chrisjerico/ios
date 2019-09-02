//
//  UGUserInfoViewController.m
//  ug
//
//  Created by ug on 2019/5/10.
//  Copyright © 2019 ug. All rights reserved.
//

#import "UGUserInfoViewController.h"

@interface UGUserInfoViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *avaterImageView;
@property (weak, nonatomic) IBOutlet UIImageView *bgImgeView;

@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *accountLabel;
@property (weak, nonatomic) IBOutlet UILabel *fullNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *qqLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyType;

@end

@implementation UGUserInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UGBackgroundColor;
    self.navigationItem.title = @"我的资料";
    [self setupUserInfo];
    [self getUserInfo];

}

- (void)getUserInfo {
    NSDictionary *params = @{@"token":[UGUserModel currentUser].sessid};
    [CMNetwork getUserInfoWithParams:params completion:^(CMResult<id> *model, NSError *err) {
        [CMResult processWithResult:model success:^{
            UGUserModel *user = model.data;
            UGUserModel *oldUser = [UGUserModel currentUser];
            user.sessid = oldUser.sessid;
            user.token = oldUser.token;
            UGUserModel.currentUser = user;
            [self setupUserInfo];
        } failure:^(id msg) {
            
            
        }];
    }];
}

- (void)setupUserInfo {
    UGUserModel *user = [UGUserModel currentUser];
    [self.avaterImageView sd_setImageWithURL:[NSURL URLWithString:user.avatar] placeholderImage:[UIImage imageNamed:@"touxiang-1"]];
    self.userNameLabel.text = user.username;
    self.accountLabel.text = [NSString stringWithFormat:@"账号：%@",user.username];
    self.fullNameLabel.text = [NSString stringWithFormat:@"真实姓名：%@",user.fullName];
    self.qqLabel.text = [NSString stringWithFormat:@"QQ：%@",user.qq];
    self.phoneLabel.text = [NSString stringWithFormat:@"手机：%@",user.phone];
    self.emailLabel.text = [NSString stringWithFormat:@"邮箱：%@",user.email];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
    NSDate *date = [NSDate new];
    NSString *str = [formatter stringFromDate:date];
    self.timeLabel.text = str;
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour;
    NSDateComponents *components = [calendar components:unitFlags fromDate:date];
    if (components.hour > 5 && components.hour < 12 ) {
        self.bgImgeView.image = [UIImage imageNamed:@"sun"];
    }else if (components.hour > 12 && components.hour < 18) {
        self.bgImgeView.image = [UIImage imageNamed:@"xiawu"];
    }else if (components.hour > 18 && components.hour < 21) {
        self.bgImgeView.image = [UIImage imageNamed:@"bangwan"];
    }else {
        self.bgImgeView.image = [UIImage imageNamed:@"wuye"];
        
    }
    
}

@end
