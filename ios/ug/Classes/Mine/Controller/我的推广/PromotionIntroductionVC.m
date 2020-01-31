//
//  PromotionIntroductionVC.m
//  ug
//
//  Created by xionghx on 2020/1/10.
//  Copyright © 2020 ug. All rights reserved.
//

#import "PromotionIntroductionVC.h"
#import "UGinviteInfoModel.h"

@interface PromotionIntroductionVC ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *title1Lable;
@property (weak, nonatomic) IBOutlet UILabel *title2Lable;
@property (strong, nonatomic) IBOutlet UIView *bgView;      /**<   自定义导航条 */
@property (weak, nonatomic) IBOutlet UIView *contentView;   /**<   自定义导航条 */



@property (strong, nonatomic)  UGinviteInfoModel *mUGinviteInfoModel;

@end

@implementation PromotionIntroductionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   [self teamInviteInfoData];
    
    if (Skin1.isBlack) {
        [_bgView setBackgroundColor:Skin1.CLBgColor];
        [_bgView setBackgroundColor:Skin1.bgColor];
        [_titleLabel setTextColor:Skin1.textColor1];
        [_title1Lable setTextColor:Skin1.textColor1];
        [_title2Lable setTextColor:Skin1.textColor3];
        
    }
}

#pragma mark -- 网络请求
//得到推荐信息数据
- (void)teamInviteInfoData {
    if ([UGUserModel currentUser].isTest) {
        return;
    }
    NSDictionary *params = @{@"token":[UGUserModel currentUser].sessid};
    
    [SVProgressHUD showWithStatus:nil];
    WeakSelf;
    [CMNetwork teamInviteInfoWithParams:params completion:^(CMResult<id> *model, NSError *err) {
        [CMResult processWithResult:model success:^{
            
            [SVProgressHUD dismiss];
            weakSelf.mUGinviteInfoModel = model.data;
            NSLog(@"rid = %@",weakSelf.mUGinviteInfoModel.rid);
           
            [weakSelf setUIDate];
            //
            
        } failure:^(id msg) {
            
            [SVProgressHUD dismiss];
            
        }];
    }];
}

#pragma mark -- UI数据
-(void)setUIDate{

    double proportion = [self.mUGinviteInfoModel.fandian doubleValue];
    double jg =  proportion *1000/100;
    NSString *jgStr = [NSString stringWithFormat:@"%.2f",jg];
    self.title2Lable.text =  [NSString stringWithFormat:@"您推荐的会员在下注结算后，佣金会自动按照比例加到您的资金账户上。例如：您所推荐的会员下注1000元，您的收益=1000元*(一级下线比例比如：%@%%）=%@元。",self.mUGinviteInfoModel.fandian,jgStr];

    self.title1Lable.text = self.mUGinviteInfoModel.month_member;
    
}
@end
